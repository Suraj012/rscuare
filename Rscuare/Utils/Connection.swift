//
//  Connection.swift
//  Rscuare
//
//  Created by suraj on 8/16/18.
//  Copyright © 2018 suraj. All rights reserved.
//

import Foundation
import Alamofire

protocol LoaderCallback : class {
    func onDataLoad(_ json: JSON)
}

class Connection {
    
    var url: String
    var parameters = [String:String]()
    let callback: LoaderCallback?
    
    init(url: String, callback: LoaderCallback, parameters: [String:String]) {
        self.url = url
        self.callback = callback
        self.parameters = parameters
    }
    
    init(url:String, parameters: [String:String]) {
        self.url = url
        self.callback = nil
        self.parameters = parameters
    }
    
    func run() {
        //http:\\nshipster.com\alamofire\
        /**
         https://www.weheartswift.com/closures/
         **/
        let myrespone = Alamofire.request(url, parameters: self.parameters)
        myrespone.responseJSON() {
            (response) in
            if let data = response.data {
                let result = JSON(data: data)
                if let call = self.callback {
                    call.onDataLoad(result)
                }
            }
        }
    }
    
    
    func start(_ success : @escaping (_ result:JSON, _ success : Bool) -> Void ) {
        let myresponse = Alamofire.request(url, method: .post, parameters: self.parameters)
        myresponse.responseJSON() {
            (response) in
            guard response.result.isSuccess else {
                success(JSON.null, false)
                return;
                
            }
            
            if let data = response.data {
                let result = JSON(data: data)
                success(result, true)
            }
            
        }
    }
    func load(_ success : @escaping (_ result:JSON, _ success : Bool) -> Void ) {
        let myresponse = Alamofire.request(url, method: .get, parameters: self.parameters)
        myresponse.responseJSON() {
            (response) in
            guard response.result.isSuccess else {
                success(JSON.null, false)
                return;
                
            }
            
            if let data = response.data {
                let result = JSON(data: data)
                success(result, true)
            }
            
        }
    }
    
}

