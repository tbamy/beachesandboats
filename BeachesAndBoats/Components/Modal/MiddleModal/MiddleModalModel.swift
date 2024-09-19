//
//  MiddleModalModel.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 01/09/2024.
//

import UIKit


public struct MiddleModalModel {
    var modalTitle: String = ""
    var modalSubtitle: String = ""
    var tetiaryTitle: String = ""
    var extraView: UIView?
    var primaryText: String = "Okay"
    var secondaryText: String = ""
    var modalType: ModalType = .success
    var dismissable: Bool = true
    var dismissOnConfirm: Bool = true
    var onConfirm: () -> Void = {}
    var onCancel: () -> Void = {}
}

public enum ModalType {
    case success, successWithLinks, successWithDetails ,error, caution, pending  ,defaultModal

    func getImage() -> UIImage {
        switch self {
 
        case .success:
            return Assets.modal_success.image
        case .successWithLinks:
            return Assets.modal_success.image
        case .successWithDetails:
            return Assets.modal_success.image
        case .error:
            return Assets.modal_error.image
        case .caution:
            return Assets.modal_caution.image
//        case .face:
//            //
//        case .touch:
//            //
//        case .lock:
            //
        case .pending:
            return Assets.modal_pending.image
//        case .redSuccess:
            //
//        case .securiy:
            //
        case .defaultModal:
            return UIImage()
        }
    }
}
