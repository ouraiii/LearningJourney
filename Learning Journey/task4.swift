//
//  task1 2.swift
//  Learning Journey
//
//  Created by Rana Alqubaly on 02/05/1447 AH.
//


import SwiftUI

struct task4: View {
    @State private var selectedDuration = "Week"
    @State private var subject = "Swift"
    
    var body: some View {
        //NavigationStack {
            ZStack {
                Color.black
                    .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    
                    Text("Learning Journey")
                        .foregroundColor(.white)
                        .font(.headline.bold())
                  
                    
                    // Learning subject
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
                    
                    
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                    .padding(.top, 10)
                    //.glassEffect(.clear.tint(Color.darkOrange.opacity(0.15)))

                    
                }
            }
        }
    }
//}

#Preview {
    task4()
}

