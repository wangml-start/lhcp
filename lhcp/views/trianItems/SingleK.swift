//
//  SingleK.swift
//  lhcp
//
//  Created by V-MAC10 on 2020/12/17.
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
