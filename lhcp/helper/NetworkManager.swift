//
//  NetUitl.swift
//  lhcp
//
//  Created by V-MAC10 on 2020/12/9.
//

import Foundation
import AFNetworking

class NetworkManager : AFHTTPSessionManager{
    
    private let serverUrl = "http://192.168.1.3:3000"
    
    //单例
    static let shared : NetworkManager = {
        let tools = NetworkManager()
        tools.requestSerializer = AFJSONRequestSerializer()
        tools.responseSerializer = AFJSONResponseSerializer()
        tools.requestSerializer.setValue("application/json,text/html", forHTTPHeaderField: "Accept")
        tools.requestSerializer.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        return tools
    }()
    
    
    /// 封装GET和POST 请求
    ///
    /// - Parameters:
    ///   - requestType: 请求方式
    ///   - urlString: urlString
    ///   - parameters: 字典参数
    ///   - completion: 回调
    func requestPost(action: String, parameters: [String: AnyObject]?, completion: @escaping (ReceiveData) -> ()) {
        let path = "\(serverUrl)/\(action)"
        var params:[String: AnyObject] = [:]
        for(key ,value) in parameters!{
            params[key] = value
        }
        let token = LoginFuns.getToken()
        if(token.count > 0){
            params["token"] = token as AnyObject
        }
        //成功回调
        let success = { (task: URLSessionDataTask, json: Any)->() in
            do{
                let data = try JSONSerialization.data(withJSONObject: json, options: [])
                let receiveData:ReceiveData = NetworkManager.transferData(json:data)
                completion(receiveData)
            }catch{
                var err = ReceiveData()
                err.setStatus(status: -1)
                err.setError(error: "解析JSON失败！")
                completion(err)
            }
        }
        
        //失败回调
        let failure = { (task: URLSessionDataTask?, error: Error) -> () in
            var err = ReceiveData()
            err.setStatus(status: -1)
            err.setError(error: "网络请求错误 \(error)")
            completion(err)
        }
        
        post(path, parameters: params, progress: nil, success: success, failure: failure)
    }
    
    /// 封装GET和POST 请求
    ///
    /// - Parameters:
    ///   - requestType: 请求方式
    ///   - urlString: urlString
    ///   - parameters: 字典参数
    ///   - completion: 回调
    func requestGet(action: String, parameters: [String: AnyObject]?, completion: @escaping (ReceiveData) -> ()) {
        let path = "\(serverUrl)/\(action)"
        var params:[String: AnyObject] = [:]
        for(key ,value) in parameters!{
            params[key] = value
        }
        let token = LoginFuns.getToken()
        if(token.count > 0){
            params["token"] = token as AnyObject
        }
        //成功回调
        let success = { (task: URLSessionDataTask, json: Any)->() in
            do{
               // print(json)
                let data = try JSONSerialization.data(withJSONObject: json, options: [])
                let receiveData:ReceiveData = NetworkManager.transferData(json:data)
                completion(receiveData)
            }catch{
                var err = ReceiveData()
                err.setStatus(status: -1)
                err.setError(error: "解析JSON失败！")
                completion(err)
            }
        }
        
        //失败回调
        let failure = { (task: URLSessionDataTask?, error: Error) -> () in
            var err = ReceiveData()
            err.setStatus(status: -1)
            err.setError(error: "网络请求错误 \(error)")
            completion(err)
        }
        
        get(path, parameters: params, progress: nil, success: success, failure: failure)
    }
    
    func jsonToReceiveData(json:AnyObject) -> ReceiveData?{
        
        return nil
    }
    
    static func transferData<T: Decodable>(json: Data) -> T{
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: json)
        } catch {
            fatalError("Couldn't parse json as \(T.self):\n\(error)")
        }
    }
    
}
