import Foundation
import CocoaLumberjack

struct LogPrefix {
    static let debug = "[DEBUG]: "
    static let function = "[FUNCTION]: "
    static let warning = "[WARNING]: "
    static let error = "[ERROR]: "
}

class Log {
  class func initializeLogging() {
    DDLog.add(DDOSLogger.sharedInstance)
    Log.thisFunction()
  }
  
  class func functionName(file: String, functionName: String, line: Int) -> String {
    let fileName = file.components(separatedBy: "/").last!.components(separatedBy: ".").first!
    return "\(fileName).\(functionName)[\(line)]"
  }
  
  class func debug(_ object:Any?) {
    let value = object != nil ? object : ""
    DDLogDebug("\(LogPrefix.debug)\(value!)\n")
  }
  
  class func thisFunction(file: String = #file, functionName: String = #function, line: Int = #line) {
    let functionName = Log.functionName(file: file, functionName: functionName, line: line)
    DDLogDebug("\(LogPrefix.function)\(functionName)\n")
  }
  
  class func warning(_ object:Any?) {
    let value = object != nil ? object : ""
    DDLogWarn("\(LogPrefix.warning)\(value!)\n")
  }
  
  class func error(_ object:Any?, file: String = #file, functionName: String = #function, line: Int = #line) {
    let value = object != nil ? object : ""
    let functionName = Log.functionName(file: file, functionName: functionName, line: line)
    DDLogError("\(LogPrefix.error)\(functionName): \(value!)\n")
  }
}
