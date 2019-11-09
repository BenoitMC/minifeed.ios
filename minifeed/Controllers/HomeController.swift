import Foundation
import UIKit
import SnapKit
import SwifterSwift
import RxSwift

class HomeController : Controller {
  override init() {
    super.init()

    tableView.dataSource = self
    tableView.delegate   = self

    makeViews()
    makeConstraints()
    makeBindings()
  }

  required init?(coder: NSCoder) { fatalError() }

  private let tableView = UITableView(style: .grouped)
  private let refreshControl = UIRefreshControl()
  private let menuButton = UIBarButtonItem(image: "menu")

  private func makeViews() {
    navigationItem.title = t("app_name")
    navigationItem.leftBarButtonItem = menuButton

    view.addSubview(tableView)
    tableView.addSubview(refreshControl)
  }

  private func makeConstraints() {
    tableView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }

  private func makeBindings() {
    menuButton.addTargetForAction(self, action: #selector(tapOnMenu))
    refreshControl.addTarget(self, action: #selector(reloadData), for: .valueChanged)

    NavRepository.instance.navObservable.subscribe(onNext: { [weak self] in
      self?.nav = $0
      self?.updateViews()
      Flash.close()
    }).disposed(by: disposeBag)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    (splitViewController as! MasterController).hideDetailControllerIfNeeded()
  }

  func updateViews() {
    tableView.reloadData()
  }

  private var nav: Nav?

  @objc
  func reloadData() {
    guard isSignedIn else { return }

    refreshControl.endRefreshing()
    Flash.progress()
    NavRepository.instance.request().onError(showErrorIfNeeded).perform()
  }

  @objc
  private func tapOnMenu() {
    pushToNav(MenuController())
  }

  private func showEntries(at indexPath: IndexPath) {
    let section = Sections(rawValue: indexPath.section)!
    let controller = EntriesListController()

    switch section {
    case .special:
      let item = nav!.specialCategories[indexPath.row]
      controller.repository.type = item.type
      controller.listName = item.name
    case .categories:
      let item = nav!.categories[indexPath.row]
      controller.repository.categoryId = item.id
      controller.repository.type = item.counter == 0 ? .all : .unread
      controller.listName = item.name
    }

    controller.loadData()

    pushToNav(controller)
  }

  private func showFeeds(at indexPath: IndexPath) {
    let category = nav!.categories[indexPath.row]
    let controller = FeedsListController(category: category)
    pushToNav(controller)
  }
}

extension HomeController : UITableViewDelegate, UITableViewDataSource {
  enum Sections : Int {
    case special, categories
  }

  func numberOfSections(in _ : UITableView) -> Int {
    guard nav != nil else { return 0 }
    return 2
  }

  func tableView(_: UITableView, numberOfRowsInSection sectionIndex: Int) -> Int {
    guard let nav = nav else { return 0 }
    let section = Sections(rawValue: sectionIndex)!

    switch section {
    case .special    : return nav.specialCategories.count
    case .categories : return nav.categories.count
    }
  }

  func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let section = Sections(rawValue: indexPath.section)!
    let cell = NavItemCell()

    switch section {
    case .special    : cell.setup(nav!.specialCategories[indexPath.row])
    case .categories : cell.setup(nav!.categories[indexPath.row])
    }

    return cell
  }

  func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselect(indexPath)
    showEntries(at: indexPath)
  }

  public func tableView(_: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    guard case .categories = Sections(rawValue: indexPath.section)! else { return UISwipeActionsConfiguration() }

    let action = UIContextualAction(title: t("home.feeds")) {
      self.showFeeds(at: indexPath)
    }

    return UISwipeActionsConfiguration(actions: [action])
  }
}

class NavItemCell : UITableViewCell {
  init() {
    super.init(style: .value1, reuseIdentifier: "NavItemCell")
    accessoryType = .disclosureIndicator
    textLabel!.font = textLabel!.font.withSize(17)
    detailTextLabel!.font = detailTextLabel!.font.withSize(17)
  }

  required init?(coder: NSCoder) { fatalError() }

  func setup(_ item: Category) {
    let image = UIImage.find("nav-folder")
    setup(image, item.name, item.counter)
  }

  func setup(_ item: Nav.SpecialCategory) {
    var image: UIImage?

    if item.type == .unread  { image = UIImage.find("nav-all") }
    if item.type == .starred { image = UIImage.find("nav-starred") }

    setup(image, item.name, item.counter)
  }

  private func setup(_ image: UIImage?, _ name: String?, _ counter: Int) {
    imageView!.image = image?.filled(withColor: .iosBlue)

    self.textLabel!.text           = name
    self.detailTextLabel!.text     = String(counter)
    self.detailTextLabel!.isHidden = (counter == 0)
  }
}
