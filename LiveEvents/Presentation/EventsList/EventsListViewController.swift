//

import UIKit

protocol EventsListView: ViewProtocol {
    var presenter: EventsListPresenterProtocol! { get set }
    func changeViewState(viewState: EventsListViewState)
}

final class EventsListViewController: UIViewController, EventsListView, Alertable {
    var presenter: EventsListPresenterProtocol!

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!
    
    static var storyboardName: String {
        "EventsList"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        presenter.viewLoaded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
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
            activityIndicatorView.isHidden = false
            tableView.isUserInteractionEnabled = false
            searchBar.isUserInteractionEnabled = false
        case .render:
            activityIndicatorView.isHidden = true
            tableView.isUserInteractionEnabled = true
            searchBar.isUserInteractionEnabled = true
            tableView.reloadData()
        case .error(let message):
            activityIndicatorView.isHidden = true
            searchBar.isUserInteractionEnabled = true
            showAlert(title: "Error", actionTitle: "Retry", message: message) { [weak self] _ in
                self?.presenter.didTapRetryOption()
            }
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
        print(tableView.contentOffset.y)
        print(tableView.contentSize.height)
        print(tableView.frame.size.height)
    }
}

extension EventsListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.didChangeSearchText(searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
}
