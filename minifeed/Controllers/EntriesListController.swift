import Foundation
import UIKit
import SwifterSwift

class EntriesListController: Controller, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
  @IBOutlet weak var searchBar : UISearchBar!
  @IBOutlet weak var tableView : UITableView!
  @IBOutlet weak var types     : UISegmentedControl!

  var categoryName: String?

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.dataSource = self
    tableView.delegate   = self
    tableView.addSubview(refreshControl)
    searchBar.delegate = self

    i18n()
    hideSearchBar()
    updateViews()

    repository.onChange = { [weak self] in
      self?.updateViews()
      Flash.close()
    }

    reloadData()
  }

  func i18n() {
    searchBar.placeholder = t("entries_list.search.placeholder")
  }

  func hideSearchBar() {
    tableView.contentOffset = CGPoint(x: 0.0, y: searchBar.height)
  }

  func updateViews() {
    tableView.reloadData()

    types.segmentTitles = EntryFilterTypes.allCases.map { t("entry_filter_types.\($0.rawValue)") }
    types.selectedSegmentIndex = EntryFilterTypes.allCases.index(of: repository.type)!
  }

  @objc func reloadData() {
    refreshControl.endRefreshing()
    Flash.progress()
    repository.get().onError(showErrorIfNeeded).perform()
  }

  func markAllAsRead() {
    Flash.progress()
    repository.markAllAsRead().onError(showErrorIfNeeded).onSuccess { _ in
      HomeController.instance?.reloadDataSilently()
    }.perform()
  }

  lazy var refreshControl : UIRefreshControl = {
    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(reloadData), for: .valueChanged)
    return refreshControl
  }()

  let repository = EntriesRepository()

  @IBAction func onTypeChange() {
    if types.selectedSegmentIndex == 0 { repository.type = .all     }
    if types.selectedSegmentIndex == 1 { repository.type = .unread  }
    if types.selectedSegmentIndex == 2 { repository.type = .starred }

    reloadData()
  }

  @IBAction func tapOnMarkAllAsRead(_ sender: Any) {
    confirm(t("entries_list.mark_all_as_read.confirm")) { [weak self] in
      self?.markAllAsRead()
    }
  }

  func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
    return repository.entries.count
  }

  func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeue(EntryCell.self)
    cell.setup(repository.entries[indexPath.row])
    return cell
  }

  func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselect(indexPath)
    let controller = instantiate(EntryMainController.self)
    controller.entriesListController = self
    controller.showEntryAtIndex(indexPath.row)
    controller.title = categoryName
    showSplitViewDetail(controller)
  }

  var searchTimer = Timer()

  func searchBar(_: UISearchBar, textDidChange q: String) {
    searchTimer.invalidate()

    searchTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [weak self] _ in
      self?.repository.q = q
      self?.reloadData()
    }
  }

  func scrollViewDidScroll(_: UIScrollView) {
    hideKeyboad()
  }
}

class EntryCell : UITableViewCell {
  @IBOutlet weak var unreadIndicator : UIView!
  @IBOutlet weak var label           : UILabel!
  @IBOutlet weak var infos           : UILabel!

  func setup(_ entry: Entry) {
    unreadIndicator.isHidden = entry.isRead!

    label.text = entry.name
    infos.text = entry.infos
  }
}
