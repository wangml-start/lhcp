//
//  KLine.swift
//  lhcp
//
//  Created by V-MAC10 on 2020/12/15.
//

class KLine{
    var high:CFloat
    var low:CFloat
    var open:CFloat
    var close:CFloat
    var lastClose:CFloat
    var volume:CFloat
    var avg5:CFloat = 0
    var avg10:CFloat = 0
    var avg20:CFloat = 0
    var dif:CFloat = 0
    var dea:CFloat = 0
    var macd:CFloat = 0
    var isOpen:Bool = false

    init(high:CFloat, low:CFloat, open:CFloat, close:CFloat, lsclose:CFloat, volume:CFloat){
        self.high = high
        self.low = low
        self.open = open
        self.close = close
        self.volume = volume
        self.lastClose = lsclose
      }

    init(open:CFloat, lsclose:CFloat) {
        self.high = open
        self.low = open
        self.open = open
        self.close = open
        self.volume = 1
        self.isOpen = true
        self.lastClose = lsclose
      }
    
    var state:Int {
        let delta = open - close
        if(delta == 0){
            return 0
        }else if (delta > 0){
            return -1
        }else{
            return 1
        }
    }
}
