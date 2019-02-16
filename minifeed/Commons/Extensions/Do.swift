import Foundation
import UIKit

protocol Do {}

extension Do {
  typealias Block = (Self) -> ()

  func `do`(_ block: Block) -> Self {
    block(self)
    return self
  }
}

extension UIView : Do {}
extension UIViewController : Do {}
