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

func login(username: String, password: String) async -> Result<UUID, NetworkError> {
    let userResult = await post(to: .api(path: "/login"), data: LoginInput(name: username, password: password), decodeTo: User.self)
    
    switch userResult {
    case .success(let user):
        UserDefaults.standard.set(user.id.uuidString, forKey: .userIdKey)
        return .success(user.id)
    case .failure(let error):
        return.failure(error)
    }
}

enum NetworkError: Error {
  case jsonEncodeError
  case networkError
  case jsonDecodeError
}

func post<Input: Codable, Response: Codable>(to url: URL, data: Input, decodeTo: Response.Type) async -> Result<Response, NetworkError> {
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
    do {
        let json = try JSONEncoder().encode(data)
        request.httpBody = json
    } catch {
        return .failure(.jsonEncodeError)
    }
    
    do {
        let (data, _) = try await URLSession.shared.data(for: request)
        do {
            let decodedData = try JSONDecoder().decode(decodeTo, from: data)
            return .success(decodedData)
        } catch {
            return .failure(.jsonDecodeError)
        }
    } catch {
        return .failure(.networkError)
    }
}
