//
//  NotificationSettingsView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 16/10/2024.
//

import UIKit
import RxSwift

class NotificationSettingsView: BaseViewControllerPlain {
    var coordinator: AccountCoordinator?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let vm = NotificationSettingsVM()
    let disposeBag = DisposeBag()
    let input = PublishSubject<NotificationSettingsVM.Input>()
    
    let notifications = UserSession.shared.loginRes?.data?.user?.notificationSettings
    
    var selectedItems: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Notifications"
        
        setupCustomNavigationButtons()
        setup()
        bind()
        
    }

    
    func setup(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.register(DynamicCollectionViewCell.self, forCellWithReuseIdentifier: "dynamicCell")
    }

    
    func bind(){
        vm.transform(input: input)

        vm.output.subscribe(onNext: {[weak self] event in
            guard let self = self else { return }
            LoadingModal.dismiss()
            switch event {
            case .updateNotificationSettingsSuccess(let response):
                Toast.show(message: response.message ?? "Notification Settings Updated Successfully")
                
            case .updateNotificationSettingsFailed(let error):
                Toast.show(message: error.message ?? "Error ocurred")
            }
        }).disposed(by: disposeBag)
    }
    
}

extension NotificationSettingsView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return notifications?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dynamicCell", for: indexPath) as! DynamicCollectionViewCell

        cell.isUserInteractionEnabled = true
        let view = NotificationViewCell(frame: cell.bounds)
        view.identifier = "Notifications " + indexPath.description
        let item = notifications?[indexPath.row]
        view.model.title = item?.title ?? ""
        view.model.subtitle = item?.description ?? ""
        if let status = item?.status{
            view.isToggled = status
        }
        
//        let itemId = item?.id ?? ""
//        view.isToggled = selectedItems.contains(itemId)
        
        // Setup toggle action to update selectedRules
        view.toggleSwitch.addTarget(self, action: #selector(toggleSwitchChanged(_:)), for: .valueChanged)
        view.toggleSwitch.tag = indexPath.row
        
        cell.applyView(view: view)
        return cell
    }
    
    @objc func toggleSwitchChanged(_ sender: UISwitch) {
        let index = sender.tag
        guard let itemId = notifications?[index].id else { return }
        
        if sender.isOn {
            if !selectedItems.contains(itemId) {
                selectedItems.append(itemId)
            }
        } else {
            selectedItems.removeAll { $0 == itemId }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let widthOfScreen: CGFloat = collectionView.bounds.width
//        let heightOfScreen = collectionView.bounds.height
        return CGSize(width: widthOfScreen, height: 90)
       
    }
    
    
}

extension NotificationSettingsView {
    func setupCustomNavigationButtons() {
        
        let saveButton = UIButton(type: .custom)
        saveButton.setTitleColor(.beachBlue, for: .normal)
        saveButton.setTitle("Save", for: .normal)
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        let addBarButtonItem = UIBarButtonItem(customView: saveButton)


        navigationItem.rightBarButtonItems = [addBarButtonItem]
    }

    // Actions for the buttons
    @objc func saveButtonTapped() {
        LoadingModal.show()
        let request = NotificationSettingsRequest(settings: selectedItems)
        input.onNext(.updateNotificationSettings(request))
    }


}
