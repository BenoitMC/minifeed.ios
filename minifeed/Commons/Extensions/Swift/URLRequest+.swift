import Foundation

extension URLRequest {
  var httpBodyString : String? {
    guard let stream = httpBodyStream else { return nil }

    var data = Data()
    var buffer = [UInt8](repeating: 0, count: 4096)

    stream.open()

    var amount = 0
    repeat {
      amount = stream.read(&buffer, maxLength: buffer.count)
      if amount > 0 {
        data.append(buffer, count: amount)
      }
    } while amount > 0

    stream.close()

    return data.string
  }

  var httpBodyStringDecoded : String? {
    return httpBodyString?.urlDecoded
  }
}
