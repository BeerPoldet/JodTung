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
    
    var selectedDate: Date? = CalendarView.defaultSelectedDate {
        didSet {
            if let selectedDate = selectedDate {
                select(date: selectedDate)
            }
        }
    }
    
    // MARK: - Properties
    
    private var didScrollingToSelectedDateOnLoadCalendar = false
    
    // MARK: - Outlets
    
    @IBOutlet weak var calendarView: JTAppleCalendarView! {
        didSet {
            setupCalendarView()
        }
    }
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let selectedDate = selectedDate, calendarView.selectedDates.isEmpty {
            select(date: selectedDate)
        }
        
        scrollToSelectedDate(withAnimation: false)
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
    
    func select(date: Date) {
        calendarView?.selectDates([date], triggerSelectionDelegate: true, keepSelectionIfMultiSelectionAllowed: false)
    }
    
    // MARK: - Setup UI
    
    private func setupCalendarView() {
        calendarView.isHidden = true
        calendarView.dataSource = self
        calendarView.delegate = self
        calendarView.scrollingMode = .nonStopToCell(withResistance: CalendarView.Scrolling.resistance)
        calendarView.direction = CalendarView.Scrolling.direction
        calendarView.registerCellViewXib(file: DayCellView.xibName)
        calendarView.registerHeaderView(xibFileNames: [MonthSectionHeaderView.xibName])
        
        calendarView.itemSize = CGFloat(CalendarView.itemSize)
    }
    
    // MARK: - Constants
    
    private struct CalendarView {
        static let defaultSelectedDate = Date()
        static let itemSize = 52
        static let numberOfRows = 6
        
        struct Scrolling {
            static let resistance = CGFloat(0.75)
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
}

extension TxactionListViewController: JTAppleCalendarViewDataSource {
    
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

extension TxactionListViewController: JTAppleCalendarViewDelegate {
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplayCell cell: JTAppleDayCellView, date: Date, cellState: CellState) {
        if let cell = cell as? DayCellView, isViewLoaded {
            cell.setup(date: date, with: cellState)
        }
    }
    
    func calendar(_ calendar: JTAppleCalendarView, sectionHeaderSizeFor range: (start: Date, end: Date), belongingTo month: Int) -> CGSize {
        return CGSize(width: Int(calendar.bounds.width), height: CalendarView.itemSize)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplaySectionHeader header: JTAppleHeaderView, range: (start: Date, end: Date), identifier: String) {
        if let headerView = header as? MonthSectionHeaderView {
            headerView.setup(range: range)
        }
    }
}
