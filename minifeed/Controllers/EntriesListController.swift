import Foundation
import UIKit
import SwifterSwift
import SnapKit

class EntriesListController: Controller, UITableViewDelegate, UITableViewDataSource {
  var categoryName: String?

  init() {
    super.init(nibName: nil, bundle: nil)

    tableView.dataSource      = self
    tableView.delegate        = self
    searchBar.delegate        = self
    searchController.delegate = self

    makeViews()
    makeConstraints()
    makeBindings()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError()
  }

  private var tableView      = UITableView()
  private var typesSegments  = UISegmentedControl(items: EntryFilterTypes.names)
  private var refreshControl = UIRefreshControl()

  private var markAllAsReadButton = UIBarButtonItem(
    image: UIImage.find("mark-all-as-read"),
    style: .plain,
    target: self,
    action: #selector(tapOnMarkAllAsRead)
  )

  private var searchController = UISearchController(searchResultsController: nil).do {
    $0.hidesNavigationBarDuringPresentation = false
    $0.dimsBackgroundDuringPresentation = false
  }

  private var searchBar : UISearchBar { return searchController.searchBar }

  private func makeViews() {
    view.addSubview(tableView)
    navigationItem.titleView = typesSegments
    navigationItem.rightBarButtonItem = markAllAsReadButton
    tableView.addSubview(refreshControl)
    navigationItem.searchController = searchController
    navigationItem.hidesSearchBarWhenScrolling = true
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

    repository.onChange = { [weak self] in
      self?.updateViews()
      Flash.close()
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    updateViews()
  }

  func updateViews() {
    if repository.entries.isEmpty {
      tableView.tableFooterView = NoEntryCell().do { $0.height = tableView.height }
    } else {
      tableView.tableFooterView = nil
    }

    tableView.reloadData()

    tableView.separatorInset = UIEdgeInsets(inset: 28)

    typesSegments.selectedSegmentIndex = EntryFilterTypes.allCases.index(of: repository.type)!
  }

  @objc
  func reloadData() {
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

  let repository = EntriesRepository()

  @objc
  func onTypeChange() {
    if typesSegments.selectedSegmentIndex == 0 { repository.type = .all     }
    if typesSegments.selectedSegmentIndex == 1 { repository.type = .unread  }
    if typesSegments.selectedSegmentIndex == 2 { repository.type = .starred }

    reloadData()
  }

  @objc
  private func tapOnMarkAllAsRead() {
    confirm(t("entries_list.mark_all_as_read.confirm")) { [weak self] in
      self?.markAllAsRead()
    }
  }

  func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
    return repository.entries.count
  }

  func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = EntryCell()
    cell.setup(repository.entries[indexPath.row])
    return cell
  }

  func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselect(indexPath)
    let controller = EntryMainController()
    controller.entriesListController = self
    controller.showEntryAtIndex(indexPath.row)
    controller.title = categoryName
    showSplitViewDetail(controller)
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

  required init?(coder aDecoder: NSCoder) {
    fatalError()
  }

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

  required init?(coder aDecoder: NSCoder) {
    fatalError()
  }

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
