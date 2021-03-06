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
    @IBOutlet weak var valueTextField: UITextField! {
        didSet {
            valueTextField.contentVerticalAlignment = .bottom
            valueTextField.delegate = self
        }
    }
    
    // MARK: - Actions
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss()
    }
    
    @IBAction func save(_ sender: Any) {
        defer {
            delegate?.transactionInfoViewControllerDidSave()
            
            dismiss()
        }
        
        guard let category = categoryPickerView.selectedCategory else { return }
        
        // Edit
        if let transaction = transaction {
            transaction.value = value
            transaction.category = category
            transaction.note = "edited note"
            
            return
        }
        
        // Add
        let transactionInfo = TransactionInfo(
            creationDate: Date(),
            note: "test note",
            value: value,
            category: category
        )
        accountant.add(transactionInfo: transactionInfo)
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
        
        isValueInTheMiddleOfTyping = transaction?.value != 0
        value = transaction?.value ?? 0
        
        if let category = transaction?.category, let group = category.group {
            transactionType = group.type
            categoryPickerView.selectedCategoryGroup = group
            categoryPickerView.selectedCategory = category
        }
    }
    
    fileprivate func dismiss() {
        self.delegate?.transactionInfoViewControllerWillDismiss?()
        dismiss(animated: true) {
            self.delegate?.transactionInfoViewControllerDidDismiss?()
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

@objc protocol TransactionInfoViewControllerDelegate: class {
    func transactionInfoViewControllerDidSave()
    
    @objc optional func transactionInfoViewControllerWillDismiss()
    
    @objc optional func transactionInfoViewControllerDidDismiss()
}

extension TransactionInfoViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.valueTextField {
            if !isValueInTheMiddleOfTyping {
                isValueInTheMiddleOfTyping = true
                valueTextField.text = ""
                return true
            }
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.valueTextField {
            if valueTextField.text?.isEmpty == true {
                value = 0
            }
        }
    }
}
