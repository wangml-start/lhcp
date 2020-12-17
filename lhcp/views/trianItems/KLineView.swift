//
//  KLine.swift
//  lhcp
//
//  Created by V-MAC10 on 2020/12/14.
//

import SwiftUI

struct SingelK: View {
    var pts:KlinePoints
    var kWidth: CGFloat {
        return (pts.highPt.x - pts.openPt.x) * 2
    }
    var lWidth:CGFloat {
        return KLineStyle.kLineBold
    }
    
    var body: some View {
        GeometryReader { geometry in
            if(pts.state > 0){
                Path { path in
                    path.move(to: pts.openPt)
                    path.addLine(to: CGPoint(x: pts.openPt.x, y: pts.closePt.y))
                    path.addLine(to: CGPoint(x: pts.openPt.x+kWidth, y: pts.closePt.y))
                    path.addLine(to: CGPoint(x: pts.openPt.x+kWidth, y: pts.openPt.y))
                    path.addLine(to: pts.openPt)
                }.stroke(MyColor.line_up, style: StrokeStyle(lineWidth: lWidth,lineCap: .round, lineJoin: .round))
                
                Path { path in
                    path.move(to: pts.highPt)
                    path.addLine(to: CGPoint(x: pts.highPt.x, y: pts.closePt.y))
                }
                .stroke(MyColor.line_up, style: StrokeStyle(lineWidth: lWidth))
                Path { path in
                    path.move(to: pts.lowPt)
                    path.addLine(to: CGPoint(x: pts.lowPt.x, y: pts.openPt.y))
                }
                .stroke(MyColor.line_up, style: StrokeStyle(lineWidth: lWidth))
            }else if (pts.state < 0){
                Path { path in
                    path.move(to: pts.openPt)
                    path.addLine(to: CGPoint(x: pts.openPt.x, y: pts.closePt.y))
                    path.addLine(to: CGPoint(x: pts.openPt.x+kWidth, y: pts.closePt.y))
                    path.addLine(to: CGPoint(x: pts.openPt.x+kWidth, y: pts.openPt.y))
                }.fill(MyColor.line_down)
                
                Path { path in
                    path.move(to: pts.highPt)
                    path.addLine(to: pts.lowPt)
                }
                .stroke(MyColor.line_down, style: StrokeStyle(lineWidth: self.lWidth))
            }else{
                Path { path in
                    path.move(to: pts.openPt)
                    path.addLine(to: CGPoint(x: pts.openPt.x+kWidth, y: pts.closePt.y))
                }.stroke(Color.gray, style: StrokeStyle(lineWidth: lWidth))
                
                Path { path in
                    path.move(to: pts.highPt)
                    path.addLine(to: pts.lowPt)
                }
                .stroke(Color.gray, style: StrokeStyle(lineWidth: lWidth))
            }
        }
    }
}

struct VolumeView: View {
    var pts:KlinePoints
    
    var bottomY:CGFloat {
        return pts.volBPt.y
    }
    var kWidth: CGFloat {
        return (pts.highPt.x - pts.openPt.x) * 2
    }
    var lWidth:CGFloat {
        return KLineStyle.kLineBold
    }

    var body: some View {
        GeometryReader { geometry in
            if(pts.state >= 0){
                Path { path in
                    path.move(to: pts.volumePt)
                    path.addLine(to: CGPoint(x: pts.volumePt.x, y: bottomY))
                    path.addLine(to: CGPoint(x: pts.volumePt.x+kWidth, y: bottomY))
                    path.addLine(to: CGPoint(x: pts.volumePt.x+kWidth, y: pts.volumePt.y))
                    path.addLine(to: pts.volumePt)
                }.stroke(MyColor.line_up, style: StrokeStyle(lineWidth: lWidth,lineCap: .round, lineJoin: .round))
            }else if (pts.state < 0){
                Path { path in
                    path.move(to: pts.volumePt)
                    path.addLine(to: CGPoint(x: pts.volumePt.x, y: bottomY))
                    path.addLine(to: CGPoint(x: pts.volumePt.x+kWidth, y: bottomY))
                    path.addLine(to: CGPoint(x: pts.volumePt.x+kWidth, y: pts.volumePt.y))
                }.fill(MyColor.line_down)

            }
        }
    }
}


struct KLineView: View {
    @State var chartData:KlineGroup
    
    //计算屏幕可容纳的KLine数量
    var visibleCount:Int{
        return Int((UIScreen.main.bounds.width-KLineStyle.rightLabelWidth)
                    / (CGFloat(KLineStyle.mBarSpace)+CGFloat(KLineStyle.kWidth)))
    }
    
    //计算屏幕可容纳的KLine数量
    @State var chartHeight:CGFloat = 0
    @State var volmeHeight:CGFloat = 0
    @State var macdHeight:CGFloat = 0
    
    var chartPts:[KlinePoints] {
        let kCount = chartData.nodes.count
        var startIndex = 0
        if(kCount > visibleCount){
            startIndex = kCount - visibleCount
        }
        chartData.calcMinMax(start: startIndex, end: kCount)
        chartData.calcAverageMACD()
        
        var pts:[KlinePoints] = []
        var startx:CGFloat = 0
        
        
        let priceDelta = chartData.mYMax - chartData.mYMin
        let punit = (chartHeight-KLineStyle.chartSpace*2) / CGFloat(priceDelta)
        let vunit = (volmeHeight-KLineStyle.volSpace*2) / CGFloat(chartData.mMaxYVolume)
        //        let munit = (macdHeight-KLineStyle.macdSpace) / CGFloat(chartData.mYMaxMacd)
        
        for (nIndex, node) in chartData.nodes.enumerated() {
            if(nIndex < startIndex){
                continue
            }
            let nStart = nIndex-startIndex
            startx = KLineStyle.mBarSpace * CGFloat(nStart + 1) + KLineStyle.kWidth * CGFloat(nStart)
            let half = KLineStyle.kWidth / 2
            let ySpace = KLineStyle.chartSpace
            var kp = KlinePoints(
                id: nStart, openPt: CGPoint(x: startx, y: CGFloat((chartData.mYMax - node.open)) * punit+ySpace),
                closePt: CGPoint(x: startx, y: CGFloat((chartData.mYMax - node.close)) * punit+ySpace),
                highPt: CGPoint(x: startx + CGFloat(half), y: CGFloat((chartData.mYMax - node.high)) * punit+ySpace),
                lowPt: CGPoint(x: startx + CGFloat(half), y: CGFloat((chartData.mYMax - node.low)) * punit+ySpace),
                state: node.state,
                isOpen: node.isOpen,
                volumePt: CGPoint(x: startx, y: CGFloat((chartData.mMaxYVolume - node.volume)) * vunit+chartHeight+KLineStyle.volSpace),
                volBPt: CGPoint(x: startx, y: chartHeight + volmeHeight)
            )
            
            //均线
            if(node.avg5 != -1){
                kp.line5Pt = CGPoint(x: startx + CGFloat(half),
                                     y: CGFloat((chartData.mYMax - node.avg5)) * punit+ySpace)
            }
            if(node.avg10 != -1){
                kp.line10Pt = CGPoint(x: startx + CGFloat(half),
                                     y: CGFloat((chartData.mYMax - node.avg10)) * punit+ySpace)
            }
            if(node.avg20 != -1){
                kp.line20Pt = CGPoint(x: startx + CGFloat(half),
                                     y: CGFloat((chartData.mYMax - node.avg20)) * punit+ySpace)
            }
            
            
            //macd
            
            
            pts.append(kp)
        }
        
        return pts
    }
    
    //价格线计算
    var linePts:[PriceLines] {
        var lines:[PriceLines] = []
        let priceDelta = chartData.mYMax - chartData.mYMin
        let punit = (chartHeight) / CGFloat(priceDelta)
        
        let endx = UIScreen.main.bounds.width-KLineStyle.mBarSpace
        let startx = KLineStyle.mBarSpace
        
        for index in 0 ..< 5 {
            let y = chartHeight * CGFloat(index) / 4
            let price = CommonUtil.formatNumber(num: chartData.mYMax - Float(y/punit))
            lines.append(PriceLines(
                            id: index,
                            startPt: CGPoint(x: startx, y: y),
                            endPt: CGPoint(x: endx, y: y),
                            price: price))
        }
        //print(lines)
        return lines
    }
    
    
    
    
    
    
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
                    .offset(x: linePts[index].endPt.x - KLineStyle.rightLabelWidth, y: (index == 4) ? linePts[index].endPt.y-15 : linePts[index].endPt.y+2)
                    .foregroundColor(.gray)
            }
            
            //绘制KLine
            ForEach(0..<chartPts.count) { index in
                SingelK(pts: chartPts[index])
                
                //均线
                if (index-1 >= 0 && chartPts[index-1].line5Pt != nil) {
                    Path { path in
                        path.move(to: chartPts[index-1].line5Pt!)
                        path.addLine(to: chartPts[index].line5Pt!)
                    }.stroke(MyColor.kline_ave_5, style: StrokeStyle(lineWidth: KLineStyle.kLineBold))

                }
                if (index-1 >= 0 && chartPts[index-1].line10Pt != nil) {
                    Path { path in
                        path.move(to: chartPts[index-1].line10Pt!)
                        path.addLine(to: chartPts[index].line10Pt!)
                    }.stroke(MyColor.kline_ave_10, style: StrokeStyle(lineWidth: KLineStyle.kLineBold))

                }
                if (index-1 >= 0 && chartPts[index-1].line20Pt != nil) {
                    Path { path in
                        path.move(to: chartPts[index-1].line20Pt!)
                        path.addLine(to: chartPts[index].line20Pt!)
                    }.stroke(MyColor.kline_ave_20, style: StrokeStyle(lineWidth: KLineStyle.kLineBold))

                }
                
                //成交量
                VolumeView(pts: chartPts[index])
                
            }
            
            
            
            .onAppear {
                let viewHeight = geometry.size.height
                self.chartHeight = viewHeight * KLineStyle.chartRate
                self.volmeHeight = viewHeight * KLineStyle.volRate
                self.macdHeight = viewHeight * KLineStyle.macdRate
            }
        }
    }
}

struct ViewK: View {
    @State var hue: CGFloat = 0
    var body: some View {
        GeometryReader { geo in
            ZStack{
                //绘制价格线
                ForEach(1..<5) { n in
                    
                    Text("\(n)").offset(x: 20, y: CGFloat(n * 10))
                }
            }
            
        }
        //.edgesIgnoringSafeArea(.all)
    }
}

struct KLineView_Previews: PreviewProvider {
    static var previews: some View {
        ViewK()
    }
}


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
    
    var difPt:CGPoint?
    var deaPt:CGPoint?
    var macdPt:CGPoint?
    var macdBPt:CGPoint?
    
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
    static let rightLabelWidth:CGFloat = 20
    
    /**
     * the max visible entry count.
     */
    static let kWidth:CGFloat = 6
    
    static let chartViewRate:CGFloat = 0.5
    static let chartRate:CGFloat = 0.6
    static let volRate:CGFloat = 0.2
    static let macdRate:CGFloat = 0.2
    
    static let chartSpace:CGFloat = 5
    static let volSpace:CGFloat = 2.5
    static let macdSpace:CGFloat = 2.5
    
}
