//
//  SharedData.swift
//  TestTask
//
//  Created by Дмитрий Хероим on 18.05.2025.
//

import Foundation

class SharedData: ObservableObject {
  @Published var isReloadNeeded: Bool = false
  
  func resetParametersInNeeded() {
    Task(priority: .userInitiated) {
      try await Task.sleep(for: .milliseconds(300)) //await needed for getting change in all viewModels
      
      //reset to delault state parameters
      ///except selectedFilters, remainingDayOffs and selectedRange
      await MainActor.run {
        if isReloadNeeded {
          isReloadNeeded = false
        }
      }
    }
  }
}
