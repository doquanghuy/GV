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
    
    private let viewModel = ContactViewModel()
    
    var contactId = Int()
    
    let greenColor = UIColor(red:0.31, green:0.89, blue:0.76, alpha:1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createGradientLayer()
        self.navigationController?.navigationBar.tintColor = greenColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.nameLabel.showSkeleton()
        self.emailLabel.showSkeleton()
        self.profilPicImageView.showSkeleton()
        
        viewModel.getDetailContact(contactId: contactId, completion: {
            DispatchQueue.main.async {
                self.nameLabel.text = self.viewModel.fullName
                self.emailLabel.text = self.viewModel.email
                self.mobileLabel.text = self.viewModel.phoneNumber
                
                Nuke.loadImage(
                    with: self.viewModel.urlProfilPic,
                    options: ImageLoadingOptions(
                        placeholder: UIImage(named: "placeholder_photo"),
                        transition: .fadeIn(duration: 0.33)
                    ),
                    into: self.profilPicImageView
                )
                
                if (self.viewModel.favorite){
                    self.favoriteButton.setImage(UIImage(named: "favorite_button_selected"), for: UIControl.State.normal)
                }else {
                    self.favoriteButton.setImage(UIImage(named: "favorite_button"), for: UIControl.State.normal)
                }
                
                self.nameLabel.hideSkeleton()
                self.emailLabel.hideSkeleton()
                self.profilPicImageView.hideSkeleton()
            }
        }) { (errorMessages) in
            let alertController = UIAlertController(title: "Error", message: errorMessages, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func createGradientLayer() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.headerView.bounds
        gradientLayer.colors = [UIColor.white.cgColor, UIColor(red:0.31, green:0.89, blue:0.76, alpha:0.3).cgColor]
        self.headerView.layer.insertSublayer(gradientLayer, at: 0)
    }    

}
