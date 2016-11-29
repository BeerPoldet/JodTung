//
//  TransactionInfoViewController.swift
//  JodTung
//
//  Created by Poldet Assanangkornchai on 11/19/2559 BE.
//  Copyright © 2559 Poldet Assanangkornchai. All rights reserved.
//

import UIKit

class TransactionInfoViewController: UIViewController {
    
    // MARK: - Injected Properties
    
    var accountant: Accountant! {
        didSet {
            categoryPickerView?.categoryGroups = accountant.categoryGroups!
        }
    }
    
    weak var delegate: TransactionInfoViewControllerDelegate?
    
    // MARK: - Properties
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var categoryPickerView: CategoryPickerView!
    @IBOutlet weak var transactionTypeSegmentedControl: UISegmentedControl!
    
    // MARK: - Actions
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: Any) {
        guard let category = categoryPickerView.selectedCategory else { return }
        let transactionInfo = TransactionInfo(
            creationDate: Date(),
            note: "test note",
            value: 200,
            category: category
        )
        accountant.add(transactionInfo: transactionInfo)
        
        delegate?.transactionInfoViewControllerDidSave()
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func transactionTypeDidChange(_ sender: UISegmentedControl) {
        categoryPickerView.selectedTransactionType =
            TransactionType(rawValue: transactionTypeSegmentedControl.selectedSegmentIndex)!
    }
    
    // MARK: - View Controller lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        modalPresentationCapturesStatusBarAppearance = true
        
        categoryPickerView.selectedTransactionType =
            TransactionType(rawValue: transactionTypeSegmentedControl.selectedSegmentIndex)!
        categoryPickerView?.categoryGroups = accountant.categoryGroups!
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNeedsStatusBarAppearanceUpdate()
    }
    
    // MARK: - Status Bar
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
}

protocol TransactionInfoViewControllerDelegate: class {
    func transactionInfoViewControllerDidSave()
}
