import SwiftUI

struct task4: View {
    @State private var selectedDuration = "Week"
    @State private var subject = "Swift"
    
    // Track the original values (for comparison)
    @State private var originalDuration = "Week"
    @State private var originalSubject = "Swift"
    
    // State for showing confirmation popup
    @State private var showUpdatePopup = false
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                
                // MARK: Header
                HStack {
                    Button(action: {
                        // Handle back navigation if needed
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                            .font(.title3.bold())
                    }
                    
                    Spacer()
                    
                    Text("Learning Goal")
                        .foregroundColor(.white)
                        .font(.headline.bold())
                    
                    Spacer()
                    
                    Button(action: {
                        // Only show popup if user changed something
                        if subject != originalSubject || selectedDuration != originalDuration {
                            showUpdatePopup = true
                        }
                    }) {
                        Image(systemName: "checkmark")
                            .foregroundColor(.white)
                            .font(.largeTitle)
                            .glassEffect(.clear.tint(Color.darkOrange.opacity(100)))
                    }
                }
                .padding(.horizontal)
                .padding(.top, 10)
                
                // MARK: Learning subject
                VStack(alignment: .leading, spacing: 10) {
                                      Text("I want to learn")
                                          .foregroundColor(.white)
                                          .font(.title3.bold())
                                      
                                      TextField("e.g. Swift, Korean, Guitar...", text: $subject)
                                          .padding(12)
                                          .background(.clear)
                                          .cornerRadius(10)
                                          .foregroundColor(.gray.opacity(0.6))
                                          .autocapitalization(.none)
                                          .disableAutocorrection(true)
                                  }
                                  .frame(maxWidth: .infinity, alignment: .leading)
                                  .padding(.horizontal)
                                  
                                  Divider()
                                      .background(Color.gray)
                                      .padding(.horizontal)
                                  
                                  // Duration picker
                                  VStack(alignment: .leading, spacing: 10) {
                                      Text("I want to learn it in a")
                                          .foregroundColor(.white)
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
                                                              .fill(selectedDuration == duration ? Color.darkOrange.opacity(0.9): Color.gray.opacity(0.05))
                                                      )
                                                      .foregroundColor(.white)
                                              }
                                          }
                                      }
                                  }

                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                
                Spacer()
            }
            
            // MARK: Popup Overlay
            if showUpdatePopup {
                Color.black.opacity(0.6)
                    .ignoresSafeArea()
                    .transition(.opacity)
                    .zIndex(1)
                
                VStack(spacing: 18) {
                    Text("Update Learning goal")
                        .font(.headline.bold())
                        .foregroundColor(.white)
                    
                    Text("If you update now, your streak will start over.")
                        .foregroundColor(.gray)
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
                                .background(Color.gray.opacity(0.3))
                                .foregroundColor(.white)
                                .cornerRadius(16)
                        }
                        
                        Button(action: {
                            withAnimation {
                                originalSubject = subject
                                originalDuration = selectedDuration
                                showUpdatePopup = false
                            }
                        }) {
                            Text("Update")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.darkOrange)
                                .foregroundColor(.white)
                                .cornerRadius(16)
                        }
                    }
                    .padding(.horizontal)
                }
                .frame(width: 320)
                .padding()
                .background(Color(white: 0.15))
                .cornerRadius(24)
                .shadow(radius: 20)
                .zIndex(2)
                .transition(.scale)
            }
        }
    }
}

#Preview {
    task4()
}
