//

//

import UIKit

protocol UpdateListContact: class {
    func reload(at indexPath: IndexPath)
    func reload()
}

class ContactListController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    private var refreshControl = UIRefreshControl()
    private let viewModel = ContactsViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        shouldShowLoadingView()
        setupViewModel()
        setupBinding()
    }
    
    private func setupUI() {
        self.refreshControl.addTarget(self, action: #selector(reloadContactList), for: .valueChanged)
        self.tableView.addSubview(self.refreshControl)
    }
    
    private func setupViewModel() {
        viewModel.getContactList()
    }
    
    private func setupBinding() {
        viewModel.shouldReloadData.bind { _ in
            DispatchQueue.main.async {
                self.hideLoadingView()
                self.refreshControl.endRefreshing()
                self.tableView.reloadData()
            }
        }
        viewModel.errorMessage.bind { (message) in
            self.hideLoadingView()
            self.refreshControl.endRefreshing()
            guard let message = message else { return }
            DispatchQueue.main.async {
                self.presentErrorAlert(message: message)
            }
        }
    }
    
    private func shouldShowLoadingView() {
        if viewModel.loadDbStatus() {
            hideLoadingView()
        }
    }
    
    private func hideLoadingView() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.2, animations: {
                self.loadingView.alpha = 0
            }) { (_) in
                self.loadingView.isHidden = true
            }
        }
    }
    
    @objc private func reloadContactList() {
        viewModel.getContactList()
    }
    
    private func presentErrorAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constant.Segue.listToAdd {
            let desVC = segue.destination as? AddContactViewController
            desVC?.delegate = self
        } else if segue.identifier == Constant.Segue.listToDetail {
            let desVC = segue.destination as? DetailContactController
            desVC?.viewModel = viewModel.contactViewModel(indexPath: sender as! IndexPath)
            desVC?.delegate = self
        }
    }
    
    // MARK: - IBAction
    @IBAction func addContactButtonClick(_ sender: Any) {
        self.performSegue(withIdentifier:  Constant.Segue.listToAdd, sender: nil)
    }
}

// MARK: - Table view data source
extension ContactListController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sectionNumber()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.titleForHeader(section)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSections(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ContactListCell.reuseIdentifier, for: indexPath) as? ContactListCell
        cell?.accessibilityIdentifier = "ContactCell_\(indexPath.section)_\(indexPath.row)"
        let cellViewModel = viewModel.cellViewModel(indexPath: indexPath)
        cell?.setupViewModel(viewModel: cellViewModel)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier:  Constant.Segue.listToDetail, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return index
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return self.viewModel.sectionIndexTitles()
    }
}

extension ContactListController: UpdateListContact {
    func reload(at indexPath: IndexPath) {
        self.tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func reload() {
        self.viewModel.resetSections()
        self.tableView.reloadData()
    }
}

