//
//  CitiesProvider.swift
//  Warp17ios
//
//  Created by Mac on 13.07.17.
//  Copyright © 2017 WarpTeam. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class UpdatesProvider: ApiClient {
    var endpoint = "/updates"
    private var updater: Updater = Updater()
    
    init(updater: Updater) {
        self.updater = updater
    }
    
    private var dataStorage: DataStorage {
        get {
            return DataStorage.sharedInstance
        }
    }
    
    func loadJson() {
        print("calling endpoint to find content updates...")
        request(endpoint: endpoint, parameters: Parameters())
    }
    
    override func proceedWithJSON(json: JSON) {
        print("api returned list of content:")
        print(json)
        
        updater.proceedSync(files: json["content"])
        
        print("updates: finished loading data fron json")
    }
}
