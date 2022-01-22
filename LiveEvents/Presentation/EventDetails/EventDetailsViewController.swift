//

import UIKit
import SDWebImage

protocol EventDetailsView: ViewProtocol {
    var presenter: EventDetailsPresenterProtocol! { get set }
    func changeViewState(viewState: EventDetailsViewState)
}

final class EventDetailsViewController: UIViewController, EventDetailsView {
    var presenter: EventDetailsPresenterProtocol!

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var locationLabel: UILabel!
    
    static var storyboardName: String {
        "EventDetails"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewLoaded()
    }
    
    @IBAction private func backButtonPressed(_ sender: Any) {
        presenter.backButtonPressed()
    }
    
    private func setUpViews() {
        imageView.layer.cornerRadius = 4.0
        imageView.layer.masksToBounds = true
    }

    func changeViewState(viewState: EventDetailsViewState) {
        switch viewState {
        case .clear:
            break
        case .render(let viewModel):
            renderViewModel(viewModel: viewModel)
        }
    }

    private func renderViewModel(viewModel: EventDetailsViewState.ViewModel) {
        imageView.sd_setImage(with: viewModel.imageURL)
        dateLabel.text = viewModel.dateString
        locationLabel.text = viewModel.address
        titleLabel.text = viewModel.name
    }
}
