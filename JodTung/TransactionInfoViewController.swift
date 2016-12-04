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
    
    var transaction: Transaction?
    
    // MARK: - Private Properties
    
    fileprivate var value: Double {
        get {
            return Double(valueTextField.text!)!
        }
        set {
            valueTextField.text = String(newValue)
        }
    }
    fileprivate var isValueInTheMiddleOfTyping = false
    fileprivate var transactionType: TransactionType {
        get {
            return categoryPickerView.selectedTransactionType
        }
        set {
            transactionTypeSegmentedControl.selectedSegmentIndex = newValue.rawValue
            categoryPickerView.selectedTransactionType = newValue
        }
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var categoryPickerView: CategoryPickerView!
    @IBOutlet weak var transactionTypeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var valueTextField: UITextField! { didSet { valueTextField.delegate = self } }
    
    // MARK: - Actions
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: Any) {
        guard let category = categoryPickerView.selectedCategory else { return }
        let transactionInfo = TransactionInfo(
            creationDate: Date(),
            note: "test note",
            value: value,
            category: category
        )
        accountant.add(transactionInfo: transactionInfo)
        
        delegate?.transactionInfoViewControllerDidSave()
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func transactionTypeDidChange(_ sender: UISegmentedControl) {
        transactionType = TransactionType(rawValue: transactionTypeSegmentedControl.selectedSegmentIndex)!
    }
    
    @IBAction func valueDisplayDidTap(_ sender: Any) {
        valueTextField.becomeFirstResponder()
    }
    
    @IBAction func textfieldDismissalDidTap(_ sender: Any) {
        if valueTextField.isFirstResponder {
            valueTextField.resignFirstResponder()
        }
    }
    
    // MARK: - View Controller lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        modalPresentationCapturesStatusBarAppearance = true
        
        transactionType = TransactionType(rawValue: transactionTypeSegmentedControl.selectedSegmentIndex)!
        categoryPickerView?.categoryGroups = accountant.categoryGroups!
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNeedsStatusBarAppearanceUpdate()
    }
    
    // MARK: - UI
    
    fileprivate func setupUI() {
        value = transaction?.value ?? 0
        
        if let category = transaction?.category, let group = category.group {
            transactionType = group.type
            categoryPickerView.selectedCategoryGroup = group
            categoryPickerView.selectedCategory = category
        }
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

extension TransactionInfoViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.valueTextField {
            print("begin")
            if !isValueInTheMiddleOfTyping {
                isValueInTheMiddleOfTyping = true
                valueTextField.text = ""
                return true
            }
        }
        return true
    }
}
