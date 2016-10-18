//
//  DayCellView.swift
//  JodTung
//
//  Created by Poldet Assanangkornchai on 10/18/2559 BE.
//  Copyright © 2559 Poldet Assanangkornchai. All rights reserved.
//

import JTAppleCalendar

class DayCellView: JTAppleDayCellView {
    
    @IBOutlet weak var dayLabel: UILabel!
    
    let normalDayColor = UIColor.black
    let weekendDayColor = UIColor.gray
    
    static let xibName: String = String(describing: DayCellView.self)
    
    func setup(date: Date, with cellState: CellState) {
        if cellState.dateBelongsTo != .thisMonth {
            self.isHidden = true
            return
        }
        
        self.isHidden = false
        dayLabel?.text = cellState.text
        
        switch cellState.day {
        case .sunday, .saturday:
            dayLabel.textColor = weekendDayColor
        default:
            dayLabel.textColor = normalDayColor
        }
    }
}
