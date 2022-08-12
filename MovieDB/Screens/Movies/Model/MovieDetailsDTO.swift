//
//  MovieDetailsDTO.swift
//  MovieDB
//
//  Created by Rajat Raj on 11/08/22.
//

import Foundation

struct MovieDetailsDTO: Codable {
    let title: String?
    let year: String?
    let rated: String?
    let released: String?
    let runtime: String?
    let genre: String?
    let director: String?
    let writer: String?
    let actors: String?
    let plot: String?
    let language: String?
    let country: String?
    let awards: String?
    let poster: String?
    let ratings: [MovieRatingDTO]?
    let metascore: String?
    let imdbRating: String?
    let imdbVotes: String?
    let imdbID: String?
    let type: String?
    let dvd: String?
    let boxOffice: String?
    let production: String?
    let website: String?
    let response: String?
    let error: String?
    
    private enum CodingKeys : String, CodingKey {
        case title = "Title", year = "Year", rated = "Rated", released = "Released", runtime = "Runtime"
        case genre = "Genre", director = "Director", writer = "Writer", actors = "Actors", plot = "Plot"
        case language = "Language", country = "Country", awards = "Awards", poster = "Poster"
        case ratings = "Ratings", metascore = "Metascore",type = "Type", dvd = "DVD"
        case boxOffice = "BoxOffice", production = "Production", website = "Website", response = "Response", error = "Error"
        case imdbRating, imdbVotes, imdbID
    }
}

struct MovieRatingDTO: Codable {
    let source: String?
    let value: String?
    
    private enum CodingKeys : String, CodingKey {
        case source = "Source", value = "Value"
    }
}
