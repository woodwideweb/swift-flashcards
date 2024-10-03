//
//  HTTPDataDownloader.wift.swift
//  ios-app
//
//  Created by Tabitha on 10/3/24.
//

import Foundation

let validStatus = 200...299


protocol HTTPDataDownloader {
    func httpData(from: URL) async throws -> Data
}


extension URLSession: HTTPDataDownloader {
    func httpData(from url: URL) async throws -> Data {
        guard let (data, response) = try await self.data(from: url, delegate: nil) as? (Data, HTTPURLResponse),
              validStatus.contains(response.statusCode) else {
            throw "it didn't work!"
        }
        return data
    }
}

extension String: Error {}
