//
//  TransactionListViewController.swift
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
    
    // Transaction for selected date
    var transactions = [Transaction]()
    
    fileprivate var expandedHeightOfCalendarWeekView: CGFloat?
    
    fileprivate var presenter = TransactionListViewControllerPresenter()
    
    fileprivate let iconImageFactory = JTIconImageFactory()
    
    // MARK: - Outlets
    
    @IBOutlet weak var calendarWeekView: CalendarWeekView! { didSet { calendarWeekView.delegate = self } }
    @IBOutlet weak var selectedDateLabel: UILabel! { didSet { updateSelectedDateLabel() } }
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
        
        reloadTableData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        calendarWeekView.scrollToSelectedDate(withAnimation: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let indexPathForSelectedRow = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPathForSelectedRow, animated: true)
        }
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
                    self.selectedDateLabel?.text = self.presenter.dateTitle(of: selectedDate)
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
            transactionInfoViewController.transitioningDelegate = presenter
            transactionInfoViewController.modalPresentationStyle = .custom
            transactionInfoViewController.accountant = accountant
            transactionInfoViewController.delegate = self
            
            if let indexPathForSelectedRow = tableView.indexPathForSelectedRow {
                transactionInfoViewController.transaction = transactions[indexPathForSelectedRow.row]
            }
        default:
            break
        }
    }
    
    // MARK: - Constants
    
    struct StoryboardIdentifier {
        struct TableViewCell {
            static let transaction = String(describing: TransactionViewCell.self)
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

// MARK: - CollapsingViewControllerAnimatedTransitioningDataSource

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

// MARK: - UITableViewDataSource UITableViewDelegate

extension TransactionListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StoryboardIdentifier.TableViewCell.transaction, for: indexPath) as! TransactionViewCell
        let transaction = transactions[indexPath.row]
        cell.transaction = transaction
        cell.iconImageFactory = iconImageFactory
        return cell
    }
}

// MARK: - TransactionListViewControllerDelegate

protocol TransactionListViewControllerDelegate: class {
    func transactionListViewController(_ controller: TransactionListViewController, didSelect date: Date)
}

// MARK: - TransactionInfoViewControllerDelegate

extension TransactionListViewController: TransactionInfoViewControllerDelegate {
    func transactionInfoViewControllerDidSave() {
        reloadTableData()
    }
}
