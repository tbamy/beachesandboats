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
    
    private var selectedDate: Date? = nil
    private var selectedStartDate: Date? = nil
    private var selectedEndDate: Date? = nil
    
    private var calendarView: CalendarView!
    var indicatorView: DayRangeIndicatorView?
    var calendarContent: CalendarViewContent?
    
    var onDatesSelected: ((Date, Date?) -> Void)?
    var onDateSelected: ((Date) -> Void)?
    var isSingleDate: Bool = false
    
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
                      date > self.selectedStartDate ?? Date() && date < selectedEndDate {
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
            
            if self.isSingleDate {
                // Handle single date selection
                self.selectedDate = selectedDate
                self.onDateSelected?(selectedDate)
                self.selectedDateLabel.text = selectedDate.toFormattedDate()
            } else {
                
                if self.selectedStartDate == nil {
                    // Set the start date if it hasn't been selected yet
                    self.selectedStartDate = selectedDate
                } else if self.selectedEndDate == nil {
                    // Set the end date if it hasn't been selected
                    if selectedDate > self.selectedStartDate! {
                        self.selectedEndDate = selectedDate
                    } else {
                        // Swap start and end dates if the new selection is earlier
                        self.selectedEndDate = self.selectedStartDate
                        self.selectedStartDate = selectedDate
                    }
                } else {
                    // Reset the selection if both start and end dates are already set
                    self.selectedStartDate = selectedDate
                    self.selectedEndDate = nil
                }
                
                
                // Update content to reflect selection
                self.updateHighlightedDateRange(start: self.selectedStartDate ?? Date(), end: self.selectedEndDate)
                
                self.onDatesSelected?(self.selectedStartDate ?? Date(), self.selectedEndDate)
                
                if let endDate = selectedEndDate{
                    selectedDateLabel.text = "\(selectedStartDate?.toFormattedDate() ?? "") - \(endDate.toFormattedDate())"
                }else{
                    selectedDateLabel.text = selectedStartDate?.toFormattedDate()
                }
            }
            
        }
    }

    // Method to update the highlighted range in the calendar view
    func updateHighlightedDateRange(start: Date, end: Date?) {
        if isSingleDate {
            return
        }
        guard let start = selectedStartDate else { return }
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
        
        if let content = calendarContent {
            calendarView.setContent(content)
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

//struct HorizonCalendarModel{
//    var startDate: Date = Date()
//    var endDate: Date = Calendar.current.date(byAdding: .month, value: 6, to: Date())!
//    var availableDateRange: ClosedRange<Date> = Date()...Calendar.current.date(byAdding: .month, value: 6, to: Date())!
//}

struct HorizonCalendarModel {
    var startDate: Date
    var endDate: Date
    var availableDateRange: ClosedRange<Date>
    
    init(startDate: Date = Date(), endDate: Date = Calendar.current.date(byAdding: .month, value: 6, to: Date())!) {
        self.startDate = startDate
        self.endDate = endDate
        self.availableDateRange = startDate...endDate
    }
}

