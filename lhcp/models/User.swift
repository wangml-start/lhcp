//
//  User.swift
//  lhcp
//
//  Created by V-MAC10 on 2020/12/10.
//

import Foundation

struct User: Hashable, Codable, Identifiable{
    var id:Int?
    var imageCut:String?
    var password:String?
    var phone:String?
    var signature:String?
    var status:Int?
    var token:String?
    var userName:String?
    var active:Int?
}


