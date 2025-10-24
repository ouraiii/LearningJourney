import SwiftUI

struct task2: View {
    let selectedDuration: String
    let subject: String
    
    // MARK: - State Variables
    let today = Calendar.current.component(.day, from: Date())
    let weekdaySymbols = Calendar.current.shortWeekdaySymbols
    @State private var selectedDay: Int
    @State private var status: ActivityStatus = .defaultState
    @State private var progressLog: [Int: ActivityStatus] = [:]
    @State private var currentWeekStart = 20
    @State private var currentMonthName = "October 2025"
    @State private var currentMonthShort = "OCT"
    @State private var selectedDate = Date()
    @State private var showDatePicker = false
    @State private var lockedDays: Set<Int> = []
    
    // ✅ Added for Task 3
    @State private var isGoalCompleted = false
    
    // MARK: - Initializer
    init(selectedDuration: String, subject: String) {
        self.selectedDuration = selectedDuration
        self.subject = subject
        _selectedDay = State(initialValue: Calendar.current.component(.day, from: Date()))
    }
    
    // Freeze limit based on selected duration
    var freezeLimit: Int {
        switch selectedDuration {
        case "Week": return 2
        case "Month": return 8
        case "Year": return 96
        default: return 2
        }
    }
    
    // MARK: - Computed Properties
    var daysRange: [Int] { Array(currentWeekStart...(currentWeekStart + 6)) }
    var daysLearned: Int { progressLog.values.filter { $0 == .learned }.count }
    var daysFreezed: Int { progressLog.values.filter { $0 == .freezed }.count }
    
    var freezesUsedText: String {
        "\(daysFreezed) out of \(freezeLimit) Freezes used"
    }
    
    var canFreeze: Bool { daysFreezed < freezeLimit }
    
    func updateMonthIfNeeded() {
        if currentWeekStart > 31 {
            currentMonthName = "November 2025"
            currentMonthShort = "NOV"
            currentWeekStart = 1
        } else if currentWeekStart < 1 {
            currentMonthName = "September 2025"
            currentMonthShort = "SEP"
            currentWeekStart = 25
        }
    }
    
    // ✅ Helper to check goal completion (Task 3)
    private func checkGoalCompletion() {
        var totalGoalDays = 7
        switch selectedDuration {
        case "Month": totalGoalDays = 30
        case "Year": totalGoalDays = 365
        default: break
        }

        // ✅ Count both learned + frozen days
        let totalCompleted = daysLearned + daysFreezed
        if totalCompleted >= totalGoalDays {
            isGoalCompleted = true
        }
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
                
                // MARK: Calendar + Summary
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 14) {
                        HStack {
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
                                .cornerRadius(100)
                                .padding(.horizontal)
                                .onChange(of: selectedDate) { newDate in
                                    let formatter = DateFormatter()
                                    formatter.dateFormat = "MMMM yyyy"
                                    currentMonthName = formatter.string(from: newDate)
                                    formatter.dateFormat = "MMM"
                                    currentMonthShort = formatter.string(from: newDate).uppercased()
                                    
                                    let day = Calendar.current.component(.day, from: newDate)
                                    selectedDay = day
                                    
                                    if let weekInterval = Calendar.current.dateInterval(of: .weekOfMonth, for: newDate) {
                                        let startDay = Calendar.current.component(.day, from: weekInterval.start)
                                        withAnimation {
                                            currentWeekStart = startDay
                                        }
                                    }
                                }
                        }
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 5) {
                                ForEach(daysRange.indices, id: \.self) { index in
                                    let day = daysRange[index]
                                    let weekday = Calendar.current.shortWeekdaySymbols[index % 7]
                                    
                                    VStack(spacing: 5) {
                                        Text(weekday)
                                            .font(.caption2)
                                            .foregroundColor(.gray)
                                        
                                        let dayStatus = progressLog[day]
                                        let isSelected = day == selectedDay
                                        let isToday = day == today
                                        
                                        Text("\(day)")
                                            .font(.title.bold())
                                            .foregroundColor(.white)
                                            .frame(width: 45, height: 45)
                                            .background(
                                                Circle()
                                                    .fill(
                                                        dayStatus == .learned ? Color.orange.opacity(0.35) :
                                                        dayStatus == .freezed ? Color.blue1.opacity(0.35) :
                                                        isToday ? Color.orange.opacity(0.8) :
                                                        isSelected ? Color.orange.opacity(0.5) :
                                                        Color.clear
                                                    )
                                            )
                                    }
                                    .onTapGesture {
                                        withAnimation {
                                            selectedDay = day
                                            status = progressLog[day] ?? .defaultState
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    Text("Learning \(subject)")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    HStack(spacing: 14) {
                        SummaryPill(icon: "flame.fill", title: "Days Learned", count: daysLearned, color: .orange)
                        SummaryPill(icon: "cube.fill", title: "Days Freezed", count: daysFreezed, color: .blue1)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .cornerRadius(18)
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal)
                .background(Color.gray.opacity(0.15))
                .cornerRadius(18)
                
                // MARK: - Main Button Area
                if isGoalCompleted {
                    VStack(spacing: 16) {
                        Text("👏 Well done!")
                            .font(.title3.bold())
                            .foregroundColor(.orange)
                        Text("Goal completed! Start learning again or set a new goal.")
                            .foregroundColor(.gray)
                            .font(.subheadline)
                            .multilineTextAlignment(.center)
                        
                        Button(action: {
                            progressLog.removeAll()
                            lockedDays.removeAll()
                            isGoalCompleted = false
                        }) {
                            Text("Set new learning goal")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.orange)
                                .cornerRadius(12)
                        }
                        
                        Button(action: {
                            progressLog.removeAll()
                            lockedDays.removeAll()
                            isGoalCompleted = false
                        }) {
                            Text("Set same learning goal and duration")
                                .font(.footnote)
                                .foregroundColor(.orange)
                        }
                    }
                    .padding(.horizontal)
                } else {
                    // ✅ your original buttons untouched
                    Button(action: {
                        if !lockedDays.contains(selectedDay) {
                            withAnimation(.spring()) {
                                switch status {
                                case .defaultState:
                                    status = .learned
                                    progressLog[selectedDay] = .learned
                                    lockedDays.insert(selectedDay)
                                    checkGoalCompletion()
                                case .learned:
                                    status = .freezed
                                    progressLog[selectedDay] = .freezed
                                    lockedDays.insert(selectedDay)
                                case .freezed:
                                    break
                                }
                            }
                        }
                    }) {
                        Text(status.mainButtonTitle)
                            .foregroundColor(status.mainFontColor.opacity(100))
                            .frame(width: 270, height: 270)
                            .background(
                                Circle()
                                    .fill(status.mainButtonColor.opacity(100))
                            )
                            .font(status.font)
                            .glassEffect(.clear)
                    }
                    .disabled(lockedDays.contains(selectedDay))
                    .opacity(lockedDays.contains(selectedDay) ? 0.7 : 1)
                    
                    Button(action: {
                        withAnimation {
                            if canFreeze && !lockedDays.contains(selectedDay) {
                                status = .freezed
                                progressLog[selectedDay] = .freezed
                                lockedDays.insert(selectedDay)
                                
                                // ✅ Delay ensures the state updates before checking
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    checkGoalCompletion()
                                }
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

                    
                    Text(freezesUsedText)
                        .font(.caption2)
                        .foregroundColor(.gray)
                        .disabled(lockedDays.contains(selectedDay))
                        .opacity(lockedDays.contains(selectedDay) ? 0.6 : 1)
                        .padding(.horizontal)
                }
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
            Image(systemName: icon)
                .foregroundColor(.white)
            VStack(alignment: .leading, spacing: 2) {
                Text("\(count)")
                    .font(.headline)
                    .foregroundColor(.white)
                Text(title)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
            }
        }
        .padding(.vertical)
        .padding(.horizontal, 25)
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
        case .defaultState: return .darkOrange
        case .learned: return .blackOrange.opacity(100)
        case .freezed: return .blackBlue.opacity(100)
        }
    }
    
    var mainFontColor: Color {
        switch self {
        case .defaultState: return .white
        case .learned: return .orange
        case .freezed: return .blue1
        }
    }
}

#Preview {
    task2(selectedDuration: "Week", subject: "Swift")
}
