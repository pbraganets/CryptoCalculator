//
//  CryptoRatesViewController.swift
//  CryptoCalculator
//
//  Created by Pavel B on 01/01/20.
//  Copyright © 2019 Pavel B. All rights reserved.
//

import UIKit
import iOSDropDown
import Flutter
import Combine
import DeepDiff

class CryptoRatesViewController: UIViewController,
    UICollectionViewDataSource,
    UICollectionViewDelegate,
    UICollectionViewDelegateFlowLayout
{
    
    // MARK: - Outlets
    
    @IBOutlet weak var ratesCollectionView: UICollectionView!
    @IBOutlet weak var topDropDownConstraint: NSLayoutConstraint!
    @IBOutlet weak var topCollectionViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomCollectionViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var dropDown : DropDown!
    
    // MARK: - Private properties
    
    private let spacingRatio: CGFloat = 12.0
    private var spacing: CGFloat { return self.view.frame.size.width / self.spacingRatio }
    private var cancellables = Set<AnyCancellable>()
    private var ratesDataSource: [Rate]?
    private var rates: [Rate]? {
        set {
            let changes = DeepDiff.diff(old: rates ?? [], new: newValue ?? [])
            if changes.count > 0 {
                self.ratesCollectionView.reload(changes: changes, section: 0, updateData: {
                    ratesDataSource = newValue
                })
            }
        }
        get {
            return ratesDataSource
        }
    }
    
    // MARK: - Public properties
    
    var cryptoRatesViewModel: CryptoRatesViewModel!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDropDown()
        
        cryptoRatesViewModel.$rates
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] rates in
                guard let self = self else {
                    return
                }
                self.rates = rates
            })
            .store(in: &cancellables)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        cryptoRatesViewModel.startUpdate()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        cryptoRatesViewModel.stopUpdate()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        topDropDownConstraint.constant = spacing
        topCollectionViewConstraint.constant = spacing
        bottomCollectionViewConstraint.constant = -spacing
    }
    
    // MARK: - Collection view data source
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int
    {
        ratesDataSource?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let identifier = CryptoRateCollectionViewCell.reuseIdentifier
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier,
                                                      for: indexPath) as! CryptoRateCollectionViewCell
        let name = ratesDataSource?[indexPath.row].crypto
        let rate =  String(ratesDataSource?[indexPath.row].value ?? 0.0)
        cell.viewModel = CryptoRateCollectionViewCell.CryptoRateCellViewModel(name: name,
                                             rate: rate)
        return cell
    }
    
    // MARK: - Collection view delegate
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath)
    {
        if let rate = ratesDataSource?[indexPath.row] {
            openCryptoCalculator(withRate: rate)
        }
    }
    
    // MARK: - Flow layout delegate

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let width = (view.frame.size.width - 4 * spacing) / 2
        return CGSize(width: width, height: width)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets
    {
        return UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: spacing)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return spacing * 1.5
    }
    
    // MARK: - Private implementation
    
    private func setupDropDown() {
        // data
        dropDown.optionArray = cryptoRatesViewModel.bases
        dropDown.selectedIndex = cryptoRatesViewModel.bases.firstIndex(of: cryptoRatesViewModel.currentBase)
        dropDown.text = cryptoRatesViewModel.currentBase
        
        // appearance
        dropDown.textAlignment = .center
        dropDown.selectedRowColor = UIColor.clear
        dropDown.isSearchEnable = false
        dropDown.checkMarkEnabled = false
        dropDown.cornerRadius = 0
        dropDown.borderColor = UIColor.darkGray
        dropDown.borderWidth = 1.0
        
        // actions
        dropDown.didSelect{(selectedText, index ,id) in
            self.cryptoRatesViewModel.updateBase(selectedText)
        }
    }
    
    private func openCryptoCalculator(withRate rate: Rate) {
        if let jsonData = try? JSONEncoder().encode(rate),
            let jsonObject = try? JSONSerialization.jsonObject(with: jsonData)
        {
            let flutterEngine = (UIApplication.shared.delegate as! AppDelegate).flutterEngine
            let flutterViewController = FlutterViewController(engine: flutterEngine,
                                                              nibName: nil,
                                                              bundle: nil)
            present(flutterViewController, animated: true, completion: nil)
            
            // setup crypto calculator
            let channel = FlutterBasicMessageChannel(name: "crypto_calculator",
                                                     binaryMessenger: flutterViewController.binaryMessenger,
                                                     codec: Flutter.FlutterJSONMessageCodec())
            channel.sendMessage(jsonObject)
        }
    }
    
}
