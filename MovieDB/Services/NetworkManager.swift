//
//  NetworkManager.swift
//  MovieDB
//
//  Created by Rajat Raj on 11/08/22.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    
    func fetchMoviesOnSearch(with searchQuery: String, pageNo: Int,
                             completion: @escaping (MovieSearchListDTO?, Error?) -> Void) {
        URLSession.shared.request(
            url: URL(string: ApiEndPoint.searchUrl.text + searchQuery.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)! + Api.pageNumber.info + "\(pageNo)"),
            expecting: MovieSearchListDTO.self) { result in
                switch result {
                case .success(let data):
                    completion(data, nil)
                case .failure(let error):
                    completion(nil, error)
                    print(error.localizedDescription)
                }
            }
    }
    
    func fetchMovieDetails(with movieId: String, completion: @escaping (MovieDetailsDTO?) -> Void) {
        URLSession.shared.request(url: URL(string: ApiEndPoint.detailedUrl.text + movieId), expecting: MovieDetailsDTO.self) { result in
            switch result {
            case .success(let data):
                completion(data)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}


extension URLSession {
    enum CustomError: Error {
        case invalidUrl
        case invalidData
    }
    
    func request<T: Codable>(
        url: URL?,
        expecting: T.Type,
        completion: @escaping(Result<T,Error>) -> Void
    ) {
        guard let url = url else {
            completion(.failure(CustomError.invalidUrl))
            return
        }
        let task = dataTask(with: url) { data, _, error in
            guard let data = data else {
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.failure(CustomError.invalidData))
                }
                return
            }
            do {
                let result = try JSONDecoder().decode(expecting, from: data)
                completion(.success(result))
            }
            catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
