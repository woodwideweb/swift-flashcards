//
//  LoginFormContainer.swift
//  ios-app
//
//  Created by Tabitha on 11/7/24.
//

import Foundation
import Models
import SwiftUI

struct LoginFormContainer: View {
  @Binding var userID: UUID?

  var body: some View {
    LoginForm { username, password in
      let result = await login(username: username, password: password)
      switch result {
      case .success(let id):
        userID = id
      case .failure(let error):
        switch error {
        case .jsonEncodeError:
          print("json encode")
        case .networkError:
//                    showNetworkError = true
          print("network error")
        case .jsonDecodeError:
          print("json decode")
        }
      }
    }
  }
}
