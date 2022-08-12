//
//  MovieDetailViewController.swift
//  MovieDB
//
//  Created by Rajat Raj on 12/08/22.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var moviePoster: UIImageView!
    @IBOutlet private weak var movieTitle: UILabel!
    @IBOutlet private weak var moviePlot: UILabel!
    @IBOutlet private weak var castAndCrew: UILabel!
    @IBOutlet private weak var movieReleaseDate: UILabel!
    @IBOutlet private weak var movieGenre: UILabel!
    @IBOutlet private weak var movieRatings: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var movieId: String?
    private let vm = MovieDetailsVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        activityIndicator.isHidden = false
        vm.getMovieInfo(movieId: movieId ?? "", delegate: self)
    }
    
    private func movieDetailsSetup() {
        ImageDownloadManager.shared.loadImage(imageView: moviePoster, imageUrl: vm.getMovie().posterUrl)
        movieTitle.text = vm.getMovie().title
        moviePlot.text = vm.getMovie().plot
        castAndCrew.attributedText = vm.getMovie().castAndCrew
        movieReleaseDate.text = vm.getMovie().releaseYear
        movieGenre.text = vm.getMovie().genre
        movieRatings.text = vm.getMovie().ratings
    }

}

extension MovieDetailViewController: RefreshUI {
    func refreshUI() {
        activityIndicator.isHidden = true
        movieDetailsSetup()
    }
}
