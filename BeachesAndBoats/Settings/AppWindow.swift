//
//  AppWindow.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 12/05/2024.
//


import UIKit

class AppWindow: UIWindow {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let onboardingService = OnboardingServiceImplementation()
    var count = 0
    var timedOut: Bool = false
    var reissueCount = 0
    var time = 3*60
    var refreshTime = (3*60) - 30
    var backgroundTime = 1*30
    var timer: Timer = Timer()
    var backgroundTaskIdentifier: UIBackgroundTaskIdentifier = .invalid
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive(_:)), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillResignActive(_:)), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillTerminate(_:)), name: UIApplication.willTerminateNotification, object: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @objc func applicationWillTerminate(_ application: UIApplication) {
        
    }
    
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
    
    @objc func applicationWillResignActive(_ application: UIApplication) {
        if UserSession.shared.startSession {
            AppStorage.backTime = Date().toBackendDateString()
        }
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
        print(timer.isValid)
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
        print("⏳", count)
    }
    
    func logOut() {
        count = 0
        UserSession.shared.performLogout()
    }
    
    func refreshToken() {
        if let user = UserSession.shared.token {
            let request = RefreshTokenRequest(token: user)
            onboardingService.refreshToken(request: request) { [weak self] data in
                self?.reissueCount = 0
                switch data {
                case .success(let response):
                    UserSession.shared.token = response.data
                case .failure(_):
                    break
                }
            }
        }
    }
    
}
