//
//  KLine.swift
//  lhcp
//
//  Created by V-MAC10 on 2020/12/14.
//

import SwiftUI


struct KlinePoints:Identifiable {
    var id: Int
    
    var openPt:CGPoint
    var closePt:CGPoint
    var highPt:CGPoint
    var lowPt:CGPoint
    var state:Int
    var isOpen:Bool
    
    var volumePt:CGPoint
    var volBPt:CGPoint
    
    var line5Pt:CGPoint?
    var line10Pt:CGPoint?
    var line20Pt:CGPoint?
    
    var difPt:CGPoint
    var deaPt:CGPoint
    var macdPt:CGPoint
    var macdBPt:CGPoint
    var macdState:Int
    
}
struct PriceLines:Identifiable{
    var id: Int
    var startPt:CGPoint
    var endPt:CGPoint
    var price:String
}

struct KLineStyle {
    static let mBarSpace:CGFloat = 2.8
    static let kLineBold:CGFloat = 0.9
    static let rightLabelWidth:CGFloat = 30
    

    static let kWidth:CGFloat = 6
    
    static let chartViewRate:CGFloat = 0.5
    static let chartRate:CGFloat = 0.6
    static let volRate:CGFloat = 0.2
    static let macdRate:CGFloat = 0.2
    
    static let chartSpace:CGFloat = 5
    static let volSpace:CGFloat = 2.5
    static let macdSpace:CGFloat = 2.5
    
}


struct KLineView: View {
    var chartPts:[KlinePoints]
    //价格线计算
    var linePts:[PriceLines]

    var body: some View {
        GeometryReader { geometry in
            //绘制价格线
            ForEach(0..<linePts.count) { index in
                Path { path in
                    path.move(to: linePts[index].startPt)
                    path.addLine(to: linePts[index].endPt)
                }.stroke(Color.gray, style: StrokeStyle(lineWidth:0.3))
                
                //价格线
                Text(linePts[index].price)
                    .font(FontSet.font10)
                    .offset(x: linePts[index].endPt.x - 20, y: (index == 4) ? linePts[index].endPt.y-15 : linePts[index].endPt.y+2)
                    .foregroundColor(.black)
            }
           
            Text("VOL")
                .font(FontSet.font10)
                .offset(x: linePts[0].endPt.x - 30, y: geometry.size.height * 0.6)
                .foregroundColor(.black)
            Text("MACD")
                .font(FontSet.font10)
                .offset(x: linePts[0].endPt.x - 30, y: geometry.size.height * 0.8)
                .foregroundColor(.black)
            
            //绘制KLine
            ForEach(0..<chartPts.count) { index in
                SingelK(pts: chartPts[index])
                //均线
                if(index > 0){
                    AverageLine(pts: chartPts[index], lastPts: chartPts[index-1])
                }
                //成交量
                VolumeView(pts: chartPts[index])
                //macd
                if(index > 0){
                    MacdView(pts: chartPts[index], lastPts: chartPts[index-1])
                }
                
            }
        }
    }
}

