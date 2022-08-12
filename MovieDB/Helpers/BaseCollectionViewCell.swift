//
//  BaseCollectionViewCell.swift
//  MovieDB
//
//  Created by Rajat Raj on 11/08/22.
//
import UIKit
import Foundation

class BaseCollectionViewCell<A>: UICollectionViewCell {
    var datasource: A!
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        contentView.layer.cornerRadius = 8.0
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.opaqueSeparator.cgColor
    }
}
