//
//  StockHolder.swift
//  lhcp
//
//  Created by V-MAC10 on 2020/12/14.
//

import SwiftUI

struct StockHolder: View {
    @State var openPrice:String = ""
    @State var openRate:String = ""
    
    @State var closePrice:String = ""
    @State var closeRate:String = ""
    
    var body: some View {
        VStack {
            //base info
            HStack {
                VStack{
                    Text("")
                }
            }
        }
    }
}

struct StockHolder_Previews: PreviewProvider {
    static var previews: some View {
        StockHolder()
    }
}
