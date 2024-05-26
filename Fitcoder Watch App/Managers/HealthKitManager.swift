//
//  HealthKitManager.swift
//  Fitcoder Watch App
//
//  Created by Rizki Maulana on 20/05/24.
//

import HealthKit

class HealthKitManager: NSObject, ObservableObject {
    let healthStore = HKHealthStore()
    let userDefaultsManager = UserDefaultsManager()
    let networkManager = NetworkManager()
    
    @Published var standValue: Int = 0
    @Published var showAlert: Bool = false
    
    func requestAuthorization() {
        let typesToRead: Set = [
            HKQuantityType.quantityType(forIdentifier: .appleStandTime)!,
            HKObjectType.activitySummaryType()
        ]
        
        healthStore.requestAuthorization(toShare: nil, read: typesToRead) { success, error in
            if !success {
                print("Failed to request authorization: \(error?.localizedDescription ?? "")")
            }
        }
    }
    
    func startStandQuery() {
        guard let standType = HKObjectType.quantityType(forIdentifier: .appleStandTime) else {
            print("Unable to create HealthKit type for stand time.")
            return
        }
        
        let predicate = createPredicateForToday()
        let statisticsOptions: HKStatisticsOptions = .cumulativeSum
        let standTimeThreshold = Constants.standTimeThreshold
        
        let query = HKStatisticsQuery(quantityType: standType, quantitySamplePredicate: predicate, options: statisticsOptions) { [weak self] query, result, error in
            guard let self = self, let result = result, let sum = result.sumQuantity() else {
                return
            }
            self.handleStandQueryResult(sum, threshold: standTimeThreshold)
        }
        
        healthStore.execute(query)
    }
    
    private func createPredicateForToday() -> NSPredicate {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())
        let now = Date()
        return HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
    }
    
    private func handleStandQueryResult(_ sum: HKQuantity, threshold: Double) {
        let totalStandTime = sum.doubleValue(for: HKUnit.minute())
        DispatchQueue.main.async {
            self.standValue = Int(totalStandTime)
            if totalStandTime >= threshold {
                self.checkAndPerformCommit(threshold: threshold)
            }
        }
    }
    
    private func checkAndPerformCommit(threshold: Double) {
        let now = Date()
        if let lastCommit = userDefaultsManager.lastTimeCommit {
            let timeIntervalSinceLastCommit = now.timeIntervalSince(lastCommit)
            if timeIntervalSinceLastCommit >= threshold * 60 {
                performCommit()
            }
        } else {
            performCommit()
        }
    }
    
    private func performCommit() {
        showAlert = true
        networkManager.commitToGitHub()
        userDefaultsManager.lastTimeCommit = Date()
    }
}
