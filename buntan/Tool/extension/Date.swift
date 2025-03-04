import Foundation

extension Date {
    
    var beforeSevenDays: Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .day, value: -7, to: self)!
    }
    
    var afterSevenDays: Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .day, value: 7, to: self)!
    }
    
    /// 直近の日曜日を返す
    var previousSunday: Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day, .weekday], from: self)
        
        guard let weekday = components.weekday else { return Date() }
        
        components.day! -= (weekday - 1)
        
        return calendar.date(from: components)!
    }
    
    var monthDayString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd"
        return dateFormatter.string(from: self)
    }
}
