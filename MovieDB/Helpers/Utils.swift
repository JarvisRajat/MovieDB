//
//  Utils.swift
//  MovieDB
//
//  Created by Rajat Raj on 11/08/22.
//

import Foundation
import UIKit

protocol ReusableView {
    static var reuseIdentifier: String { get }
}
enum ApiEndPoint {
    case searchUrl
    case detailedUrl
    
    var text: String {
        switch self {
        case .searchUrl:
            return "https://www.omdbapi.com/?apikey=\(Api.key.info)&s="
        case .detailedUrl:
            return "https://www.omdbapi.com/?apikey=\(Api.key.info)&i="
        }
    }
}

enum Api {
    case key
    case pageNumber
    
    var info: String {
        switch self {
        case .key:
            return "dc01ed78"
        case .pageNumber:
            return "&page="
        }
    }
    
}

class Utility {
    static let shared = Utility()
    func textStylingForCastAndCrew(actors: String, director: String, writer: String) -> NSMutableAttributedString {
        let mainString = "Actors: \(actors)\nDirector: \(director)\nWriter: \(writer)"
        let actorTile = "Actors:"
        let directorTile = "Director:"
        let writerTile = "Writer:"
        let actorRange = (mainString as NSString).range(of: actorTile)
        let directorRange = (mainString as NSString).range(of: directorTile)
        let writerRange = (mainString as NSString).range(of: writerTile)
        let mutableAttributedString = NSMutableAttributedString.init(string: mainString)
        mutableAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.systemPink, range: actorRange)
        mutableAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.systemPink, range: directorRange)
        mutableAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.systemPink, range: writerRange)
        return mutableAttributedString
    }
}
extension ReusableView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
extension UICollectionViewCell: ReusableView {}
extension UICollectionView {
    func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Unable to Dequeue Reusable Collection View Cell")
        }
        return cell
    }
}
