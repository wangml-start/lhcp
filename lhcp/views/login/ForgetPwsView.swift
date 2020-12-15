//
//  ForgetPwsView.swift
//  lhcp
//
//  Created by V-MAC10 on 2020/12/6.
//

import SwiftUI

struct ForgetPwsView: View {
    static var maxCountter = 20
    @State var tips = ""
    @State var errorMessge = ""
    @State var account = ""
    @State var password = ""
    @State var eamil_code = ""
    @State var beginEdit = false
    @State var showingLoginError = false
    @State var showNewPwd=false
    @State var timer: Timer?
    @State var countDown = maxCountter
    
   
    
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
    var isEmailCode: Bool {
        if eamil_code.count == 6 {
            return true
        }else {
            if beginEdit {
                DispatchQueue.main.async {
                    self.tips = "邮箱验证码应为6位！"
                }
            }
            return false
        }
    }
    var isCanLogin: Bool {
        isAccount && isPws && isEmailCode
    }
    
    var body: some View {
        
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
                if showNewPwd {
                    TextField("请输入新密码", text: $password)
                } else {
                    SecureField("请输入新密码", text: $password)
                }
                Button(action: {
                    self.showNewPwd.toggle()
                }) {
                    Image(systemName: self.showNewPwd ? "eye" : "eye.slash")
                        .foregroundColor(.gray)
                }
            }.padding(.top, 10).padding(.bottom, 2)
            Divider()
            HStack {
                Image(systemName: "m.circle")
                TextField("邮箱验证码", text:$eamil_code,
                          onEditingChanged:{ state in
                            self.beginEdit = true
                          }
                )
                Button(action: {
                    timer?.fireDate = .distantPast
                    self.onForgetBtnClick()
                }, label: {
                    Text((self.countDown == ForgetPwsView.maxCountter) ? "获取验证码" : "请\(self.countDown)s之后重试")
                }).disabled(countDown != ForgetPwsView.maxCountter || !isAccount)
            }
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
                Text("登录").frame(minWidth: 0, maxWidth: .infinity)
            }.accentColor(.white).padding(10)
            .background(isCanLogin ? Color.blue: Color.gray)
            .cornerRadius(5)
            .disabled(!isCanLogin)
            .alert(isPresented: $showingLoginError){LoginFuns.showLoginErrorTips(content: self.errorMessge)}
            
            
            Spacer()
        }
        .padding(.top, 100)
        .padding(.bottom, 50)
        .padding(.leading)
        .padding(.trailing)
        
        .navigationBarTitle(Text("忘记密码"), displayMode: .inline)
        
        .onAppear{
            self.startTimer()
        }
        .onDisappear {
            self.invalidate()
        }
    }
    
    
    private func startTimer() {
        if timer == nil {
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (t) in
                if self.countDown <= 1 {
                    self.countDown = ForgetPwsView.maxCountter
                    t.fireDate = .distantFuture
                } else {
                    self.countDown -= 1
                }
            })
            timer?.fireDate = .distantFuture
        }
    }
    
    private func invalidate() {
        timer?.invalidate()
    }
}

struct ForgetPwsView_Previews: PreviewProvider {
    static var previews: some View {
        ForgetPwsView()
    }
}
