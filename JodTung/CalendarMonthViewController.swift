//
//  CalendarViewController.swift
//  JodTung
//
//  Created by Poldet Assanangkornchai on 10/20/2559 BE.
//  Copyright © 2559 Poldet Assanangkornchai. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CalendarMonthViewController: UIViewController {
    
    // MARK: - Injected Dependencies
    
    open var selectedDate: Date? {
        get {
            return calendarViewController.selectedDate
        }
        set {
            calendarViewController.selectedDate = newValue
        }
    }
    
    // MARK: - Properties
    
    fileprivate lazy var calendarViewController: CalendarViewController = {
        let calendarViewController = CalendarViewController(config: self.presenter.calendarViewControllerConfig)
        calendarViewController.calendarDelegate = self
        return calendarViewController
    }()
    
    fileprivate var presenter = CalendarMonthViewControllerPresenter()
    
    // MARK: - Outlets
    
    @IBOutlet weak var calendarView: JTAppleCalendarView! {
        didSet {
            calendarView.registerHeaderView(xibFileNames: [MonthSectionHeaderView.xibName])
            
            calendarViewController.calendarView = calendarView
        }
    }
    @IBOutlet weak var calendarTitleView: UIView!
    @IBOutlet weak var monthTitleLabel: UILabel!
    @IBOutlet weak var yearTitleLabel: UILabel!
    @IBOutlet weak var calendarNavigationView: UIView!
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        calendarViewController.scrollToSelectedDate(withAnimation: false)
        
        navigationItem.title = ""
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        setupCalendarViewContentInset()
    }
    
    // MARK: - Setup UI
    
    /**
        preload high cost performance view before it being use make app feels more smoother
    */
    func preloadView() {
        loadViewIfNeeded()
        calendarView?.layoutIfNeeded()
    }
    
    fileprivate func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: calendarTitleView)
        
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.removeDefaultShadow()
        }
    }
    
    fileprivate func updateNavigationBarTitle() {
        guard let selectedDate = selectedDate,
            let navigationBar = navigationController?.navigationBar else { return }
        
        /// On initiate state fade text from Back > Month make it's look awkward
        if self.navigationItem.title != nil {
            navigationBar.layer.add(presenter.fadeTextAnimation, forKey: "fadeText")
        }
        
        self.navigationItem.title = presenter.monthTitle(for: selectedDate)
    }
    
    fileprivate func setupCalendarViewContentInset() {
        
        let tabBarHeight = tabBarController?.tabBar.bounds.height ?? 0
        calendarView.contentInset = UIEdgeInsets(
            top: calendarNavigationView.frame.maxY,
            left: 0,
            bottom: tabBarHeight,
            right: 0
        )
    }
    
    // MARK: - Navigation
    
    fileprivate struct SegueIdentifier {
        static let showTransaction = "Show Transaction"
    }
}

// MARK: - JTAppleCalendarViewDelegate

extension CalendarMonthViewController: JTAppleCalendarViewDelegate {
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplayCell cell: JTAppleDayCellView, date: Date, cellState: CellState) {
        if let cell = cell as? DayCellView {
            if cellState.dateBelongsTo != .thisMonth {
                cell.isHidden = true
            } else {
                cell.isHidden = false
                cell.setup(date: date, with: cellState)
            }
        }
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleDayCellView?, cellState: CellState) {
        calendarViewController.calendar(calendar, didSelectDate: date, cell: cell, cellState: cellState)
        
        if let selectedDate = selectedDate {
            let calendarNavigationController = navigationController as! CalendarNavigationController
            calendarNavigationController.performSegue(toTransactionListViewControllerWith: selectedDate)
        }
    }
    
    func calendar(_ calendar: JTAppleCalendarView, sectionHeaderSizeFor range: (start: Date, end: Date), belongingTo month: Int) -> CGSize {
        return CGSize(width: Int(calendar.bounds.width), height: Int(calendar.itemSize ?? 0))
    }
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplaySectionHeader header: JTAppleHeaderView, range: (start: Date, end: Date), identifier: String) {
        if let headerView = header as? MonthSectionHeaderView {
            headerView.setup(range: range)
        }
    }
    
    func calendarDidScroll(_ calendar: JTAppleCalendarView) {
        calendar.visibleDates { (dateSegmentInfo) in
            self.presenter.monthInfo(for: dateSegmentInfo, completionHandler: { (monthInfo) in
                self.monthTitleLabel.text = monthInfo.monthTitle
                self.yearTitleLabel.text = monthInfo.yearTitle
            })
        }
    }
}

// MARK: - TransactionListViewControllerDelegate

extension CalendarMonthViewController: TransactionListViewControllerDelegate {
    func transactionListViewController(_ controller: TransactionListViewController, didSelect date: Date) {
        
//        if let selectedDate = selectedDate, Calendar.current.isDate(selectedDate, inSameDayAs: date) {
//            return
//        }
        
        selectedDate = date
        updateNavigationBarTitle()
        calendarViewController.scrollToSelectedDate()
    }
}
