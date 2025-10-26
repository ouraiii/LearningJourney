import SwiftUI

struct task2: View {
    @Binding var selectedDuration: String
    @Binding var subject: String

    // MARK: - State
    let calendar = Calendar.current
    @State private var selectedDate = Date()
    @State private var showDatePicker = false
    @State private var status: ActivityStatus = .defaultState
    @State private var progressLog: [Date: ActivityStatus] = [:]
    @State private var lockedDays: Set<Date> = []
    @State private var isGoalCompleted = false
    @State private var navigateToTask4 = false // ✅ navigation trigger

    // MARK: - Computed properties
    var weekDates: [Date] {
        guard let weekInterval = calendar.dateInterval(of: .weekOfMonth, for: selectedDate) else { return [] }
        let start = weekInterval.start
        return (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: start) }
    }

    var monthName: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: selectedDate)
    }

    var today: Date { calendar.startOfDay(for: Date()) }
    var selectedDay: Date { calendar.startOfDay(for: selectedDate) }

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

    var canFreeze: Bool { daysFreezed < freezeLimit }
    var freezesUsedText: String { "\(daysFreezed) out of \(freezeLimit) Freezes used" }

    // MARK: - Goal Completion
    private func checkGoalCompletion() {
        var totalGoalDays = 7
        switch selectedDuration {
        case "Month": totalGoalDays = 30
        case "Year": totalGoalDays = 365
        default: break
        }

        let totalCompleted = daysLearned + daysFreezed
        if totalCompleted >= totalGoalDays {
            isGoalCompleted = true
        }
    }

    // MARK: - Body
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 28) {
                // MARK: Header
                HStack {
                    Text("Activity")
                        .font(.largeTitle.bold())
                        .foregroundColor(.white)
                    Spacer()
                    HStack(spacing: 16) {
                        CircleButton(icon: "calendar")
                        // ✅ Navigate to task4 when tapping person icon
                        Button(action: {
                            navigateToTask4 = true
                        }) {
                            CircleButton(icon: "person.circle")
                        }
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
                                    Text(monthName)
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
                                    withAnimation {
                                        if let newDate = calendar.date(byAdding: .weekOfMonth, value: -1, to: selectedDate) {
                                            selectedDate = newDate
                                        }
                                    }
                                }) { Image(systemName: "chevron.left") }

                                Button(action: {
                                    withAnimation {
                                        if let newDate = calendar.date(byAdding: .weekOfMonth, value: 1, to: selectedDate) {
                                            selectedDate = newDate
                                        }
                                    }
                                }) { Image(systemName: "chevron.right") }
                            }
                            .foregroundColor(.orange)
                        }

                        if showDatePicker {
                            DatePicker("", selection: Binding(
                                get: { selectedDate },
                                set: { newDate in
                                    selectedDate = newDate
                                    withAnimation {
                                        showDatePicker = false
                                    }
                                }
                            ), displayedComponents: [.date])
                            .datePickerStyle(.wheel)
                            .labelsHidden()
                            .tint(.orange)
                            .colorScheme(.dark)
                            .background(Color.black)
                            .cornerRadius(16)
                            .padding(.horizontal)
                        }

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 5) {
                                ForEach(weekDates, id: \.self) { day in
                                    let weekday = calendar.shortWeekdaySymbols[calendar.component(.weekday, from: day) - 1]
                                    let isSelected = calendar.isDate(day, inSameDayAs: selectedDay)
                                    let isToday = calendar.isDate(day, inSameDayAs: today)
                                    let dayStatus = progressLog[day]

                                    VStack(spacing: 5) {
                                        Text(weekday)
                                            .font(.caption2)
                                            .foregroundColor(.gray)
                                        Text("\(calendar.component(.day, from: day))")
                                            .font(.title.bold())
                                            .foregroundColor(.white)
                                            .frame(width: 45, height: 45)
                                            .background(
                                                Circle()
                                                    .fill(
                                                        dayStatus == .learned ? Color.orange.opacity(0.35) :
                                                        dayStatus == .freezed ? Color.blue1.opacity(0.35) :
                                                        isToday ? Color.orange.opacity(100) :
                                                            isSelected ? Color.orange.opacity(0.8) :
                                                        Color.clear
                                                    )
                                            )
                                    }
                                    .onTapGesture {
                                        withAnimation {
                                            selectedDate = day
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

                // MARK: Main Button Area
                if isGoalCompleted {
                    VStack(spacing: 16) {
                        Image(systemName: "hands.clap.fill")
                            .symbolRenderingMode(.hierarchical)
                            .foregroundColor(.orange)
                            .font(.system(size: 42))
                            .padding(.bottom, 6)

                        Text("Well done!")
                            .font(.title3.bold())
                            .foregroundColor(.white)
                        Text("Goal completed! Start learning again or set a new goal.")
                            .foregroundColor(.gray)
                            .font(.subheadline)
                            .multilineTextAlignment(.center)

                        // ✅ Navigate to task4
                        Button(action: {
                            navigateToTask4 = true
                        }) {
                            Text("Set new learning goal")
                                .foregroundColor(.white)
                                .fontWeight(.semibold)
                                .frame(maxWidth: 225)
                                .padding()
                                .background(Color.darkOrange)
                                .cornerRadius(25)
                                .glassEffect(.clear)
                        }

                        Button(action: {
                            progressLog.removeAll()
                            lockedDays.removeAll()
                            isGoalCompleted = false
                        }) {
                            Text("Set same learning goal and duration")
                                .font(.headline)
                                .foregroundColor(.orange)
                        }
                    }
                    .padding(.horizontal)
                } else {
                    // Main big circle button
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
                            .foregroundColor(status.mainFontColor)
                            .frame(width: 270, height: 270)
                            .background(
                                Circle()
                                    .fill(status.mainButtonColor)
                            )
                            .font(status.font)
                            .glassEffect(.clear)
                    }
                    .disabled(lockedDays.contains(selectedDay))
                    .opacity(lockedDays.contains(selectedDay) ? 0.7 : 1)

                    // Freeze button
                    Button(action: {
                        withAnimation {
                            if canFreeze && !lockedDays.contains(selectedDay) {
                                status = .freezed
                                progressLog[selectedDay] = .freezed
                                lockedDays.insert(selectedDay)
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
                        .padding(.horizontal)
                }
            }

            // ✅ Hidden NavigationLink to task4
            NavigationLink(
                destination: task4(selectedDuration: $selectedDuration, subject: $subject),
                isActive: $navigateToTask4
            ) {
                EmptyView()
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
        case .learned: return .blackOrange
        case .freezed: return .blackBlue
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
    NavigationStack {
        task2(selectedDuration: .constant("Week"), subject: .constant("Swift"))
    }
}
