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

class UpdatesProvider
{
    private var updater: Updater = Updater()
    
    init(updater: Updater) {
        self.updater = updater
    }
    
    func loadJson() {
        print("\(Thread.current) - updates provider: calling endpoint...")
        
        let client = ApiClient()
        
        client.request(endpoint: "/updates", parameters: Parameters()) { json in
            
            print("\(Thread.current) - updates provider: api returned list of content")
            self.updater.proceedSync(files: json["content"])
            print("\(Thread.current) - updates provider: finished loading data fron json")

        }
    }
}
