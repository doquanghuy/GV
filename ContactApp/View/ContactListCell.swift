//

//

import UIKit
import Foundation
import Nuke

class ContactListCell: UITableViewCell {
    @IBOutlet weak var profilPicImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    public static let reuseIdentifier = Constant.TableViewCell.listCell
    private var viewModel: ContactCellViewModel? {
        didSet {
            self.bindingData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profilPicImageView.layer.cornerRadius = profilPicImageView.bounds.width / 2
    }
    
    public func setupViewModel(viewModel: ContactCellViewModel?) {
        self.viewModel = viewModel
        self.viewModel?.reloadData()
    }
    
    private func bindingData() {
        viewModel?.fullName.bind {[weak self](fullName) in
            self?.nameLabel.text = fullName
        }
        
        viewModel?.favorite.bind {[weak self] (favorite) in
            self?.favoriteButton.isHidden = !favorite
        }
        
        viewModel?.urlProfilPic.bind {[weak self](imageURL) in
            guard let this = self, let url = imageURL, let profileURL = URL(string: url) else { return }
            Nuke.loadImage(
                with: profileURL,
                options: ImageLoadingOptions(
                    placeholder: UIImage(named: Constant.Image.placeHolder),
                    transition: .fadeIn(duration: 0.33)
                ),
                into: this.profilPicImageView
            )
        }
    }
}
