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
    
    private var sortedDates: [String] = []
    private var withdrawalData: [String: [WithdrawalDetail]] = [:]

    var coordinator: HostingServiceEarningCoordinator?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        LoadingModal.show(title: "Loading...")
        input.onNext(.withdrawalHistory)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableSetup()
//        groupTransactions()
        bind()
//        vm.useMockData()
    }
    
    func tableSetup() {
        withdrawalTable.dataSource = self
        withdrawalTable.delegate = self
        withdrawalTable.register(UINib(nibName: "WithdrawHistoryViewCell", bundle: nil), forCellReuseIdentifier: "WithdrawHistoryViewCell")
    }
    
    private func updateWithdrawals(_ response: WithdrawalResponse) {
        guard let data = response.data else { return }
        
        withdrawalData = data
        
        // Sort dates in descending order (most recent first)
        sortedDates = data.keys.sorted { date1, date2 -> Bool in
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            
            guard let date1Obj = formatter.date(from: date1),
                  let date2Obj = formatter.date(from: date2) else {
                return false
            }
            
            return date1Obj > date2Obj
        }
        
        withdrawalTable.reloadData()
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
                self?.updateWithdrawals(response)

//                print("Response data:", response.data ?? [])
//                self?.historyData = response.data?.values.flatMap { $0 } ?? []
//                self?.historyData = response.data ?? []
//                self?.groupTransactions()
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
        return sortedDates.count

//        groupedData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return groupedData[section].transactions.count
        let dateKey = sortedDates[section]
        return withdrawalData[dateKey]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WithdrawHistoryViewCell", for: indexPath) as! WithdrawHistoryViewCell
                
                let dateKey = sortedDates[indexPath.section]
        if let transactions = withdrawalData[dateKey] {
            let transaction = transactions[indexPath.row]
            cell.setupCell(with: transaction)
            
            // Format the time if needed
            if let createdAt = transaction.createdAt {
                let inputFormatter = DateFormatter()
                inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                
                let outputFormatter = DateFormatter()
                outputFormatter.dateFormat = "hh:mm a"
                
                if let date = inputFormatter.date(from: createdAt) {
                    cell.timeLbl.text = outputFormatter.string(from: date)
                }
            }
        }
                
                
                return cell
//        let cell = tableView.dequeueReusableCell(withIdentifier: "WithdrawHistoryViewCell", for: indexPath) as! WithdrawHistoryViewCell
//        let cellData = groupedData[indexPath.section].transactions[indexPath.row]
//        cell.setupCell(with: cellData)
//        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .systemGray6
        
        let label = UILabel()
        let dateKey = sortedDates[section]
        
        // Convert date string to formatted display date
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "MMMM d"
        
        if let date = inputFormatter.date(from: dateKey) {
            label.text = outputFormatter.string(from: date)
        }
        
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        
        headerView.addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
        ])
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
