//
//  HorizonCalendarModal.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 27/12/2024.
//

import UIKit

class HorizonCalendarModal: BaseXib {

    @IBOutlet weak var calendarView: HorizonCalendar!
    @IBOutlet weak var close: UIImageView!
    @IBOutlet weak var clearBtn: UILabel!
    
    let nibName = "HorizonCalendarModal"
    
    var selectedItem: String?
    var callback: (Date?, Date?) -> Void = { _,_  in }
    var startDate: Date?
    var endDate: Date?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup(){
        clearBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clearDates)))
        close.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss(_ :))))
        
        calendarView.onDatesSelected = { startDate, endDate in
            self.selectedItem = "\(startDate.toFormattedDate()) - \(endDate?.toFormattedDate() ?? "")"
            self.startDate = startDate
            self.endDate = endDate
        }
        
        calendarView.onDateSelected = { startDate in
            self.selectedItem = "\(startDate.toFormattedDate())"
            self.startDate = startDate
        }
    }
    
    @objc func handleDismiss(_ sender: UITapGestureRecognizer) {
        dismiss()
    }
    
    @objc func clearDates(_ sender: UITapGestureRecognizer) {
        
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        callback(startDate, endDate)
        print("Start Date: \(startDate), End Date: \(endDate)")
        dismiss()
    }
    
}

extension HorizonCalendarModal{
    
    public static func show(callBack: @escaping (Date?, Date?) -> Void) {
        let backDrop = UIView(frame: Helpers.screen)
        backDrop.backgroundColor = .gray.withAlphaComponent(0.5)
        
        let modal = HorizonCalendarModal()
        modal.callback = callBack
        
        modal.backgroundColor = .background.lighter(by: 17)
        modal.layer.cornerRadius = 12
        modal.clipsToBounds = true
        backDrop.addSubview(modal)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }) {
            keyWindow.addSubview(backDrop)
        }
        let height = Helpers.screenHeight * 0.9
        modal.frame = CGRect(x: 0, y: Helpers.screenHeight, width: Helpers.screenWidth, height: height)
        backDrop.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
            modal.frame.origin.y = Helpers.screenHeight - height
            backDrop.layoutIfNeeded()
        }, completion: nil)
    }
    
    func dismiss() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: { [weak self] in
            self?.frame.origin.y = Helpers.screenHeight
            self?.layoutIfNeeded()
        }, completion: { [weak self] _ in
            self?.superview?.removeFromSuperview()
        })
    }
}
