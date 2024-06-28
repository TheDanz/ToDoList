import Foundation

func getDayAndMonth(from: Date) -> String {
    let calendar = Calendar.current
    let day = calendar.component(.day, from: from)
    let month = calendar.component(.month, from: from)

    let dateFormatter = DateFormatter()
    let monthName = dateFormatter.monthSymbols[month - 1]

    return "\(day) \(monthName)"
}

func getDayMonthAndYear(from: Date) -> String {
    let calendar = Calendar.current
    let day = calendar.component(.day, from: from)
    let month = calendar.component(.month, from: from)
    let year = calendar.component(.year, from: from)

    let dateFormatter = DateFormatter()
    let monthName = dateFormatter.monthSymbols[month - 1]

    return "\(day) \(monthName) \(year)"
}
