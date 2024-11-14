//
//  LoginFormContainer.swift
//  ios-app
//
//  Created by Tabitha on 11/7/24.
//

import SwiftUI
import Models

struct LoginFormContainer: View {
    @Binding var userID: String?
    
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



func login(username: String, password: String) async -> Result<String, LoginError>{
    var request = URLRequest(url: .api(path: "/login"))
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    let userJson = UserJson(name: username, password: password)
    
    do {
        let json = try JSONEncoder().encode(userJson)
        request.httpBody = json
    } catch {
        return .failure(.jsonEncodeError)
    }
    
    do {
       let (data, _) = try await URLSession.shared.data(for: request)
        do {
            let user = try JSONDecoder().decode(User.self, from: data)
            UserDefaults.standard.set(user.id, forKey: .userIdKey)
            return .success(user.id)
        } catch {
            return .failure(.jsonDecodeError)
        }
    } catch {
        return .failure(.networkError)
    }
    
}

struct UserJson: Codable {
  var name: String
  var password: String
}

enum LoginError: Error {
    case jsonEncodeError
    case networkError
    case jsonDecodeError
}
