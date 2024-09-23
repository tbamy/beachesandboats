//
//  DateRangePage.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 06/09/2024.
//

import UIKit
import HorizonCalendar

public protocol DateRangeDelegate{
    func selectedDate(startDate: String, endDate: String)
}

public class DateRangePage: BaseXib {

    @IBOutlet weak var clearDateBtn: UILabel!
    @IBOutlet weak var calendarViewContainer: UIView!
    @IBOutlet weak var selectedDate: UILabel!
    @IBOutlet weak var doneBtn: PrimaryButton!
    
    private var selectedStartDate: Date?
    private var selectedEndDate: Date?
    
    let nibName = "DateRangePicker"
    var dateRangeDelegate: DateRangeDelegate?
    
    private var calendarView: CalendarView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    override func getNibName() -> String? {
        return nibName
    }
    
     func commonInit() {
        setupCalendar()
    }

     func setupCalendar() {
        let currentDate = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: currentDate)
        let startDate = calendar.date(from: components)!
        let endDate = calendar.date(from: DateComponents(year: 2025, month: 12, day: 31))!

        let content = CalendarViewContent(calendar: calendar, visibleDateRange: startDate...endDate, monthsLayout: .vertical(options: VerticalMonthsLayoutOptions()))
        
        calendarView = CalendarView(initialContent: content)
        
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        calendarViewContainer.addSubview(calendarView)
        NSLayoutConstraint.activate([
            calendarView.leadingAnchor.constraint(equalTo: calendarViewContainer.leadingAnchor),
            calendarView.trailingAnchor.constraint(equalTo: calendarViewContainer.trailingAnchor),
            calendarView.topAnchor.constraint(equalTo: calendarViewContainer.topAnchor),
            calendarView.bottomAnchor.constraint(equalTo: calendarViewContainer.bottomAnchor)
        ])
        

//                self.calendarView = calendarView
         
         
         
         doneBtn.addTarget(self, action: #selector(handleApply), for: .touchUpInside)
        }
    
    @objc func handleApply() {
//        print(
        dismiss()
    }
    
    func dismiss() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: { [weak self] in
            self?.frame.origin.y = Helpers.screenHeight
            self?.layoutIfNeeded()
        }, completion: { [weak self] _ in
            self?.superview?.removeFromSuperview()
        })
    }
    
    
    public static func startDateRangeModal(on view: UIView, delegate dateRangeDel: DateRangeDelegate) {
        let backDrop = UIView(frame: Helpers.screen)
        backDrop.backgroundColor = .gray.withAlphaComponent(0.5)
        
        let modal = DateRangePage()
        modal.dateRangeDelegate = dateRangeDel
        
        modal.layer.cornerRadius = 20
        modal.backgroundColor = .white
        modal.clipsToBounds = true
        backDrop.addSubview(modal)
        UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.addSubview(backDrop)
        let height = Helpers.screenHeight * 0.95
        modal.frame = CGRect(x: 0, y: Helpers.screenHeight, width: Helpers.screenWidth, height: height)
        backDrop.layoutIfNeeded()
        
        UIView.animate(withDuration: 0, delay: 0, options: .curveEaseIn, animations: {
            modal.frame.origin.y = Helpers.screenHeight - height
            backDrop.layoutIfNeeded()
        }, completion: nil)
    }
        
   
}
