//
//  StockService.swift
//  lhcp
//
//  Created by V-MAC10 on 2020/12/14.
//

import Foundation

extension StockView{
    
    func getAction() -> String{
        if(self.trainType == Constants.LEADING_STRATEGY){
            return "/stock/getHigherKlineSet"
        }else{
            return "/stock/getKlineSet"
        }
    }
    
    func loadKline(){
        let params:[String: AnyObject] = [:]
        NetworkManager.shared.requestGet(action: self.getAction(), parameters: params) { data in
            if(data.status == -1){
                self.showTip = true
                self.tips = data.error ?? ""
            }else{
                self.tradeManager = TradePageManager()
                self.tradeManager?.klineset = data.klineSet
                self.startChartInit()
                print("\(data.klineSet?.stockName) \(data.klineSet?.stockCode) \(data.klineSet?.startDate)")
            }
        }
    }
    
    func startChartInit() {
        if(self.tradeManager!.showNextOpen()){
            self.loadedChart = true
        }
    }
    
   
}
