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
    static var token = ""
    
    let queue = DispatchQueue(label: "api_request_results")
    
    func request(endpoint: String, parameters: Parameters, method: HTTPMethod = .get, completion: @escaping (_ json: JSON) -> Void) {
        
        let requestUrl = "\(url)\(endpoint)"
        
        var params = parameters
        params["token"] = ApiClient.token
        
        print("\(Thread.current) - api client: alamofire calling \(requestUrl)...")
        
        Alamofire.request(requestUrl, method: method, parameters: params).validate().responseJSON { response in
            switch response.result {
                case .success(let value):
                    print("\(Thread.current) - api client: alamofire calling \(requestUrl) success!")
                    
                    self.queue.async {
                        print("\(Thread.current) - api client: alamofire calling \(requestUrl) - api queue async -> proceed with json closure...")
                        
                        completion(JSON(value))
                    }
                case .failure(let error):
                    print("\(Thread.current) - api client: failed \(requestUrl)")
                    debugPrint(response)
                    print(response.value)
                    UiUtils.sharedInstance.errorAlert(
                        text: "Error with internet connection, please retry later."
                    )
            }
        }
    }
}
