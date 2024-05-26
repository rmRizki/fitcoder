//
//  ContentView.swift
//  Fitcoder Watch App
//
//  Created by Rizki Maulana on 15/05/24.
//

import SwiftUI
import HealthKit

struct ContentView: View {
    @EnvironmentObject var healthKitManager: HealthKitManager
    
    let imageUrl: URL = URL(string: Constants.profileImageUrl)!
    let userName = "@\(Constants.userName)"
    
    var body: some View {
        VStack {
            AsyncImage(url: imageUrl) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipShape(Circle())
            } placeholder: {
                ProgressView()
            }
            .frame(width: 116, height: 116)
            .padding([.bottom], 4)
            Text(userName)
                .foregroundColor(.gray)
                .font(.system(.footnote))
            Divider()
                .padding(4)
            HStack {
                Image(systemName: "clock.fill")
                    .resizable()
                    .foregroundColor(.gray)
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: 24)
                    .padding([.trailing], 8)
                VStack (alignment: .leading) {
                    Text("\(healthKitManager.standValue) minutes")
                        .font(.system(.body))
                        .foregroundColor(.blue)
                        .privacySensitive()
                    Text("Standing Time")
                        .font(.system(.footnote))
                        .foregroundColor(.gray)
                }
            }.padding(.bottom)
        }
        .padding()
        .onAppear {
            healthKitManager.requestAuthorization()
            healthKitManager.startStandQuery()
            Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true) { _ in
                healthKitManager.startStandQuery()
            }
        }
        .alert(isPresented: $healthKitManager.showAlert) {
            Alert(
                title: Text("Great Job!"),
                message: Text("You've earned a commit reward!"),
                dismissButton:  .default(Text("OK"), action: {
                    healthKitManager.showAlert = false
                })
            )
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(HealthKitManager())
}
