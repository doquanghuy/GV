//

//

import UIKit

class ContactListController: UITableViewController {
    
    private let viewModel = ContactsViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.getContactList(completion: {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }) { (errorMessages) in
            DispatchQueue.main.async {
                let alertController = UIAlertController(title: "Error", message: errorMessages, preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ContactListCell.reuseIdentifier, for: indexPath) as? ContactListCell

        let cellViewModel = viewModel.cellViewModel(index: indexPath.row)
        cell!.viewModel = cellViewModel
        
        return cell!
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DetailContact") as? DetailContactController
        let cellViewModel = viewModel.cellViewModel(index: indexPath.row)
        
        vc?.contactId = cellViewModel!.id
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}
