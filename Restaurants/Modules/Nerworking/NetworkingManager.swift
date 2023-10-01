//
//  NetworkingManager.swift
//  Restaurants
//
//  Created by Nina on 10/1/23.
//

import Foundation

final class NetworkingManager {
    
    static let shared = NetworkingManager()
    
    private init() {}
    
    func login(email: String, password: String, completion: @escaping (Result<String, NetworkingError>) -> Void) {
        let loginUrl = URL(string: "https://profai.ru/v1/login")!
        
        var request = URLRequest(url: loginUrl)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = ["email": email, "password": password]
        guard let jsonData = try? JSONSerialization.data(withJSONObject: body) else {
            completion(.failure(.invalidRequest))
            return
        }
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299) ~= httpResponse.statusCode else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.emptyData))
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if let token = json?["token"] as? String {
                    completion(.success(token))
                } else {
                    completion(.failure(.invalidResponse))
                }
            } catch {
                completion(.failure(.jsonDecodingError(error)))
            }
        }.resume()
            
//            do {
//                let loginResponse = try JSONDecoder().decode(LoginResponse
//                    .self, from: data)
//                if let _ = loginResponse.status, let _ = loginResponse.token {
//                completion(.success(data))
//                } else if let status = loginResponse.status, let message = loginResponse.message {
//                    completion(.failure(.apiError(status: status, message: message)))
//                }
//
//            } catch {
//                completion(.failure(.jsonDecodingError(error)))
//            }
//        }.resume()
            
    }
}

//struct LoginResponse: Codable {
//    let status: String?
//    let token: String?
//    let message: String?
//}

enum NetworkingError: Error {
    case invalidRequest
    case invalidResponse
    case emptyData
    case networkError(Error)
    case jsonDecodingError(Error)
    case apiError(status: String, message: String)
}
