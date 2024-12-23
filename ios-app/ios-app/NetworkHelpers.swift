//
//  NetworkHelpers.swift
//  ios-app
//
//  Created by Tabitha on 12/23/24.
//
import SwiftUI
import Models

extension URL {
  static func api(path: String) -> URL {
    return URL(string: "http://127.0.0.1:8080\(path)")!
  }
}

func getDataResult<T: Codable>(_ t: T.Type, url: URL) async -> Result<T, Error> {
  do {
    let (data, _) = try await URLSession.shared.data(from: url)
    let decoder = JSONDecoder()
    let decodedData = try decoder.decode(t, from: data)
    return .success(decodedData)
  } catch {
    return .failure(error)
  }
}

func login(username: String, password: String) async -> Result<String, LoginError> {
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
