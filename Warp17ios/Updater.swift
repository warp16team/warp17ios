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
    private let contentUrl: String = "file://" + NSHomeDirectory().appending("/Content")
    
    public func proceed() {
        //getUpdatesList()
    }
    
    public func proceedSync(files: [JSON]) {
        // createContentDirectory() создание каталога обновлений
        // checkForExistsFiles() проверка загруженности обновлений - создание списка на download
        // идем по списку и загружаем файлы
        // показываем обычный view controller
    }
    
    private func getUpdatesList()
    {
        // todo
        // запрос к api UpdatesProvider - переадресация на функцию proceedSync
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
    
    private func checkForExistsFiles(listFiles: [JSON]) {
        for filename in listFiles {
            // todo возможно использование realm как хранилища списка загруженных обновлений
            if !isFileExists(filename.stringValue) {
                // todo добавление в очередь на download
            }
        }
    }
    
    private func isFileExists(_ filename: String) -> Bool {
        return FileManager.default.fileExists(atPath: getPathForContentFile(filename))
    }
    
    private func getPathForContentFile(_ filename: String) -> String {
        return contentDir.appending("/" + filename)
    }
    
    private func getUrlForContentFile(_ filename: String) -> URL {
        return URL(string: contentUrl.appending("/" + filename))!
    }
    
    private func downloadContentFile(_ filename: String) {
        let utilityQueue = DispatchQueue.global(qos: .utility)
        
        Alamofire.download("https://warp16.ru/ios/content/" + filename)
            .downloadProgress(queue: utilityQueue) { progress in
                print("Download Progress: \(progress.fractionCompleted)")
                // todo progressbar interface update
            }
            .responseData { response in
                if let data = response.result.value {
                    try! data.write(to: self.getUrlForContentFile(filename))
                }
        }
    }
}
