//

//

import UIKit
import Nuke

class ContactListCell: UITableViewCell {
    
    @IBOutlet weak var profilPicImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    public static let reuseIdentifier = "ContactCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profilPicImageView.layer.cornerRadius = profilPicImageView.bounds.width/2
    }
    
    public var viewModel: ContactViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            
            nameLabel.text = viewModel.fullName
            favoriteButton.isHidden = !viewModel.favorite
            
            Nuke.loadImage(
                with: viewModel.urlProfilPic,
                options: ImageLoadingOptions(
                    placeholder: UIImage(named: "placeholder_photo"),
                    transition: .fadeIn(duration: 0.33)
                ),
                into: profilPicImageView
            )
        }
    }
    
}
