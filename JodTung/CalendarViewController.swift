//
//  CalendarViewController.swift
//  JodTung
//
//  Created by Poldet Assanangkornchai on 10/20/2559 BE.
//  Copyright © 2559 Poldet Assanangkornchai. All rights reserved.
//

import UIKit

import UIKit
import JTAppleCalendar

class CalendarViewController: UIViewController {
    
    // MARK: - Injected Dependencies
    
    
    
    // MARK: - Properties
    
    fileprivate var didScrollingToSelectedDateOnLoadCalendar = false
    fileprivate var selectedDate: Date? = CalendarView.defaultSelectedDate
    
    // MARK: - Outlets
    
    @IBOutlet weak var calendarView: JTAppleCalendarView! {
        didSet {
            setupCalendarView()
        }
    }
    @IBOutlet var calendarTitleView: UIView!
    @IBOutlet weak var monthTitleLabel: UILabel!
    @IBOutlet weak var yearTitleLabel: UILabel!
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let selectedDate = selectedDate, calendarView.selectedDates.isEmpty {
            select(date: selectedDate)
        }
        
        scrollToSelectedDate(withAnimation: false)
        
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.isTranslucent = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: calendarTitleView)
    }
    
    
    // MARK: - Calendar View
    
    func scrollToSelectedDate(withAnimation: Bool = true) {
        if let selectedDate = selectedDate {
            calendarView?.scrollToHeaderForDate(
                selectedDate,
                triggerScrollToDateDelegate: true,
                withAnimation: withAnimation,
                completionHandler: {
                    if !self.didScrollingToSelectedDateOnLoadCalendar {
                        self.calendarView.isHidden = false
                        self.didScrollingToSelectedDateOnLoadCalendar = true
                    }
                }
            )
        }
    }
    
    func select(date: Date, updatingCalendar: Bool = false) {
        calendarView?.selectDates([date], triggerSelectionDelegate: updatingCalendar, keepSelectionIfMultiSelectionAllowed: false)
    }
    
    // MARK: - Setup UI
    
    fileprivate func setupCalendarView() {
        calendarView.isHidden = true
        calendarView.dataSource = self
        calendarView.delegate = self
        calendarView.scrollingMode = CalendarView.Scrolling.mode
        calendarView.direction = CalendarView.Scrolling.direction
        calendarView.registerCellViewXib(file: DayCellView.xibName)
        calendarView.registerHeaderView(xibFileNames: [MonthSectionHeaderView.xibName])
        calendarView.itemSize = CGFloat(CalendarView.itemSize)
        calendarView.cellInset = CalendarView.cellInset
    }
    
    // MARK: - Constants
    
    fileprivate struct CalendarView {
        static let defaultSelectedDate = Date()
        static let itemSize = 54
        static let numberOfRows = 6
        static let cellInset = CGPoint(x: 0, y: 0)
        
        struct Scrolling {
            //            static let mode = JTAppleCalendarView.ScrollingMode.nonStopToCell(withResistance: CalendarView.Scrolling.resistance)
            static let mode = JTAppleCalendarView.ScrollingMode.none
            static let resistance = CGFloat(0)
            static let direction = UICollectionViewScrollDirection.vertical
        }
        
        struct Boundary {
            static var startDate: Date {
                return dateFormatter.date(from: "1970 01 01")!
            }
            
            static var endDate: Date {
                return dateFormatter.date(from: "2030 01 01")!
            }
            
            private static var dateFormatter: DateFormatter {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy MM dd"
                return formatter
            }
        }
    }
    
    // MARK: - Calendar Navigation Header
    
    lazy var monthFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter
    }()
    
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
                let month = Calendar.current.component(.month, from: date)
                let year = Calendar.current.component(.year, from: date)
                self.add(MonthItem(month: month, year: year))
            })
        }
        
        var mostPresenceDate: Date? {
            guard let mostPresenceMonthItem = self.max else { return nil }
            var dateComponent = DateComponents()
            dateComponent.month = mostPresenceMonthItem.month
            dateComponent.year = mostPresenceMonthItem.year
            
            return Calendar.current.date(from: dateComponent)
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

extension CalendarViewController: JTAppleCalendarViewDataSource {
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        
        let startDate = CalendarView.Boundary.startDate
        let endDate = CalendarView.Boundary.endDate
        let numberOfRows = CalendarView.numberOfRows
        let calendar = Calendar.current
        
        return ConfigurationParameters(
            startDate: startDate,
            endDate: endDate,
            numberOfRows: numberOfRows,
            calendar: calendar,
            generateInDates: InDateCellGeneration.forAllMonths,
            generateOutDates: OutDateCellGeneration.tillEndOfRow,
            firstDayOfWeek: DaysOfWeek.sunday
        )
    }
}

extension CalendarViewController: JTAppleCalendarViewDelegate {
    
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
    
    func calendar(_ calendar: JTAppleCalendarView, sectionHeaderSizeFor range: (start: Date, end: Date), belongingTo month: Int) -> CGSize {
        return CGSize(width: Int(calendar.bounds.width), height: CalendarView.itemSize)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplaySectionHeader header: JTAppleHeaderView, range: (start: Date, end: Date), identifier: String) {
        if let headerView = header as? MonthSectionHeaderView {
            headerView.setup(range: range)
        }
        
        updateNavigationTitle()
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleDayCellView?, cellState: CellState) {
        var reloadDates = [date]
        if let selectedDate = selectedDate {
            reloadDates.append(selectedDate)
        }
        calendar.reloadDates(reloadDates)
        
        selectedDate = calendar.selectedDates.first
    }
}
