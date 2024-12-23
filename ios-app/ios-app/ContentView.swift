//
//  ContentView.swift
//  ios-app
//
//  Created by Tabitha on 9/26/24.
//

import SwiftUI
import Models

enum ViewState {
    case loading
    case loaded([Card])
    case failed
}

extension String {
    static let userIdKey = "UserID"
}

struct ContentView: View {
    @State private var state: ViewState = .loading
//    @State private var userID = UserDefaults.standard.string(forKey: .userIdKey)
    @AppStorage(.userIdKey) private var userID: String?
    
    var body: some View {
       
        if userID != nil {
            VStack {
                CardViewer(state: state)
                    .padding()
                LogoutButton(userID: $userID)
            }
            .task {
                try? await self.getCards(id: userID!)
                
//                doNotDoThisInRealLife()
            }
        } else {
            LoginFormContainer(userID: $userID)
        }
    }
    
    func getCards(id: String) async throws {
        let cardResult = await getDataResult([Card].self, url: URL.api(path: "/cards/\(id)"))
        switch cardResult {
            case .success(let cards):
                self.state = .loaded(cards)
            case .failure:
                self.state = .failed
        }
    }
}

#Preview {
    ContentView()
}

extension URL {
    static func api(path: String) -> URL {
        return URL(string: "http://127.0.0.1:8080\(path)")!
    }
}

func getData<T: Codable>(_ t: T.Type, url: URL) async throws -> T {
    let (data, _) = try await URLSession.shared.data(from: url)
    let decoder = JSONDecoder()
    let decodedData = try decoder.decode(t, from: data)
    return decodedData
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

struct UserDataCard: Codable {
  var id: String
}
