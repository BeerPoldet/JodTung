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
    
    var selectedDate: Date! {
        get {
            return calendarViewController.selectedDate
        }
        set {
            calendarViewController.selectedDate = newValue
            selectedDateDidChange()
        }
    }
    
    weak var delegate: TransactionListViewControllerDelegate?
    
    var accountant: Accountant!
    
    // MARK: - Properties
    
    // Transaction for selected date
    var transactions = [Transaction]()
    
    lazy var calendarViewController: CalendarViewController = {
        let config = CalendarViewController.CalendarViewConfig(
            itemSize: nil,
            numberOfRows: 1,
            cellInset: CGPoint.zero,
            generateInDates: .forFirstMonthOnly,
            generateOutDates: .off,
            firstDayOfWeek: .sunday,
            allowsMultipleSelection: false,
            scrolling: CalendarViewController.CalendarViewConfig.Scrolling(
                mode: .stopAtEachCalendarFrameWidth,
                direction: .horizontal
            )
        )
        let calendarViewController = CalendarViewController(config: config)
        calendarViewController.calendarDelegate = self
        return calendarViewController
    }()
    
    fileprivate var selectedDay: DaysOfWeek?
    fileprivate lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        return dateFormatter
    }()
    fileprivate var expandedHeightOfCalendarWeekView: CGFloat?
    
    fileprivate lazy var viewControllerAnimatedTransitioning = StackViewControllerAnimatedTransitioning()
    
    // MARK: - Outlets
    
    @IBOutlet weak var calendarView: JTAppleCalendarView! {
        didSet {
            calendarViewController.calendarView = calendarView
        }
    }
    @IBOutlet weak var selectedDateLabel: UILabel! {
        didSet {
            updateSelectedDateLabel()
        }
    }
    @IBOutlet weak var calendarWeekView: UIView!
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
    
    // MARK: - Events
    
    fileprivate func selectedDateDidChange() {
        updateSelectedDay()
        updateSelectedDateLabel()
        if let selectedDate = selectedDate {
            reloadTableData()
            delegate?.transactionListViewController(self, didSelect: selectedDate)
        }
    }
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
               
//        let categories = accountant.transactionCategories!
//        accountant.add(transactionInfo: TransactionInfo(creationDate: Date(), note: "some note", value: 40, category: categories.first!))
        
        reloadTableData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        calendarViewController.scrollToSelectedDate(withAnimation: false)
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
    
    fileprivate func updateSelectedDay() {
        
        func dayOfWeek(from date: Date?) -> DaysOfWeek? {
            if let date = date {
                return DaysOfWeek(rawValue: Calendar.current.component(.weekday, from: date))
            } else {
                return nil
            }
        }
        
        selectedDay = dayOfWeek(from: selectedDate)
    }
    
    // MARK: - Navigation
    
    struct SegueIdentifier {
        static let showCalendar = "Show Calendar"
        static let showTransactionInfo = "Show Transaction Info"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case SegueIdentifier.showCalendar:
            let calendarMonthViewController = segue.destination as! CalendarMonthViewController
            if let selectedDate = calendarViewController.selectedDate {
                calendarMonthViewController.selectedDate = selectedDate
            }
        case SegueIdentifier.showTransactionInfo:
            let transactionInfoViewController = segue.destination as! TransactionInfoViewController
            transactionInfoViewController.transitioningDelegate = self
            transactionInfoViewController.modalPresentationStyle = .custom
            transactionInfoViewController.accountant = accountant
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
}

// MARK: - JTAppleCalendarViewDelegate

extension TransactionListViewController: JTAppleCalendarViewDelegate {
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplayCell cell: JTAppleDayCellView, date: Date, cellState: CellState) {
        if let cell = cell as? DayCellView {
            cell.setup(date: date, with: cellState, showingSeparateLine: false)
        }
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleDayCellView?, cellState: CellState) {
        calendarViewController.calendar(calendar, didSelectDate: date, cell: cell, cellState: cellState)
        
        selectedDateDidChange()
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        let shiftSelectedDate = visibleDates.monthDates.first(where: { (date) -> Bool in
            let weekday = Calendar.current.component(.weekday, from: date)
            return DaysOfWeek(rawValue: weekday) == selectedDay
        })
        
        if shiftSelectedDate != nil {
            selectedDate = shiftSelectedDate
        }
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
