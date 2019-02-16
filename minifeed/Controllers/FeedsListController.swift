import Foundation
import UIKit
import SnapKit
import SwifterSwift

class FeedsListController : Controller {
  let category: Category

  init(category: Category) {
    self.category = category

    super.init()

    tableView.dataSource = self
    tableView.delegate   = self

    makeViews()
    makeConstraints()
  }

  required init?(coder: NSCoder) { fatalError() }

  private let tableView = UITableView()

  private func makeViews() {
    view.addSubview(tableView)
    navigationItem.title = category.name
  }

  private func makeConstraints() {
    tableView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
}

extension FeedsListController : UITableViewDataSource, UITableViewDelegate {
  public func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
    return category.feeds.count
  }

  public func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    return FeedCell(feed: category.feeds[indexPath.row])
  }

  public func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselect(indexPath)
    let feed = category.feeds[indexPath.row]

    let controller = EntriesListController()
    controller.listName = feed.name
    controller.repository.feedId = feed.id
    controller.reloadData()

    pushToNav(controller)
  }
}

class FeedCell : UITableViewCell {
  init(feed: Feed) {
    super.init(style: .value1, reuseIdentifier: "FeedCell")

    accessoryType = .disclosureIndicator

    imageView!.image = UIImage.find("nav-feed").filled(withColor: UIColor.iosBlue)

    _ = textLabel!.do {
      $0.font = $0.font.withSize(17)
      $0.text = feed.name
    }

    _ = detailTextLabel!.do {
      $0.font = $0.font.withSize(17)
      $0.text = String(feed.counter)
      $0.isHidden = (feed.counter == 0)
    }
  }

  required init?(coder: NSCoder) { fatalError() }
}
