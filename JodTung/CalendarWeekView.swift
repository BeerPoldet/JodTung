//
//  CalendarWeekView.swift
//  JodTung
//
//  Created by Dev on 11/28/2559 BE.
//  Copyright © 2559 Poldet Assanangkornchai. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CalendarWeekView: UIView, StoryboardView {
    
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
    
    weak var delegate: CalendarWeekViewDelegate?
    
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
    
    @IBOutlet weak var calendarView: JTAppleCalendarView! {
        didSet {
            calendarViewController.calendarView = calendarView
        }
    }
    
    // MARK: - Events
    
    fileprivate func selectedDateDidChange() {
        updateSelectedDay()
        delegate?.calenadrWeekView(self, didSelect: selectedDate)
    }
    
    // MARK: - UI
    
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
    
    func scrollToSelectedDate(withAnimation animation: Bool) {
        calendarViewController.scrollToSelectedDate(withAnimation: animation)
    }
    
    // MARK: - Object lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
}

// MARK: - CalendarWeekViewDelegate

protocol CalendarWeekViewDelegate: class {
    func calenadrWeekView(_ calendar: CalendarWeekView, didSelect date: Date)
}

// MARK: - JTAppleCalendarViewDelegate

extension CalendarWeekView: JTAppleCalendarViewDelegate {
    
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
