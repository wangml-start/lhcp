//
//  SettledAccount.swift
//  lhcp
//
//  Created by V-MAC10 on 2020/12/18.
//

struct SettledAccount:Codable , Hashable{
    var id:Int
    var userId:Int
    var principal:CFloat
    var pl:CFloat
    var cashAmt:Float
    var fee:Float
}
