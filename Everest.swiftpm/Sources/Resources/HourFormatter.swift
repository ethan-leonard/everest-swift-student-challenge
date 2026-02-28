import Foundation

enum HourFormatter {
    private static let formatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "h:mm a"
        f.locale = Locale(identifier: "en_US_POSIX")
        return f
    }()
    
    private static let shortFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "h a"
        f.locale = Locale(identifier: "en_US_POSIX")
        return f
    }()
    
    private static let dayFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        f.locale = Locale(identifier: "en_US_POSIX")
        return f
    }()
    
    static func format(_ hour: Int, short: Bool = false) -> String {
        var components = DateComponents()
        components.hour = hour
        let date = Calendar.current.date(from: components) ?? Date()
        return short ? shortFormatter.string(from: date) : formatter.string(from: date)
    }
    
    static func todayString() -> String {
        dayFormatter.string(from: Date())
    }
}
