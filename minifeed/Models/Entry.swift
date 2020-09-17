import Foundation
import SwiftyJSON

class Entry : Model {
  var name             : String?
  var body             : String?
  var categoryName     : String?
  var feedName         : String?
  var isRead           : Bool?
  var isStarred        : Bool?
  var publishedAtHuman : String?
  var url              : String?

  var infos : String {
    return [
      feedName,
      publishedAtHuman,
    ].compactMap { $0 }.filter { $0.isPresent }.joined(separator: " - ")
  }

  override func loadFromJson(_ json: JSON) {
    super.loadFromJson(json)

    id               = json["id"].stringValue
    name             = json["name"].stringValue
    body             = json["body"].stringValue
    categoryName     = json["category_name"].stringValue
    feedName         = json["feed_name"].stringValue
    isRead           = json["is_read"].boolValue
    isStarred        = json["is_starred"].boolValue
    publishedAtHuman = json["published_at_human"].stringValue
    url              = json["url"].stringValue
  }

  // TODO : Move ?
  var bodyHTML : String {
    return """
    <!DOCTYPE html>
    <html>
      <head>
        <meta charset="utf-8">
        <meta name="viewport" content="initial-scale=1.0, maximum-scale=1.0" />
        <style>
          :root {
            color-scheme: light dark;
          }
          html, body {
            margin: 0;
            padding: 0;
            font-family: -apple-system;
          }
          body { margin: 12px; }
          img {
            max-width: 100%;
            height: auto !important;
            width: auto !important;
          }
          iframe {
            max-width: 100% !important;
          }
        </style>
      </head>
      <body>
        \(body ?? "")
      </body>
    </html>
    """
  }
}
