//
//  DayCellView.swift
//  JodTung
//
//  Created by Poldet Assanangkornchai on 10/18/2559 BE.
//  Copyright © 2559 Poldet Assanangkornchai. All rights reserved.
//

import JTAppleCalendar

class DayCellView: JTAppleDayCellView {
  
  // MARK: - Outlets
  
  @IBOutlet weak var dayLabel: RoundedLabel!
  
  // MARK: - Properties
  
  private var showingSeparateLine: Bool = true
  private var date: Date?
  
  // MARK: - Day Style
  
  private struct DayOpions {
    var dayType: DayType
    var isSelected: Bool
  }
  
  private enum DayType {
    case today, weekend, normal
  }
  
  private struct DayLabelStyle {
    var textColor: UIColor
    var backgroundColor: UIColor?
  }
  
  private func dayOptions(of cellState: CellState) -> DayOpions {
    if Calendar.current.isDateInToday(cellState.date) {
      return DayOpions(dayType: .today, isSelected: cellState.isSelected)
    }
    
    switch cellState.day {
    case .sunday, .saturday:
      return DayOpions(dayType: .weekend, isSelected: cellState.isSelected)
    default:
      return DayOpions(dayType: .normal, isSelected: cellState.isSelected)
    }
  }
  
  private func dayLabelStyle(for dayOptions: DayOpions) -> DayLabelStyle {
    switch (dayOptions.dayType, dayOptions.isSelected) {
    case (.today, true):
      return DayLabelStyle(textColor: UIColor.white, backgroundColor: UIColor.red)
    case (.today, false):
      return DayLabelStyle(textColor: UIColor.red, backgroundColor: nil)
    case (.weekend, false):
      return DayLabelStyle(textColor: UIColor.gray, backgroundColor: nil)
    case (.normal, false):
      return DayLabelStyle(textColor: UIColor.black, backgroundColor: nil)
    case (_, true):
      return DayLabelStyle(textColor: UIColor.white, backgroundColor: UIColor.black)
    }
  }
  
  // MARK: - UI
  
  static let xibName: String = String(describing: DayCellView.self)
  
  func setup(date: Date, with cellState: CellState, showingSeparateLine: Bool = true) {
    self.date = date
    
    dayLabel?.text = cellState.text
    let dayLabelStyle = self.dayLabelStyle(for: dayOptions(of: cellState))
    dayLabel.textColor = dayLabelStyle.textColor
    
    if let backgroundColor = dayLabelStyle.backgroundColor {
      dayLabel.backgroundHidden = false
      dayLabel.layerBackgroundColor = backgroundColor
    } else {
      dayLabel.backgroundHidden = true
    }
    
    
    self.showingSeparateLine = showingSeparateLine
    setNeedsDisplay()
  }
  
  override func draw(_ rect: CGRect) {
    super.draw(rect)
    if showingSeparateLine {
      setupSeparateLine()
    }
  }
  
  private func setupSeparateLine() {
    let path = UIBezierPath()
    path.move(to: CGPoint(x: bounds.minX, y: bounds.minY))
    path.addLine(to: CGPoint(x: bounds.maxX, y: bounds.minY))
    UIColor.gray.set()
    path.lineWidth = 0.5
    path.stroke()
  }
}
