//
//  Task5View.swift
//  Learning Journey
//
//  Created by Rana Alqubaly on 04/05/1447 AH.
//

import SwiftUI

struct task5: View {
    let calendar = Calendar.current
    let progressLog: [Date: ActivityStatus]
    
    // MARK: Generate continuous 12 months starting from current month
    private var monthsToShow: [Date] {
        let startOfCurrentMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: Date()))!
        return (0..<12).compactMap { offset in
            calendar.date(byAdding: .month, value: offset, to: startOfCurrentMonth)
        }
    }
    
    private func monthTitle(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }

    private func daysInMonth(for date: Date) -> [Date] {
        guard let monthRange = calendar.range(of: .day, in: .month, for: date),
              let monthStart = calendar.date(from: calendar.dateComponents([.year, .month], from: date))
        else { return [] }
        return monthRange.compactMap { calendar.date(byAdding: .day, value: $0 - 1, to: monthStart) }
    }

    private func firstWeekdayOffset(for date: Date) -> Int {
        let comps = calendar.dateComponents([.year, .month], from: date)
        guard let monthStart = calendar.date(from: comps) else { return 0 }
        let weekday = calendar.component(.weekday, from: monthStart)
        return weekday - calendar.firstWeekday
    }

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            // Adaptive background (light/dark)
            Color(.systemBackground)
                .ignoresSafeArea()
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {
                    
                    // MARK: Header
                    HStack {
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.primary)
                                .font(.title2)
                        }
                        Text("All activities")
                            .font(.headline)
                            .foregroundColor(.primary)
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                    
                    // MARK: Calendar sections
                    ForEach(monthsToShow, id: \.self) { month in
                        VStack(alignment: .leading, spacing: 10) {
                            Text(monthTitle(for: month))
                                .font(.headline)
                                .foregroundColor(.primary)
                                .padding(.horizontal)
                            
                            let days = daysInMonth(for: month)
                            let offset = firstWeekdayOffset(for: month)
                            let columns = Array(repeating: GridItem(.flexible(), spacing: 8), count: 7)
                            
                            LazyVGrid(columns: columns, spacing: 8) {
                                // Empty cells for offset
                                ForEach(0..<max(offset, 0), id: \.self) { _ in
                                    Text("")
                                        .frame(width: 32, height: 32)
                                }
                                
                                ForEach(days, id: \.self) { day in
                                    let status = progressLog[day]
                                    Text("\(calendar.component(.day, from: day))")
                                        .frame(width: 36, height: 36)
                                        .background(
                                            Circle()
                                                .fill(
                                                    status == .learned ? Color.orange.opacity(0.7) :
                                                    status == .freezed ? Color.blue.opacity(0.7) :
                                                    Color(.systemBackground)
                                                )
                                                .shadow(color: Color.gray.opacity(0.2), radius: 1)
                                        )
                                        .foregroundColor(.primary)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.bottom, 40)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    let calendar = Calendar.current
    var sampleLog: [Date: ActivityStatus] = [:]
    
    // Only a few random days learned/freezed (others empty)
    for offset in 0..<12 {
        if let monthDate = calendar.date(byAdding: .month, value: offset, to: Date()) {
            for day in [3, 10, 17, 24] {
                if let date = calendar.date(from: DateComponents(
                    year: calendar.component(.year, from: monthDate),
                    month: calendar.component(.month, from: monthDate),
                    day: day
                )) {
                    sampleLog[date] = (day % 2 == 0) ? .freezed : .learned
                }
            }
        }
    }

    return NavigationStack {
        task5(progressLog: sampleLog)
    }
}
