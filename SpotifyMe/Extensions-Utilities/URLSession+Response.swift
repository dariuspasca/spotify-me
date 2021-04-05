//
//  URLSession+Ext.swift
//  SpotifyMe
//
//  Created by Darius Pasca on 27/03/21.
//

import Foundation

extension URLSession {
    func getResponse<T: Codable>(for request: URLRequest,
                                 responseType: T.Type,
                                 completion: @escaping (Result<T, Error>) -> Void) {
        let task = dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(error!))
                }
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                guard (200...299).contains(httpResponse.statusCode) else {
                    let statusCode = httpResponse.statusCode

                    switch statusCode {
                    case 400:
                        completion(.failure(ServiceError.badRequest))
                    case 401:
                        completion(.failure(ServiceError.unauthorized))
                    default:
                        completion(.failure(ServiceError.internalError(code: statusCode)))
                    }
                    return
                }
            }

            // print(String(data: data, encoding: String.Encoding.utf8))

            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            decoder.dateDecodingStrategy = .iso8601

            do {
                let responseObject = try decoder.decode(responseType, from: data)
                DispatchQueue.main.async {
                    completion(.success(responseObject))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
}
