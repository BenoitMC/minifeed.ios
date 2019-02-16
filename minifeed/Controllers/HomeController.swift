import Foundation
import UIKit
import SnapKit
import SwifterSwift

class HomeController : Controller, UITableViewDelegate, UITableViewDataSource {
  static var instance : HomeController?

  override init() {
    super.init()

    HomeController.instance = self
    tableView.dataSource = self
    tableView.delegate   = self

    makeViews()
    makeConstraints()
    makeBindings()
  }

  required init?(coder: NSCoder) { fatalError() }

  private let tableView = UITableView(style: .grouped)
  private let refreshControl = UIRefreshControl()
  private let signOutButton = UIBarButtonItem(image: UIImage.find("signout"))

  private func makeViews() {
    navigationItem.title = t("app_name")
    navigationItem.rightBarButtonItem = signOutButton

    view.addSubview(tableView)
    tableView.addSubview(refreshControl)
  }

  private func makeConstraints() {
    tableView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }

  private func makeBindings() {
    signOutButton.addTargetForAction(self, action: #selector(tapOnSignout))
    refreshControl.addTarget(self, action: #selector(reloadData), for: .valueChanged)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    (splitViewController as! MasterController).hideDetailControllerIfNeeded()
  }

  func updateViews() {
    tableView.reloadData()
  }

  private let repository = NavRepository()

  @objc
  func reloadData() {
    guard isSignedIn else { return }

    refreshControl.endRefreshing()
    Flash.progress()

    repository.onChange { [weak self] in
      self?.updateViews()
      Flash.close()
    }.request().onError(showErrorIfNeeded).perform()
  }

  func reloadDataSilently() {
    guard isSignedIn else { return }

    repository.onChange { [weak self] in
      self?.updateViews()
    }.request().onError(showErrorIfNeeded).perform()
  }

  @objc
  private func tapOnSignout() {
    confirm(t("signout.confirm")) {
      (self.splitViewController as! MasterController).signout()
    }
  }

  enum Sections : Int {
    case special, categories
  }

  func numberOfSections(in _ : UITableView) -> Int {
    guard repository.nav != nil else { return 0 }
    return 2
  }

  func tableView(_: UITableView, numberOfRowsInSection sectionIndex: Int) -> Int {
    guard let nav = repository.nav else { return 0 }
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
    case .special    : cell.setup(repository.nav!.specialCategories[indexPath.row])
    case .categories : cell.setup(repository.nav!.categories[indexPath.row])
    }

    return cell
  }

  func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselect(indexPath)
    let section = Sections(rawValue: indexPath.section)!
    let controller = EntriesListController()


    switch section {
    case .special:
      let item = repository.nav!.specialCategories[indexPath.row]
      controller.repository.type = item.type
      controller.categoryName = item.name
    case .categories:
      let item = repository.nav!.categories[indexPath.row]
      controller.repository.categoryId = item .id
      controller.categoryName = item.name
    }

    controller.reloadData()

    pushToNav(controller)
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
    imageView!.image = image?.filled(withColor: UIColor.iosBlue)

    self.textLabel!.text           = name
    self.detailTextLabel!.text     = String(counter)
    self.detailTextLabel!.isHidden = (counter == 0)
  }
}
