import Foundation

protocol EventDetailsPresenterProtocol: PresenterProtocol {
    func backButtonPressed()
}

enum EventDetailsViewState: Equatable {
    case clear
    case render(viewModel: ViewModel)

    struct ViewModel: Equatable {
        let name: String
        let imageURL: URL?
        let dateString: String
        let address: String
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
    
    func backButtonPressed() {
        router.goBack()
    }

    private func calculateViewState() {
        let viewModel = EventDetailsViewState.ViewModel(name: eventModel.title,
                                                        imageURL: eventModel.imageURL,
                                                        dateString: getDisplayDateString(date: eventModel.date) ?? "N/A",
                                                        address: eventModel.location ?? "N/A")
        viewState = .render(viewModel: viewModel)
    }
    
    private func getDisplayDateString(date: Date?) -> String? {
        var completeDateString: String?
        if let date = eventModel.date,
           let weekday = date.toString(style: .weekday),
           let dateDisplayString = date.toString(format: .custom("d MMM yyyy h:mm a")) {
            completeDateString = weekday + ", " + dateDisplayString
        }
        return completeDateString
    }
}

