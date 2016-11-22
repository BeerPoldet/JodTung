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
    
    lazy var calendarViewController: CalendarViewController = {
        let config = CalendarViewController.CalendarViewConfig(
            itemSize: 54,
            numberOfRows: 6,
            cellInset: CGPoint.zero,
            generateInDates: .forAllMonths,
            generateOutDates: .tillEndOfRow,
            firstDayOfWeek: .sunday,
            allowsMultipleSelection: false,
            scrolling: CalendarViewController.CalendarViewConfig.Scrolling(
                mode: .none,
                direction: .vertical
            )
        )
        let calendarViewController = CalendarViewController(config: config)
        calendarViewController.calendarDelegate = self
        return calendarViewController
    }()
    
    fileprivate lazy var monthFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter
    }()
    
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
    
    private func setupNavigationBar() {
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
            let fadeTextAnimation = CATransition()
            fadeTextAnimation.type = kCATransitionFade
            fadeTextAnimation.duration = 0.5
            
            navigationBar.layer.add(fadeTextAnimation, forKey: "fadeText")
        }
        
        self.navigationItem.title = self.monthFormatter.string(from: selectedDate)
    }
    
    private func setupCalendarViewContentInset() {
        
        let tabBarHeight = tabBarController?.tabBar.bounds.height ?? 0
        calendarView.contentInset = UIEdgeInsets(
            top: calendarNavigationView.frame.maxY,
            left: 0,
            bottom: tabBarHeight,
            right: 0
        )
    }
    
    // MARK: - Navigation
    
    struct SegueIdentifier {
        static let showTxaction = "Show Txaction"
    }
    
    // Deprecated: - it won't be any segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let identifier = segue.identifier
        if identifier == SegueIdentifier.showTxaction {
            let transactionViewController = segue.destination as! TransactionListViewController
            transactionViewController.selectedDate = selectedDate
            transactionViewController.delegate = self
        }
    }
    
    // MARK: - Calendar Navigation Header
    
    lazy var yearFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter
    }()
    
    struct MonthItem {
        var month: Int
        var year: Int
        
        init(month: Int, year: Int) {
            self.month = month
            self.year = year
        }
        
        var count = 0
    }
    
    struct MonthItemList {
        var items = [MonthItem]()
        
        mutating func add(_ item: MonthItem) {
            if let existItemIndex = items.index(where: { item.month == $0.month && item.year == $0.year }) {
                items[existItemIndex].count = items[existItemIndex].count + 1
            } else {
                items.append(item)
            }
        }
        
        var max: MonthItem? {
            if items.isEmpty {
                return nil
            }
            return items.max { $0.count < $1.count }
        }
        
        init(monthDates: [Date]) {
            monthDates.forEach({ (date) in
                var calendar = Calendar.current
                calendar.timeZone = TimeZone(secondsFromGMT: 0)!
                let month = calendar.component(.month, from: date)
                let year = calendar.component(.year, from: date)
                self.add(MonthItem(month: month, year: year))
            })
        }
        
        var mostPresenceDate: Date? {
            guard let mostPresenceMonthItem = self.max else { return nil }
            var dateComponent = DateComponents()
            dateComponent.month = mostPresenceMonthItem.month
            dateComponent.year = mostPresenceMonthItem.year
            
            var calendar = Calendar.current
            calendar.timeZone = TimeZone(secondsFromGMT: 0)!
            return calendar.date(from: dateComponent)
        }
    }
    
    fileprivate var currentMostPresenceDate: Date?
    
    fileprivate func updateNavigationTitle() {
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.calendarView.visibleDates { (dateSegmentInfo: DateSegmentInfo) in
                
                let monthItemList = MonthItemList(monthDates: dateSegmentInfo.monthDates)
                if let mostPresenceDate = monthItemList.mostPresenceDate, self.currentMostPresenceDate != mostPresenceDate {
                    DispatchQueue.main.async {
                        self.monthTitleLabel.text = self.monthFormatter.string(from: mostPresenceDate)
                        self.yearTitleLabel.text = self.yearFormatter.string(from: mostPresenceDate)
                        
                        self.currentMostPresenceDate = mostPresenceDate
                    }
                }
            }
        }
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
            calendarNavigationController.performSegue(toTxactionListViewControllerWith: selectedDate)
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
        updateNavigationTitle()
    }
}

// MARK: - TxactionListViewControllerDelegate

extension CalendarMonthViewController: TransactionListViewControllerDelegate {
    func transactionListViewController(_ controller: TransactionListViewController, didSelect date: Date) {
        updateNavigationBarTitle()
        
        if let selectedDate = selectedDate, Calendar.current.isDate(selectedDate, inSameDayAs: date) {
            return
        }
        
        selectedDate = date
        calendarViewController.scrollToSelectedDate()
    }
}
