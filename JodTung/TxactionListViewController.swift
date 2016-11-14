//
//  TxactionListViewController.swift
//  JodTung
//
//  Created by Poldet Assanangkornchai on 10/18/2559 BE.
//  Copyright © 2559 Poldet Assanangkornchai. All rights reserved.
//

import UIKit
import JTAppleCalendar

class TxactionListViewController: UIViewController {
    
    // MARK: - Injected Dependencies
    
    var selectedDate: Date? {
        get {
            return calendarViewController.selectedDate
        }
        set {
            calendarViewController.selectedDate = newValue
            selectedDateDidChange()
        }
    }
    
    var boundary: Boundary?
    
    weak var delegate: TxactionListViewControllerDelegate?
    
    // MARK: - Properties
    
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
    @IBOutlet weak var contentView: UIView!
    
    // MARK: - Events
    
    fileprivate func selectedDateDidChange() {
        updateSelectedDay()
        updateSelectedDateLabel()
        if let selectedDate = selectedDate {
            delegate?.txactionListViewController(self, didSelect: selectedDate)
        }
    }
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        
        var cateInfo = CategoryInfo()
        cateInfo.title = "test"
        cateInfo.iconName = "hi"
        
        
            let todayTxn = boundary?.transactions(forDate: Date())
            print(todayTxn)
        
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
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let identifier = segue.identifier
        if identifier == SegueIdentifier.showCalendar {
            let calendarMonthViewController = segue.destination as! CalendarMonthViewController
            if let selectedDate = calendarViewController.selectedDate {
                calendarMonthViewController.selectedDate = selectedDate
            }
        }
    }
}

// MARK: - JTAppleCalendarViewDelegate

extension TxactionListViewController: JTAppleCalendarViewDelegate {
    
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

// MARK: - 

extension TxactionListViewController: CalendarViewControllerAnimatedTransitioningDataSource {
    func expandableLayoutConstraint() -> NSLayoutConstraint {
        return self.calendarWeekViewHeightConstraint
    }
    
    func expendedHeight() -> CGFloat {
        return self.expandedHeightOfCalendarWeekView ?? 0
    }
    
    func contentViewToFadeIn() -> UIView {
        return self.contentView
    }
}

// MARK: - TxactionListViewControllerDelegate

protocol TxactionListViewControllerDelegate: class {
    func txactionListViewController(_ controller: TxactionListViewController, didSelect date: Date)
}
