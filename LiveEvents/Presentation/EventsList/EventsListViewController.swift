//

import UIKit

protocol EventsListView: ViewProtocol {
    var presenter: EventsListPresenterProtocol! { get set }
    func changeViewState(viewState: EventsListViewState)
}

final class EventsListViewController: UIViewController, EventsListView {
    var presenter: EventsListPresenterProtocol!

    @IBOutlet private weak var tableView: UITableView!
    
    static var storyboardName: String {
        "EventsList"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        presenter.viewLoaded()
    }

    private func setupViews() {
        tableView.register(UINib(nibName: String(describing: EventTableViewCell.self),
                                 bundle: nil),
                           forCellReuseIdentifier: EventTableViewCell.identifier)
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
    }

    func changeViewState(viewState: EventsListViewState) {
        switch viewState {
        case .clear:
            break
        case .loading:
            tableView.isUserInteractionEnabled = false
        case .render:
            tableView.isUserInteractionEnabled = true
            tableView.reloadData()
        }
    }
}

extension EventsListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfRowsInSection(section: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EventTableViewCell.identifier,
                                                       for: indexPath) as? EventTableViewCell ,
              let cellViewModel = presenter.viewModelForCell(at: indexPath) as? EventCellViewModel else {
            assertionFailure("Cannot dequeue reusable cell \(EventTableViewCell.self) with reuseIdentifier: \(EventTableViewCell.identifier))")
            return UITableViewCell()
        }

        cell.setup(viewModel: cellViewModel)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectRow(indexPath: indexPath)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if tableView.contentOffset.y >= (tableView.contentSize.height - tableView.frame.size.height) {
            presenter.didScrollBeyondCurrentPage()
        }
    }
}
