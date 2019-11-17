//
//  Login.swift
//  Zoo
//
//  Created by Никита Казанцев on 16.11.2019.
//  Copyright © 2019 sudox.kazantsev.com. All rights reserved.
//

import SwiftUI
import SocketIO
struct Login_page: View {
    @State var login: Bool = true
    
    @State var nickname: String = ""
    @State var email: String = ""
    @State var password: String = ""
    
    
    var maincolor: Color = Color(red: 136 / 255, green: 177 / 255, blue: 83 / 255)
    
    @EnvironmentObject var socketData: Socket
    
    @State var success_auth: Bool = false  // SHOULD BE FALSE
    
    @State var show_error: Bool = false
    
    var body: some View {
        //NAVIGATION VIEW
        NavigationView {
            VStack {
                Text(show_error ? "Some error appeared": "").foregroundColor(.red).animation(.spring())
                
                VStack {
                    
                    // TRANSPARENT NAVIGATION LINK TO OPEN NEXT PAGE IF LOGIN WAS SUCCESSFUL
                    NavigationLink(destination: ContentView(), isActive: self.$success_auth) {
                      Text("")
                    }.hidden()
                    
                    VStack{
                        
                        
                        LogoView()
                            .padding(.top, 10)
                            .padding(.bottom, 25)
                        
                        
                        HStack {
                            Text("Sign In")
                                .font(.system(size: 32))
                                .padding(.bottom, 0)
                                .padding(.leading, 16)
                                .padding(.trailing, 16)
                            Spacer()
                        }
                            
                        
                        HStack {
                            Text("Notify people around about any urgent ecological problems you notice.")
                                .fixedSize(horizontal: false, vertical: true)
                                .lineLimit(2)
                                .opacity(0.4)
                                .font(.system(size: 16))
                                .padding(.leading, 16).padding(.trailing, 16).padding(.top, 16).padding(.bottom, 16)
                            
                               Spacer()
                            
                        }
                        
                        // SHOW LOGIN FORM ON DEFAULT
                        if (login){
                            
                            
                            InputFieldView(input: $email, textfield_label: "Input your E-mail", image_name: "person", label: "E-mail")
                            
                            SequreInputField(input: $password, textfield_label: "Input your password", image_name: "lock", label: "Password")
                            
                            HStack(spacing: 1) {
                                Button(action: {
                                    self.login.toggle()
                                }) {
                                    
                                    Text("Need account?")
                                        .foregroundColor((.primary))
                                    .opacity(0.4)
                                    .font(.system(size: 16))
                                    .padding(.leading, 16)
                                    
                                    Text("Register")
                                    .foregroundColor((maincolor))
                                    .font(.system(size: 16))
                                        
                                }
                                
                                Spacer()
                            }
                        }
                        else // SHOW REGISTER FORM IF REGISTER BUTTON WAS PRESSED
                        {
                            InputFieldView(input: $nickname, textfield_label: "Input your nickname", image_name: "person", label: "Nickname")
                            
                            InputFieldView(input: $email, textfield_label: "Input your E-mail", image_name: "person", label: "E-mail")
                             
                            SequreInputField(input: $password,textfield_label: "Input your password", image_name: "lock", label: "Password")
                            
                            
                            
                            
                            HStack(spacing: 1) {
                                Button(action: {
                                    self.login.toggle()
                                }) {
                                    
                                    Text("Already have an account?")
                                        .foregroundColor((.primary))
                                    .opacity(0.4)
                                    .font(.system(size: 16))
                                    .padding(.leading, 16)
                                    
                                    Text("Login")
                                    .foregroundColor((maincolor))
                                    .font(.system(size: 16))
                                        
                                }
                                
                                Spacer()
                            }
                        }
                        
                        Button(action: { // BUTTON TO CHANGE FORMS OF AUTHORISATIONS
                                
                            self.socketData.emit(self.login ? "auth:sign_in" : "auth:sign_up" , with: self.login ? [ "email" : self.email, "password" : self.password] : ["nickname": self.nickname, "email" : self.email, "password" : self.password] )
                        }) {
                            
                            // MAIN GREEN BUTTON TO INIT REGISTER/LOGIN REQUEST TO SERVER
                            Text(login ? "Sign in" : "Sign up")
                            .foregroundColor((.white))
                            .frame(minWidth: 0, idealWidth: .infinity, maxWidth: .infinity, minHeight: 0, idealHeight: 45, maxHeight: 45).padding(.leading, 16)
                            .padding(.trailing, 16)
                            .background(maincolor)
                            .cornerRadius(5)
                            .font(.system(size: 16))
                                
                        }.padding(.leading, 16).padding(.trailing, 16).padding(.top, 16)
                    }
                    
                  Spacer()
                    
                    
                }.modifier(DismissingKeyboard()) // MODIFIER TO CLOSE KEYBOARD BY RANDOM TAP ON SCREEN
                
                
            }
            
            }
            .onAppear(){ // RUNNING ON START
                
            
            let defaults = UserDefaults.standard
            
            
            defaults.removeObject(forKey: "latitude")
            defaults.removeObject(forKey: "longitude")
                
            self.socketData.on(clientEvent: .statusChange, callback: { (data, ack) in
                print("STATUS CHANGED")
                print(type(of: data[0]))
                let socketConnectionStatus: SocketIOStatus = data[0] as! SocketIOStatus
                print(socketConnectionStatus.description)
                
                if (socketConnectionStatus.description  == "connected")
                {
                    // id token if profile exists
                    if defaults.object(forKey: "token") != nil
                    {
                        if defaults.object(forKey: "id") != nil
                        {
                            print("CHECKING DEFAULTS RETURNS TRUE ##!!!!!")
                            self.socketData.emit("auth:import_auth", with:  [ "id" : defaults.string(forKey: "id")!, "token" : defaults.string(forKey: "token")!]  )

                        }
                    }
                }
                
            })
            self.socketData.on("auth:import_auth", callback: { (data, ack) in
                
                print("GOT ANSWER ON IMPORT AUTH")
                
                let b = data as!  [Dictionary<String, AnyObject>]
                
                print(b)
                if b[0]["res"] as! Int == 0
                {
                    print("saving userdata to db")
                    let user = b[0]["user"] as!  Dictionary<String, Any>
                    defaults.set(user["id"], forKey: "id")
                    defaults.set(user["token"], forKey: "token")
                    defaults.set(user["nickname"], forKey: "nickname")
                    defaults.set(user["email"], forKey: "email")
                    
                    self.success_auth = true
                }
                else
                {
                    print("ERROR IN IMPORTING AUTH")
                    
                }
            })
            // if you are already loggined socket
            self.socketData.on("auth:import_auth", callback: { (data, ack) in
                
                print("GOT ANSWER ON IMPORT AUTH")
                
                let b = data as!  [Dictionary<String, AnyObject>]
                
                
                if b[0]["res"] as! Int == 0
                {
                    let user = b[0]["user"] as!  Dictionary<String, Any>
                    defaults.set(user["id"], forKey: "id")
                    defaults.set(user["token"], forKey: "token")
                    defaults.set(user["nickname"], forKey: "nickname")
                    defaults.set(user["email"], forKey: "email")
                    
                    self.success_auth = true
                }
                else
                {
                    print("ERROR IN IMPORTING AUTH")
                    
                }
            })
            
            
            

            // REGISTRATION SERVER SOCKET
            self.socketData.on("auth:sign_up",callback: { (data, ack) in
                
                print("###########")
                print(data)
                print("###########")
                print(ack)
                print("###########")
                // СДЕЛАТЬ ПОДДЕРЖКУ СЛОВАРЯ
                let b = data as!  [Dictionary<String, AnyObject>]
                let user = b[0]["user"] as!  Dictionary<String, Any>
                
                // IF FIRST ELEMENT OF ARRAY IS 0 (SUCCESSFUL CODE) DO
                if b[0]["res"] as! Int == 0
                {
                    
                    self.show_error = false
                    
                    defaults.set(user["id"], forKey: "id")
                    defaults.set(user["token"], forKey: "token")
                    
                    defaults.set(user["nickname"], forKey: "nickname")
                    
                    print("navig true")
                    self.success_auth = true
                }
                else
                {
                    print("ERROR IN REGISTRATION")
                    self.show_error = true
                }
                

            })
                
            
            // LOGINNING SERVER SOCKET
            self.socketData.on("auth:sign_in",callback: { (data, ack) in
                // СДЕЛАТЬ ПОДДЕРЖКУ СЛОВАРЯ
                let b = data as!  [Dictionary<String, AnyObject>]
                
                
                // IF FIRST ELEMENT OF ARRAY IS 0 (SUCCESSFUL CODE) DO
                if b[0]["res"] as! Int == 0
                {
                    let user = b[0]["user"] as!  Dictionary<String, Any>
                    self.show_error = false
                    let defaults = UserDefaults.standard
                    defaults.set(user["id"], forKey: "id")
                    defaults.set(user["token"], forKey: "token")
                    
                    defaults.set(user["nickname"], forKey: "nickname")
                    self.success_auth = true
                    print("navig")
                    
                }
                else
                {
                    print("ERROR")
                    self.show_error = true
                }
                print(data)
                print(ack)

            })
            
        }
        
        
    //.navigationBarHidden(true)
    .edgesIgnoringSafeArea(.vertical)
    }
}


/// DISSMISSING KEYBOARD ON TAP OF VIEW TO WHICH MODIFIER WAS CONNECTED
struct DismissingKeyboard: ViewModifier {
    func body(content: Content) -> some View {
        content
            .onTapGesture {
                let keyWindow = UIApplication.shared.connectedScenes
                        .filter({$0.activationState == .foregroundActive})
                        .map({$0 as? UIWindowScene})
                        .compactMap({$0})
                        .first?.windows
                        .filter({$0.isKeyWindow}).first
                keyWindow?.endEditing(true)
        }
    }
}


struct SequreInputField: View{
    @Binding var input: String
    
    var textfield_label: String
    
    var maincolor: Color = Color(red: 136 / 255, green: 177 / 255, blue: 83 / 255)
    
    var image_name: String
    
    var label: String
    
    var body: some View
    {
        ZStack{
            
            VStack(alignment: .leading, spacing: 0){
                Group{
                    HStack{
                    Image(systemName: image_name)
                        .resizable()
                        .frame(width: 14, height: 16)
                        .foregroundColor(maincolor)
                    Text(label).padding(.leading, 8)
                    }.padding(.top, 6)
                }
                
                .padding(.leading, 32)
                    
            
            
            VStack {
                
                SecureField(textfield_label, text: $input)
                .frame(height: 30)
                .padding(.leading, 64)
                .padding(.trailing, 32)
                .padding(.bottom, 4)
                    .opacity(0.7)
                }
            }
            
        }.overlay(
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color.primary . opacity(0.1), lineWidth: 1)
                .padding(.leading, 16)
                .padding(.trailing, 16)
        )
    }
}


struct InputFieldView: View{
    @Binding var input: String
    
    var textfield_label: String
    
    var maincolor: Color = Color(red: 136 / 255, green: 177 / 255, blue: 83 / 255)
    
    var image_name: String
    
    var label: String
    
    var body: some View
    {
        ZStack{
            
            VStack(alignment: .leading, spacing: 0){
                Group{
                    HStack{
                    Image(systemName: image_name)
                        .resizable()
                        .frame(width: 14, height: 16)
                        .foregroundColor(maincolor)
                    Text(label).padding(.leading, 8)
                    }.padding(.top, 6)
                }
                
                .padding(.leading, 32)
                    
            
            
            VStack {
                
                TextField(textfield_label, text: $input)
                .frame(height: 30)
                .padding(.leading, 64)
                .padding(.trailing, 32)
                .padding(.bottom, 4)
                    .opacity(0.7)
                }
            }
            
        }.overlay(
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color.primary . opacity(0.1), lineWidth: 1)
                .padding(.leading, 16)
                .padding(.trailing, 16)
        )
    }
}

/*
struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login_page()
    }
}
*/

struct LogoView: View {
    var maincolor: Color = Color(red: 136 / 255, green: 177 / 255, blue: 83 / 255)
    
    var body: some View {
        HStack(spacing: 0){
            
            VStack {
                Text("N")
                    .bold()
                    .foregroundColor((maincolor))
                    .font(.system(size: 30))
                    .padding(.bottom, 0)
            }.frame(height: 45)
            
            VStack {
                
                Text("Care")
                    .foregroundColor(.primary)
                    .opacity(0.4)
                    .font(.system(size: 30))
                .padding(.bottom, 0)
            }.frame(height: 45)
                
            
        }
    }
}
