//
//  CitiesProvider.swift
//  Warp17ios
//
//  Created by Mac on 13.07.17.
//  Copyright © 2017 WarpTeam. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift
import Alamofire

class CitiesViewProvider {
    func loadJson() {
        
        let realm = try! Realm()
        
        let url = "https://warp16.ru/api/cities?token=cc43de317c7b45042d6dd7d09ee12d74"
        
        Alamofire.request(url, method: .get).validate().responseJSON { response in
            
            switch response.result {
            case .success(let value):
                let json = JSON(value)
//                print("JSON: \(json["city"]["name"].stringValue)")
//                let onlineWeather = WeatherData()
//                onlineWeather.city_name = json["city"]["name"].stringValue
                
//                try! realm.write {
//                    realm.add(onlineWeather)
//                }
                
            case .failure(let error):
                print(error)
            }
            
        }
        
    }
}
