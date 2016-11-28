//
//  TxactionListViewController.swift
//  JodTung
//
//  Created by Poldet Assanangkornchai on 10/18/2559 BE.
//  Copyright © 2559 Poldet Assanangkornchai. All rights reserved.
//

import UIKit
import JTAppleCalendar

class TransactionListViewController: UIViewController {
    
    // MARK: - Injected Dependencies
    
    weak var delegate: TransactionListViewControllerDelegate?
    
    var accountant: Accountant!
    
    // MARK: - Properties
    
    var selectedDate: Date! {
        get {
            return calendarWeekView.selectedDate
        }
        set {
            calendarWeekView?.selectedDate = newValue
            if calendarWeekView == nil {
                _selectedDate = newValue
            }
        }
    }
    
    private var _selectedDate: Date?
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        return dateFormatter
    }()
    
    // Transaction for selected date
    var transactions = [Transaction]()
    
    fileprivate var expandedHeightOfCalendarWeekView: CGFloat?
    
    fileprivate lazy var viewControllerAnimatedTransitioning = StackViewControllerAnimatedTransitioning()
    
    // MARK: - Outlets
    
    @IBOutlet weak var calendarWeekView: CalendarWeekView! {
        didSet {
            calendarWeekView.delegate = self
        }
    }
    @IBOutlet weak var selectedDateLabel: UILabel! {
        didSet {
            updateSelectedDateLabel()
        }
    }
    @IBOutlet weak var calendarWeekViewHeightConstraint: NSLayoutConstraint! {
        didSet {
            expandedHeightOfCalendarWeekView = calendarWeekViewHeightConstraint.constant
        }
    }
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    // MARK: - Table View
    
    fileprivate func reloadTableData() {
        if let accountant = accountant {
            transactions = accountant.transactions(ofDate: selectedDate)!
            tableView.reloadData()
        }
    }
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        
        setupCalendarWeekView()
               
//        let categories = accountant.transactionCategories!
//        accountant.add(transactionInfo: TransactionInfo(creationDate: Date(), note: "some note", value: 40, category: categories.first!))
        
        reloadTableData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        calendarWeekView.scrollToSelectedDate(withAnimation: false)
    }
    
    // MARK: - Setup UI
    
    fileprivate func setupNavigationBar() {
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.removeDefaultShadow()
        }
    }
    
    fileprivate func updateSelectedDateLabel() {
        if let selectedDate = selectedDate,
            let selectedDateLabel = selectedDateLabel {
            
            UIView.transition(
                with: selectedDateLabel,
                duration: 0.5,
                options: .transitionCrossDissolve,
                animations: {
                    self.selectedDateLabel?.text = self.dateFormatter.string(from: selectedDate)
            },
                completion: nil
            )
        }
    }
    
    // MARK: - Navigation
    
    struct SegueIdentifier {
        static let showTransactionInfo = "Show Transaction Info"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case SegueIdentifier.showTransactionInfo:
            let transactionInfoViewController = segue.destination as! TransactionInfoViewController
            transactionInfoViewController.transitioningDelegate = self
            transactionInfoViewController.modalPresentationStyle = .custom
            transactionInfoViewController.accountant = accountant
            transactionInfoViewController.delegate = self
        default:
            break
        }
    }
    
    // MARK: - Constants
    
    struct StoryboardIdentifier {
        struct TableViewCell {
            static let transaction = "TxactionViewCell"
        }
    }
    
    // MARK: - CalendarWeekView
    
    private func setupCalendarWeekView() {
        if _selectedDate != nil {
            calendarWeekView.selectedDate = _selectedDate
            _selectedDate = nil
        }
    }
}

// MARK: - CalendarWeekViewDelegate

extension TransactionListViewController: CalendarWeekViewDelegate {
    func calenadrWeekView(_ calendar: CalendarWeekView, didSelect date: Date) {
        updateSelectedDateLabel()
        reloadTableData()
        delegate?.transactionListViewController(self, didSelect: date)
    }
}

// MARK: - CalendarViewControllerAnimatedTransitioningDataSource

extension TransactionListViewController: CollapsingViewControllerAnimatedTransitioningDataSource {
    
    func expandableLayoutConstraint() -> NSLayoutConstraint {
        return self.calendarWeekViewHeightConstraint
    }
    
    func expendedHeight() -> CGFloat {
        return self.expandedHeightOfCalendarWeekView ?? 0
    }
    
    func contentView() -> UIView {
        return self.tableView
    }
}

// MARK: - UITableViewDataSource

extension TransactionListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StoryboardIdentifier.TableViewCell.transaction, for: indexPath) as! TxactionViewCell
        let transaction = transactions[indexPath.row]
        cell.transaction = transaction
        return cell
    }
}

// MARK: - UITableViewDelegate

extension TransactionListViewController: UITableViewDelegate {
    
}

// MARK: - TxactionListViewControllerDelegate

protocol TransactionListViewControllerDelegate: class {
    func transactionListViewController(_ controller: TransactionListViewController, didSelect date: Date)
}

// MARK: - TransitioningDelgate

extension TransactionListViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return viewControllerAnimatedTransitioning
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return viewControllerAnimatedTransitioning
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return StackPresentationController(presentedViewController: presented, presenting: presenting)
    }
}

// MARK: - TransactionInfoViewControllerDelegate

extension TransactionListViewController: TransactionInfoViewControllerDelegate {
    func transactionInfoViewControllerDidSave() {
        reloadTableData()
    }
}
