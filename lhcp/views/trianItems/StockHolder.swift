//
//  StockHolder.swift
//  lhcp
//
//  Created by V-MAC10 on 2020/12/14.
//

import SwiftUI
import UIKit

struct AccountLine :View {
    var lineWidth:CGFloat  {
        return 0.3
    }
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                path.move(to: CGPoint(x: 4, y: 5))
                path.addLine(to: CGPoint(x: UIScreen.main.bounds.width-4, y: 5))
            }.stroke(Color.black, style: StrokeStyle(lineWidth: lineWidth))
            Path { path in
                path.move(to: CGPoint(x: 4, y: 45))
                path.addLine(to: CGPoint(x: UIScreen.main.bounds.width-4, y: 45))
            }.stroke(Color.black, style: StrokeStyle(lineWidth: lineWidth))
            Path { path in
                path.move(to: CGPoint(x: 4, y: 85))
                path.addLine(to: CGPoint(x: UIScreen.main.bounds.width-4, y: 85))
            }.stroke(Color.black, style: StrokeStyle(lineWidth: lineWidth))
            Path { path in
                path.move(to: CGPoint(x: 4, y: 115))
                path.addLine(to: CGPoint(x: UIScreen.main.bounds.width-4, y: 115))
            }.stroke(Color.black, style: StrokeStyle(lineWidth: lineWidth))
            Path { path in
                path.move(to: CGPoint(x: UIScreen.main.bounds.width*1/3, y: 10))
                path.addLine(to: CGPoint(x: UIScreen.main.bounds.width*1/3, y: 80))
            }.stroke(Color.black, style: StrokeStyle(lineWidth: lineWidth))
            Path { path in
                path.move(to: CGPoint(x: UIScreen.main.bounds.width*2/3, y: 10))
                path.addLine(to: CGPoint(x: UIScreen.main.bounds.width*2/3, y: 80))
            }.stroke(Color.black, style: StrokeStyle(lineWidth: lineWidth))
        }
    }
}

struct AccData:Identifiable {
    var id:Int
    var x:CGFloat
    var y:CGFloat
    var text:String
}

struct StockHolder: View {
    @Binding var data:HolderData
    var oneBThreex:CGFloat {
        return UIScreen.main.bounds.width*1/3 * 0.5
    }
    var twoBThreex:CGFloat {
        return UIScreen.main.bounds.width*2/3 - oneBThreex
    }
    var thBThreex:CGFloat {
        return UIScreen.main.bounds.width*1 - oneBThreex
    }
    
    var texts: [AccData] {
        var arr:[AccData] = []
        arr.append(AccData(id: 1, x: oneBThreex-CommonUtil.getHalfSW("总资产"), y: 8, text: "总资产"))
        arr.append(AccData(id: 2, x: twoBThreex-CommonUtil.getHalfSW("可用"), y: 8, text: "可用"))
        arr.append(AccData(id: 3, x: thBThreex-CommonUtil.getHalfSW("手续费"), y: 8, text: "手续费"))
        
        arr.append(AccData(id: 4, x: oneBThreex-CommonUtil.getHalfSW(CommonUtil.formatNumber(num: data.totAmt)),
                           y: 28, text: CommonUtil.formatNumber(num: data.totAmt)))
        arr.append(AccData(id: 5, x: twoBThreex-CommonUtil.getHalfSW(CommonUtil.formatNumber(num: data.avaiAmt)),
                           y: 28, text: CommonUtil.formatNumber(num: data.avaiAmt)))
        arr.append(AccData(id: 6, x: thBThreex-CommonUtil.getHalfSW(CommonUtil.formatNumber(num: data.exchange)),
                           y: 28, text: CommonUtil.formatNumber(num: data.exchange)))
        
        arr.append(AccData(id: 7, x: oneBThreex-CommonUtil.getHalfSW("总市值"), y: 48, text: "总市值"))
        arr.append(AccData(id: 8, x: twoBThreex-CommonUtil.getHalfSW("盈亏"), y: 48, text: "盈亏"))
        arr.append(AccData(id: 9, x: thBThreex-CommonUtil.getHalfSW("盈亏率"), y: 48, text: "盈亏率"))
        arr.append(AccData(id: 10, x: oneBThreex-CommonUtil.getHalfSW(CommonUtil.formatNumber(num: data.holdAmt)),
                           y: 68, text: CommonUtil.formatNumber(num: data.holdAmt)))
        arr.append(AccData(id: 11, x: twoBThreex-CommonUtil.getHalfSW(CommonUtil.formatNumber(num: data.pl)),
                           y: 68, text: CommonUtil.formatNumber(num: data.pl)))
        arr.append(AccData(id: 12, x: thBThreex-CommonUtil.getHalfSW(data.getRealRate()),
                           y: 68, text: data.getRealRate()))
        return arr
    }
    
    
    
    
    var body: some View {
        GeometryReader { geometry in
            AccountLine()
            ForEach(texts) {item in
                Text(item.text).font(FontSet.font12).offset(x: item.x, y: item.y)
            }
            VStack {
                HStack {
                    Spacer()
                    Text("代码/市值")
                    Spacer()
                    Text("持仓/可用")
                    Spacer()
                    Text("现价/成本")
                    Spacer()
                    Text("持仓盈亏")
                    Spacer()
                }.padding(.top, 0.1)
                
                HStack {
                    Spacer()
                    Text(data.getCode)
                    Spacer()
                    Text(data.getHoldShare)
                    Spacer()
                    Text(data.priceStr)
                    Spacer()
                    Text(data.holdplStr)
                    Spacer()
                }.padding(.top, 0.1)
                HStack {
                    Spacer()
                    Text(data.holdAmtStr)
                    Spacer()
                    Text(data.avaiCountStr)
                    Spacer()
                    Text(data.cpriceStr)
                    Spacer()
                    Text(data.getPlRate)
                    Spacer()
                }
                
                Divider()
                Spacer()
            }.font(FontSet.font12).padding(.top, 95)
        }
    }
}

struct StockHolder_Previews: PreviewProvider {
    static var previews: some View {
        StockHolder(data: .constant(HolderData(trainType: 1)))
    }
}




struct HolderData {
    
    var nodes:[Trade] = []
    //交易相关参数
    var code:String  = ""
    
    var initTotAmt:CFloat = 0.0
    var totAmt:CFloat = 0.0
    var holdAmt:CFloat = 0.0
    var holdPl:CFloat = 0.0
    var avaiAmt:CFloat = 0.0
    var costPrice:CFloat = 0.0
    var price:CFloat = 0.0
    var pl:CFloat = 0.0
    
    var holdShare:Int = 0
    var avaiLabelShare:Int = 0
    var exchange:CFloat = 0.0
    //1代表已结算
    var settleStatus:Int = 0
    var holdDays:Int = 0
    //设置的模式
    var modeList:[SettingItem] = []
    //违反的原则
    var unprinciple:[Int] = []
    var trainType:Int
    var modelRecordId:Int = 1
    
    
    mutating func whenNextDay() {
        if(holdShare>0){
            holdDays += 1
        }
    }
    
    var getCode:String {
        if (code.count == 0) {
            return code;
        }
        return "\(code.prefix(4))XX"
    }
    
    var getHoldShare:String{
        if(holdShare == 0){
            return ""
        }else{
            return String(holdShare)
        }
    }
    
    var priceStr:String{
        if(price == 0){
            return ""
        }else{
            return CommonUtil.formatNumber(num: price)
        }
    }
    
    var holdplStr: String{
        if(holdPl == 0){
            return ""
        }else{
            return CommonUtil.formatNumber(num: holdPl)
        }
    }
    
    var  getPlRate:String {
        let delta = price - costPrice
        if(delta == 0){
            return ""
        }else{
            return CommonUtil.formatPercent(num: delta / costPrice)
        }
    }
    
    var holdAmtStr:String{
        if(holdAmt == 0){
            return ""
        }else{
            return CommonUtil.formatNumber(num: holdAmt)
        }
    }
    
    var avaiCountStr:String{
        if(avaiLabelShare == 0){
            return ""
        }else{
            return String(avaiLabelShare)
        }
    }
    
    var cpriceStr:String{
        if(costPrice == 0){
            return ""
        }else{
            return CommonUtil.formatNumber(num: costPrice)
        }
    }
    
    func getRealRate() -> String{
        if (Int(initTotAmt) == 0) {
            return "0.0%"
        }
        return CommonUtil.formatPercent(num: pl / initTotAmt)
    }
    
    mutating func buyStock(_ count:Int, _ pri:CFloat, _ scode:String) {
        code = scode
        holdShare += count
        price = pri
        let buyAmt = pri * CFloat(count)
        var fee:CFloat = 0
        if (scode.hasPrefix("6")) {
            var ghfee:CFloat = CFloat(count) * Constants.guohuRate
            if (ghfee < 1) {
                ghfee = 1
            }
            fee += ghfee
        }
        var brofee = buyAmt * Constants.brokerRate
        if (brofee < 5) {
            brofee = 5
        }
        fee += brofee
        exchange += fee
        totAmt -= fee
        holdAmt += buyAmt
        holdPl -= fee
        avaiAmt = totAmt - holdAmt
        costPrice = (holdAmt - holdPl) / Float(holdShare)
        pl = totAmt - initTotAmt
    }
    
    mutating func sellStock(_ count:Int, _ pri:CFloat) {
        holdShare -= count
        avaiLabelShare -= count
        let sellAmt:CFloat = price * Float(count)
        var yhfee:CFloat = sellAmt * Constants.yinhuaRate
        if (yhfee < 5) {
            yhfee = 5
        }
        var brofee:CFloat = sellAmt * Constants.brokerRate
        if (brofee < 5) {
            brofee = 5
        }
        let fee:CFloat = brofee + yhfee
        exchange += fee
        holdPl -= fee
        holdAmt -= sellAmt
        totAmt -= fee
        avaiAmt = totAmt - holdAmt
        if (holdShare == 0) {
            costPrice = 0
            holdPl = 0
            holdDays = 0
        } else {
            costPrice = (holdAmt - holdPl) / Float(holdShare)
        }
        pl = totAmt - initTotAmt
    }
    
    func getAvaiBuyCount(_ price:String) -> Int {
        let priceNum:CFloat = CFloat(price)!
        let avaiCount = Int(avaiAmt / priceNum / 100)
        return 100 * avaiCount
    }
    
    func getAvaiBuyCount(_ price:String, _ percent:CFloat) -> Int{
        let priceNum = CFloat(price)!
        let avaiAmtTemp = avaiAmt * percent
        let avaiCount = Int(avaiAmtTemp / priceNum / 100)
        
        return 100 * avaiCount
    }
    
    func getAvaiSellCount(_ percent:CFloat ) -> Int {
        let avaiCount:CFloat = Float(avaiLabelShare) * percent / 100
        return Int(100 * avaiCount)
    }
    
    mutating func nextPrice(_ pr:CFloat, _ changeDay:Bool) {
        price = pr
        if (changeDay) {
            avaiLabelShare = holdShare
        }
        holdPl = (price - costPrice) * Float(holdShare)
        holdAmt = price * Float(holdShare)
        totAmt = holdAmt + avaiAmt
        pl = totAmt - initTotAmt
    }
    
    mutating func settleTrading(_ price:CFloat ) {
        if (CommonUtil.floatNumEqual(exchange, 0)) {
            return
        }
        if (settleStatus == 1) {
            nodes.removeAll()
            return;
        }
        settleStatus = 1
        if (holdShare > 0) {
            self.sellStock(holdShare, price)
        }
        let trade = Trade(
            stockCode:code, pl:pl, fee:exchange,
            unprinciple: unprinciple,
            trainType:trainType,modelRecordId:modelRecordId
        )
        nodes.append(trade)
    }
    
    func exists(_ type:Int) -> Bool{
        
        return unprinciple.contains(type)
        
    }
    
    mutating func addOverType(_ type:Int) {
        if(!unprinciple.contains(type)){
            unprinciple.append(type)
        }
    }
    
    
    func getStartRate(_ amt:CFloat) -> CFloat{
        return amt / totAmt
    }
    
    func getHoldRate() -> CFloat{
        return holdAmt / totAmt
    }
    
    func getLossRate() -> CFloat{
        return (price - costPrice) / costPrice
    }
    
}


struct Trade {
    var stockCode:String
    var tradeDate:Date?
    var pl:CFloat
    var fee:CFloat
    var unprinciple:[Int]
    var trainType:Int
    var modelRecordId:Int
}
