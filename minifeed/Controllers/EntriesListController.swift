import Foundation
import UIKit
import SwifterSwift

class EntriesListController: Controller, UITableViewDelegate, UITableViewDataSource {
  @IBOutlet weak var tableView : UITableView!
  @IBOutlet weak var types     : UISegmentedControl!

  var categoryName: String?

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.dataSource = self
    tableView.delegate   = self
    tableView.addSubview(refreshControl)

    updateViews()
    reloadData()
  }

  func updateViews() {
    tableView.reloadData()

    types.segmentTitles = EntryFilterTypes.allCases.map { t("entry_filter_types.\($0.rawValue)") }
    types.selectedSegmentIndex = EntryFilterTypes.allCases.index(of: repository.type)!
  }

  @objc func reloadData() {
    refreshControl.endRefreshing()
    Flash.progress()
    repository.onChange { [weak self] in
      self?.updateViews()
      Flash.close()
    }.request().onError(showErrorIfNeeded).perform()
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
