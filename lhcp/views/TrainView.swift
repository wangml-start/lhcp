//
//  TrainView.swift
//  lhcp
//
//  Created by V-MAC10 on 2020/12/13.
//

import SwiftUI

struct TrainView: View {
    
    var data:[MainSection] = [
        MainSection(id: 1, header: "   操盘", items: [
            MainItem(id: 1, title: "龙头战法训练", imageName: "main_1", nameExtension: "png"),
            MainItem(id: 2, title: "趋势波段训练", imageName: "main_1", nameExtension: "png")
        ]),
        MainSection(id: 2, header: "   盈亏曲线", items: [
            MainItem(id: 3, title: "龙头战法曲线", imageName: "main_1", nameExtension: "png"),
            MainItem(id: 4, title: "趋势波段曲线", imageName: "main_1", nameExtension: "png")
        ]),
        MainSection(id: 3,header: "   排行", items: [
            MainItem(id: 5, title: "排行榜", imageName: "main_1", nameExtension: "png")
        ]),
        MainSection(id: 4,header: "   模式详情", items: [
            MainItem(id: 6, title: "模式设置", imageName: "main_1", nameExtension: "png"),
            MainItem(id: 7, title: "执行情况", imageName: "main_1", nameExtension: "png")
        ])
    ]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(data){(section) in
                    Section(header:
                                Text(section.header)
                                .font(.headline)
                                .frame(width:UIScreen.main.bounds.width,height: 30, alignment: .leading)
                                .background(MyColor.div_white)
                            //.padding(.leading, 30)
                    )
                    {
                        ForEach(section.items){ item in
                            NavigationLink(destination: self.getDestination(item: item)){
                                MainRow(mainItem: item)
                                    .listRowInsets(.init(top: 0, leading: 15, bottom: 0, trailing: 0))
                            }
                        }
                    }
                }
                
            }
//            .listStyle(GroupedListStyle())
            //            .listStyle(PlainListStyle())
            .navigationBarTitle("进阶训练",displayMode: .inline)
        }
        
    }
    
    func getDestination(item:MainItem) -> AnyView {
        switch item.id {
        case 1:
            return AnyView(StockView(trainType: Constants.LEADING_STRATEGY, holderData: HolderData(trainType: Constants.LEADING_STRATEGY)))
        case 2:
            return AnyView(StockView(trainType: Constants.NORMAL_STRATEGY, holderData: HolderData(trainType: Constants.LEADING_STRATEGY)))
        default:
            return AnyView(Text("None"))
        }
    }
    
}

struct TrainView_Previews: PreviewProvider {
    static var previews: some View {
        TrainView()
    }
}
