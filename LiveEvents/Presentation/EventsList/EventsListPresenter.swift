//

import Foundation

protocol EventsListPresenterProtocol: PresenterProtocol, TableViewDataSource {
    func didScrollBeyondCurrentPage()
    func didSelectRow(indexPath: IndexPath)
}

enum EventsListViewState: Equatable {
    case clear
    case loading
    case render(viewModel: ViewModel)

    struct ViewModel: Equatable {
        let rowsViewModels: [EventCellViewModel]
    }
}

protocol EventsListPresenterDelegate: AnyObject {
    func handleNextPageRequest()
}

final class EventsListPresenter: EventsListPresenterProtocol {

    private weak var view: EventsListView?

    private weak var router: EventsListRouterProtocol!
    private var eventModels: [EventModel]?
    private var getEventsUseCase: GetEventsUseCaseProtocol

    private var viewState: EventsListViewState = .clear {
        didSet {
            guard oldValue != viewState else {
                return
            }
            view?.changeViewState(viewState: viewState)
        }
    }

    init(view: EventsListView?,
         getEventsUseCase: GetEventsUseCaseProtocol,
         router: EventsListRouterProtocol) {
        self.view = view
        self.getEventsUseCase = getEventsUseCase
        self.router = router
    }

    func viewLoaded() {
        getEvents()
    }

    private func getEvents() {
        viewState = .loading
        let params = GetEventsParams() { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let receivedEvents):
                self.eventModels = receivedEvents
                let rowViewModels = (self.eventModels ?? []).map {
                    self.getCellViewModel(eventModel: $0)
                }
                let viewModel = EventsListViewState.ViewModel(rowsViewModels: rowViewModels)
                self.viewState = .render(viewModel: viewModel)
            case .failure(let useCaseError): break
            }
        }
        getEventsUseCase.run(params)
    }

    func didSelectRow(indexPath: IndexPath) {
        guard let eventModels = eventModels else {
            return
        }
        let selectedEventModel = eventModels[indexPath.row]
        router.showEventDetails(model: selectedEventModel)
    }

    func didScrollBeyondCurrentPage() {
        guard viewState != .loading, !isAllModelsDisplayed() else { // already loading or all models availble
            return
        }
        viewState = .loading
    }

    private func getCellViewModel(eventModel: EventModel) -> EventCellViewModel {
        return EventCellViewModel(imageURL: eventModel.imageURL,
                                  name: eventModel.title,
                                  location: eventModel.location,
                                  dateString: getDisplayDateString(date: eventModel.date))
    }

    private func isAllModelsDisplayed() -> Bool {
        return true
    }
    
    private func getDisplayDateString(date: Date?) -> String? {
        var completeDateString: String?
        if let date = date,
           let weekday = date.toString(style: .weekday),
           let dateDisplayString = date.toString(format: .custom("d MMM yyyy h:mm a")) {
            completeDateString = weekday + ", " + dateDisplayString
        }
        return completeDateString
    }
}

extension EventsListPresenter: TableViewDataSource {
    func numberOfRowsInSection(section: Int) -> Int {
        eventModels?.count ?? 0
    }

    func viewModelForCell(at indexPath: IndexPath) -> CellViewModel? {
        guard let eventModel = eventModels?[indexPath.row] else {
            return nil
        }
        let cellViewModel = getCellViewModel(eventModel: eventModel)
        return cellViewModel
    }
}
