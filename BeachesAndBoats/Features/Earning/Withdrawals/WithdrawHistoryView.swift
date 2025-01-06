//
//  WithdrawHistoryView.swift
//  BeachesAndBoats
//
//  Created by Hefepa on 02/01/2025.
//

import UIKit
import RxSwift

class WithdrawHistoryView: UIViewController {

    @IBOutlet weak var withdrawalTable: UITableView!
    
    let vm = WithdrawalHistoryVM()
    let disposeBag = DisposeBag()
    let input = PublishSubject<WithdrawalHistoryVM.Input>()
    
    var historyData: [WithdrawalDetail] = []
    var groupedData: [(date: String, transactions: [WithdrawalDetail])] = []

    var coordinator: HostingServiceEarningCoordinator?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        LoadingModal.show(title: "Loading...")
//        input.onNext(.withdrawalHistory)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableSetup()
        groupTransactions()
        bind()
        vm.useMockData()
    }
    
    func tableSetup() {
        withdrawalTable.dataSource = self
        withdrawalTable.delegate = self
        withdrawalTable.register(UINib(nibName: "WithdrawHistoryViewCell", bundle: nil), forCellReuseIdentifier: "WithdrawHistoryViewCell")
    }
    
    func groupTransactions() {
        let grouped = Dictionary(grouping: historyData) { detail -> String in
            // Convert createdAt to just the date portion
            let dateStr = detail.createdAt?.split(separator: "T")[0]
            return String(dateStr ?? "")
        }
        
        groupedData = grouped.map { (date: $0.key, transactions: $0.value) }
            .sorted { $0.date > $1.date }
    }
}

//MARK: - Binding
extension WithdrawHistoryView {
    func bind() {
        vm.transform(input: input)
        vm.output.subscribe(onNext: { [weak self] output in
            LoadingModal.dismiss()
            switch output {
            case .withdrawalHistorySuccess(let response):
                print("Response data:", response.data ?? [])
                self?.historyData = response.data ?? []
                self?.groupTransactions()
                print("Grouped data:", self?.groupedData ?? [])
                self?.withdrawalTable.reloadData()
            case .withdrawalHistoryFailure(let error):
                MiddleModal.show(title: error.message ?? "", type: .error)
            }
        }).disposed(by: disposeBag)
    }
}
//MARK: - Table Delegate
extension WithdrawHistoryView: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        groupedData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupedData[section].transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WithdrawHistoryViewCell", for: indexPath) as! WithdrawHistoryViewCell
        let cellData = groupedData[indexPath.section].transactions[indexPath.row]
        cell.setupCell(with: cellData)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .back
        
        let dateLabel = UILabel()
        dateLabel.font = .systemFont(ofSize: 14, weight: .medium)
        dateLabel.textColor = .gray
        
        // Format date for header
        let dateStr = groupedData[section].date
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        
        if let date = inputFormatter.date(from: dateStr) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "MMMM d"
            dateLabel.text = outputFormatter.string(from: date)
        }
        
        headerView.addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            dateLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
        ])
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
