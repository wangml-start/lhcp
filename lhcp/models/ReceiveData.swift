//
//  ReceiveData.swift
//  lhcp
//
//  Created by V-MAC10 on 2020/12/10.
//

import Foundation

struct ReceiveData: Hashable, Codable {
    var status:Int?
    var error:String?
    var recordId:Int?
    var user:User?
    var klineSet:KlineSet?
    var settledAccount:SettledAccount?
    
}

extension ReceiveData{
    mutating func setStatus(status: Int){
        self.status = status
    }
    
    mutating func setError(error: String){
        self.error = error
    }
}
