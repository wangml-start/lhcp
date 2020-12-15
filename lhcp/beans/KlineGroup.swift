//
//  KlineGroup.swift
//  lhcp
//
//  Created by V-MAC10 on 2020/12/15.
//

class KlineGroup{
    var nodes:[KLine] = []
    
    var mYMax:CFloat = 0.0
    var mYMin:CFloat = 0.0
    var mMaxYVolume:CFloat = 0.0
    var mYMaxMacd:CFloat = 0.0
    var mYMinMacd:CFloat = 0.0
    
    var ks5:[CFloat] = []
    var ks10:[CFloat] = []
    var ks20:[CFloat] = []
    
    func addKline(kline: KLine){
        nodes.append(kline)
    }
    
    func calcMinMax(start: Int , end:Int ) {
        var lastIndex:Int
        if (end == 0 || end >= nodes.count) {
            lastIndex = nodes.count - 1
        } else {
            lastIndex = end
        }
        let number:CFloat = 99999
        mYMin = number
        mYMax = number * -1
        mMaxYVolume = number * -1
        mYMaxMacd = number * -1
        mYMinMacd = number
        
        var i:Int = start
        while(i <= lastIndex){
            i += 1
            let entry:KLine  = nodes[i]
            if (entry.low < mYMin) {
                mYMin = entry.low
            }
            if (entry.high > mYMax) {
                mYMax = entry.high
            }
            if (entry.volume > mMaxYVolume) {
                mMaxYVolume = entry.volume
            }
            if(entry.dif > mYMaxMacd){
                mYMaxMacd = entry.dif
            }
            if(entry.dea > mYMaxMacd){
                mYMaxMacd = entry.dea
            }
            if(entry.macd > mYMaxMacd){
                mYMaxMacd = entry.macd
            }
            
            if(entry.dif < mYMinMacd){
                mYMinMacd = entry.dif
            }
            if(entry.dea < mYMinMacd){
                mYMinMacd = entry.dea
            }
            if(entry.macd < mYMinMacd){
                mYMinMacd = entry.macd
            }
        }
    }
    
    func calcAverage(days:Int) -> CFloat{
        let blankVal:CFloat = 1.0
        var temp:[CFloat] = []
        if (5 == days) {
            if (ks5.count < 5) {
                return blankVal
            }
            temp = ks5
        } else if (10 == days) {
            if (ks10.count < 10) {
                return blankVal
            }
            temp = ks10
        } else {
            if (ks20.count < 20) {
                return blankVal
            }
            temp = ks20
        }
        var sum:CFloat  = 0
        for num in temp {
            sum += num
        }
        
        return sum / Float(days)
    }
    
    func calcAverageMACD() {
        let map = MacdCalcutor.MACD(s: 12, l: 26, mid: 9, list: nodes)
        let length = nodes.count
        var i:Int = 0
        while(i < length){
            let kline = nodes[i]
            ks5.append(kline.close)
            ks10.append(kline.close)
            ks20.append(kline.close)
            
            if (ks5.count > 5) {
                ks5.removeFirst()
            }
            if (ks10.count > 10) {
                ks10.removeFirst()
            }
            if (ks20.count > 20) {
                ks20.removeFirst()
            }
            kline.avg5 = calcAverage(days: 5);
            kline.avg10 = calcAverage(days: 10);
            kline.avg20 = calcAverage(days: 20);
            
            
            kline.dif = (map["dif"]?[i])!
            kline.dea = (map["dea"]?[i])!
            kline.macd = (map["macd"]?[i])!
            
            i += 1
        }
    }
}
