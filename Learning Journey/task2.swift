import SwiftUI

struct task2: View {
    let selectedDuration: String
    let subject: String
    
    // MARK: - State Variables
    let today = Calendar.current.component(.day, from: Date())
    let weekdaySymbols = Calendar.current.shortWeekdaySymbols // ["Sun", "Mon", ...]
    @State private var selectedDay: Int
    @State private var status: ActivityStatus = .defaultState
    @State private var progressLog: [Int: ActivityStatus] = [:]
    @State private var currentWeekStart = 20
    @State private var currentMonthName = "October 2025"
    @State private var currentMonthShort = "OCT"
    @State private var selectedDate = Date()//here
    @State private var showDatePicker = false//here
    @State private var lockedDays: Set<Int> = []

    
    // MARK: - Initializer to make current day default
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
    
    var canFreeze: Bool {
        daysFreezed < freezeLimit
    }
    
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
                
                //من هنا
                VStack(alignment: .leading, spacing: 20) {

                    // MARK: Calendar Container
                    VStack(alignment: .leading, spacing: 14) {
                        HStack {
                            // MARK: Month & Date Picker Toggle
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
                            
                            // MARK: Week Navigation Arrows
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
                            DatePicker(
                                "",
                                selection: $selectedDate,
                                displayedComponents: [.date]
                                
                            )
                            .datePickerStyle(.wheel)
                            .labelsHidden()
                            .tint(.orange)
                            .colorScheme(.dark)
                            .background(Color.black)
                            .glassEffect(.clear)
                            .cornerRadius(100)
                            .padding(.horizontal)
                            .onChange(of: selectedDate) { newDate in
                                let formatter = DateFormatter()
                                formatter.dateFormat = "MMMM yyyy"
                                currentMonthName = formatter.string(from: newDate)
                                
                                formatter.dateFormat = "MMM"
                                currentMonthShort = formatter.string(from: newDate).uppercased()
                            }
                            //.glassEffect()
                            //.cornerRadius(25)
                        }
                            
                        //.padding(.horizontal)
                        //.foregroundColor(.orange)


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

                    // MARK: Learning Summary (inside same VStack)
                   //VStack(alignment: .leading, spacing: 12) {
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
                   /* }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.15))
                    .cornerRadius(18)*/
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal)
                .background(Color.gray.opacity(0.15))
                .cornerRadius(18)


                // MARK: Main Action Button
                Button(action: {
                    // Only allow if today hasn't been logged yet
                    if !lockedDays.contains(selectedDay) {
                        withAnimation(.spring()) {
                            switch status {
                            case .defaultState:
                                status = .learned
                                progressLog[selectedDay] = .learned
                                lockedDays.insert(selectedDay) // ✅ lock current day

                            case .learned:
                                status = .freezed
                                progressLog[selectedDay] = .freezed
                                lockedDays.insert(selectedDay) // ✅ lock current day

                            case .freezed:
                                break // do nothing, stays locked
                            }
                        }
                    }
                }) {
                    Text(status.mainButtonTitle)
                        .foregroundColor(status.mainFontColor.opacity(100))
                        .frame(width: 270, height: 270)
                        .background(
                            Circle()
                                .fill(status.mainButtonColor.opacity(100))// ✅ dynamic color
                        )
                        .glassEffect(.clear)
                        .font(status.font)
                }
                .disabled(lockedDays.contains(selectedDay)) // ✅ disable after first press
                .opacity(lockedDays.contains(selectedDay) ? 0.7 : 1)

                
                // MARK: Log as Freezed Button
                
                
                Button(action: {
                    withAnimation {
                        if canFreeze && !lockedDays.contains(selectedDay) {
                            status = .freezed
                            progressLog[selectedDay] = .freezed
                            lockedDays.insert(selectedDay) // ✅ lock after freeze
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
                
                .disabled(lockedDays.contains(selectedDay)) // ✅ disable if locked
                .opacity(lockedDays.contains(selectedDay) ? 0.6 : 1)
                .padding(.horizontal)

                //.padding(.bottom, 40)
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
        .padding(.horizontal,25)
        //.background(color.opacity(0.8))
        
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
    
    var font: Font {
        switch self {
        case .defaultState: return .largeTitle.bold()
        case .learned: return .largeTitle.bold()
        case .freezed: return .largeTitle.bold()
        }
    }
    var mainButtonColor: Color {
            switch self {
            case .defaultState: return Color.darkOrange
            case .learned: return Color.blackOrange.opacity(100) // darker orange
            case .freezed: return Color.blackBlue.opacity(100)
            }
        }
    
    var mainFontColor: Color {
            switch self {
            case .defaultState: return Color.white
            case .learned: return Color.orange.opacity(100)
            case .freezed: return Color.blue1.opacity(100)
            }
        }
    
}


#Preview {
    task2(selectedDuration: "Week", subject: "Swift")
}


