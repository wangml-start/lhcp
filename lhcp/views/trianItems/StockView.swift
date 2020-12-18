//
//  StockView.swift
//  lhcp
//
//  Created by V-MAC10 on 2020/12/14.
//

import SwiftUI

struct StockView: View {
    var trainType:Int
    
    @State var openPrice:String = "26.35"
    @State var openRate:String = "2.35%"
    @State var exchangeRate:String = "25.3%"
    @State var leftDay:String = "59"
    @State var closePrice:String = "27.12"
    @State var closeRate:String = "4.56%"
    
    @State var tradeManager:TradePageManager?
    @State var holderData:HolderData
    @State var openStatus:Int = 0
    @State var closeStatus:Int = 0
    @State var tips:String = ""
    @State var showTip:Bool = false
    @State var loadedChart:Bool = false
    @State var loadedAcc:Bool = false
    var font = FontSet.font12

    
    var body: some View {
        VStack {
            //base info
            HStack {
                VStack{
                    Text("开盘价: \(openPrice)").font(font)
                    Text("涨跌: \(openRate)").font(font)
                }
                .padding(.leading, 10)
                .foregroundColor(self.loadColor())
                Spacer()
                VStack{
                    Text("昨换手: \(exchangeRate)").font(font)
                    Text("剩余: \(leftDay) 天").font(font)
                }
                Spacer()
                VStack{
                    Text("收盘价: \(closePrice)").font(font)
                    Text("涨跌: \(closePrice)").font(font)
                }
                .padding(.trailing, 10)
            }
            .edgesIgnoringSafeArea(.bottom)
            .frame(width:UIScreen.main.bounds.width,height: 40)
            
            if(loadedChart){
                KLineView(chartPts: self.calcLinePoints(),
                          linePts: self.calcPriceLines())
                .frame(height: UIScreen.main.bounds.height * KLineStyle.chartViewRate)
                    //.background(MyColor.div_white)
                Divider()
                StockHolder(data: $holderData)
            }
            
            Spacer()
        }
        .onAppear{
            self.showTip.toggle()
            self.tips = "正在请求数据。。。"
            self.loadKline()
            self.loadKAccount()
        }
        //        .navigationBarHidden(true)
        .toast(isShow: $showTip, info: tips)
    }
    
    
    func loadColor() -> Color {
        switch self.openStatus{
        case 1:
            return MyColor.line_up
        case -1:
            return MyColor.line_down
        default:
            return Color.black
        }
    }
}

struct StockView_Previews: PreviewProvider {
    static var previews: some View {
        StockView(trainType: Constants.NORMAL_STRATEGY, holderData: HolderData(trainType: Constants.NORMAL_STRATEGY))
    }
}
