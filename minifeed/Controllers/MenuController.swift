import Foundation
import UIKit

class MenuController : Controller {
  override init() {
    super.init()

    makeViews()
    makeConstraints()
    makeBindings()
  }

  required init?(coder: NSCoder) { fatalError() }

  var masterController : MasterController {
    splitViewController as! MasterController
  }

  let tableView = UITableView(style: .grouped)

  let addBookmarkCell = MenuCell().do {
    $0.imageView?.image = UIImage.find("nav-starred").filled(withColor: .iosBlue)
    $0.textLabel?.text = t("menu.add_bookmark")
  }

  let signoutCell = MenuCell().do {
    $0.imageView?.image = UIImage.find("signout").filled(withColor: .systemRed)
    $0.textLabel?.text = t("menu.sign_out")
    $0.textLabel?.textColor = .systemRed
  }

  lazy var cells = [
    [addBookmarkCell],
    [signoutCell],
  ]

  private func makeViews() {
    title = t("menu.title")

    view.addSubview(tableView)

    tableView.dataSource = self
    tableView.delegate = self
  }

  private func makeConstraints() {
    tableView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }

  private func makeBindings() {
    addBookmarkCell.action = { [weak self] in
      self?.addBookmark()
    }

    signoutCell.action = { [weak self] in
      self?.signOut()
    }
  }

  private func addBookmark() {
    let controller = AddBookmarkController.build(done: { [weak self] in
      NavRepository.instance.reload()
      self?.navigationController?.popToRoot()
    })

    present(controller)
  }

  private func signOut() {
    confirm(t("sign_out.confirm")) {
      self.masterController.signOut()
    }
  }
}

extension MenuController : UITableViewDelegate, UITableViewDataSource {
  public func numberOfSections(in tableView: UITableView) -> Int {
    cells.count
  }

  func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
    cells[section].count
  }

  func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    cells[indexPath.section][indexPath.row]
  }

  public func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselect(indexPath)
    cells[indexPath.section][indexPath.row].action?()
  }
}

class MenuCell : UITableViewCell {
  typealias Action = () -> Void

  var action: Action?
}
