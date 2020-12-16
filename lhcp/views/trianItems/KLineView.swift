//
//  KLine.swift
//  lhcp
//
//  Created by V-MAC10 on 2020/12/14.
//

import SwiftUI

struct DownK: View {
    var pts:KlinePoints
    var kWidth: CGFloat {
        return (pts.highPt.x - pts.openPt.x) * 2
    }
    var lWidth:CGFloat {
        return KLineStyle.kLineBold
    }
    var body: some View {
        GeometryReader { geometry in
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
        }
    }
}

struct UpperK: View {
    var pts:KlinePoints
    var kWidth: CGFloat {
        return (pts.highPt.x - pts.openPt.x) * 2
    }
    var lWidth:CGFloat {
        return KLineStyle.kLineBold
    }
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                path.move(to: pts.openPt)
                path.addLine(to: CGPoint(x: pts.openPt.x, y: pts.closePt.y))
                path.addLine(to: CGPoint(x: pts.openPt.x+kWidth, y: pts.closePt.y))
                path.addLine(to: CGPoint(x: pts.openPt.x+kWidth, y: pts.openPt.y))
                path.addLine(to: pts.openPt)
            }.stroke(MyColor.line_up, style: StrokeStyle(lineWidth: lWidth))
            
            Path { path in
                path.move(to: pts.highPt)
                path.addLine(to: CGPoint(x: pts.highPt.x, y: pts.openPt.y))
            }
            .stroke(MyColor.line_up, style: StrokeStyle(lineWidth: lWidth))
            Path { path in
                path.move(to: pts.lowPt)
                path.addLine(to: CGPoint(x: pts.lowPt.x, y: pts.closePt.y))
            }
            .stroke(MyColor.line_up, style: StrokeStyle(lineWidth: lWidth))
        }
    }
}


struct KLineView: View {
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                UpperK(pts: KlinePoints(
                        openPt: CGPoint(x: 20, y: 15),
                        closePt: CGPoint(x: 20, y: 35),
                        highPt: CGPoint(x: 30, y: 8),
                        lowPt: CGPoint(x: 30, y: 55)))
                DownK(pts: KlinePoints(
                        openPt: CGPoint(x: 60, y: 15),
                        closePt: CGPoint(x: 60, y: 35),
                        highPt: CGPoint(x: 70, y: 8),
                        lowPt: CGPoint(x: 70, y: 55)))
            }
        }
    }
}

struct ViewK: View {
    var body: some View {
        VStack {
            VStack{
                Text("Hello KLine")
            }.frame(height: 80, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            
            KLineView().frame(height: UIScreen.main.bounds.height * 0.6)
                .background(MyColor.div_white)
            
            Spacer()
        }
    }
}

struct KLineView_Previews: PreviewProvider {
    static var previews: some View {
        ViewK()
    }
}


struct KlinePoints {
    var openPt:CGPoint
    var closePt:CGPoint
    var highPt:CGPoint
    var lowPt:CGPoint
    
    var volumePt:CGPoint?
    
    var line5Pt:CGPoint?
    var line10Pt:CGPoint?
    var line20Pt:CGPoint?
    
    var difPt:CGPoint?
    var deaPt:CGPoint?
    var macdPt:CGPoint?
    
}

struct KLineStyle {
    static let mBarSpace:CGFloat = 0.15
    static let kLineBold:CGFloat = 1.5

       /**
        * the max visible entry count.
        */
    static let visibleCount:Int = 40
}
