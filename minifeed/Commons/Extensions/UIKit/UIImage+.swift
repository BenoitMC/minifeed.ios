import Foundation
import UIKit

extension UIImage {
  static func find(_ name: String) -> UIImage {
    return UIImage(named: name)!
  }
}
