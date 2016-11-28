//
//  CalendarViewController.swift
//  JodTung
//
//  Created by Poldet Assanangkornchai on 11/1/2559 BE.
//  Copyright © 2559 Poldet Assanangkornchai. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CalendarViewController {
    
    weak var calendarDelegate: JTAppleCalendarViewDelegate? {
        didSet {
            calendarView?.delegate = calendarDelegate
        }
    }
    
    // MARK: - Properties
    
    open var selectedDate: Date? {
        get {
            return _selectedDate
        }
        set(newDate) {
            if newDate == nil && _selectedDate != nil {
                _selectedDate = nil
                return
            }
            
            if _selectedDate == nil && newDate != nil {
                _selectedDate = newDate
                return
            }
            
            if let newDate = newDate, let _selectedDate = _selectedDate {
                if !Calendar.current.isDate(newDate, inSameDayAs: _selectedDate) {
                    self._selectedDate = newDate
                }
            }
        }
    }
    
    fileprivate var _selectedDate: Date? = CalendarViewConfig.defaultSelectedDate {
        didSet {
            updateCalendarViewSelectedDate()
        }
    }
    
    weak var calendarView: JTAppleCalendarView! {
        didSet {
            setupCalendarView()
        }
    }
    
    fileprivate var config: CalendarViewConfig!
    
    // MARK: - Object Lifecycle
    
    init(config: CalendarViewConfig) {
        self.config = config
    }
    
    // MARK: - Calendar View
    
    func scrollToSelectedDate(withAnimation: Bool = true) {
        
        if let selectedDate = selectedDate {
            calendarView?.scrollToDate(
                selectedDate,
                triggerScrollToDateDelegate: true,
                animateScroll: withAnimation,
                preferredScrollPosition: .centeredVertically,
                completionHandler: {
                    self.updateCalendarViewSelectedDate()
                }
            )
        }
    }
    
    fileprivate func updateCalendarViewSelectedDate() {
        var selectedDates = [Date]()
        if let selectedDate = selectedDate {
            selectedDates.append(selectedDate)
        }
        
        calendarView?.selectDates(selectedDates, triggerSelectionDelegate: false, keepSelectionIfMultiSelectionAllowed: false)
    }
    
    fileprivate func setupCalendarView() {
        calendarView.dataSource = self
        calendarView.delegate = calendarDelegate
        calendarView.scrollingMode = config.scrolling.mode
        calendarView.direction = config.scrolling.direction
        calendarView.registerCellViewXib(file: DayCellView.xibName)
        calendarView.itemSize = config.itemSize
        calendarView.cellInset = config.cellInset
        calendarView.allowsMultipleSelection = config.allowsMultipleSelection
        
    }
    
    struct CalendarViewConfig {
        static let components: DateComponents = {
            var components = Calendar.current.dateComponents([.year, .month, .day], from: Date())
            components.timeZone = TimeZone(secondsFromGMT: 0)
            return components
        }()
        static let defaultSelectedDate = Calendar.current.date(from: components)
        
        var itemSize: CGFloat? = nil
        var numberOfRows: Int = 1
        var cellInset = CGPoint.zero
        var generateInDates = InDateCellGeneration.forFirstMonthOnly
        var generateOutDates = OutDateCellGeneration.off
        var firstDayOfWeek = DaysOfWeek.sunday
        var allowsMultipleSelection = false
        var scrolling: Scrolling
        
        struct Scrolling {
            var mode: JTAppleCalendarView.ScrollingMode
            var direction: UICollectionViewScrollDirection
            static let resistance = CGFloat(0)
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
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleDayCellView?, cellState: CellState) {
        if let previousSelectedDate = selectedDate {
            calendar.reloadDates([previousSelectedDate])
        }
        
        // do the trick to hightlight the selected cell
        if let cell = cell as? DayCellView {
            cell.setup(date: date, with: cellState, showingSeparateLine: false)
        }
        
        selectedDate = date
    }
}

extension CalendarViewController: JTAppleCalendarViewDataSource {
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        
        return ConfigurationParameters(
            startDate: CalendarViewConfig.Boundary.startDate,
            endDate: CalendarViewConfig.Boundary.endDate,
            numberOfRows: config.numberOfRows,
            calendar: Calendar.current,
            generateInDates: config.generateInDates,
            generateOutDates: config.generateOutDates,
            firstDayOfWeek: config.firstDayOfWeek
        )
    }
}




