import Foundation

public class iCal {

    public static func loadFile(path: String) throws -> [Calendar] {
        guard let data = NSData(contentsOfFile: path) else { throw iCalError.FileNotFound }
        guard let string = String(data: data, encoding: NSUTF8StringEncoding) else { throw iCalError.Encoding }

        let icsContent = string.splitNewlines()

        return parse(icsContent)
    }

    public static func loadString(string: String) -> [Calendar] {
        let icsContent = string.splitNewlines()

        return parse(icsContent)
    }

    public static func loadURL(url: NSURL) throws -> [Calendar] {
        guard let data = NSData(contentsOfURL: url) else { throw iCalError.FileNotFound }
        guard let string = String(data: data, encoding: NSUTF8StringEncoding) else { throw iCalError.Encoding }

        let icsContent = string.splitNewlines()

        return parse(icsContent)
    }

    private static func parse(icsContent: [String]) -> [Calendar] {
        let parser = Parser(icsContent)
        do {
            return try parser.read()
        } catch let error {
            print(error)
            return []
        }
    }

    // Convenience and Util functions

    public static func dateFromString(string: String) -> NSDate? {
        return iCal.dateFormatter.dateFromString(string)
    }

    public static func stringFromDate(date: NSDate) -> String {
        return iCal.dateFormatter.stringFromDate(date)
    }

    static let dateFormatter: NSDateFormatter = {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd'T'HHmmss'Z'"
        return dateFormatter
    }()
}
