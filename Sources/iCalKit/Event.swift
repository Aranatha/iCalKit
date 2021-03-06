import Foundation

/// TODO add documentation
public struct Event {
    public var subComponents: [CalendarComponent] = []
    public var otherAttrs = [String:String]()

    // required
    public var uid: String!
    public var dtstamp: VDate!

    // optional
    // public var organizer: Organizer? = nil
    public var location: String?
    public var summary: String?
    public var descr: String?
    public var isCancelled = false
    // public var class: some enum type?
    public var dtstart: VDate?
    public var dtend: VDate?

    public init(uid: String? = NSUUID().uuidString, dtstamp: VDate? = VDate.fromDate(Date())) {
        self.uid = uid
        self.dtstamp = dtstamp
    }

    public init(uid: String!, dtstamp: VDate!, location: String?, summary: String?, descr: String?, isCancelled: Bool, dtstart: VDate?, dtend: VDate?) {
        self.uid = uid
        self.dtstamp = dtstamp
        self.location = location
        self.summary = summary
        self.descr = descr
        self.isCancelled = isCancelled
        self.dtstart = dtstart
        self.dtend = dtend
    }

}

extension Event: CalendarComponent {
    public func toCal() -> String {
        var str: String = "BEGIN:VEVENT\n"

        if let uid = uid {
            str += "UID:\(uid)\n"
        }
        if let dtstamp = dtstamp {
            str += "DTSTAMP:\(dtstamp.rawValue)\n"
        }
        if let summary = summary {
            str += "SUMMARY:\(summary)\n"
        }
        if let descr = descr {
            str += "DESCRIPTION:\(descr)\n"
        }
        if let location = location {
            str += "LOCATION:\(location)\n"
        }
        if isCancelled {
            str += "STATUS:CANCELLED\n"
        }
        if let dtstart = dtstart {
            str += "DTSTART:\(dtstart.rawValue)\n"
        }
        if let dtend = dtend {
            str += "DTEND:\(dtend.rawValue)\n"
        }

        for (key, val) in otherAttrs {
            str += "\(key):\(val)\n"
        }

        for component in subComponents {
            str += "\(component.toCal())\n"
        }

        str += "END:VEVENT"
        return str
    }
}

extension Event: IcsElement {
    public mutating func addAttribute(attr: String, _ value: String) {
        switch attr {
        case "UID":
            uid = value
        case "DTSTAMP":
            dtstamp = VDate(rawValue: value)
        case "DTSTART":
            dtstart = VDate(rawValue: value)
        case "DTEND":
            dtend = VDate(rawValue: value)
        // case "ORGANIZER":
        //     organizer
        case "SUMMARY":
            summary = value
        case "DESCRIPTION":
            descr = value
        case "LOCATION":
            location = value
        case "STATUS":
            if value == "CANCELLED" {
                isCancelled = true
            }
        default:
            otherAttrs[attr] = value
        }
    }
}

extension Event: Equatable { }

public func ==(lhs: Event, rhs: Event) -> Bool {
    return lhs.uid == rhs.uid
}

extension Event: CustomStringConvertible {
    public var description: String {
        //return "\(dtstamp.toString()): \(summary ?? "")"
        return "Event(uid: \(uid ?? "nil"), dtstamp: \(dtstamp.rawValue), location: \(location ?? "nil"), summary: \(summary ?? "nil"), descr: \(descr ?? "nil"), dtstart: \(dtstart?.rawValue ?? "nil"), dtend: \(dtend?.rawValue ?? "nil"), isCancelled: \(isCancelled))"
    }
}
