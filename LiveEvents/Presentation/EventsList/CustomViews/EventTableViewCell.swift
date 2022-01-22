//

import UIKit
import SDWebImage

struct EventCellViewModel: CellViewModel, Equatable {
    let imageURL: URL?
    let name: String
    let location: String?
    let dateString: String?
}

final class EventTableViewCell: UITableViewCell {
    @IBOutlet private weak var eventImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var locationLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    
    static let identifier = String(describing: EventTableViewCell.self)

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        layoutIfNeeded()
    }

    func setup(viewModel: EventCellViewModel) {
        eventImageView.image = nil
        if let url = viewModel.imageURL {
            eventImageView.sd_setImage(with: url)
        }
        nameLabel.text = viewModel.name
        locationLabel.text = viewModel.location
        dateLabel.text = viewModel.dateString
    }
}
