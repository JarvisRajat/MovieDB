//
//  ViewController.swift
//  MovieDB
//
//  Created by Rajat Raj on 11/08/22.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var errorLbl: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.register(UINib(nibName: "CustomFooterView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "CustomFooterView")
        }
    }
    private let vm = ViewControllerVM()
    var footerView: CustomFooterView?
    var isLoading: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        vm.delegate = self
    }
    
    private func updateUI(errorEncountered: Bool) {
        let searchText = searchBar.text ?? ""
        errorLbl.isHidden = searchText.isEmpty || vm.getDataCount() > 0 || !errorEncountered
        collectionView.isHidden = vm.getDataCount() == 0 || errorEncountered
        activityIndicator.isHidden = true
        collectionView.reloadData()
    }
    func fetchMoreSearchResultsIfAvailable() {
        if !vm.isSearchInProgress, vm.areMoreDataAvailable() {
            vm.fetchMoreSearchResults()
        } else {
            collectionView.reloadData()
        }
    }
    
    private func initiateSearch(forString searchString: String) {
        activityIndicator.isHidden = false
        vm.searchData(forString: searchString)
        if searchString.count >= 3 {
            collectionView.reloadData()
            errorLbl.isHidden = true
        } else {
            activityIndicator.isHidden = true
            collectionView.isHidden = true
            errorLbl.isHidden = searchString.count == 0
        }
    }
    
    private func navigateToMovieDetailScreen(with id: String) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        guard let detailVC = storyBoard.instantiateViewController(withIdentifier: "MovieDetailViewController") as? MovieDetailViewController else { return }
        detailVC.movieId = id
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vm.getDataCount()
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MovieInfoCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.datasource = vm.searchListData[indexPath.row]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (UIScreen.main.bounds.width - 40) / 2
        return CGSize(width: width, height: (width * 1.50))
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let aFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CustomFooterView", for: indexPath) as! CustomFooterView
            self.footerView = aFooterView
            self.footerView?.backgroundColor = UIColor.clear
            return aFooterView
        } else {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CustomFooterView", for: indexPath)
            return headerView
        }
    }
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            self.footerView?.prepareInitialAnimation()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            self.footerView?.stopAnimate()
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if isLoading {
            return CGSize.zero
        }
        return CGSize(width: collectionView.bounds.size.width, height: 55)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let threshold   = 100.0
        let contentOffset = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let diffHeight = contentHeight - contentOffset
        let frameHeight = scrollView.bounds.size.height
        var triggerThreshold  = Float((diffHeight - frameHeight))/Float(threshold)
        triggerThreshold   =  min(triggerThreshold, 0.0)
        let pullRatio  = min(abs(triggerThreshold),1.0)
        self.footerView?.setTransform(inTransform: CGAffineTransform.identity, scaleFactor: CGFloat(pullRatio))
        if pullRatio >= 1 {
            self.footerView?.animateFinal()
        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let contentOffset = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let diffHeight = contentHeight - contentOffset
        let frameHeight = scrollView.bounds.size.height
        let pullHeight  = abs(diffHeight - frameHeight)
        if pullHeight == 0.0 || pullHeight == 0.25 {
            guard let footerView = self.footerView, footerView.isAnimatingFinal else { return }
            self.isLoading = true
            self.footerView?.startAnimate()
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { (timer:Timer) in
                self.fetchMoreSearchResultsIfAvailable()
                self.isLoading = false
            })
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        navigateToMovieDetailScreen(with: (vm.searchListData[indexPath.item].movieId ?? ""))
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        initiateSearch(forString: searchText)
    }
}

extension ViewController: RefreshUIProtocol {
    func didUpdateUI(success: Bool, error: String?) {
        errorLbl.text = error ?? "Please Enter atleast 3 characters..."
        updateUI(errorEncountered: !success)
    }
}
