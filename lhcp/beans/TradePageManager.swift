//
//  TradePageManager.swift
//  lhcp
//
//  Created by V-MAC10 on 2020/12/15.
//

class TradePageManager{
    var klineset:KlineSet?
    var group:KlineGroup?
    var lastK:StockDetail?
    var currentK:StockDetail?
    var kStatus:String = ""
    
    
    
    func fixInitDate() {
        self.group = KlineGroup()
        for detail in klineset!.initList{
            var last:CFloat = 0
            if(lastK != nil){
                last = lastK!.end
            }
            self.group!.addKline(kline: KLine(
                                    high: detail.high,
                                    low: detail.low,
                                    open: detail.start,
                                    close: detail.end,
                                    lsclose: last,
                                    volume: detail.vol))
            lastK = detail
        }
    }
    
    func showNextOpen() -> Bool{
        if (klineset!.futureList.count > 0) {
            fixInitDate()
            if(currentK != nil){
                lastK = currentK
            }
            currentK = klineset!.futureList[0]
            let num = (currentK!.start - lastK!.end) / lastK!.end
            if(num > -0.2){
                currentK?.openrate = CommonUtil.formatPercent(num: num)
            }else{
                currentK?.openrate = "--"
            }
            self.group!.addKline(kline: KLine(open: currentK!.start,lsclose:lastK!.end))
            
            kStatus = Constants.OPEN
            
            setDatas()
            
            return true
        }
        
        return false;
    }
    
    func showNextClose() {
        fixInitDate()
        self.group!.addKline(kline: KLine(
            high: currentK!.high,
            low: currentK!.low,
            open: currentK!.start,
            close: currentK!.end,
            lsclose: lastK!.end,
            volume: currentK!.vol
        ))
        klineset!.futureList.removeFirst()
        klineset!.initList.append(currentK!)
        setDatas();
        kStatus = Constants.CLOSE
    }
    
    func setDatas() {
        self.group!.calcAverageMACD()
    }
    
    func getLeftDay() -> Int{
        return klineset!.futureList.count - 1
    }
    
    public func getkStatus() -> String{
        return kStatus
    }
    
    public func openWithUp() -> Bool{
        return  (currentK!.start - lastK!.end) > 0
    }
    
    public func openWithDown() -> Bool{
        return  (currentK!.start - lastK!.end) < 0
    }
    
    
    public func getCurenPrice() -> String{
        if(kStatus == Constants.OPEN){
            return CommonUtil.formatNumber(num: currentK!.start)
        }else{
            return CommonUtil.formatNumber(num: currentK!.end)
        }
    }
    
    /**
     * 0 可以买入
     * -10 跌停
     * 10 涨停
     * @return
     */
    public func canTradingStatus() -> Int{
        var flag:Int = 0
        if(kStatus == Constants.OPEN){
            var rate = currentK!.openrate?.replacingOccurrences(of: "%", with: "")
            rate = rate!.replacingOccurrences(of: "_", with: "")
            if(rate?.count == 0){
                return flag
            }
            if(CFloat(rate!)! > 9.85){
                flag = 10
            }
            if(CFloat(rate!)! < -9.85){
                flag = -10;
            }
        }else{
            let rate = currentK!.upRate.replacingOccurrences(of: "%", with: "")
            if(rate.count == 0){
                return flag
            }
            if(CFloat(rate)! > 9.85 && (currentK!.high - currentK!.end) < 0.001){
                flag = 10
            }
            if(CFloat(rate)! < -9.85 && (currentK!.end - currentK!.low) < 0.001){
                flag = -10
            }
        }
        return flag
    }
}
