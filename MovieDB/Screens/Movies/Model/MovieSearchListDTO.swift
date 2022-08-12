//
//  MovieSearchListDTO.swift
//  MovieDB
//
//  Created by Rajat Raj on 11/08/22.
//

import Foundation

struct MovieSearchListDTO: Codable {
    let search: [MoviesInfoDTO]?
    let totalResults: String?
    let response: String?
    let error: String?
    
    private enum CodingKeys : String, CodingKey {
        case search = "Search", totalResults, response = "Response", error = "Error"
    }
}

struct MoviesInfoDTO: Codable {
    let title: String?
    let year: String?
    let imdbID: String?
    let type: String?
    let poster: String?
    
    private enum CodingKeys : String, CodingKey {
        case title = "Title", year = "Year", imdbID, type = "Type", poster = "Poster"
    }
}
