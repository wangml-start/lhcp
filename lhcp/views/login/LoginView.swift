//
//  LoginView.swift
//  lhcp
//
//  Created by V-MAC10 on 2020/12/6.
//

import SwiftUI

struct LoginView: View {
    @State var tips = ""
    @State var errorMessge = ""
    @State var account = ""
    @State var password = ""
    @State var beginEdit = false
    
    @State var showingLoginError = false
    @State var showPwd=false
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: MyUIColor.toorBarColor]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: MyUIColor.toorBarColor]
        UINavigationBar.appearance().tintColor = MyUIColor.toorBarColor
    }
    
    
    var isAccount: Bool {
        if CommonUtil.validEmail(email: account) {
            return true
        }else {
            if beginEdit {
                DispatchQueue.main.async {
                    self.tips = "邮箱账号验证失败！"
                }
            }
            return false
        }
    }
    var isPws: Bool {
        if password.count >= 8 {
            return true
        }else {
            if beginEdit {
                DispatchQueue.main.async {
                    self.tips = "密码不能少于8位！"
                }
            }
            return false
        }
    }
    var isCanLogin: Bool {
        isAccount && isPws
    }
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Image(systemName: "person")
                    TextField("邮箱账号", text:$account,
                              onEditingChanged:{ state in
                                self.beginEdit = true
                              }
                    )
                }
                Divider()
                HStack {
                    Image(systemName: "lock")
                    if showPwd {
                        TextField("请输入密码", text: $password)
                    } else {
                        SecureField("请输入密码", text: $password)
                    }
                    Button(action: {
                        self.showPwd.toggle()
                    }) {
                        Image(systemName: self.showPwd ? "eye" : "eye.slash")
                            .foregroundColor(.gray)
                    }
                }.padding(.top, 10).padding(.bottom, 2)
                Divider()
                if !isCanLogin {
                    HStack(alignment: .center, spacing: 2){
                        Text(self.tips)
                            .font(.caption)
                            .foregroundColor(.red)
                            .frame(alignment: .top)
                        Spacer()
                    }
                   
                }
                
                Button(action: {
                    self.onLoginClick()
                }) {
                    Text("登录/注册").frame(minWidth: 0, maxWidth: .infinity)
                }.accentColor(.white).padding(10)
                .background(isCanLogin ? Color.blue: Color.gray)
                .cornerRadius(5)
                .disabled(!isCanLogin)
                .alert(isPresented: $showingLoginError){LoginFuns.showLoginErrorTips(content: self.errorMessge)}
                
                NavigationLink(destination: ForgetPwsView(account: account, password: password)){
                    Text("忘记密码").frame(minWidth: 0, maxWidth: .infinity)
                    .accentColor(.white).padding(10).background(Color.blue).cornerRadius(5)
                }
                Spacer()
            }
            .padding(.top, 100)
            .padding(.bottom, 50)
            .padding(.leading)
            .padding(.trailing)
            
            .navigationBarTitle(Text("登录"), displayMode: .inline)
            
            .onAppear{
                self.loadUserInfo()
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
