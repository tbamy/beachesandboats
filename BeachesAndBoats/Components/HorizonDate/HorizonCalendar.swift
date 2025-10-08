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
    var onBlockedDatesChanged: (([Date]) -> Void)?
    var isSingleDate: Bool = false
    var isListingMode: Bool = false // NEW: Flag to disable today in selection mode
    
    // NEW: Property to hold blocked dates
    public var blockedDates: Set<Date> = [] {
        didSet {
            // Normalize dates to remove time components
            let calendar = Calendar.current
            blockedDates = Set(blockedDates.map { calendar.startOfDay(for: $0) })
            // Only refresh calendar, don't call setupCalendar to prevent scroll
            refreshCalendarContent()
            updateBlockingLabel()
        }
    }
    
    // NEW: Blocking mode - when true, tapping dates will add/remove them from blockedDates
    var isBlockingMode: Bool = false {
        didSet {
            // Clear regular selections when switching modes
            selectedDate = nil
            selectedStartDate = nil
            selectedEndDate = nil
            setupCalendar()
            if isBlockingMode {
                updateBlockingLabel()
            }
        }
    }
    
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
        let today = Calendar.current.startOfDay(for: currentDate)
        let normalizedStartDate = Calendar.current.startOfDay(for: model.startDate)
        
        // Determine the actual visible date range
        let visibleStartDate: Date
        if normalizedStartDate < today {
            // If start date is in the past, start from the current month
            visibleStartDate = calendar.dateInterval(of: .month, for: currentDate)?.start ?? currentDate
        } else {
            visibleStartDate = model.startDate
        }
        
        let endDate = model.endDate

        calendarContent = CalendarViewContent(
            calendar: calendar,
            visibleDateRange: visibleStartDate...endDate,
            monthsLayout: .vertical(options: VerticalMonthsLayoutOptions())
        )
        
        updateCalendarContent()

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
        
        setupDaySelectionHandler()
    }
    
    // NEW: Separate method to update calendar content
    private func updateCalendarContent() {
        let calendar = Calendar.current
        
        calendarContent = calendarContent?.dayItemProvider { [weak self] day in
            guard let self = self else { return DayLabel.calendarItemModel(
                    invariantViewProperties: .init(
                        font: .systemFont(ofSize: 18),
                        textColor: .label,
                        backgroundColor: .clear,
                        isEnabled: true),
                    content: .init(day: day))
            }

            let date = calendar.date(from: day.components)
            
            // Check if date is valid
            let today = Calendar.current.startOfDay(for: Date())
            let normalizedDate = date.map { Calendar.current.startOfDay(for: $0) }
            let normalizedEndDate = Calendar.current.startOfDay(for: model.endDate)
            let normalizedStartDate = Calendar.current.startOfDay(for: model.startDate)
            
            // NEW: In listing mode, disallow today
            let minimumSelectableDate = self.isListingMode ? calendar.date(byAdding: .day, value: 1, to: today)! : today
            
            let isValidDate = normalizedDate.map { normalizedDate in
                // Allow dates from minimumSelectableDate and future dates within the end date range
                return normalizedDate >= minimumSelectableDate && normalizedDate <= normalizedEndDate
            } ?? false
            
            // NEW: Check if date is in the blockedDates list
            let isBlockedDate = normalizedDate.map { self.blockedDates.contains($0) } ?? false
            
            // Default textColor and backgroundColor for all other days
            var textColor: UIColor = .label
            var backgroundColor: UIColor = .clear
            var isEnabled = true
            
            // NEW: Handle blocked dates
            if isBlockedDate {
                textColor = .white
                backgroundColor = .lightGray
                isEnabled = self.isBlockingMode // Enable in blocking mode to allow unblocking, disable in normal mode
            }
            // Disable invalid dates (but allow them in blocking mode if they're within range)
            else if !isValidDate && !self.isBlockingMode {
                textColor = .systemGray4
                backgroundColor = .clear
                isEnabled = false
            }
            // In blocking mode, enable valid dates for blocking
            else if !isValidDate && self.isBlockingMode {
                // Check if date is within the model's date range (ignore past date restriction in blocking mode)
                let isWithinModelRange = normalizedDate.map { normalizedDate in
                    return normalizedDate >= normalizedStartDate && normalizedDate <= normalizedEndDate
                } ?? false
                
                if isWithinModelRange {
                    textColor = .systemGray2
                    backgroundColor = .clear
                    isEnabled = true
                } else {
                    textColor = .systemGray4
                    backgroundColor = .clear
                    isEnabled = false
                }
            }
            // Customize for selected dates
            else if self.isSingleDate && date == self.selectedDate && !self.isBlockingMode {
                // Highlight single selected date
                textColor = .white
                backgroundColor = .beachBlue
            } else if date == self.selectedStartDate && !self.isBlockingMode {
                textColor = .white
                backgroundColor = .beachBlue
            } else if date == self.selectedEndDate && !self.isBlockingMode {
                textColor = .white
                backgroundColor = .beachBlue
            } else if let selectedEndDate = self.selectedEndDate,
                      let date = date,
                      date > self.selectedStartDate ?? Date() && date < selectedEndDate && !self.isBlockingMode {
                // Highlight for dates in between the range
                textColor = .label
                backgroundColor = .bBLight
            }

            return DayLabel.calendarItemModel(
                invariantViewProperties: .init(
                    font: .systemFont(ofSize: 18),
                    textColor: textColor,
                    backgroundColor: backgroundColor,
                    isEnabled: isEnabled),
                content: .init(day: day)
            )
        }
        .interMonthSpacing(24)
        .verticalDayMargin(8)
        .horizontalDayMargin(8)
    }
    
    // NEW: Separate method to setup day selection handler
    private func setupDaySelectionHandler() {
        let calendar = Calendar.current
        
        // Handle selection logic
        calendarView.daySelectionHandler = { [weak self] day in
            guard let self = self else { return }
            
            let selectedDate = calendar.date(from: DateComponents(
                year: day.month.year,
                month: day.month.month,
                day: day.day
            ))!
            
            let normalizedSelected = Calendar.current.startOfDay(for: selectedDate)
            
            // NEW: Handle blocking mode
            if self.isBlockingMode {
                // Check if date is within the model's date range
                let normalizedEndDate = Calendar.current.startOfDay(for: model.endDate)
                let normalizedStartDate = Calendar.current.startOfDay(for: model.startDate)
                
                guard normalizedSelected >= normalizedStartDate && normalizedSelected <= normalizedEndDate else {
                    MiddleModal.show(title: "Date is outside the calendar range.", type: .error)
                    return
                }
                
                // Toggle date in blockedDates
                if self.blockedDates.contains(normalizedSelected) {
                    // Remove from blocked dates (unblock)
                    self.blockedDates.remove(normalizedSelected)
                } else {
                    // Add to blocked dates (block)
                    self.blockedDates.insert(normalizedSelected)
                }
                
                // Manually refresh only the content without re-creating the calendar
                self.refreshCalendarContent()
                
                // Notify callback with updated list
                let sortedDates = Array(self.blockedDates).sorted()
                self.onBlockedDatesChanged?(sortedDates)
                
                return
            }
            
            // Regular selection logic (only when not in blocking mode)
            let today = Calendar.current.startOfDay(for: Date())
            let normalizedEndDate = Calendar.current.startOfDay(for: model.endDate)
            let normalizedStartDate = Calendar.current.startOfDay(for: model.startDate)

            // Check if the selected date is blocked
            if self.blockedDates.contains(normalizedSelected) {
                MiddleModal.show(title: "This date is not available for selection.", type: .error)
                return
            }

            // NEW: In listing mode, don't allow selecting today
            let minimumSelectableDate = self.isListingMode ? calendar.date(byAdding: .day, value: 1, to: today)! : today
            
            // First check: don't allow dates before minimum selectable date
            guard normalizedSelected >= minimumSelectableDate else {
                let message = self.isListingMode ? "You cannot select today's date." : "You cannot select past dates."
                MiddleModal.show(title: message, type: .error)
                return
            }
            
            // Second check: validate against the appropriate range
            if normalizedStartDate < minimumSelectableDate {
                // If start date is before minimum selectable, only validate against minimum and end date
                guard normalizedSelected >= minimumSelectableDate && normalizedSelected <= normalizedEndDate else {
                    MiddleModal.show(title: "Selected date is not within the available range.", type: .error)
                    return
                }
            } else {
                // Normal validation: check against normalized start date and end date
                guard normalizedSelected >= normalizedStartDate && normalizedSelected <= normalizedEndDate else {
                    MiddleModal.show(title: "Selected date is not within the available range.", type: .error)
                    return
                }
            }
            
            if self.isSingleDate {
                // Handle single date selection
                self.selectedDate = selectedDate
                self.onDateSelected?(selectedDate)
                self.selectedDateLabel.text = selectedDate.toFormattedDate()
                
                // Refresh calendar to show highlighting
                if let content = self.calendarContent {
                    self.calendarView.setContent(content)
                }
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
    
    // NEW: Refresh calendar content without scrolling or rebuilding
    func refreshCalendarContent() {
        guard calendarView != nil else { return }
        updateCalendarContent()
        if let content = calendarContent {
            calendarView.setContent(content)
        }
    }
    
    // NEW: Update label to show blocked dates count
    func updateBlockingLabel() {
        if !calendarOnlyMode {
            if blockedDates.isEmpty {
                selectedDateLabel.text = isBlockingMode ? "Tap dates to block" : ""
            } else {
                selectedDateLabel.text = "\(blockedDates.count) date(s) blocked"
            }
        }
    }
    
    // NEW: Method to toggle blocking mode
    func setBlockingMode(_ enabled: Bool) {
        self.isBlockingMode = enabled
    }
    
    // NEW: Method to check if calendar is in blocking mode
    func getBlockingMode() -> Bool {
        return isBlockingMode
    }
    
    // NEW: Get the list of blocked dates
    func getBlockedDates() -> [Date] {
        return Array(blockedDates).sorted()
    }
    
    // NEW: Set blocked dates programmatically
    func setBlockedDates(_ dates: [Date]) {
        let calendar = Calendar.current
        self.blockedDates = Set(dates.map { calendar.startOfDay(for: $0) })
    }
    
    // NEW: Clear all blocked dates
    func clearBlockedDates() {
        self.blockedDates.removeAll()
    }
    
    // NEW: Add a single blocked date
    func addBlockedDate(_ date: Date) {
        let calendar = Calendar.current
        self.blockedDates.insert(calendar.startOfDay(for: date))
    }
    
    // NEW: Remove a single blocked date
    func removeBlockedDate(_ date: Date) {
        let calendar = Calendar.current
        self.blockedDates.remove(calendar.startOfDay(for: date))
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
        let isEnabled: Bool
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
        
        label.isUserInteractionEnabled = invariantViewProperties.isEnabled
        label.layer.cornerRadius = .zero
        label.font = invariantViewProperties.font
        label.textColor = invariantViewProperties.textColor
        label.backgroundColor = invariantViewProperties.backgroundColor
        
        label.textAlignment = .center
        label.clipsToBounds = true
        
        // Visual indication for disabled state
        if !invariantViewProperties.isEnabled {
            label.alpha = 0.9
        } else {
            label.alpha = 1.0
        }
        
        return label
    }
    
    static func setContent(_ content: Content, on view: UILabel) {
        view.text = "\(content.day.day)"
    }
}

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
