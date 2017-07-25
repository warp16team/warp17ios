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

// todo использование картинок при отображении перечня планет и городов
class Updater {
    private let contentDir: String = NSHomeDirectory().appending("/Content")
    
    // создание последовательной очереди
    let downloadTasksQueue = DispatchQueue(label: "updates_download_queue")
    
    private var downloadQueue: [String] = []
    
    public func proceed() {
        // todo инициализация view прогрессбара
        let provider = UpdatesProvider(updater: self)
        provider.loadJson() // запрос к api UpdatesProvider - переадресация на функцию proceedSync
    }
    
    public func proceedSync(files: JSON) {
        // переадресация из провайдера с прокидыванием json
        
        for (_, subJson) in files {
            if (!checkAlreadyDownloaded(file: subJson)) {
                downloadQueue.append(subJson["filename"].stringValue)
                print("updated file \(subJson["filename"]) must be downloaded")
            }
        }

        createContentDirectory() // создание каталога контента
        
        // идем по списку и загружаем файлы
        for filename in downloadQueue {
            downloadContentFile(filename)
            // todo обновление progressbar
        }
        
        // todo показываем обычный view controller
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
            print("already have \(file["filename"].stringValue)")
            return true
        }
        
        return false
    }
    
    private func isFileExists(_ filename: String) -> Bool {
        let path = getPathForContentFile(filename)
        // debug delete file
        //if FileManager.default.fileExists(atPath: path) {
        //    try! FileManager.default.removeItem(atPath: path)
        //}
        // end of debug
        
        return FileManager.default.fileExists(atPath: path)
    }
    
    private func getPathForContentFile(_ filename: String) -> String {
        return contentDir.appending("/" + filename)
    }
    
    private func downloadContentFile(_ filename: String) {
        print("downloading content file \(filename)")
        let destination = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory)
        
        Alamofire.download("https://warp16.ru/ios/content/" + filename, to: destination)
            .downloadProgress(queue: downloadTasksQueue) { progress in
                print("Download content file \(filename) progress: \(progress.fractionCompleted)")
                // todo обновление прогрессбара загрузки одного файла
            }
            .responseData { response in
                if let error = response.error {
                    debugPrint(response)
                    print("Failed with error: \(error)")
                }else{
                    print("download content file \(filename) complete - no error occured")
                    
                    try! FileManager.default.moveItem(atPath: NSHomeDirectory() + "/Documents/" + filename, toPath: self.getPathForContentFile(filename))
                }
        }
    }
}
