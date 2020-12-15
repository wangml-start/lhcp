//
//  ContentView.swift
//  lhcp
//
//  Created by V-MAC10 on 2020/12/6.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        Text("正在初始化。。。")
            .padding()
            .onAppear{
                self.loadLoginInfo()
            }
    }
    
    func loadLoginInfo(){
        let screnDelegate: UIWindowSceneDelegate? = {
            var uiScreen: UIScene?
            UIApplication.shared.connectedScenes.forEach { (screen) in
                uiScreen = screen
            }
            return (uiScreen?.delegate as? UIWindowSceneDelegate)
        }()
        let activAcc = LoginFuns.getActiveUserInfo()
        if(activAcc == nil){
            screnDelegate?.window!?.rootViewController = UIHostingController(rootView: LoginView());
        }else{
            var params:[String: AnyObject] = [:]
            params["pws"] = activAcc?.password as AnyObject
            params["email"] = activAcc?.phone as AnyObject
            params["GENERAL_LOGIN"] = 1 as AnyObject
            
            NetworkManager.shared.requestGet(action: "/user/login", parameters: params) { data in
                if(data.status == -1){
                    screnDelegate?.window!?.rootViewController = UIHostingController(rootView: LoginView());
                }else{
                    var user = data.user
                    user?.active = 1
                    LoginFuns.storageUserInfo(user: user!)
                    LoginFuns.storageToken(token: user?.token ?? "")
                    screnDelegate?.window!?.rootViewController = UIHostingController(rootView: MainAppView());
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
