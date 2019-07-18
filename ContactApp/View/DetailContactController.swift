//
//  DetailContactController.swift
//

import UIKit
import Nuke
import SkeletonView

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
        viewModel?.errorMessage.bind {(message) in
            guard let message = message else { return }
            DispatchQueue.main.async {
                self.presentErrorAlert(message: message)
            }
        }
        
        viewModel?.fullName.bind {(fullName) in
            self.nameLabel.text = fullName
        }
        
        viewModel?.favorite.bind {(favorite) in
            let image = favorite ? UIImage(named: "favorite_button_selected") :  UIImage(named: "favorite_button")
            self.favoriteButton.setImage(image, for: UIControl.State.normal)
        }
        
        viewModel?.urlProfilPic.bind {(imageURL) in
            guard let url = imageURL, let profileURL = URL(string: url) else { return }
            DispatchQueue.main.async {
                Nuke.loadImage(
                    with: profileURL,
                    options: ImageLoadingOptions(
                        placeholder: UIImage(named: "placeholder_photo"),
                        transition: .fadeIn(duration: 0.33)
                    ),
                    into: self.profilPicImageView
                )
            }
        }

        viewModel?.email.bind({ (email) in
            guard let email = email else { return }
            self.emailLabel.text = email
        })
        
        viewModel?.phoneNumber.bind({ (mobile) in
            guard let mobile = mobile else { return }
            self.mobileLabel.text = mobile
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

}
