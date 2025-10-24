/*import SwiftUI

// FIX 1: Removed erroneous inheritance from 'ActivityCalendarView'
struct MonthDatePickerView: View {
    @Binding var selectedDate: Date
    @Binding var currentMonthName: String
    @Binding var selectedDay: Int
    @Binding var currentWeekStart: Int // Added this binding to allow week update

    var body: some View {
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
        // FIX 2: Updated deprecated 'onChange' syntax to the modern version
        .onChange(of: selectedDate) { newDate in
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM yyyy"
            currentMonthName = formatter.string(from: newDate)

            let calendar = Calendar.current
            selectedDay = calendar.component(.day, from: newDate)
            
            // Logic to update the week view to show the selected date range
            if let weekInterval = calendar.dateInterval(of: .weekOfMonth, for: newDate),
               let startDay = calendar.dateComponents([.day], from: weekInterval.start).day {
                currentWeekStart = startDay
            }
        }
    }
}
*/
