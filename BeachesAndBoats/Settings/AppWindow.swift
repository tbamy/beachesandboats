//
//  AppWindow.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 12/05/2024.
//

import UIKit

class AppWindow: UIWindow {
    let onboardingService = OnboardingServiceImplementation()
    var count = 0
    var timedOut: Bool = false
    var reissueCount = 0
    var time = 3*60
    var refreshTime = (3*60) - 30
    var backgroundTime = 1*30
    var timer: Timer = Timer()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var backgroundTaskIdentifier: UIBackgroundTaskIdentifier = .invalid
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterBackground(_:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive(_:)), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillResignActive(_:)), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillTerminate(_:)), name: UIApplication.willTerminateNotification, object: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func sendEvent(_ event: UIEvent) {
        super.sendEvent(event)
        
        start()
        let touchUps = event.allTouches?.filter { $0.phase == .ended }

        touchUps?.forEach { _ in
            count = 0
        }
    }
    
    func start() {
//        print(timer.isValid)
        if !timer.isValid, UserSession.shared.startSession {
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
                guard let self = self else { return }
                if UserSession.shared.startSession {
                    self.handleSession()
                } else {
                    self.timer.invalidate()
                }
            }
        }
    }
    
    @objc func applicationWillTerminate(_ application: UIApplication) {
        
    }
    
    @objc func applicationWillResignActive(_ application: UIApplication) {
        if UserSession.shared.startSession {
            AppStorage.backTime = Date().toBackendDateString()
        }
    }
    
//    @objc func applicationDidEnterBackground(_ application: UIApplication) {
//        if UserSession.shared.startSession {
//            AppStorage.backTime = Date().toBackendDateString()
//            print(AppStorage.backTime)
//        }
//    }
    
    @objc func applicationDidBecomeActive(_ application: UIApplication) {
        if UserSession.shared.startSession {
            let calendar = Calendar.current
            let backDate = AppStorage.backTime?.fromBackendDateString()
            
            if let backDate = backDate {
                let lapse = calendar.dateComponents([.second], from: backDate, to: Date())
                count += lapse.second ?? 0
//                if lapse.second ?? 0 > backgroundTime {
//                    logOut()
//                }
            }
        }
    }
    
    func handleSession() {
        count += 1
        reissueCount += 1
        if count >= time, !timedOut {
            MiddleModal.show(title: "Session Timeout", type: .error, dismissable: false, onConfirm: { [weak self] in
                self?.logOut()
            })
            timedOut = true
        }
        if count > time + 10 {
            logOut()
        }
        if reissueCount == refreshTime {
            refreshToken()
        }
//        print("⏳", count)
    }
    
    func logOut() {
        count = 0
        UserSession.shared.performLogout()
    }
    
    func refreshToken() {
//        if let user = UserSession.shared.userDetails {
//            let request = RefreshTokenRequest(token: user.token, username: user.userName ?? "", customerId: user.customerId )
//            onboardingService.refreshToken(request: request) { [weak self] data in
//                self?.reissueCount = 0
//                switch data {
//                case .success(let response):
//                    UserSession.shared.userDetails?.token = response.data.accessToken ?? ""
//                    UserSession.shared.token = response.data.accessToken
//                case .failure(_):
//                    break
//                }
//            }
//        }
    }
    
    
}
