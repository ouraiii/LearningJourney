import SwiftUI

struct task2: View {
    let selectedDuration: String
    let subject: String
    
    // MARK: - State Variables
    let todayDate = Date()
    let weekdaySymbols = Calendar.current.shortWeekdaySymbols
    @State private var selectedDay: Int
    @State private var status: ActivityStatus = .defaultState
    @State private var progressLog: [String: ActivityStatus] = [:] // ✅ full date key
    @State private var currentWeekStart = 20
    @State private var currentMonth = 10
    @State private var currentYear = 2025
    @State private var currentMonthName = "October 2025"
    @State private var currentMonthShort = "OCT"
    @State private var selectedDate = Date()
    @State private var showDatePicker = false
    @State private var lockedDays: Set<String> = [] // ✅ full date key
    
    // MARK: - Initializer
    init(selectedDuration: String, subject: String) {
        self.selectedDuration = selectedDuration
        self.subject = subject
        _selectedDay = State(initialValue: Calendar.current.component(.day, from: Date()))
    }
    
    // MARK: - Helpers
    func key(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    func date(for day: Int) -> Date? {
        var components = DateComponents()
        components.year = currentYear
        components.month = currentMonth
        components.day = day
        return Calendar.current.date(from: components)
    }
    
    func updateMonthIfNeeded() {
        if currentWeekStart > 31 {
            currentMonth += 1
            if currentMonth > 12 {
                currentMonth = 1
                currentYear += 1
            }
            currentMonthName = monthName(for: currentMonth, year: currentYear)
            currentMonthShort = shortMonth(for: currentMonth)
            currentWeekStart = 1
        } else if currentWeekStart < 1 {
            currentMonth -= 1
            if currentMonth < 1 {
                currentMonth = 12
                currentYear -= 1
            }
            currentMonthName = monthName(for: currentMonth, year: currentYear)
            currentMonthShort = shortMonth(for: currentMonth)
            currentWeekStart = 25
        }
    }
    
    func monthName(for month: Int, year: Int) -> String {
        let dateFormatter = DateFormatter()
        let dateComponents = DateComponents(year: year, month: month)
        let date = Calendar.current.date(from: dateComponents)!
        dateFormatter.dateFormat = "MMMM yyyy"
        return dateFormatter.string(from: date)
    }
    
    func shortMonth(for month: Int) -> String {
        let dateFormatter = DateFormatter()
        let dateComponents = DateComponents(year: currentYear, month: month)
        let date = Calendar.current.date(from: dateComponents)!
        dateFormatter.dateFormat = "MMM"
        return dateFormatter.string(from: date).uppercased()
    }
    
    // MARK: - Computed Properties
    var daysRange: [Int] { Array(currentWeekStart...(currentWeekStart + 6)) }
    var daysLearned: Int { progressLog.values.filter { $0 == .learned }.count }
    var daysFreezed: Int { progressLog.values.filter { $0 == .freezed }.count }
    
    var freezeLimit: Int {
        switch selectedDuration {
        case "Week": return 2
        case "Month": return 8
        case "Year": return 96
        default: return 2
        }
    }
    
    var freezesUsedText: String {
        "\(daysFreezed) out of \(freezeLimit) Freezes used"
    }
    
    var canFreeze: Bool {
        daysFreezed < freezeLimit
    }
    
    // MARK: - Body
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 28) {
                
                // MARK: Header
                HStack {
                    Text("Activity")
                        .font(.largeTitle.bold())
                        .foregroundColor(.white)
                    Spacer()
                    HStack(spacing: 16) {
                        CircleButton(icon: "calendar")
                        CircleButton(icon: "pencil.and.outline")
                    }
                }
                .padding(.horizontal)
                .padding(.top, 10)
                
                // MARK: Calendar Container
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 14) {
                        HStack {
                            // Month & DatePicker Toggle
                            Button(action: {
                                withAnimation { showDatePicker.toggle() }
                            }) {
                                HStack(spacing: 4) {
                                    Text(currentMonthName)
                                        .font(.headline)
                                        .foregroundColor(.white)
                                    Image(systemName: showDatePicker ? "chevron.up" : "chevron.down")
                                        .foregroundColor(.orange)
                                        .font(.subheadline)
                                }
                            }
                            Spacer()
                            // Week navigation
                            HStack(spacing: 20) {
                                Button(action: {
                                    withAnimation { currentWeekStart -= 7; updateMonthIfNeeded() }
                                }) { Image(systemName: "chevron.left") }
                                
                                Button(action: {
                                    withAnimation { currentWeekStart += 7; updateMonthIfNeeded() }
                                }) { Image(systemName: "chevron.right") }
                            }
                            .foregroundColor(.orange)
                        }
                        
                        if showDatePicker {
                            DatePicker("", selection: $selectedDate, displayedComponents: [.date])
                                .datePickerStyle(.wheel)
                                .labelsHidden()
                                .tint(.orange)
                                .colorScheme(.dark)
                                .background(Color.black)
                                .glassEffect(.clear)
                                .cornerRadius(100)
                                .padding(.horizontal)
                                .onChange(of: selectedDate) { newDate in
                                    let components = Calendar.current.dateComponents([.year, .month, .day], from: newDate)
                                    currentYear = components.year ?? 2025
                                    currentMonth = components.month ?? 10
                                    selectedDay = components.day ?? 1
                                    
                                    let formatter = DateFormatter()
                                    formatter.dateFormat = "MMMM yyyy"
                                    currentMonthName = formatter.string(from: newDate)
                                    
                                    formatter.dateFormat = "MMM"
                                    currentMonthShort = formatter.string(from: newDate).uppercased()
                                    
                                    if let weekInterval = Calendar.current.dateInterval(of: .weekOfMonth, for: newDate) {
                                        let startDay = Calendar.current.component(.day, from: weekInterval.start)
                                        withAnimation {
                                            currentWeekStart = startDay
                                        }
                                    }
                                }
                        }
                        
                        // Horizontal Week View
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 5) {
                                ForEach(daysRange.indices, id: \.self) { index in
                                    let day = daysRange[index]
                                    let weekday = weekdaySymbols[index % 7]
                                    
                                    VStack(spacing: 5) {
                                        Text(weekday)
                                            .font(.caption2)
                                            .foregroundColor(.gray)
                                        
                                        if let date = date(for: day) {
                                            let keyValue = key(for: date)
                                            let dayStatus = progressLog[keyValue]
                                            let isSelected = Calendar.current.isDate(date, inSameDayAs: selectedDate)
                                            let isToday = Calendar.current.isDate(date, inSameDayAs: todayDate)
                                            
                                            Text("\(day)")
                                                .font(.title.bold())
                                                .foregroundColor(.white)
                                                .frame(width: 45, height: 45)
                                                .background(
                                                    Circle().fill(
                                                        dayStatus == .learned ? Color.orange.opacity(0.35) :
                                                        dayStatus == .freezed ? Color.blue1.opacity(0.35) :
                                                        isToday ? Color.orange.opacity(0.8) :
                                                        isSelected ? Color.orange.opacity(0.5) :
                                                        Color.clear
                                                    )
                                                )
                                                .onTapGesture {
                                                    withAnimation {
                                                        selectedDate = date
                                                        selectedDay = day
                                                        status = progressLog[keyValue] ?? .defaultState
                                                    }
                                                }
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    // MARK: Learning Summary
                    Text("Learning \(subject)")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    HStack(spacing: 14) {
                        SummaryPill(icon: "flame.fill", title: "Days Learned", count: daysLearned, color: Color.orange)
                        SummaryPill(icon: "cube.fill", title: "Days Freezed", count: daysFreezed, color: Color.blue1)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .cornerRadius(18)
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal)
                .background(Color.gray.opacity(0.15))
                .cornerRadius(18)
                
                // MARK: Main Action Button
                Button(action: {
                    let selectedKey = key(for: selectedDate)
                    if !lockedDays.contains(selectedKey) {
                        withAnimation(.spring()) {
                            switch status {
                            case .defaultState:
                                status = .learned
                                progressLog[selectedKey] = .learned
                                lockedDays.insert(selectedKey)
                            case .learned:
                                status = .freezed
                                progressLog[selectedKey] = .freezed
                                lockedDays.insert(selectedKey)
                            case .freezed:
                                break
                            }
                        }
                    }
                }) {
                    Text(status.mainButtonTitle)
                        .foregroundColor(status.mainFontColor)
                        .frame(width: 270, height: 270)
                        .background(Circle().fill(status.mainButtonColor))
                        .glassEffect(.clear)
                        .font(status.font)
                }
                .disabled(lockedDays.contains(key(for: selectedDate)))
                .opacity(lockedDays.contains(key(for: selectedDate)) ? 0.7 : 1)
                
                // MARK: Log as Freezed
                Button(action: {
                    let selectedKey = key(for: selectedDate)
                    withAnimation {
                        if canFreeze && !lockedDays.contains(selectedKey) {
                            status = .freezed
                            progressLog[selectedKey] = .freezed
                            lockedDays.insert(selectedKey)
                        }
                    }
                }) {
                    Text(canFreeze ? "Log as Freezed" : "No Freezes Left")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .foregroundColor(.white)
                        .cornerRadius(50)
                        .glassEffect(.clear.tint(Color.blue1.opacity(0.6)))
                }
                .disabled(lockedDays.contains(key(for: selectedDate)))
                .opacity(lockedDays.contains(key(for: selectedDate)) ? 0.6 : 1)
                .padding(.horizontal)
                
                Text(freezesUsedText)
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
        }
    }
}

// MARK: - Supporting Components
struct CircleButton: View {
    var icon: String
    var body: some View {
        Circle()
            .fill(Color(white: 0.15))
            .frame(width: 36, height: 36)
            .overlay(Image(systemName: icon).foregroundColor(.white))
    }
}

struct SummaryPill: View {
    var icon: String
    var title: String
    var count: Int
    var color: Color
    var body: some View {
        HStack(spacing: 13) {
            Image(systemName: icon).foregroundColor(.white)
            VStack(alignment: .leading, spacing: 2) {
                Text("\(count)").font(.headline).foregroundColor(.white)
                Text(title).font(.caption).foregroundColor(.white.opacity(0.8))
            }
        }
        .padding(.vertical)
        .padding(.horizontal,25)
        .cornerRadius(34)
        .glassEffect(.clear.tint(color.opacity(0.6)))
    }
}

enum ActivityStatus {
    case defaultState, learned, freezed
    
    var mainButtonTitle: String {
        switch self {
        case .defaultState: return "Log as       Learned"
        case .learned: return "Learned            Today"
        case .freezed: return "Day               Freezed"
        }
    }
    
    var font: Font { .largeTitle.bold() }
    
    var mainButtonColor: Color {
        switch self {
        case .defaultState: return Color.darkOrange
        case .learned: return Color.blackOrange
        case .freezed: return Color.blackBlue
        }
    }
    
    var mainFontColor: Color {
        switch self {
        case .defaultState: return .white
        case .learned: return .orange.opacity(100)
        case .freezed: return .blue1.opacity(100)
        }
    }
}

#Preview {
    task2(selectedDuration: "Week", subject: "Swift")
}
