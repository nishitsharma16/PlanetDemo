//
//  WebServiceManager.swift
//  JPMC
//
//  Created by B0095764 on 1/8/19.
//  Copyright © 2019 Mine. All rights reserved.
//

import Foundation

/**
 This Type to define different type of requests.
 */

enum RequestType : String {
    case GET
    case POST
    case PUT
    case DELETE
}

/**
 This Type is used for fetching, uploading data from or to any API from the server.
 */

final class WebServiceManager {
    
    static let sharedInstance = WebServiceManager()
    private var taskList = [URLSessionDataTask]()

    private init() {
        
    }
}

extension WebServiceManager : WebEngineDataDownloader {
    
    /**
     This method will be used for creating web request.
     - Parameter path: path is the end point from which we need to load the data from server.
     - Parameter param: param is json we need to give as request param.
     - Parameter headers: headers is the additional headers which are required for URL request.
     - Parameter type: type is the RequestType (i.e. GET, POST, DELETE, PUT etc.).
     - Parameter completion: completion is the callback once data is fetched.
     */
    
    func createDataRequest(withPath path : String, withParam param: [AnyHashable : Any]?, withCustomHeader headers : [String : String]? , withRequestType type : RequestType, withCompletion completion : ((Any?, DataError?) -> Void)?)
    {
        switch type {
        case .GET:
            CacheManager.sharedInstance.getData(forKey: path) { [weak self] (data) in
                if let dataVal = data {
                    if let handler = completion {
                        handler(dataVal, nil)
                    }
                }
                else {
                    self?.createRequest(withPath: path, withParam: param, withCustomHeader: headers, withRequestType: type, withCompletion: completion)
                }
            }
        default:
            print("TO DO")
        }
    }
}

// Private Method Extension

extension WebServiceManager {

    private func createRequest(withPath path : String, withParam param: [AnyHashable : Any]?, withCustomHeader headers : [String : String]? , withRequestType type : RequestType, withCompletion completion : ((Any?, DataError?) -> Void)?)
    {
        let successBlock = { [weak self] (dataTask: URLSessionDataTask?, response : Any?) in
            guard let responseData = response as? Data else {
                let error = DataError()
                if let handler = completion {
                    handler(nil, error)
                }
                return
            }
            
            do {
                let jsonObject = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers)
                CacheManager.sharedInstance.saveData(withData: jsonObject, forKey: path, withCompletion: { (status) in
                })
                
                if let handler = completion {
                    handler(jsonObject, nil)
                }
            } catch let myJSONError {
                let error = DataError()
                print(myJSONError)
                if let handler = completion {
                    handler(nil, error)
                }
            }
            
            self?.removeTask(dataTask: dataTask)
        }
        
        let failureBlock = { [weak self] (dataTask: URLSessionDataTask?, error : Error?) in
            guard let dataError = error else {
                let error = DataError()
                if let handler = completion {
                    handler(nil, error)
                }
                return
            }
            
            let error = DataError(withError: dataError)
            if let handler = completion {
                handler(nil, error)
            }
            
            self?.removeTask(dataTask: dataTask)
        }
        
        switch type {
        case .GET:
            let dataTask = self.getRequest(withURLStr: path, requestType: type, param: param, headers: headers, successHander: successBlock, failureHandler: failureBlock)
            addTask(dataTask: dataTask)
        case .POST:
            print("Not Required")
        case .DELETE:
            print("Not Required")
        case .PUT:
            print("Not Required")
        }
    }
    
    private func getRequest(withURLStr urlStr : String, requestType type: RequestType, param paramVal: [AnyHashable : Any]?, headers headerVal: [String : String]?, successHander successBlock: ((URLSessionDataTask?, Any?) -> Void)?, failureHandler failureBlock: ((URLSessionDataTask?, Error?) -> Void)?) -> URLSessionDataTask? {
        let dataTaskVal = dataTask(withURLStr: urlStr, requestType: type, param: paramVal, headers: headerVal, successHander: successBlock, failureHandler: failureBlock)
        dataTaskVal?.resume()
        return dataTaskVal
    }
    
    private func dataTask(withURLStr urlStr : String, requestType type: RequestType, param paramVal: [AnyHashable : Any]?, headers headerVal: [String : String]?, successHander successBlock: ((URLSessionDataTask?, Any?) -> Void)?, failureHandler failureBlock: ((URLSessionDataTask?, Error?) -> Void)?) -> URLSessionDataTask? {
        guard let urlReq = URL(string: urlStr) else {
            return nil
        }
        
        var request = URLRequest(url: urlReq)
        request.httpMethod = requestMethod(withRequestType: type)
        if let customHeader = headerVal {
            for (key, value) in customHeader {
                if let _ = request.value(forHTTPHeaderField: key)
                {
                    
                }
                else {
                    request.setValue(value, forHTTPHeaderField: key)
                }
            }
        }
        
        if let paramData = paramVal {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: paramData, options: JSONSerialization.WritingOptions(rawValue: 0))
            } catch let myJSONError {
                print(myJSONError)
                return nil
            }
        }
        
        var task : URLSessionDataTask?
        task = dataTask(withRequest: request) { (response, data, error) in
            if let dataError = error
            {
                if let failure = failureBlock
                {
                    failure(task, dataError)
                }
            }
            else
            {
                if let success = successBlock
                {
                    success(task, data)
                }
            }
        }
        
        return task
    }
    
    private func dataTask(withRequest reuest : URLRequest, withCompletion completion : ((URLResponse?, Any?, Error?) -> Void)?) -> URLSessionDataTask? {
        let dataTask = URLSession.shared.dataTask(with: reuest) { (data, response, error) in
            
            DispatchQueue.main.async {
                if let handler = completion {
                    handler(response, data, error)
                }
            }
        }
        return dataTask
    }
    
    
    private func requestMethod(withRequestType type : RequestType) -> String {
        return type.rawValue
    }
    
    private func addTask(dataTask : URLSessionDataTask?) {
        if let task = dataTask, taskList.contains(task) {
            taskList.append(task)
        }
    }
    
    private func removeTask(dataTask : URLSessionDataTask?) {
        if let task = dataTask, taskList.contains(task) {
            if let index = taskList.index(of: task) {
                taskList.remove(at: index)
            }
        }
    }
}

