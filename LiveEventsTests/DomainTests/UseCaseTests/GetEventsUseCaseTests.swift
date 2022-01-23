//

import XCTest

@testable import LiveEvents

class GetEventsUseCaseTests: XCTestCase {
    var useCase: GetEventsUseCase!
    let providerMock = EventsProviderMock()

    override func setUp() {
        super.setUp()
        useCase = GetEventsUseCase(provider: providerMock)
    }

    func testGetEventsSuccess() {
        let expectation = expectation(description: "Get Events success")
        providerMock.eventsListResult = .success(getSampleEventsInfoModel())
        useCase.run(GetEventsParams(query: "abc", page: 1) { result in
            if case let .success(response) = result {
                XCTAssertEqual(response.events.count, 1)
                expectation.fulfill()
            }
        })
        waitForExpectations(timeout: 1, handler: nil)
    }

    func testGetEventsFailure() {
        let expectation = expectation(description: "Get Events failure")
        let underlyingError = NSError(domain: NSURLErrorDomain, code: 0, userInfo: nil)
        providerMock.eventsListResult = .failure(.underlying(underlyingError))
        useCase.run(GetEventsParams(query: "abc", page: 1) { result in
            if case .failure = result {
                expectation.fulfill()
            }
        })
        waitForExpectations(timeout: 1, handler: nil)
    }
}

extension GetEventsUseCaseTests {
    private func getSampleEventsInfoModel() -> EventsInfoModel {
        let eventModel = EventModel(identifier: 123,
                                    title: "sample title",
                                    imageURL: URL(string: "https://abc.com")!,
                                    location: "location",
                                    date: Date())
        let eventsInfoModel = EventsInfoModel(events: [eventModel],
                                              totalEntitiesAvailable: 20,
                                              page: 2)
        return eventsInfoModel
    }
}
