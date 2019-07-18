//

//

import UIKit

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
}

 // MARK: - Table view data source
extension ContactListController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ContactListCell.reuseIdentifier, for: indexPath) as? ContactListCell
        let cellViewModel = viewModel.cellViewModel(index: indexPath.row)
        cell?.setupViewModel(viewModel: cellViewModel)
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DetailContact") as? DetailContactController
        vc?.viewModel = viewModel.contactViewModel(index: indexPath.row)
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}
