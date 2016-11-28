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
    
    // MARK: - Properties
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var categoryPickerView: CategoryPickerView!
    
    // MARK: - Actions
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - View Controller lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        modalPresentationCapturesStatusBarAppearance = true
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
