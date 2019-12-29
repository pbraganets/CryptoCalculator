//
//  CryptoRateCollectionViewCell.swift
//  CryptoCalculator
//
//  Created by Pavel B on 01/01/20.
//  Copyright © 2019 Pavel B. All rights reserved.
//

import UIKit

class CryptoRateCollectionViewCell: UICollectionViewCell {
    
    struct CryptoRateCellViewModel {
        let name: String?
        let rate: String?
    }
    
    // MARK: - Outlets
    
    @IBOutlet private weak var currencyName: UILabel!
    @IBOutlet private weak var currencyRate: UILabel!
    
    // MARK: - Private properties
    
    static let reuseIdentifier: String = "CryptoRateCollectionViewCell"

    // MARK: - Public properties
    
    var viewModel: CryptoRateCellViewModel? {
        didSet {
            currencyName.text = viewModel?.name
            currencyRate.text = viewModel?.rate
        }
    }
    
    // MARK: - Lifecycle
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.darkGray.cgColor
    }

}
