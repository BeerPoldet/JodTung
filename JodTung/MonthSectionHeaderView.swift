//
//  MonthSectionHeaderView.swift
//  JodTung
//
//  Created by Poldet Assanangkornchai on 10/18/2559 BE.
//  Copyright © 2559 Poldet Assanangkornchai. All rights reserved.
//

import JTAppleCalendar

class MonthSectionHeaderView: JTAppleHeaderView {
    
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel! {
        didSet {
            yearLabel.isHidden = true
        }
    }
    
    static let xibName: String = String(describing: MonthSectionHeaderView.self)
    
    func setup(range: (start: Date, end: Date)) {
        self.range = range
    }
    
    var range: (start: Date, end: Date)? {
        didSet {
            if let range = range {
                monthLabel.text = monthText(for: range.start)
                yearLabel.text = yearText(for: range.start)
            } else {
                monthLabel.text = ""
                yearLabel.text = ""
            }
        }
    }
    
    func monthText(for date: Date) -> String {
        return text(of: date, dateFormat: "MMM").uppercased()
    }
    
    func yearText(for date: Date) -> String {
        return text(of: date, dateFormat: "yyyy")
    }
    
    func text(of date: Date, dateFormat: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        return formatter.string(from: date)
    }
}
