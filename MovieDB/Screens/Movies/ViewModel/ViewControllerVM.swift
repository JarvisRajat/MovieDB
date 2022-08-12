//
//  ViewControllerVM.swift
//  MovieDB
//
//  Created by Rajat Raj on 11/08/22.
//

import Foundation
import UIKit

protocol RefreshUIProtocol: AnyObject {
    func didUpdateUI(success: Bool, error: String?)
}

final class ViewControllerVM {
    private(set) var isSearchInProgress = false
    private var currentPage = 1
    weak var delegate: RefreshUIProtocol?
    private var searchString: String = ""
    private var requestTimer: Timer?
    private var totalSearchResultsOnServer: Int?
    var searchListData = [MovieInfoDataModel]()
    
    func areMoreDataAvailable() -> Bool {
        if let serverResultsCount = totalSearchResultsOnServer {
            return searchListData.count < serverResultsCount
        } else {
            return false
        }
    }
    
    func getDataCount() -> Int {
        return searchListData.count
    }
    
    func getTotalSearchResultsCount() -> Int {
        return totalSearchResultsOnServer ?? 0
    }
    
    func searchData(forString searchString: String, afterWait : Bool = true) {
        requestTimer?.invalidate()
        self.searchString = searchString
        totalSearchResultsOnServer = nil
        currentPage = 1
        searchListData = [MovieInfoDataModel]()
        if self.searchString.count >= 3 {
            if afterWait {
                requestTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(sendSearchRequest), userInfo: nil, repeats: false)
            }else{
                sendSearchRequest()
            }
        }
    }
    func fetchMoreSearchResults() {
        currentPage += 1
        sendSearchRequest()
    }
    
    
    @objc func sendSearchRequest() {
        isSearchInProgress = true
        NetworkManager.shared.fetchMoviesOnSearch(with: searchString, pageNo: currentPage) { response, error in
            DispatchQueue.main.async {
                self.isSearchInProgress = false
                if error == nil, let response = response, let totalCount = response.totalResults {
                    self.searchListData.append(contentsOf: self.getDataFrom(response: response))
                    self.totalSearchResultsOnServer = Int(totalCount)
                    self.delegate?.didUpdateUI(success: true, error: nil)
                } else {
                    self.delegate?.didUpdateUI(success: false, error: response?.error)
                }
            }
           
        }
    }
    
    func getDataFrom(response: MovieSearchListDTO)-> [MovieInfoDataModel] {
        var searchListItem = [MovieInfoDataModel]()
        if let list = response.search  {
            for item in list {
                searchListItem.append(MovieInfoDataModel(imageUrl: item.poster, movieTitle: item.title, movieId: item.imdbID))
            }
        }
        return searchListItem
    }
}
