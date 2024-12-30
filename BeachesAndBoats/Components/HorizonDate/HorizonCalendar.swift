//
//  HorizonCalendar.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 13/10/2024.
//

import UIKit
import HorizonCalendar

class HorizonCalendar: BaseXib {
    
    @IBOutlet weak var calendarViewContainer: UIView!
    @IBOutlet weak var selectedDateLabel: UILabel!
    
    private var selectedStartDate: Date = Date()
    private var selectedEndDate: Date? = nil
    
    private var calendarView: CalendarView!
    var indicatorView: DayRangeIndicatorView?
    var calendarContent: CalendarViewContent?
    
    var onDateSelected: ((Date, Date?) -> Void)?
    
    public var model: HorizonCalendarModel = HorizonCalendarModel() {
        didSet {
            setupCalendar()
        }
    }
    
    @IBInspectable var calendarOnlyMode: Bool = false {
        didSet { setupCalendar() }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupCalendar()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCalendar()
    }

    func setupCalendar() {
        if calendarOnlyMode{
            selectedDateLabel.isHidden = true
        }else{
            selectedDateLabel.isHidden = false
        }
        
        let currentDate = Date()
        let calendar = Calendar.current
//        let components = calendar.dateComponents([.year, .month, .day], from: currentDate)
//        let startDate = calendar.date(from: components)!
//        let endDate = calendar.date(byAdding: .month, value: 6, to: startDate)!
        let startDate = model.startDate
        let endDate = model.endDate

        calendarContent = CalendarViewContent(
            calendar: calendar,
            visibleDateRange: startDate...endDate,
            monthsLayout: .vertical(options: VerticalMonthsLayoutOptions())
        )

        calendarContent = calendarContent?.dayItemProvider { [weak self] day in
            guard let self = self else { return DayLabel.calendarItemModel(
                    invariantViewProperties: .init(
                        font: .systemFont(ofSize: 18),
                        textColor: .label, backgroundColor: .clear),
                    content: .init(day: day))
            }

            let date = calendar.date(from: day.components)
            
            // Default textColor and borderColor for all other days
            var textColor: UIColor = .label
            var backgroundColor: UIColor = .clear
            
            // Customize for start and end dates
            if date == self.selectedStartDate {
                textColor = .white
                backgroundColor = .beachBlue
            } else if date == self.selectedEndDate {
                textColor = .white
                backgroundColor = .beachBlue
            } else if let selectedEndDate = self.selectedEndDate,
                      let date = date,
                      date > self.selectedStartDate && date < selectedEndDate {
                // Highlight for dates in between the range
                textColor = .label
                backgroundColor = .bBLight
                
            }

            return DayLabel.calendarItemModel(
                invariantViewProperties: .init(
                    font: .systemFont(ofSize: 18),
                    textColor: textColor, backgroundColor: backgroundColor),
                content: .init(day: day)
            )
        }
        .interMonthSpacing(24)
        .verticalDayMargin(8)
        .horizontalDayMargin(8)

        if let cont = calendarContent {
            calendarView = CalendarView(initialContent: cont)
        }
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        calendarViewContainer.addSubview(calendarView)
        calendarView.backgroundColor = .background.lighter(by: 17)

        NSLayoutConstraint.activate([
            calendarView.leadingAnchor.constraint(equalTo: calendarViewContainer.leadingAnchor),
            calendarView.trailingAnchor.constraint(equalTo: calendarViewContainer.trailingAnchor),
            calendarView.topAnchor.constraint(equalTo: calendarViewContainer.topAnchor),
            calendarView.bottomAnchor.constraint(equalTo: calendarViewContainer.bottomAnchor)
        ])
        
        // Handle selection logic
        calendarView.daySelectionHandler = { [weak self] day in
            guard let self = self else { return }
            
            let selectedDate = calendar.date(from: DateComponents(
                year: day.month.year,
                month: day.month.month,
                day: day.day
            ))!
            
            let availableDateRange = model.availableDateRange
            
            guard availableDateRange.contains(selectedDate) else {
                MiddleModal.show(title: "Selected date is not within the available range.", type: .error)
                return
            }
                            
            
            if self.selectedEndDate == nil {
                if selectedDate > self.selectedStartDate {
                    self.selectedEndDate = selectedDate
                } else {
                    self.selectedEndDate = self.selectedStartDate
                    self.selectedStartDate = selectedDate
                }
            } else {
                self.selectedStartDate = selectedDate
                self.selectedEndDate = nil
            }

            // Update content to reflect selection
            self.updateHighlightedDateRange(start: self.selectedStartDate, end: self.selectedEndDate)
            self.onDateSelected?(self.selectedStartDate, self.selectedEndDate)
            
            if let endDate = selectedEndDate{
                selectedDateLabel.text = "\(selectedStartDate.toFormattedDate()) - \(endDate.toFormattedDate())"
            }else{
                selectedDateLabel.text = selectedStartDate.toFormattedDate()
            }
            
        }
    }

    // Method to update the highlighted range in the calendar view
    func updateHighlightedDateRange(start: Date, end: Date?) {
//        let calendar = Calendar.current

        // Determine the range to highlight
        if let endDate = end {
            let dateRangeToHighlight = start...endDate
            calendarContent = calendarContent?.dayRangeItemProvider(for: [dateRangeToHighlight]) { dayRangeLayoutContext in
                DayRangeIndicatorView.calendarItemModel(
                    invariantViewProperties: .init(indicatorColor: UIColor.clear),
                    content: .init(framesOfDaysToHighlight: dayRangeLayoutContext.daysAndFrames.map { $0.frame })
                )
            }
        }

        // Refresh calendar content to apply new highlights immediately
        calendarView.setContent(calendarContent!)
    }
        // Helper method to format the date for the label
        func formatDate(date: Date) -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            return dateFormatter.string(from: date)
        }
        
    
}
    
// Custom DayView class to represent individual days in the calendar
struct DayLabel: CalendarItemViewRepresentable {
    
    /// Properties that are set once when we initialize the view.
    struct InvariantViewProperties: Hashable {
        let font: UIFont
        let textColor: UIColor
        let backgroundColor: UIColor
    }
    
    /// Properties that will vary depending on the particular date being displayed.
    struct Content: Equatable {
        let day: DayComponents
    }
    
    static func makeView(
        withInvariantViewProperties invariantViewProperties: InvariantViewProperties)
    -> UILabel
    {
        let label = UILabel()
        
        label.isUserInteractionEnabled = true
        label.layer.cornerRadius = .zero
        //    label.layer.borderColor = invariantViewProperties.borderColor.cgColor
        label.font = invariantViewProperties.font
        label.textColor = invariantViewProperties.textColor
        label.backgroundColor = invariantViewProperties.backgroundColor
        
        label.textAlignment = .center
        label.clipsToBounds = true
//        label.layer.cornerRadius = 12
        
        return label
    }
    
    static func setContent(_ content: Content, on view: UILabel) {
        view.text = "\(content.day.day)"
    }
    
}

struct HorizonCalendarModel{
    var startDate: Date = Date()
    var endDate: Date = Calendar.current.date(byAdding: .month, value: 6, to: Date())!
    var availableDateRange: ClosedRange<Date> = Date()...Calendar.current.date(byAdding: .month, value: 6, to: Date())!
}
