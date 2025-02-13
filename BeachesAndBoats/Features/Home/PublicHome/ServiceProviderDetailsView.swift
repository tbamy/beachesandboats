//
//  ServiceProviderDetailsView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 31/01/2025.
//

import UIKit
import Kingfisher
import RxSwift

class ServiceProviderDetailsView: BaseViewControllerPlain {
    
    var coordinator: ExploreCoordinator?
    var provider: String?
    var data: FindProviderResponseData?
    var images: [Image]?
    var bookingId: String?
    var propertyType: String?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var photosTitleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var genderLabel2: UILabel!
    @IBOutlet weak var picturesCollectionView: UICollectionView!
    @IBOutlet weak var commentsCollectionView: UICollectionView!
    @IBOutlet weak var contactBtn: PlainOutlineButton!
    
    var conversationRequest: StartConversationRequest?
    var conversationResponse: StartConversationResponse?
    let user = UserSession.shared.userDetails?.id
    
    let vm = StartConversationVM()
    let disposeBag = DisposeBag()
    let input = PublishSubject<StartConversationVM.Input>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "\(data?.name ?? "")"
        setup()
    }
    
    func setup(){
        
        switch provider {
        case "Chef":
            photosTitleLabel.text = "Food Samples"
            genderLabel.isHidden = true
            genderLabel2.text = data?.dishes?.map { "ID: \($0.id), Name: \($0.name)" }
                .joined(separator: "\n")
        case "Bouncer":
            photosTitleLabel.text = "Bouncer's Pictures"
            genderLabel2.text = data?.gender
        case "Dj":
            photosTitleLabel.text = "DJ’s pictures"
            genderLabel.isHidden = true
            genderLabel2.isHidden = true
        default:
            photosTitleLabel.text = "Food Samples"
        }
        image.layer.cornerRadius = image.frame.height / 2
        if let url = URL(string: data?.images?.first?.url?.replacingOccurrences(of: "http://", with: "https://") ?? "") {
            image.kf.setImage(
                with: url,
                placeholder: UIImage(named: "dummy"),
                options: nil,
                completionHandler: { result in
                    switch result {
                    case .success(let value):
                        print("Image loaded: \(value.source.url?.absoluteString ?? "")")
                    case .failure(let error):
                        print("Failed to load image: \(error.localizedDescription)")
                        self.image.image = UIImage(named: "dummy")
                    }
                }
            )
        } else {
            image.image = UIImage(named: "dummy")
        }
        
        aboutLabel.text = data?.description
        ratingLabel.text = "\(data?.rating ?? 0)"
        priceLabel.text = "From \(data?.startingPrice ?? 0)"
        
        contactBtn.setTitleColor(.B_B, for: .normal)
        images = data?.images
        
        picturesCollectionView.delegate = self
        picturesCollectionView.dataSource = self
        picturesCollectionView.tag = 0
        picturesCollectionView.backgroundColor = .clear
        picturesCollectionView.register(DynamicCollectionViewCell.self, forCellWithReuseIdentifier: "dynamicCell")
        
        commentsCollectionView.delegate = self
        commentsCollectionView.dataSource = self
        commentsCollectionView.tag = 1
        commentsCollectionView.backgroundColor = .clear
        commentsCollectionView.register(DynamicCollectionViewCell.self, forCellWithReuseIdentifier: "dynamicCell")
        
    }

    @IBAction func contactMeTapped(_ sender: Any) {
        //start conversation
        conversationRequest?.bookingId = bookingId
        conversationRequest?.personId = user ?? ""
        conversationRequest?.propertyType = propertyType
        
        if let conversationRequest = conversationRequest{
            input.onNext(.startConversation(conversationRequest))
            LoadingModal.show()
        }
    }

    
    func bind(){
        vm.transform(input: input)
        
        vm.output.subscribe(onNext: { [weak self] data in
            LoadingModal.dismiss()
            switch data {
            case .startConversationSuccess(let response):
                self?.conversationResponse = response
//                self?.coordinator.goto
            case .startConversationFailed(let error) :
                MiddleModal.show(title: error.message ?? "", type: .error)
            }
        }).disposed(by: disposeBag)
    }

}

extension ServiceProviderDetailsView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag {
        case 0:
            return images?.count ?? 0
        case 1:
            return  0
        default:
            return  0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView.tag {
        case 0:
            let cell = picturesCollectionView.dequeueReusableCell(withReuseIdentifier: "dynamicCell", for: indexPath) as! DynamicCollectionViewCell
            let name = images?[indexPath.item]
            
            let view = ImageCell(frame: cell.bounds)
            view.identifier = "Image " + indexPath.description
            view.img = name?.url ?? ""
            
            cell.applyView(view: view)
            return cell
            
        case 1:
            return UICollectionViewCell()
            
        default:
            return UICollectionViewCell()
        }

    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView.tag {
        case 0:
            return CGSize(width: (collectionView.bounds.width / 2) - 50, height: 180)
        case 1:
            return CGSize()
        default:
            return CGSize()
        }
        
    }
    
}
