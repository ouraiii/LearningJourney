import SwiftUI

struct task1: View {
    @State private var selectedDuration = "Week"
    @State private var subject = "Swift"
    @Environment(\.colorScheme) private var colorScheme  // 👈 Detect system appearance
    
    var body: some View {
        NavigationStack {
            ZStack {
                // MARK: Background
                Color(.systemBackground)
                    .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    
                    // MARK: App logo
                    Circle()
                        .fill(
                            colorScheme == .dark
                            ? Color(.blackOrange)  // 🌙 Dark mode background
                            : Color(.orange)                // 🔆 Light mode background
                        )
                        .frame(width: 120, height: 120)
                        .overlay(
                            Image(systemName: "flame.fill")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.orange)
                                .frame(width: 50, height: 50)
                        )
                        .shadow(color: .white.opacity(0.3), radius: 0, x: 0, y: 2)
                        .glassEffect(.clear.tint(Color.blackOrange))
                    
                    // MARK: Intro texts
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Hello Learner")
                            .font(.largeTitle.bold())
                            .foregroundColor(.primary)
                        Text("This app will help you learn everyday!")
                            .foregroundColor(.secondary)
                            .font(.subheadline)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    
                    // MARK: Learning subject
                    VStack(alignment: .leading, spacing: 10) {
                        Text("I want to learn")
                            .foregroundColor(.primary)
                            .font(.headline)
                        
                        TextField("e.g. Swift, Korean, Guitar...", text: $subject)
                            .padding(12)
                            .cornerRadius(10)
                            .foregroundColor(Color(.systemGray))
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    
                    Divider()
                        .background(Color(.separator))
                        .padding(.horizontal)
                    
                    // MARK: Duration picker
                    VStack(alignment: .leading, spacing: 10) {
                        Text("I want to learn it in a")
                            .foregroundColor(.primary)
                            .font(.headline)
                        
                        HStack(spacing: 8) {
                            ForEach(["Week", "Month", "Year"], id: \.self) { duration in
                                Button(action: {
                                    selectedDuration = duration
                                }) {
                                    Text(duration)
                                        .fontWeight(.medium)
                                        .padding(.horizontal, 30)
                                        .padding(.vertical, 15)
                                        .glassEffect(.clear)
                                        .background(
                                            Capsule()
                                                .fill(selectedDuration == duration
                                                      
                                                      ?
                                                      Color.darkOrange.opacity(0.9)
                                                      :

                                                        colorScheme == .dark
                                                      ? Color.gray.opacity(0.1)  // 🌙 Dark mode background
                                                      : Color.gray.opacity(100)               // 🔆 Light mode background
                                                    )
                                            
                                        )
                                        .foregroundColor(selectedDuration == duration ? .white : .primary)
                                        .shadow(color: .white.opacity(0.4), radius: 0, x: 0, y: 0.5)

                                }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    // MARK: Start button
                    NavigationLink(destination: task2(selectedDuration: $selectedDuration, subject: $subject)) {
                        Text("Start learning")
                            .fontWeight(.semibold)
                            .padding()
                            .frame(maxWidth: 182, maxHeight: 48)
                            .glassEffect(.clear)
                            .foregroundColor(.white)
                            .shadow(radius: 3)
                            .background(
                                colorScheme == .dark
                                ? Color(.darkOrange)  // 🌙 Dark mode background
                                : Color(.orange)                // 🔆 Light mode background
                            )
                            .cornerRadius(30)
                    }
                    .padding(.bottom, 10)
                    .shadow(color: .white.opacity(100), radius: 0, x: 0, y: 0.5)

                }
            }
        }
    }
}

#Preview {
    task1()
}
