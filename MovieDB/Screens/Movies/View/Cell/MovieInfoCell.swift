//
//  MovieInfoCell.swift
//  MovieDB
//
//  Created by Rajat Raj on 11/08/22.
//

import UIKit

class MovieInfoCell: BaseCollectionViewCell<MovieInfoDataModel> {
    @IBOutlet private weak var moviePoster: UIImageView!
    @IBOutlet private weak var movieTitle: UILabel!
    
    override var datasource: MovieInfoDataModel! {
        didSet {
            ImageDownloadManager.shared.loadImage(imageView: moviePoster, imageUrl: datasource.imageUrl ?? "")
            movieTitle.text = datasource.movieTitle
        }
    }
}
