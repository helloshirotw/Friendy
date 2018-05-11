//
//  Service.swift
//  TwitterLBTA
//
//  Created by Gary Chen on 10/4/2018.
//  Copyright © 2018 Gary Chen. All rights reserved.
//

import Foundation
import TRON
import SwiftyJSON


struct Service {
    
    let tron = TRON(baseURL: "https://api.letsbuildthatapp.com")
    
    static let sharedInstance = Service()
    
    func fetchHomeFeed(completion: @escaping (HomeDatasource?, Error?) -> ()) {
        // This is a lot of code, use tron instead
        //        URLSession.shared.dataTask(with: , completionHandler: )
        
        let request: APIRequest<HomeDatasource, JSONError> = tron.swiftyJSON.request("/twitter/home")
        
        request.perform(withSuccess: { (homeDatasource) in
            print(2)
            
            completion(homeDatasource, nil)

        }) { (err) in
            completion(nil, err)
        }
        print(1)
    }
    
    class JSONError: JSONDecodable {
        required init(json: JSON) throws {
            print("JSON ERROR")
        }
    }
    
}
