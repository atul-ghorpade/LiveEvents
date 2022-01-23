//

@testable import LiveEvents

import XCTest

class EventDetailsPresenterTests: XCTestCase {
    private var presenter: EventDetailsPresenter!
    private var viewMock: EventDetailsViewMock!
    private var routerMock: EventDetailsRouterMock!

    override func setUp() {
        super.setUp()
        viewMock = EventDetailsViewMock()
        routerMock = EventDetailsRouterMock()
    }

    func testViewStateAfterViewLoaded() {
        // Given
        presenter = EventDetailsPresenter(view: viewMock,
                                          router: routerMock,
                                          eventModel: getSampleEventModel())
        // When
        presenter.viewLoaded()

        // Then
        guard case .render(let viewModel) = viewMock.viewState else {
            return XCTFail("state is not correct")
        }
        XCTAssertEqual(viewModel.name,
                       "event title")
        XCTAssertEqual(viewModel.imageURL,
                       URL(string: "https://abc.com")!)
        XCTAssertEqual(viewModel.address,
                       "sample location")
        XCTAssertEqual(viewModel.dateString,
                       "Sunday, 23 Jan 2022 6:00 AM")
    }
}

extension EventDetailsPresenterTests {
    func getSampleEventModel() -> EventModel {
        EventModel(identifier: 123,
                   title: "event title",
                   imageURL: URL(string: "https://abc.com")!,
                   location: "sample location",
                   date: Date(fromString: "2022-01-23T06:00:00+05:30", format: .isoDateTime))
    }
}
