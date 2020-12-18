//
//  StockService.swift
//  lhcp
//
//  Created by V-MAC10 on 2020/12/14.
//

import SwiftUI

extension StockView{
    
    func getAction() -> String{
        if(self.trainType == Constants.LEADING_STRATEGY){
            return "/stock/getHigherKlineSet"
        }else{
            return "/stock/getKlineSet"
        }
    }
    
    func loadKAccount(){
        var params:[String: AnyObject] = [:]
        params["train_type"] = self.trainType as AnyObject
        NetworkManager.shared.requestGet(action: "/stock/account_info", parameters: params) { data in
            if(data.status == -1){
                self.showTip = true
                self.tips = data.error ?? ""
            }else{
                let settle = data.settledAccount!
                DispatchQueue.main.async {
                    self.holderData.totAmt = settle.cashAmt
                    self.holderData.avaiAmt = settle.cashAmt
                    self.holderData.initTotAmt = settle.cashAmt
                }
            }
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
    
    /*计算Kline在屏幕上的坐标*/
    func calcLinePoints() -> [KlinePoints] {
        let viewHeight = UIScreen.main.bounds.height * KLineStyle.chartViewRate
        let chartHeight = viewHeight * KLineStyle.chartRate
        let volmeHeight = viewHeight * KLineStyle.volRate
        let macdHeight = viewHeight * KLineStyle.macdRate
        let visibleCount = Int((UIScreen.main.bounds.width-KLineStyle.rightLabelWidth)
                    / (KLineStyle.mBarSpace+KLineStyle.kWidth))
        
        let kCount = self.tradeManager!.group!.nodes.count
        var startIndex = 0
        if(kCount > visibleCount){
            startIndex = kCount - visibleCount
        }
        
        self.tradeManager!.group!.calcMinMax(start: startIndex, end: kCount)
        self.tradeManager!.group!.calcAverageMACD()
        
        var pts:[KlinePoints] = []
        var startx:CGFloat = 0
        
        let priceDelta = self.tradeManager!.group!.mYMax - self.tradeManager!.group!.mYMin
        let punit = (chartHeight-KLineStyle.chartSpace*2) / CGFloat(priceDelta)
        let vunit = (volmeHeight-KLineStyle.volSpace*2) / CGFloat(self.tradeManager!.group!.mMaxYVolume)
        let macdDelta = self.tradeManager!.group!.mYMaxMacd - self.tradeManager!.group!.mYMinMacd
        let munit = (macdHeight-KLineStyle.macdSpace*2) / CGFloat(macdDelta)
        
        for (nIndex, node) in self.tradeManager!.group!.nodes.enumerated() {
            if(nIndex < startIndex){
                continue
            }
            let nStart = nIndex-startIndex
            startx = KLineStyle.mBarSpace * CGFloat(nStart + 1) + KLineStyle.kWidth * CGFloat(nStart)
            let half = CGFloat(KLineStyle.kWidth / 2)
            let ySpace = KLineStyle.chartSpace
            let macdY = chartHeight + volmeHeight
            var kp = KlinePoints(
                id: nStart, openPt: CGPoint(x: startx, y: CGFloat((self.tradeManager!.group!.mYMax - node.open)) * punit+ySpace),
                closePt: CGPoint(x: startx, y: CGFloat((self.tradeManager!.group!.mYMax - node.close)) * punit+ySpace),
                highPt: CGPoint(x: startx + CGFloat(half), y: CGFloat((self.tradeManager!.group!.mYMax - node.high)) * punit+ySpace),
                lowPt: CGPoint(x: startx + CGFloat(half), y: CGFloat((self.tradeManager!.group!.mYMax - node.low)) * punit+ySpace),
                state: node.state,
                isOpen: node.isOpen,
                volumePt: CGPoint(x: startx, y: CGFloat((self.tradeManager!.group!.mMaxYVolume - node.volume)) * vunit+chartHeight+KLineStyle.volSpace),
                volBPt: CGPoint(x: startx, y: macdY),
                difPt: CGPoint(x: startx + CGFloat(half), y: CGFloat(self.tradeManager!.group!.mYMaxMacd - node.dif) * munit + macdY+KLineStyle.macdSpace),
                deaPt: CGPoint(x: startx + CGFloat(half), y: CGFloat(self.tradeManager!.group!.mYMaxMacd - node.dea) * munit + macdY+KLineStyle.macdSpace),
                macdPt: CGPoint(x: startx + CGFloat(half), y: CGFloat(self.tradeManager!.group!.mYMaxMacd - node.macd) * munit + macdY+KLineStyle.macdSpace),
                macdBPt: CGPoint(x: startx + CGFloat(half), y: CGFloat(self.tradeManager!.group!.mYMaxMacd) * munit + macdY+KLineStyle.macdSpace),
                macdState: node.macd >= 0 ? 1 : -1
            )

            //均线
            if(node.avg5 != -1){
                kp.line5Pt = CGPoint(x: startx + CGFloat(half),
                                     y: CGFloat((self.tradeManager!.group!.mYMax - node.avg5)) * punit+ySpace)
            }
            if(node.avg10 != -1){
                kp.line10Pt = CGPoint(x: startx + CGFloat(half),
                                     y: CGFloat((self.tradeManager!.group!.mYMax - node.avg10)) * punit+ySpace)
            }
            if(node.avg20 != -1){
                kp.line20Pt = CGPoint(x: startx + CGFloat(half),
                                     y: CGFloat((self.tradeManager!.group!.mYMax - node.avg20)) * punit+ySpace)
            }

            pts.append(kp)
        }
        return pts
    }
    
    /*计算价格线坐标*/
    func calcPriceLines() -> [PriceLines] {
        let viewHeight = UIScreen.main.bounds.height * KLineStyle.chartViewRate
        let chartHeight = viewHeight * KLineStyle.chartRate
        var lines:[PriceLines] = []
        let priceDelta = self.tradeManager!.group!.mYMax - self.tradeManager!.group!.mYMin
        let punit = (chartHeight) / CGFloat(priceDelta)
        
        let endx = UIScreen.main.bounds.width-KLineStyle.mBarSpace
        let startx = KLineStyle.mBarSpace
        
        for index in 0 ..< 5 {
            let y = chartHeight * CGFloat(index) / 4
            let price = CommonUtil.formatNumber(num: self.tradeManager!.group!.mYMax - Float(y/punit))
            lines.append(PriceLines(
                            id: index,
                            startPt: CGPoint(x: startx, y: y),
                            endPt: CGPoint(x: endx, y: y),
                            price: price))
        }
        //print(lines)
        return lines
    }
        
      
    
   
}
