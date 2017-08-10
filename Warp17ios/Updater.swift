//
//  Updater.swift
//  Warp17ios
//
//  Created by Mac on 20.07.17.
//  Copyright © 2017 WarpTeam. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire
import Firebase
//import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth

// todo использование картинок при отображении перечня планет и городов
class Updater {
    private let contentDir: String = NSHomeDirectory().appending("/Content")
    
    let downloadTasksQueue = DispatchQueue(label: "updates_download_queue"/*, attributes: .concurrent*/)
    
    private var haveErrorsDownloadingContentFiles: Bool = false // как сделать потокобезопасной?
    
    public func proceed() {
        
        loginFirebase()
        
        
        // todo инициализация view прогрессбара
        
        haveErrorsDownloadingContentFiles = false
        let provider = UpdatesProvider(updater: self)
        provider.loadJson() // запрос к api UpdatesProvider - переадресация на функцию proceedSync
        
        
        
        //  тут попробуем поработать с firebase storage
        
        


    }
    
    private func firebaseDownloadFile(_ fileName: String) {
        
        print("\(Thread.current) - firebase download \(fileName)...")
        let imageRef = Storage.storage().reference(withPath:fileName)
        
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        imageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                print("\(Thread.current) - firebase download \(fileName) error:")
                print(error)
                // Uh-oh, an error occurred!
            } else {
                //let image = UIImage(data: data!)
                //self.sampleFirebaseImage = image
                //print("\(Thread.current) - setting self image...")
                //print("\(Thread.current) - UPDATER: FIREBASE IMAGE \(String(describing: self.sampleFirebaseImage))")
                
                let url = URL(string: "file://" + self.getPathForContentFile(fileName))!
                print("\(Thread.current) - fb local url = \(url)")
                
                imageRef.write(toFile: url) { url, error in
                    if error != nil {
                        print("\(Thread.current) - fb file \(fileName) save fail: \(String(describing: error))")
                    } else {
                        print("\(Thread.current) - fb file \(fileName) saved locally")
                    }
                }
            }
        }
    }
    
    public func proceedSync(files: JSON) {
        // сюда попадаем из провайдера по получении json
        var downloadQueue: [String] = []
        
        createContentDirectory() // создание каталога контента
        
        for (_, subJson) in files {
            if (!checkAlreadyDownloaded(file: subJson)) {
                downloadQueue.append(subJson["filename"].stringValue)
                print("\(Thread.current) - updater: updated file \(subJson["filename"]) must be downloaded")
            }
        }
        
        downloadFiles(filenameList: downloadQueue)
        // todo показываем обычный view controller по завершении всего обновления
    }
    
    private func loginFirebase() {
        print("\(Thread.current) - firebase logging in...")
        Auth.auth().signInAnonymously(completion: { user, error in
            let uid = Auth.auth().currentUser?.uid
            print("Firebase as \(String(describing: uid!)) logged in.")
            print("Firebase logging in error: \(String(describing: error)).")
        })
        
    }
    
    private func downloadFiles(filenameList: [String]) {
        
        for filename in filenameList {
            firebaseDownloadFile(filename)
            // downloadContentFile(filename)
            // todo обновление progressbar
        }

    }
    
    private func createContentDirectory() {
        if !FileManager.default.fileExists(atPath: contentDir) {
            do {
                try FileManager.default.createDirectory(atPath: contentDir, withIntermediateDirectories: false, attributes: nil)
            } catch let error as NSError {
                UiUtils.sharedInstance.errorAlert(text: "Cannot create application content directory.")
                print(error.localizedDescription);
            }
        }
    }
    
    private func checkAlreadyDownloaded(file: JSON) -> Bool { // todo передача объекта
        // todo возможно использование realm как хранилища списка загруженных обновлений
        
        // пока на наличие файла, todo проверка версии file["version"] в реалме
        if isFileExists(file["filename"].stringValue) {
            print("\(Thread.current) - updater: already have \(file["filename"].stringValue)")
            return true
        }
        
        return false
    }
    
    private func isFileExists(_ filename: String) -> Bool {
        return FileManager.default.fileExists(atPath: getPathForContentFile(filename))
    }
    
    //private func deleteFile(_ filename: String) {
    //    let path = getPathForContentFile(filename)
    //    if FileManager.default.fileExists(atPath: path) {
    //        try! FileManager.default.removeItem(atPath: path)
    //    }
    //}
    
    public func getPathForContentFile(_ filename: String) -> String {
        return contentDir.appending("/" + filename)
    }
    
    private func downloadContentFile(_ filename: String) {
        print("\(Thread.current) - updater: downloading content file \(filename)")
        let destination = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory)
        
        Alamofire.download("https://warp16.ru/ios/content/" + filename, to: destination)
            .downloadProgress(queue: downloadTasksQueue) { progress in
                print("\(Thread.current) - updater: Download content file \(filename) progress: \(progress.fractionCompleted)")
                // todo обновление прогрессбара загрузки одного файла
            }
            .responseData { response in
                if let error = response.error {
                    debugPrint(response)
                    print("\(Thread.current) - updater: download \(filename) failed with error: \(error)")
                    self.haveErrorsDownloadingContentFiles = true
                }else{
                    print("\(Thread.current) - updater: content file \(filename) downloaded")
                    
                    try! FileManager.default.moveItem(atPath: NSHomeDirectory() + "/Documents/" + filename, toPath: self.getPathForContentFile(filename))
                }
        }
    }
}
