//
//  LoginForm.swift
//  ios-app
//
//  Created by Tabitha on 10/31/24.
//

import SwiftUI

struct LoginForm: View {
    var onSubmit:  (_: String, _: String) async -> Void
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var showNetworkError: Bool = false
    
    var body: some View {
        Text("Please log in to continue")
            .font(.title2)
        
        Form {
            HStack{
                TextField(text: $username, prompt: Text("Username")) {
                    Text("Username")
                }
                .textInputAutocapitalization(.never)
            }
            
            //            SecureField(text: $password, prompt: Text("Password")) {
            TextField(text: $password, prompt: Text("Password")) {
                Text("Password")
            }
            .textInputAutocapitalization(.never)
            
            Button("Log in") {
                Task {
                  await onSubmit(username, password)
                }
            }
        }
        if showNetworkError {
            Text("Something went wrong. Please try again")
        }
        
    }
}

#Preview {
    LoginForm { _, _ in }
}
