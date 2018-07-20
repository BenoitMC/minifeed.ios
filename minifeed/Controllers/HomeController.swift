import Foundation
import UIKit
import SwifterSwift

class HomeController : Controller, UITableViewDelegate, UITableViewDataSource {
  @IBOutlet weak var tableView: UITableView!

  static var instance : HomeController?

  override func viewDidLoad() {
    super.viewDidLoad()
    HomeController.instance = self
    tableView.dataSource = self
    tableView.delegate   = self
    tableView.addSubview(refreshControl)
    reloadData()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    (splitViewController as! MasterController).hideDetailController()
  }

  func updateViews() {
    tableView.reloadData()
  }

  var repository = NavRepository()

  @objc func reloadData() {
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

  lazy var refreshControl : UIRefreshControl = {
    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(reloadData), for: .valueChanged)
    return refreshControl
  }()

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
    let cell = tableView.dequeue(NavItemCell.self)

    switch section {
    case .special    : cell.setup(repository.nav!.specialCategories[indexPath.row])
    case .categories : cell.setup(repository.nav!.categories[indexPath.row])
    }

    return cell
  }

  func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselect(indexPath)
    let section = Sections(rawValue: indexPath.section)!
    let controller = instantiate(EntriesListController.self)


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

    pushToNav(controller)
  }

  @IBAction func clickOnSignout(_ sender: Any) {
    confirm(t("signout.confirm")) {
      (self.splitViewController as! MasterController).signout()
    }
  }
}

class NavItemCell : UITableViewCell {
  @IBOutlet weak var icon    : UIImageView!
  @IBOutlet weak var label   : UILabel!
  @IBOutlet weak var counter : UILabel!

  func setup(_ item: Category) {
    icon.image   = UIImage.find("folder").filled(withColor: UIColor.iosBlue)

    setup(item.name, item.counter)
  }

  func setup(_ item: Nav.SpecialCategory) {
    if item.type == .unread  { icon.image = UIImage.find("list") }
    if item.type == .starred { icon.image = UIImage.find("starred") }

    setup(item.name, item.counter)
  }

  func setup(_ name: String?, _ counter: Int) {
    icon.image = icon.image?.filled(withColor: UIColor.iosBlue)

    self.label.text       = name
    self.counter.text     = String(counter)
    self.counter.isHidden = (counter == 0)
  }
}
