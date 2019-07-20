//

//

import UIKit

protocol UpdateListContact: class {
    func reload(at indexPath: IndexPath)
    func reload()
}

class ContactListController: UITableViewController {
    private let viewModel = ContactsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        setupBinding()
    }
    
    private func setupViewModel() {
        viewModel.getContactList()
    }
    
    private func setupBinding() {
        viewModel.shouldReloadData.bind { (shouldReload) in
            if shouldReload {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        viewModel.errorMessage.bind { (message) in
            guard let message = message else { return }
            DispatchQueue.main.async {
                self.presentErrorAlert(message: message)
            }
        }
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
extension ContactListController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sectionNumber
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.titleForHeader(section)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSections(section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ContactListCell.reuseIdentifier, for: indexPath) as? ContactListCell
        let cellViewModel = viewModel.cellViewModel(indexPath: indexPath)
        cell?.setupViewModel(viewModel: cellViewModel)
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier:  Constant.Segue.listToDetail, sender: indexPath)
    }
}

extension ContactListController: UpdateListContact {
    func reload(at indexPath: IndexPath) {
        self.tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func reload() {
        self.tableView.reloadData()
    }
}

