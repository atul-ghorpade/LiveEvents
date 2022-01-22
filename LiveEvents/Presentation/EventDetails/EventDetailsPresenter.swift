import Foundation

protocol EventDetailsPresenterProtocol: PresenterProtocol {
}

enum EventDetailsViewState: Equatable {
    case clear
    case render(viewModel: ViewModel)

    struct ViewModel: Equatable {
        let name: String
        let address: String
        let status: String
    }
}

final class EventDetailsPresenter: EventDetailsPresenterProtocol {
    private weak var view: EventDetailsView?
    private weak var router: EventDetailsRouterProtocol!
    private var eventModel: EventModel!

    private var viewState: EventDetailsViewState = .clear {
        didSet {
            guard oldValue != viewState else {
                return
            }
            view?.changeViewState(viewState: viewState)
        }
    }

    init(view: EventDetailsView?,
         router: EventDetailsRouterProtocol,
         eventModel: EventModel) {
        self.view = view
        self.router = router
        self.eventModel = eventModel
    }

    func viewLoaded() {
        calculateViewState()
    }

    private func calculateViewState() {
        let viewModel = EventDetailsViewState.ViewModel(name: "eventModel.",
                                                             address: "Not Available",
                                                             status: "Not Available")
        viewState = .render(viewModel: viewModel)
    }
}

