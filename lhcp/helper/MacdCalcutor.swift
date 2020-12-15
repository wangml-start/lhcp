//
//  MACDCalcuTor.swift
//  lhcp
//
//  Created by V-MAC10 on 2020/12/15.
//


public class MacdCalcutor {

    /**
     * @param n    周期 12 26 9
     * @param list
     * @return
     */
    static func EMA(n:Int, list: [KLine]) -> [CFloat] {
        var ema:[CFloat] = []
        let length:Int = list.count
        let factor:CFloat  = 2.0 / CFloat(n + 1)
        let kk:KLine = list[0]
        ema.append(kk.close)
        var i:Int = 1
        while(i < length){
            let entity:KLine = list[i]
            ema.append(factor * entity.close + (1 - factor) * ema[i - 1])
            i += 1
        }
        return ema;
    }

    /**
     * 重载方法
     *
     * @param n
     * @param list
     * @return
     */
    static func EMA(n:Int, list:[CFloat]) -> [CFloat]{
        var ema:[CFloat] = []
        let length:Int = list.count
        let factor:CFloat  = 2.0 / CFloat(n + 1)
        ema.append(list[0]);
        var i:Int = 1
        while(i < length){
            ema.append(factor * list[i] + (1 - factor) * list[i - 1])
            i += 1
        }
       
        //普通一维数组

        return ema;
    }


    /**
     * @param mid
     * @param dif
     * @return
     */
    static func DEA(mid:Int , dif:[CFloat] ) -> [CFloat]{
        return MacdCalcutor.EMA(n: mid, list: dif)
    }

    /**
     * @param s    12
     * @param l    26
     * @param list
     * @return
     */
    static func DIF(s:Int, l:Int, list:[KLine]) -> [CFloat]{
        var dif:[CFloat] = []
        let emaShort = EMA(n: s, list: list)
        let emaLong = EMA(n: l, list: list)
        let length = list.count
        var i:Int = 0
        while(i < length){
            dif.append(emaShort[i] - emaLong[i])
            i += 1
        }
        return dif
    }

    static func MACD(s:Int, l:Int, mid:Int, list:[KLine]) -> [String:[CFloat]] {
        var result = [String:[CFloat]]()
        var macd:[CFloat] = []
        let dif = DIF(s: s, l: l, list: list)
        let dea = DEA(mid: mid, dif: dif)
        var i:Int = 0
        while(i < list.count){
            macd.append((dif[i] - dea[i]) * 2)
            i += 1
        }
        
        result["dif"] = dif
        result["dea"] = dea
        result["macd"] = macd
        
        return result
    }
}
