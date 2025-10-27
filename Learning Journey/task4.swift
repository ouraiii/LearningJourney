import SwiftUI

struct task4: View {
    @Binding var selectedDuration: String
    @Binding var subject: String
    
    @State private var originalDuration = ""
    @State private var originalSubject = ""
    @State private var showUpdatePopup = false
    @State private var navigateToTask2 = false
    @Environment(\.colorScheme) private var colorScheme  // 👈 Detect system appearance

    var body: some View {
        ZStack {
            // MARK: Background
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                // MARK: Header
                HStack {
                    Spacer()
                    
                    Text("Learning Goal")
                        .foregroundColor(.primary)
                        .font(.headline.bold())
                    
                    Spacer()
                    
                    Button(action: {
                        if subject != originalSubject || selectedDuration != originalDuration {
                            showUpdatePopup = true
                        }
                    }) {
                        Circle()
                            .fill(Color.darkOrange)
                            .frame(width: 36, height: 36)
                            .overlay(
                                Image(systemName: "checkmark")
                                    .foregroundColor(.white)
                            )
                            .font(.title2)
                            .shadow(radius: 3)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 10)

                // MARK: Subject Field
                VStack(alignment: .leading, spacing: 10) {
                    Text("I want to learn")
                        .foregroundColor(.primary)
                        .font(.title3.bold())
                    
                    TextField("e.g. Swift, Korean, Guitar...", text: $subject)
                        .padding(12)
                        //.background(Color(.secondarySystemBackground))
                        .cornerRadius(10)
                        .foregroundColor(Color(.systemGray))
                }
                .padding(.horizontal)
                
                // MARK: Duration Picker
                VStack(alignment: .leading, spacing: 10) {
                    Text("I want to learn it in a")
                        .foregroundColor(.primary)
                        .font(.title3.bold())

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
                .padding(.horizontal)
                
                Spacer()
            }
            
            // MARK: Popup Overlay
            if showUpdatePopup {
                Color.black.opacity(0.6)
                    .ignoresSafeArea()
                    .zIndex(1)
                
                VStack(spacing: 18) {
                    Text("Update Learning Goal")
                        .font(.title3.bold())
                        .foregroundColor(.primary)
                    
                    Text("If you update now, your streak will start over.")
                        .foregroundColor(.secondary)
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    HStack(spacing: 14) {
                        Button(action: {
                            withAnimation {
                                showUpdatePopup = false
                                subject = originalSubject
                                selectedDuration = originalDuration
                            }
                        }) {
                            Text("Dismiss")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(.tertiarySystemBackground))
                                .foregroundColor(.primary)
                                .glassEffect(.clear)
                                .cornerRadius(25)


                        }
                        
                        Button(action: {
                            withAnimation {
                                originalSubject = subject
                                originalDuration = selectedDuration
                                showUpdatePopup = false
                                navigateToTask2 = true
                            }
                        }) {
                            Text("Update")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.darkOrange)
                                .foregroundColor(.white)
                                .glassEffect(.clear)
                                .cornerRadius(25)

                        }
                    }
                    
                    .padding(.horizontal)
                }
                .frame(width: 320)
                .padding()
                .background(Color(.systemBackground))
                .shadow(radius: 20)
                .zIndex(2)
                .glassEffect(.clear)
                .cornerRadius(90)
            }
            
            // MARK: NavigationLink
            NavigationLink(
                destination: task2(selectedDuration: $selectedDuration, subject: $subject),
                isActive: $navigateToTask2
            ) {
                EmptyView()
            }
        }
    }
}

#Preview {
    NavigationStack {
        task4(selectedDuration: .constant("Week"), subject: .constant("Swift"))
    }
}
