//
//  EarningsView.swift
//  BeachesAndBoats
//
//  Created by Hefepa on 31/12/2024.
//

import UIKit
import RxSwift

class EarningsView: BaseViewControllerPlain {
    
    @IBOutlet weak var yearBtn: YearPickerButton!
    @IBOutlet weak var totalEarning: UILabel!
    @IBOutlet weak var monthCollectionView: UICollectionView!
    @IBOutlet weak var yearlySummaryLbl: BoldLabel!
    @IBOutlet weak var withdrawalsLbl: BoldLabel!
    @IBOutlet weak var topEarningTableView: UITableView!
    @IBOutlet weak var paymentName: RegularLabel!
    @IBOutlet weak var paymentImg: UIImageView!
    @IBOutlet weak var accountNumber: RegularLabel!
    @IBOutlet weak var noInfoLabel: RegularLabel!
    @IBOutlet weak var editBtn: UIButton!
    
    var coordinator: HostingServiceEarningCoordinator?
    
    var arrayOfMonths: [String] = ["All", "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    var topEarningBookingData: [TopEarningResponse] = []
    var getSelectedMonth: String = "Jan"
    
    let vm = EarningsVM()
    let disposeBag = DisposeBag()
    let input = PublishSubject<EarningsVM.Input>()
    
    var selectedIndex: IndexPath?

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        LoadingModal.show(title: "Loading...")
        let selectedYear = yearBtn.title(for: .normal) ?? "2024"
        let request = TopEarningRequest(year: selectedYear, month: getSelectedMonth)
        input.onNext(.topEarnings(request))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Earnings"
        tableAndCollectionViewSetup()
        makeRequest()
        bind()
        setupUI()
        gestureRecognizers()
    }
    
    func setupUI() {
        let summary = "Total yearly summary"
        let attributedString = NSMutableAttributedString(string: summary)
        let underlineValue = (summary as NSString).range(of: "Total yearly summary")
        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: underlineValue)
        attributedString.addAttribute(.foregroundColor, value: UIColor.black, range: underlineValue)
        yearlySummaryLbl.attributedText = attributedString
        
        let withdraw = "Withdrawals"
        let attributedStringForWitdraw = NSMutableAttributedString(string: withdraw)
        let underlineValueForWithdraw = (withdraw as NSString).range(of: "Withdrawals")
        attributedStringForWitdraw.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: underlineValueForWithdraw)
        attributedStringForWitdraw.addAttribute(.foregroundColor, value: UIColor.black, range: underlineValueForWithdraw)
        withdrawalsLbl.attributedText = attributedStringForWitdraw
    }
    
    func makeRequest() {
        
        // Automatically select "Jan" on view load
        if let janIndex = arrayOfMonths.firstIndex(of: "Jan") {
            selectedIndex = IndexPath(item: janIndex, section: 0)
            monthCollectionView.reloadData()  // Refresh collection view to highlight "Jan"
            
            // Trigger the selection action to fetch the data for "Jan"
            collectionView(monthCollectionView, didSelectItemAt: selectedIndex!)
        }
        
        yearBtn.onYearSelected = { [weak self] year in
            LoadingModal.show(title: "Loading")
            let selectedYear = year
            print("Selected Year is \(selectedYear)")
            let request = TopEarningRequest(year: year, month: self?.getSelectedMonth ?? "All")
            self?.input.onNext(.topEarnings(request))
        }
    }
    
    func gestureRecognizers() {
        let yearlySummary = UITapGestureRecognizer(target: self, action: #selector(yearlySummaryTapped))
        yearlySummaryLbl.isUserInteractionEnabled = true
        yearlySummaryLbl.addGestureRecognizer(yearlySummary)
        
        let withdraw = UITapGestureRecognizer(target: self, action: #selector(withdrawalTapped))
        withdrawalsLbl.isUserInteractionEnabled = true
        withdrawalsLbl.addGestureRecognizer(withdraw)
    }
    
    @objc func yearlySummaryTapped() {
        let modal = YearlySummaryModal()
        modal.delegate = self
        YearlySummaryModal.show(grossEarning: "2000", yearAdjustment: "300", serviceFee: "200", yearTax: "200", delegate: self)
    }
    
    @objc func withdrawalTapped() {
        coordinator?.gotoHistoryView()
    }
    
    func tableAndCollectionViewSetup() {
        yearBtn.setTitle("2024", for: .normal)
        
        topEarningTableView.delegate = self
        topEarningTableView.dataSource = self
        topEarningTableView.register(UINib(nibName: "EarningDistributionTableCell", bundle: nil), forCellReuseIdentifier: "EarningDistributionTableCell")
        
        monthCollectionView.delegate = self
        monthCollectionView.dataSource = self
        monthCollectionView.register(UINib(nibName: "monthCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "monthCollectionViewCell")
    }
    
    @IBAction func editBtnTapped(_ sender: Any) {
        coordinator?.gotoCountryPaymentView()
    }
    
    
}

//MARK: - YearlyModalDelegate
extension EarningsView: YearlySummaryModalDelegate {
    func yearlySummaryModalDidTapExport(_ modal: YearlySummaryModal) {
        print("Export tapped")
    }
    
    func yearlySummaryModalDidTapDone(_ modal: YearlySummaryModal) {
        print("Tapped")
    }
}

//MARK: - Binding
extension EarningsView {
    func bind() {
        vm.transform(input: input)
        vm.output.subscribe(onNext: { [weak self] output in
            LoadingModal.dismiss()
            switch output {
            case .topEarningsSuccess(let response):
                self?.topEarningBookingData = [response]
            case .topEarningsFailure(let error):
                MiddleModal.show(title: error.message ?? "", type: .error)
            }
        }).disposed(by: disposeBag)
    }
}

// MARK: - Table Delegate
extension EarningsView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if topEarningBookingData.isEmpty {
            noInfoLabel.isHidden = false
            noInfoLabel.text = "No Information"
            topEarningTableView.isHidden = true
            return topEarningBookingData.count
        } else {
            noInfoLabel.isHidden = true
            topEarningTableView.isHidden = false
            return topEarningBookingData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EarningDistributionTableCell", for: indexPath) as! EarningDistributionTableCell
        if topEarningBookingData.isEmpty {
            cell.setup(with: nil)
        } else {
            let cellAt = topEarningBookingData[indexPath.item]
            cell.setup(with: cellAt)
        }
        return cell
    }
}

// MARK: - Collection Delegate
extension EarningsView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayOfMonths.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "monthCollectionViewCell", for: indexPath) as! monthCollectionViewCell
        let cellAt = arrayOfMonths[indexPath.item]
        cell.months.text = cellAt
        cell.updateCell(isSelected: selectedIndex == indexPath)

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        LoadingModal.show(title: "Fetching data...")
        let selectedMonth = arrayOfMonths[indexPath.item]
        getSelectedMonth = selectedMonth
        
        print("The selected month is \(getSelectedMonth)")
        
        let selectedYear = yearBtn.title(for: .normal) ?? "2024"
        let request = TopEarningRequest(year: selectedYear, month: getSelectedMonth)
        input.onNext(.topEarnings(request))
        
        selectedIndex = indexPath
        collectionView.reloadData()
    }
}

extension EarningsView: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthOfScreen: CGFloat = 700
        let heightOfScreen = collectionView.bounds.height
        return CGSize(width: widthOfScreen / CGFloat(arrayOfMonths.count), height: heightOfScreen)
    }
}
