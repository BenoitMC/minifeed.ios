import Foundation
import UIKit
import SnapKit
import SwifterSwift
import RxSwift

class FeedsListController : Controller {
  var category: Category

  init(category: Category) {
    self.category = category

    super.init()

    tableView.dataSource = self
    tableView.delegate   = self

    makeViews()
    makeConstraints()
    makeBindings()
  }

  required init?(coder: NSCoder) { fatalError() }

  private let tableView = UITableView()

  private func makeViews() {
    view.addSubview(tableView)
  }

  private func makeConstraints() {
    tableView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }

  private func makeBindings() {
    NavRepository.instance.navObservable.subscribe(onNext: updateCategoryFromNav).disposed(by: disposeBag)
  }

  private func updateViews() {
    navigationItem.title = category.name
    tableView.reloadData()
  }

  private func updateCategoryFromNav(_ nav: Nav) {
    if let updatedCategory = nav.categories.first(where: {$0.id == category.id}) {
      category = updatedCategory
      updateViews()
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
    controller.repository.type = feed.counter == 0 ? .all : .unread
    controller.loadData()

    pushToNav(controller)
  }
}

class FeedCell : UITableViewCell {
  init(feed: Feed) {
    super.init(style: .value1, reuseIdentifier: "FeedCell")

    accessoryType = .disclosureIndicator

    imageView!.image = UIImage.find("nav-feed").filled(withColor: UIColor.iosBlue)

    textLabel!.do {
      $0.font = $0.font.withSize(17)
      $0.text = feed.name
    }

    detailTextLabel!.do {
      $0.font = $0.font.withSize(17)
      $0.text = String(feed.counter)
      $0.isHidden = (feed.counter == 0)
    }
  }

  required init?(coder: NSCoder) { fatalError() }
}
