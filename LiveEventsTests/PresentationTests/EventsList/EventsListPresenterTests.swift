//

@testable import LiveEvents

import XCTest

class EventsListPresenterTests: XCTestCase {
    private var presenter: EventsListPresenter!
    private var viewMock: EventsListViewMock!
    private var getEventsUseCaseMock: GetEventsUseCaseMock!
    private var routerMock: EventsListRouterMock!

    override func setUp() {
        super.setUp()
        viewMock = EventsListViewMock()
        getEventsUseCaseMock = GetEventsUseCaseMock()
        routerMock = EventsListRouterMock()
        presenter = EventsListPresenter(view: viewMock,
                                        getEventsUseCase: getEventsUseCaseMock,
                                        router: routerMock)

    }

    func testViewLoadedEventsViewState() {
        // Given
        let eventModel = EventModel(identifier: 123,
                                    title: "event title",
                                    imageURL: URL(string: "https://abc.com")!,
                                    location: "sample location",
                                    date: Date(fromString: "2022-01-23T06:00:00+05:30", format: .isoDateTime))
        let eventsInfoModel = EventsInfoModel(events: [eventModel],
                                              totalEntitiesAvailable: 20,
                                              page: 1)
        getEventsUseCaseMock.result = .success(eventsInfoModel)
        
        // When
        presenter.viewLoaded()
        
        // Then
        guard case .render(let viewModel) = viewMock.viewState else {
            return XCTFail("state is not correct")
        }
        XCTAssertEqual(viewModel.rowsViewModels.count, 1)
        XCTAssertEqual(viewModel.rowsViewModels.first?.name, "event title")
        XCTAssertEqual(viewModel.rowsViewModels.first?.location, "sample location")
        XCTAssertEqual(viewModel.rowsViewModels.first?.imageURL, URL(string: "https://abc.com"))
        XCTAssertEqual(viewModel.rowsViewModels.first?.dateString, "Sunday, 23 Jan 2022 6:00 AM")
    }

    func testNumberOfRowsInSection() {
        // Given
        let eventModel = EventModel(identifier: 123,
                                    title: "event title",
                                    imageURL: URL(string: "https://abc.com")!,
                                    location: "sample location",
                                    date: Date(fromString: "2022-01-23T06:00:00+05:30", format: .isoDateTime))
        let eventsInfoModel = EventsInfoModel(events: [eventModel],
                                              totalEntitiesAvailable: 20,
                                              page: 1)
        getEventsUseCaseMock.result = .success(eventsInfoModel)
        
        // When
        presenter.viewLoaded()
        let numberOfRows = presenter.numberOfRowsInSection(section: 0)

        // Then
        XCTAssertEqual(numberOfRows, 1)
    }

    func testViewModelForCell() {
        // Given
        let eventModel = EventModel(identifier: 123,
                                    title: "event title",
                                    imageURL: URL(string: "https://abc.com")!,
                                    location: "sample location",
                                    date: Date(fromString: "2022-01-23T06:00:00+05:30", format: .isoDateTime))
        let eventsInfoModel = EventsInfoModel(events: [eventModel],
                                              totalEntitiesAvailable: 20,
                                              page: 1)
        getEventsUseCaseMock.result = .success(eventsInfoModel)
        
        // When
        presenter.viewLoaded()
        let cellViewModel = presenter.viewModelForCell(at: IndexPath(row: 0, section: 0)) as?  EventCellViewModel

        // Then
        XCTAssertEqual(cellViewModel?.name, "event title")
        XCTAssertEqual(cellViewModel?.location, "sample location")
        XCTAssertEqual(cellViewModel?.imageURL, URL(string: "https://abc.com"))
        XCTAssertEqual(cellViewModel?.dateString, "Sunday, 23 Jan 2022 6:00 AM")
    }

    func testViewModelForCellForAbsenceOfValues() throws {
        // Given
        let eventModel = EventModel(identifier: 123,
                                    title: "event title",
                                    imageURL: nil,
                                    location: nil,
                                    date: nil)
        let eventsInfoModel = EventsInfoModel(events: [eventModel],
                                              totalEntitiesAvailable: 20,
                                              page: 1)
        getEventsUseCaseMock.result = .success(eventsInfoModel)
        
        // When
        presenter.viewLoaded()
        let cellViewModel = try XCTUnwrap(presenter.viewModelForCell(at: IndexPath(row: 0, section: 0)) as?  EventCellViewModel)

        // Then
        XCTAssertNil(cellViewModel.location)
        XCTAssertNil(cellViewModel.imageURL)
        XCTAssertNil(cellViewModel.dateString)
    }

    func testViewModelForError() {
        // Given
        let useCaseError = UseCaseError.generic
        getEventsUseCaseMock.result = .failure(useCaseError)

        // When
        presenter.viewLoaded()

        // Then
        XCTAssertEqual(viewMock.viewState,
                       .error(message: "Unable to get events list, please retry."))
    }
    
    func testViewModelForNextPageRequest() {
        // Given
        let eventModel = EventModel(identifier: 123,
                                    title: "event title",
                                    imageURL: URL(string: "https://abc.com")!,
                                    location: "sample location",
                                    date: Date(fromString: "2022-01-23T06:00:00+05:30", format: .isoDateTime))
        let eventsInfoModel = EventsInfoModel(events: [eventModel],
                                              totalEntitiesAvailable: 2,
                                              page: 1)
        getEventsUseCaseMock.result = .success(eventsInfoModel)
        
        // When
        presenter.viewLoaded()
        let eventModelForNextPage = EventModel(identifier: 1234,
                                               title: "another event title",
                                               imageURL: URL(string: "https://abc.com")!,
                                               location: "another sample location",
                                               date: Date(fromString: "2022-01-23T06:00:00+05:30", format: .isoDateTime))
        let eventsInfoModelForNextPage = EventsInfoModel(events: [eventModelForNextPage],
                                                         totalEntitiesAvailable: 2,
                                                         page: 2)
        getEventsUseCaseMock.result = .success(eventsInfoModelForNextPage)
        presenter.didScrollBeyondCurrentPage()
        guard case .render(let viewModel) = viewMock.viewState else {
            return XCTFail("state is not correct")
        }

        // Then
        let numberOfRows = presenter.numberOfRowsInSection(section: 0)
        XCTAssertEqual(viewModel.rowsViewModels.count, 2)
        XCTAssertEqual(numberOfRows, 2)
    }
}
