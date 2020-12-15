//
//  ToastView.swift
//  lhcp
//
//  Created by V-MAC10 on 2020/12/15.
//

import SwiftUI

extension View {
    func toast(isShow:Binding<Bool>, info:String="",  duration:Double = 2) -> some View {
        ZStack {
            self
            if isShow.wrappedValue {
                ToastView(isShow:isShow, info: info, duration: duration)
            }
        }
    }
}


struct ToastView: View {
    @Binding var isShow:Bool
    let info: String
    
    init(isShow:Binding<Bool>,info: String = "", duration:Double = 2) {
        self._isShow = isShow
        self.info = info
        
        changeShow(duration: duration)
    }
    
    private func changeShow(duration:Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            self.isShow = false
        }
    }
    
    var body: some View {
        ZStack {
            VStack {
                Text(info)
                    .font(FontSet.font14)
                    .foregroundColor(.white)
                    .frame(minWidth: 80, alignment: Alignment.center)
                    .zIndex(1.0)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 7).foregroundColor(.gray))
                Spacer()
            }
        }
        .padding()
        .animation(.easeIn(duration: 0.5))
        .edgesIgnoringSafeArea(.all)
    }
}


struct ToastView_Previews: PreviewProvider {
    static var previews: some View {
        ToastView(isShow: .constant(true), info: "ToastView")
    }
}
