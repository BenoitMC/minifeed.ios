import Foundation
import UIKit
import SnapKit
import SwifterSwift
import RxSwift

class EntriesListController: Controller {
  var listName: String?
  var entries: [Entry] = []
  var isLastPage = false

  override init() {
    super.init()

    tableView.dataSource      = self
    tableView.delegate        = self
    searchBar.delegate        = self
    searchController.delegate = self

    makeViews()
    makeConstraints()
    makeBindings()
    showBlankView()
  }

  required init?(coder: NSCoder) { fatalError() }

  private let tableView      = UITableView()
  private let typesSegments  = UISegmentedControl(items: EntryFilterTypes.names)
  private let refreshControl = UIRefreshControl()

  private let markAllAsReadButton = UIBarButtonItem(
    image: UIImage.find("mark-all-as-read"),
    style: .plain,
    target: self,
    action: #selector(tapOnMarkAllAsRead)
  )

  private let searchController = UISearchController(searchResultsController: nil).do {
    $0.hidesNavigationBarDuringPresentation = false
    $0.obscuresBackgroundDuringPresentation = false
  }

  private var searchBar: UISearchBar { return searchController.searchBar }

  private func makeViews() {
    view.addSubview(tableView)
    navigationItem.titleView = typesSegments
    navigationItem.rightBarButtonItem = markAllAsReadButton
    tableView.addSubview(refreshControl)
    navigationItem.searchController = searchController
    navigationItem.hidesSearchBarWhenScrolling = true
    tableView.separatorInset = UIEdgeInsets(inset: 28)
    extendedLayoutIncludesOpaqueBars = true
  }

  private func makeConstraints() {
    tableView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }

  private func makeBindings() {
    refreshControl.addTarget(self, action: #selector(reloadData), for: .valueChanged)
    typesSegments.addTarget(self, action: #selector(onTypeChange), for: .valueChanged)
    markAllAsReadButton.addTargetForAction(self, action: #selector(tapOnMarkAllAsRead))

    repository.entriesObservable.subscribe(onNext: { [weak self] in
      self?.entries += $0.entries
      self?.isLastPage = $0.isLastPage
      self?.updateViews()
      Flash.close()
    }).disposed(by: disposeBag)
  }

  func updateViews() {
    if entries.isEmpty {
      tableView.tableFooterView = NoEntryCell().do { $0.height = tableView.height }
    } else {
      tableView.tableFooterView = nil
    }

    tableView.reloadData()

    typesSegments.selectedSegmentIndex = EntryFilterTypes.allCases.firstIndex(of: repository.type)!
  }

  private func showBlankView() {
    tableView.tableFooterView = UITableViewCell().do { $0.height = tableView.height }
    tableView.reloadData()
  }

  func loadData() {
    refreshControl.endRefreshing()
    Flash.progress()
    repository.get().onError(showErrorIfNeeded).perform()
  }

  @objc
  private func reloadData() {
    resetEntries()
    loadData()
  }

  private func resetEntries() {
    entries = []
    repository.page = 1
    showBlankView()
  }

  private func markAllAsRead() {
    resetEntries()
    Flash.progress()
    repository.markAllAsRead().onError(showErrorIfNeeded).onSuccess { _ in
      NavRepository.instance.reload()
    }.perform()
  }

  let repository = EntriesRepository()

  @objc
  func onTypeChange() {
    repository.type = EntryFilterTypes.allCases[typesSegments.selectedSegmentIndex]

    reloadData()
  }

  @objc
  private func tapOnMarkAllAsRead() {
    confirm(t("entries_list.mark_all_as_read.confirm")) { [weak self] in
      self?.markAllAsRead()
    }
  }
}

extension EntriesListController : UITableViewDelegate, UITableViewDataSource {
  func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
    return entries.count
  }

  func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = EntryCell()
    cell.setup(entries[indexPath.row])
    return cell
  }

  func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselect(indexPath)
    let controller = EntryMainController(entriesListController: self)
    controller.showEntryAtIndex(indexPath.row)
    controller.title = listName
    showSplitViewDetail(controller)
  }

  func tableView(_: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    if isLastPage { return }

    if indexPath.row == entries.count-1 {
      repository.page += 1
      loadData()
    }
  }
}

extension EntriesListController : UISearchBarDelegate {
  func searchBarSearchButtonClicked(_: UISearchBar) {
    repository.q = searchController.searchBar.text
    reloadData()
  }
}

extension EntriesListController : UISearchControllerDelegate {
  public func didDismissSearchController(_: UISearchController) {
    repository.q = nil
    reloadData()
  }
}

class EntryCell : UITableViewCell {
  init() {
    super.init(style: .subtitle, reuseIdentifier: "EntryCell")
    makeViews()
    makeConstraints()
  }

  required init?(coder: NSCoder) { fatalError() }

  func setup(_ entry: Entry) {
    unreadIndicator.isHidden = entry.isRead!

    textLabel!.text = entry.name
    detailTextLabel!.text = entry.infos
  }

  private let unreadIndicator = UIView().do {
    $0.backgroundColor = UIColor.iosBlue
    $0.cornerRadius = 6
  }

  private func makeViews() {
    accessoryType = .disclosureIndicator

    textLabel!.font = textLabel!.font.withSize(17)
    detailTextLabel!.font = detailTextLabel!.font.withSize(14)
    detailTextLabel!.textColor = UIColor.gray

    contentView.addSubview(unreadIndicator)
  }

  private func makeConstraints() {
    unreadIndicator.snp.makeConstraints {
      $0.size.equalTo(12)
      $0.centerY.equalTo(textLabel!.snp.centerY)
      $0.right.equalTo(textLabel!.snp.left).offset(-7)
    }
  }
}

class NoEntryCell : UITableViewCell {
  init() {
    super.init(style: .default, reuseIdentifier: nil)
    makeViews()
    makeConstraints()
  }

  required init?(coder: NSCoder) { fatalError() }

  private let label = UILabel().do {
    $0.font = $0.font.withSize(32)
    $0.textColor = .lightGray
    $0.text = t("entries_list.empty")
  }

  private func makeViews() {
    contentView.addSubview(label)
  }

  private func makeConstraints() {
    label.snp.makeConstraints {
      $0.center.equalToSuperview()
    }
  }
}
