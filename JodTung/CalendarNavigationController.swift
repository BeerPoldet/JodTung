//
//  CalendarNavigationViewController.swift
//  JodTung
//
//  Created by Poldet Assanangkornchai on 10/31/2559 BE.
//  Copyright © 2559 Poldet Assanangkornchai. All rights reserved.
//

import UIKit

class CalendarNavigationController: UINavigationController {
    
    lazy var txactionListViewController: TxactionListViewController = {
        let txactionListViewController = self.storyboard!.instantiateViewController(withType: TxactionListViewController.self)
        txactionListViewController.selectedDate = Date()
        return txactionListViewController
    }()
    
    var calendarMonthViewController: CalendarMonthViewController {
        return self.viewControllers.first as! CalendarMonthViewController
    }
    
    let collapsingViewControllerAnimatedTransitioning = CollapsingViewControllerAnimatedTransitioning(isExpanding: true)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        delegate = self
        
        txactionListViewController.delegate = calendarMonthViewController
        
        collapsingViewControllerAnimatedTransitioning.dataSource = txactionListViewController
        
        pushViewController(txactionListViewController, animated: false)
    }
    
    func performSegue(toTxactionListViewControllerWith selectedDate: Date) {
        
        txactionListViewController.selectedDate = selectedDate
        pushViewController(txactionListViewController, animated: true)
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
