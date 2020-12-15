//
//  StockDetail.swift
//  lhcp
//
//  Created by V-MAC10 on 2020/12/15.
//

struct StockDetail : Codable,Hashable, Identifiable{
    var id:Int
    var stackCode:String
    var quoteDate:String
    var start:CFloat
    var end:CFloat
    var upDown:CFloat

    var upRate:String
    var low:CFloat
    var high:CFloat
    var vol:CFloat
    var amount:CFloat
    var exchageRate:String
    var openrate:String?
}
