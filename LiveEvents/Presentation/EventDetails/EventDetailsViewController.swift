//

import UIKit

protocol EventDetailsView: ViewProtocol {
    var presenter: EventDetailsPresenterProtocol! { get set }
    func changeViewState(viewState: EventDetailsViewState)
}

final class EventDetailsViewController: UIViewController, EventDetailsView {
    var presenter: EventDetailsPresenterProtocol!

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var nameDetailLabel: UILabel!
    @IBOutlet private weak var addressDetailLabel: UILabel!
    @IBOutlet private weak var statusDetailLabel: UILabel!
    
    static var storyboardName: String {
        "EventDetails"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewLoaded()
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
        nameDetailLabel.text = viewModel.name
        addressDetailLabel.text = viewModel.address
        statusDetailLabel.text = viewModel.status
    }

    @IBAction private func startNavigationButtonPressed(_ sender: Any) {
    }
}
