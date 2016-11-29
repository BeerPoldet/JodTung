//
//  CalendarMonthViewControllerPresenter.swift
//  JodTung
//
//  Created by Dev on 11/29/2559 BE.
//  Copyright © 2559 Poldet Assanangkornchai. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CalendarMonthViewControllerPresenter {
    
    // MARK: - Public API
    
    open var calendarViewControllerConfig: CalendarViewController.CalendarViewConfig {
        return CalendarViewController.CalendarViewConfig(
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
    }
    
    open var fadeTextAnimation: CATransition {
        let fadeTextAnimation = CATransition()
        fadeTextAnimation.type = kCATransitionFade
        fadeTextAnimation.duration = 0.5
        
        return fadeTextAnimation
    }
    
    open func monthTitle(for date: Date) -> String {
        return monthFormatter.string(from: date)
    }
    
    open func monthInfo(for dateSegmentInfo: DateSegmentInfo, completionHandler: @escaping (MonthInfo) -> ()) {
        func isDate(_ dateA: Date, inSameMonthAs dateB: Date) -> Bool {
            let isSameMonth = Calendar.current.compare(
                dateA,
                to: dateB,
                toGranularity: Calendar.Component.month) == .orderedSame
            
            let isSameYear = Calendar.current.compare(
                dateA,
                to: dateB,
                toGranularity: Calendar.Component.year) == .orderedSame
            return isSameMonth && isSameYear
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            let monthItemList = MonthItemList(monthDates: dateSegmentInfo.monthDates)
            
            guard let mostPresenceDate = monthItemList.mostPresenceDate else { return }
            
            if self.currentMostPresenceDate == nil {
                self.present(mostPresenceDate: mostPresenceDate, completionHandler: completionHandler)
            } else if let currentMostPresenceDate = self.currentMostPresenceDate,
                !isDate(currentMostPresenceDate, inSameMonthAs: mostPresenceDate)
            {
                self.present(mostPresenceDate: mostPresenceDate, completionHandler: completionHandler)
            }
            
        }
    }
    
    // MARK: - Properties
    
    fileprivate lazy var monthFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter
    }()
    
    fileprivate lazy var yearFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter
    }()
    
    // MARK: - Month Presentation
    
    fileprivate struct MonthItem {
        var month: Int
        var year: Int
        
        init(month: Int, year: Int) {
            self.month = month
            self.year = year
        }
        
        var count = 0
    }
    
    fileprivate struct MonthItemList {
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
    
    public struct MonthInfo {
        var monthTitle: String?
        var yearTitle: String?
    }
    
    fileprivate func present(mostPresenceDate: Date, completionHandler: @escaping (MonthInfo) -> ()) {
        DispatchQueue.main.async {
            
            self.currentMostPresenceDate = mostPresenceDate
            
            completionHandler(MonthInfo(
                monthTitle: self.monthFormatter.string(from: mostPresenceDate),
                yearTitle: self.yearFormatter.string(from: mostPresenceDate)
            ))
        }
    }
}
