//
//  CalendarNavigationViewController.swift
//  JodTung
//
//  Created by Poldet Assanangkornchai on 10/31/2559 BE.
//  Copyright © 2559 Poldet Assanangkornchai. All rights reserved.
//

import UIKit

class CalendarNavigationController: UINavigationController {
    
    lazy var transactionListViewController: TransactionListViewController = {
        let transansactionListViewController = self.storyboard!.instantiateViewController(withType: TransactionListViewController.self)
        transansactionListViewController.selectedDate = Date()
        return transansactionListViewController
    }()
    
    var calendarMonthViewController: CalendarMonthViewController {
        return self.viewControllers.first as! CalendarMonthViewController
    }
    
    let collapsingViewControllerAnimatedTransitioning = CollapsingViewControllerAnimatedTransitioning(isExpanding: true)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        delegate = self
        
        transactionListViewController.delegate = calendarMonthViewController
        
        collapsingViewControllerAnimatedTransitioning.dataSource = transactionListViewController
        
        pushViewController(transactionListViewController, animated: false)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.calendarMonthViewController.preloadView()
    }
    
    func performSegue(toTransactionListViewControllerWith selectedDate: Date) {
        
        transactionListViewController.selectedDate = selectedDate
        pushViewController(transactionListViewController, animated: true)
    }
}

extension CalendarNavigationController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        switch operation {
        case .push:
            return collapsingViewControllerAnimatedTransitioning
        case .pop:
            return collapsingViewControllerAnimatedTransitioning
        case .none:
            return nil
        }
    }
}
