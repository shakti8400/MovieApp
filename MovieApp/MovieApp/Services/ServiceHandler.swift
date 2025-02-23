//
//  ServiceHandler.swift
//  MovieApp
//
//  Created by Shakti Singh on 21/02/25.
//

import Foundation
import UIKit

class ServiceHandler {
    
    static let shared = ServiceHandler()
    private init() {}
    
    func request<T: Decodable>(url: String,method: String = "GET",parameters: [String: String]? = nil,showLoader:Bool = true,completion: @escaping (Result<T, Error>) -> Void) {
        
        guard var urlComponents = URLComponents(string: url) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 400, userInfo: nil)))
            return
        }
        
        if method == "GET", let parameters = parameters {
            urlComponents.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        
        guard let finalURL = urlComponents.url else {
            completion(.failure(NSError(domain: "Invalid URL after query parameters", code: 400, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: finalURL)
        request.httpMethod = method
        
        let headers = ["accept":"application/json","Authorization":"Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIwNTRlNzM3ZWZhOTI2YzE1YTA4YmI2YWRkYTE4ZmIwZiIsIm5iZiI6MTc0MDA2MjE2Ny4yNDEsInN1YiI6IjY3YjczZGQ3OWY3ZmIyYTc0MzY1ODE5YiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.yvP8Ng1qtCq4YFt-jiW4GNP4dEPkB7ct7oxBkFikB5U"]
        
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        if showLoader{
            DispatchQueue.main.async {
                Utility.navigationController?.topViewController?.addLoader(Constants.pleaseWaitMsg.rawValue)
            }
           
        }
        // Perform request
        DispatchQueue.global(qos: .background).async {
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                DispatchQueue.main.async {
                    if showLoader{
                        Utility.navigationController?.topViewController?.removeLoader()
                    }
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    
                    guard let data = data else {
                        completion(.failure(NSError(domain: "No data received", code: 500, userInfo: nil)))
                        return
                    }
                    
                    do {
                        let decodedData = try JSONDecoder().decode(T.self, from: data)
                        completion(.success(decodedData))
                    } catch {
                        completion(.failure(error))
                    }
                }
            }
            task.resume()
        }
    }
    
    func fetchPosterImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        DispatchQueue.global(qos: .background).async {
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    completion(image)
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }

}



