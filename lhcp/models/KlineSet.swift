//
//  KlineSet.swift
//  lhcp
//
//  Created by V-MAC10 on 2020/12/15.
//

struct KlineSet : Codable, Hashable{
    var stockName:String
    var stockCode:String
    var startDate:String
    var endDate:String
    var initList:[StockDetail]
    var futureList:[StockDetail]
}
