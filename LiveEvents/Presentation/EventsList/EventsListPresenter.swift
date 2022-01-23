//

import Foundation

protocol EventsListPresenterProtocol: PresenterProtocol, TableViewDataSource {
    func didScrollBeyondCurrentPage()
    func didSelectRow(indexPath: IndexPath)
    func didChangeSearchText(_ text: String)
    func didTapRetryOption()
}

enum EventsListViewState: Equatable {
    case clear
    case loading
    case render(viewModel: ViewModel)
    case error(message: String)

    struct ViewModel: Equatable {
        let rowsViewModels: [EventCellViewModel]
    }
}

final class EventsListPresenter: NSObject, EventsListPresenterProtocol {

    private weak var view: EventsListView?
    private var currentEnteredText: String?

    private weak var router: EventsListRouterProtocol!
    private var eventsInfoModel: EventsInfoModel?
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
        viewState = .loading
        getEvents()
    }

    private func getEvents(searchText: String? = nil,
                           page: Int = 1) {
        let params = GetEventsParams(query: searchText, page: page) { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let receivedEventsInfoModel):
                let totalReceivedEventModels = (self.eventsInfoModel?.events ?? []) + receivedEventsInfoModel.events
                self.eventsInfoModel = EventsInfoModel(events: totalReceivedEventModels,
                                                       totalEntitiesAvailable: receivedEventsInfoModel.totalEntitiesAvailable,
                                                       page: receivedEventsInfoModel.page)
                let rowViewModels = (self.eventsInfoModel?.events ?? []).map {
                    self.getCellViewModel(eventModel: $0)
                }
                let viewModel = EventsListViewState.ViewModel(rowsViewModels: rowViewModels)
                self.viewState = .render(viewModel: viewModel)
            case .failure(let useCaseError):
                var errorMessage: String
                switch useCaseError {
                case .mapping:
                    errorMessage = "Error fetching the events"
                default:
                    errorMessage = "Unable to get events list, please retry."
                }
                self.viewState = .error(message: errorMessage)
            }
        }
        self.getEventsUseCase.run(params)
    }

    func didSelectRow(indexPath: IndexPath) {
        guard let eventsInfoModel = eventsInfoModel else {
            return
        }
        let selectedEventModel = eventsInfoModel.events[indexPath.row]
        router.showEventDetails(model: selectedEventModel)
    }

    func didScrollBeyondCurrentPage() {
        guard viewState != .loading, !isAllModelsDisplayed() else { // already loading or all models availble
            return
        }
        viewState = .loading
        let nextPage = (eventsInfoModel?.page ?? 0) + 1
        getEvents(searchText: currentEnteredText, page: nextPage)
    }

    func didTapRetryOption() {
        eventsInfoModel = nil
        viewState = .loading
        getEvents()
    }

    func didChangeSearchText(_ text: String) {
        if eventsInfoModel?.page ?? 1 > 1 { // beyond first page, text changed -> reset
            eventsInfoModel = nil
            viewState = .render(viewModel: EventsListViewState.ViewModel(rowsViewModels: []))
        }
        currentEnteredText = text
        NSObject.cancelPreviousPerformRequests(withTarget: self,
                                               selector: #selector(EventsListPresenter.searchChangedText),
                                               object: nil)
        self.perform(#selector(Self.searchChangedText),
                     with: nil,
                     afterDelay: 0.5)
    }

    @objc private func searchChangedText() {
        eventsInfoModel = nil
        getEvents(searchText: currentEnteredText)
    }
    
    private func getCellViewModel(eventModel: EventModel) -> EventCellViewModel {
        return EventCellViewModel(imageURL: eventModel.imageURL,
                                  name: eventModel.title,
                                  location: eventModel.location,
                                  dateString: getDisplayDateString(date: eventModel.date))
    }

    private func isAllModelsDisplayed() -> Bool {
        let isAllModelsDisplayed = eventsInfoModel?.totalEntitiesAvailable == eventsInfoModel?.events.count
        if isAllModelsDisplayed {
            print("All available events are displayed")
        }
        return isAllModelsDisplayed
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
        eventsInfoModel?.events.count ?? 0
    }

    func viewModelForCell(at indexPath: IndexPath) -> CellViewModel? {
        guard let eventModel = eventsInfoModel?.events[indexPath.row] else {
            return nil
        }
        let cellViewModel = getCellViewModel(eventModel: eventModel)
        return cellViewModel
    }
}
