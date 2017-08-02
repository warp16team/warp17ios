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
    
    func loadJson() {
        print("\(Thread.current) - updates provider: calling endpoint...")
        request(endpoint: endpoint, parameters: Parameters())
    }
    
    override func proceedWithJSON(json: JSON) {
        print("\(Thread.current) - updates provider: api returned list of content")
        updater.proceedSync(files: json["content"])        
        print("\(Thread.current) - updates provider: finished loading data fron json")
    }
}
