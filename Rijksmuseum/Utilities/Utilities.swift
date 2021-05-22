import Foundation

struct Utilities {
    static func classNameAsString(obj: Any) -> String {
        return String(describing: type(of: obj))
    }
}
