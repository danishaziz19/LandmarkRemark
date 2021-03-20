//
//  SearchRemarkViewController.swift
//  LandmarkRemark
//
//  Created by Danish Aziz on 20/3/21.
//

import UIKit

protocol SearchRemarkPresenter {
    func reload()
}

enum RemarkCellType: String {
    case remarkCell = "remarkCell"
}

class SearchRemarkViewController: UIViewController, UITextFieldDelegate, SearchRemarkPresenter {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var textFieldView: UIView!
    
    lazy var viewModel: SearchViewModel = SearchViewModel(searchRemarkPresenter: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
    }
    
    // set tableview and SearchField Delegate
    func setup() {
        self.title = "Search Remarks"
        textFieldView.layer.borderWidth = 1.0
        textFieldView.layer.borderColor = UIColor.gray.cgColor
        txtSearch.delegate = self
        txtSearch.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        setupTableView()
        //setTopNavigation()
        viewModel.loadData()
    }
    
    // setup tableview and set tableview delegate
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        registerCells()
        reload()
    }
    
    // register cell for tableview
    func registerCells() {
        tableView.register(UINib (nibName: "RemarkTableViewCell", bundle: nil), forCellReuseIdentifier: RemarkCellType.remarkCell.rawValue)
    }
    
    // reload tableview
    func reload() {
        tableView.reloadData()
    }
    
    // set navigation Item
    func setTopNavigation() {
        let btnLogout = UIButton(type: .custom)
        btnLogout.setTitle("Logout", for: .normal)
        btnLogout.setTitleColor(UIColor.black, for: .normal)
        btnLogout.frame = CGRect(x: 0.0, y: 0.0, width: 30, height: 30)
        btnLogout.addTarget(self, action: #selector(logout), for: .touchUpInside)
        let menuBarItem = UIBarButtonItem(customView: btnLogout)
        self.navigationItem.rightBarButtonItem = menuBarItem
    }
    
    // textField delegate text change
    @objc
    func textFieldDidChange(_ textField: UITextField) {
        if let text = textField.text?.lowercased() {
            viewModel.filter(text: text)
        }
    }
    
    // logout from firebase
    @objc func logout() {
        let alert = UIAlertController(title: nil, message: "Are you sure you want to logout?", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Cancel".uppercased(), style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Logout".uppercased(), style: .default, handler: { (action: UIAlertAction!) in
            //AuthenticationLogicController().logout()
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // text field delegate when press return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}


// Marks :- Search Tableview delegate and DataSource

extension SearchRemarkViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getRemarksCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let remark = viewModel.getRemarks(index: indexPath.row)
        guard let cell: RemarkTableViewCell = tableView.dequeueReusableCell(withIdentifier: RemarkCellType.remarkCell.rawValue) as? RemarkTableViewCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        cell.setCell(remark: remark)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let remark = viewModel.getRemarks(index: indexPath.row)
        let alert = UIAlertController(title: remark.userName, message: remark.bodyWithDate, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
