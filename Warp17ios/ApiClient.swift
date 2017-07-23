//
//  ApiClient.swift
//  Warp17ios
//
//  Created by Mac on 14.07.17.
//  Copyright © 2017 WarpTeam. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class ApiClient {
    var url = "https://warp16.ru/app_dev.php/api"
    var token = ""
    
    func request(endpoint: String, parameters: Parameters, method: HTTPMethod = .get) {
        
        let requestUrl = "\(url)\(endpoint)"
        print(requestUrl)
        
        var params = parameters
        params["token"] = token
        
        Alamofire.request(requestUrl, method: method, parameters: params).validate().responseJSON { response in            
                switch response.result {
                case .success(let value):
                    self.proceedWithJSON(json: JSON(value))
                case .failure(let error):
                    print(error)
                    UiUtils.sharedInstance.errorAlert(
                        text: "Error with internet connection, please retry later."
                    )
                }
            
        }
    }
    
    func proceedWithJSON(json: JSON) {
        
    }
}
