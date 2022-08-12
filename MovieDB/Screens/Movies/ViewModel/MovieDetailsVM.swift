//
//  MovieDetailsVM.swift
//  MovieDB
//
//  Created by Rajat Raj on 12/08/22.
//

import Foundation
import UIKit

protocol RefreshUI: AnyObject {
    func refreshUI()
}

final class MovieDetailsVM {
    private var movieInfo: MovieDetailsDTO?
    
    func getMovieInfo(movieId: String, delegate: RefreshUI) {
        NetworkManager.shared.fetchMovieDetails(with: movieId) { response in
            DispatchQueue.main.async {
                if let data = response {
                    self.movieInfo = data
                    delegate.refreshUI()
                }
            }
        }
    }
    
    func getMovie()->(posterUrl: String, title: String, plot: String, castAndCrew: NSMutableAttributedString, releaseYear: String, genre: String, ratings: String) {
        if let title =  movieInfo?.title,
           let plot = movieInfo?.plot,
           let actors = movieInfo?.actors,
           let director = movieInfo?.director,
           let writer = movieInfo?.writer,
           let year = movieInfo?.year,
           let genre = movieInfo?.genre,
           let poster = movieInfo?.poster {
            let attributedCastAndCrew = Utility.shared.textStylingForCastAndCrew(actors: actors, director: director, writer: writer)
            return (poster, title, plot, attributedCastAndCrew, year, genre, getRatings())
        }
        return ("","", "", NSMutableAttributedString(""), "", "", "")
    }

    private func getRatings()-> String {
        var ratings: String = "N/A"
        if let ratingData = movieInfo?.ratings {
            for data in ratingData {
                if let source = data.source,
                   let ratingValue = data.value {
                    ratings += "\(source): \(ratingValue)\n"
                }
            }
        }
        return ratings
    }
}
