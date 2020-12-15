//
//  LoginService.swift
//  lhcp
//
//  Created by V-MAC10 on 2020/12/7.
//
import SwiftUI

struct LoginFuns {
    static func showLoginErrorTips(content:String) -> Alert{
        return Alert(
            title: Text("错误提示"),
            message: Text(content),
            dismissButton: .default(Text("OK")))
    }
    
    static func showLoginTips() -> ActionSheet{
        return ActionSheet(title: Text("您喜欢那个诗人呢"),
                           message: Text("历代诗人"),
                           buttons:
                            [
                                .default(Text("李白")),
                                .default(Text("杜甫"),
                                         action: {
                                            
                                         }),
                                .default(Text("苏轼"))
                            ]
        )
    }
    
    static func storageToken(token: String) {
        //print("Token: \(token)")
        let uDefault = UserDefaults.standard;
        uDefault.set(token, forKey: "token");
        uDefault.synchronize();
    }
    
    static func getToken() -> String{
        let uDefault = UserDefaults.standard;
        return uDefault.string(forKey: "token") ?? ""
    }
    
    //save user login datas 保存用户登陆信息
    static func storageUserInfo(user:User){
        let uDefault = UserDefaults.standard;
        // 读取
        let storageStr = uDefault.string(forKey: "userList") ?? ""
        var users:[User] = [user]
        if(storageStr.count > 0){
            let data = storageStr.data(using: .utf8)!
            let list:[User] = NetworkManager.transferData(json:data)
            for u in list{
                if(u.phone != user.phone){
                    users.append(u)
                }
            }
        }
        do{
            let data =  try JSONEncoder().encode(users)
            let jsonStr = String(data: data, encoding: String.Encoding.utf8)
            uDefault.set(jsonStr, forKey: "userList");
        }catch{
           print("Storage user failed!")
        }
        uDefault.synchronize();
    }
    
    //获取当前登陆的用户
    static func getActiveUserInfo() -> User?{
        let list:[User] = LoginFuns.loadAccountList() ?? []
        for u in list{
            if(u.active == 1){
                return u
            }
        }
        return nil
    }
    
    //获取账户列表
    static func loadAccountList() -> [User]? {
        let uDefault = UserDefaults.standard;
        // 读取
        let storageStr = uDefault.string(forKey: "userList") ?? ""
        if(storageStr.count > 0){
            let data = storageStr.data(using: .utf8)!
            let list:[User] = NetworkManager.transferData(json:data)
            return list
        }
        return nil
    }
}

extension LoginView{
    func onLoginClick(){
        var params:[String: AnyObject] = [:]
        params["pws"] = AESUtil.encode(content: self.password) as AnyObject
        params["email"] = self.account as AnyObject
        params["GENERAL_LOGIN"] = 1 as AnyObject
        
        let screnDelegate: UIWindowSceneDelegate? = {
            var uiScreen: UIScene?
            UIApplication.shared.connectedScenes.forEach { (screen) in
                uiScreen = screen
            }
            return (uiScreen?.delegate as? UIWindowSceneDelegate)
        }()
        NetworkManager.shared.requestGet(action: "/user/login", parameters: params) { data in
            if(data.status == -1){
                self.showingLoginError = true
                self.errorMessge = data.error ?? ""
            }else{
                self.showingLoginError = true
                self.errorMessge = data.user?.token ?? ""
                var user = data.user
                user?.active = 1
                LoginFuns.storageUserInfo(user: user!)
                let token = user?.token ?? ""
                if(token.count == 0){
                    self.showingLoginError = true
                    self.errorMessge = "获取Token失败！"
                }else{
                    LoginFuns.storageToken(token: token)
                    screnDelegate?.window!?.rootViewController = UIHostingController(rootView: MainAppView());
                }
                
            }
        }
    }

    //load
    func loadUserInfo(){
        let user = LoginFuns.getActiveUserInfo()
        if(user != nil){
            DispatchQueue.main.async {
                self.account = user?.phone ?? ""
                self.password = AESUtil.decode(content: user?.password ?? "")
            }
        }
    }
}

//忘记密码业务处理
extension ForgetPwsView{
    func onLoginClick(){
        var params:[String: AnyObject] = [:]
        params["pws"] = AESUtil.encode(content: self.password) as AnyObject
        params["email"] = self.account as AnyObject
        params["code"] = self.eamil_code as AnyObject
        params["FORGET_LOGIN"] = 1 as AnyObject
        
        let screnDelegate: UIWindowSceneDelegate? = {
            var uiScreen: UIScene?
            UIApplication.shared.connectedScenes.forEach { (screen) in
                uiScreen = screen
            }
            return (uiScreen?.delegate as? UIWindowSceneDelegate)
        }()
        
        NetworkManager.shared.requestGet(action: "/user/login", parameters: params) { data in
            if(data.status == -1){
                self.showingLoginError = true
                self.errorMessge = data.error ?? ""
            }else{
                self.showingLoginError = true
                self.errorMessge = data.user?.token ?? ""
                var user = data.user
                user?.active = 1
                LoginFuns.storageUserInfo(user: user!)
                
                let token = user?.token ?? ""
                if(token.count == 0){
                    self.showingLoginError = true
                    self.errorMessge = "获取Token失败！"
                }else{
                    LoginFuns.storageToken(token: token)
                    screnDelegate?.window!?.rootViewController = UIHostingController(rootView: MainAppView());
                }
            }
        }
    }
    
    func onForgetBtnClick(){
        var params:[String: AnyObject] = [:]
        params["email"] = self.account as AnyObject
        NetworkManager.shared.requestGet(action: "/user/valid_code", parameters: params) { data in
            if(data.status == -1){
                timer?.fireDate = .distantFuture
                self.countDown = ForgetPwsView.maxCountter
                self.showingLoginError = true
                self.errorMessge = data.error ?? ""
            }else{
                self.showingLoginError = true
                self.errorMessge = "发送成功"
            }
        }
    }

}
