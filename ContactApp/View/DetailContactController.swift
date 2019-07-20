//
//  DetailContactController.swift
//

import UIKit
import Nuke
import MessageUI

class DetailContactController: UIViewController {
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var profilPicImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messagesButton: UIButton!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var mobileLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    var viewModel: ContactViewModel?
    weak var delegate: UpdateListContact?
    
    let greenColor = UIColor(red:0.31, green:0.89, blue:0.76, alpha:1.0)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.createGradientLayer()
        self.navigationController?.navigationBar.tintColor = greenColor
        setupBinding()
        setupViewModel()
    }
    
    private func setupViewModel() {
        viewModel?.reloadData()
        viewModel?.getDetailContact()
    }
    
    private func setupBinding() {
        viewModel?.errorMessage.bind {[weak self](message) in
            guard let message = message else { return }
            DispatchQueue.main.async {
                self?.presentErrorAlert(message: message)
            }
        }
        
        viewModel?.updateErrorMessage.bind {[weak self](message) in
            guard let message = message else { return }
            DispatchQueue.main.async {
                self?.favoriteButton.isEnabled = true
                self?.presentErrorAlert(message: message)
            }
        }
        
        viewModel?.fullName.bind {[weak self](fullName) in
            DispatchQueue.main.async {
                self?.nameLabel.text = fullName
            }
        }
        
        viewModel?.favorite.bind {[weak self](favorite) in
            DispatchQueue.main.async {
                self?.favoriteButton.isSelected = favorite
                self?.favoriteButton.isEnabled = true
            }
        }
        
        viewModel?.urlProfilPic.bind {[weak self](imageURL) in
            guard let this = self, let url = imageURL, let profileURL = URL(string: url) else { return }
            DispatchQueue.main.async {
                Nuke.loadImage(
                    with: profileURL,
                    options: ImageLoadingOptions(
                        placeholder: UIImage(named: "placeholder_photo"),
                        transition: .fadeIn(duration: 0.33)
                    ),
                    into: this.profilPicImageView
                )
            }
        }
        
        viewModel?.email.bind({[weak self] (email) in
            DispatchQueue.main.async {
                self?.emailLabel.text = email
            }
        })
        
        viewModel?.phoneNumber.bind({[weak self] (mobile) in
            DispatchQueue.main.async {
                self?.mobileLabel.text = mobile
            }
        })
        
        viewModel?.didUpdateContact.bind({[weak self] indexPath in
            DispatchQueue.main.async {
                self?.delegate?.reload(at: indexPath)
            }
        })
    }
    
    private func presentErrorAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func createGradientLayer() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.headerView.bounds
        gradientLayer.colors = [UIColor.white.cgColor, UIColor(red:0.31, green:0.89, blue:0.76, alpha:0.3).cgColor]
        self.headerView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    //MARK: -IBAction
    @IBAction func messageButtonDidClick(_ sender: Any) {
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            if let phoneNumber = viewModel?.phoneNumber.value {
                controller.recipients = [phoneNumber]
            }
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    @IBAction func callButtonDidClick(_ sender: Any) {
        guard let phoneNumber = viewModel?.phoneNumber.value, let url = URL(string: "tel://\(phoneNumber)"), UIApplication.shared.canOpenURL(url) else { return }
        if #available(iOS 10, *) {
            UIApplication.shared.open(url)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    @IBAction func emailButtonDidClick(_ sender: Any) {
        if MFMailComposeViewController.canSendMail() {
            let mailController = MFMailComposeViewController()
            mailController.mailComposeDelegate = self
            if let email = viewModel?.email.value {
                mailController.setToRecipients([email])
            }
            self.present(mailController, animated: true)
        }
    }
    
    @IBAction func favoriteButtonDidClick(_ sender: Any) {
        favoriteButton.isEnabled = false
        favoriteButton.isSelected = !favoriteButton.isSelected
        viewModel?.updateContact(favorite: favoriteButton.isSelected)
    }
    
}

extension DetailContactController: MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension DetailContactController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.dismiss(animated: true, completion: nil)
    }
}

