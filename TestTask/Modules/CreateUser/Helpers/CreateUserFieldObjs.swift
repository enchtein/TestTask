//
//  CreateUserFieldObjs.swift
//  TestTask
//
//  Created by Дмитрий Хероим on 17.05.2025.
//

import SwiftUI
import Combine

//MARK: - CreateUserFieldObj
class CreateUserFieldObj: ObservableObject {
  let type: CreateUserFieldType
  
  var isEmptyValue: Bool = true
  @Published var isErrored: Bool = false
  
  init(type: CreateUserFieldType) {
    self.type = type
  }
  
  open func restoreToDefault() {
    isEmptyValue = true
    isErrored = false
  }
}
//MARK: - Mock's
extension CreateUserFieldObj {
  static let baseMock = CreateUserTextFieldObj(type: .phone)
}

//MARK: - CreateUserTextFieldObj
class CreateUserTextFieldObj: CreateUserFieldObj {
  @Published var text: String = ""
  
  override func restoreToDefault() {
    super.restoreToDefault()
    
    text = ""
  }
  
  open func setFormatedTextIfNeeded() {}
}
//MARK: - Mock's
extension CreateUserTextFieldObj {
  static let mock = CreateUserTextFieldObj(type: .name)
}

//MARK: - CreateUserPhoneTextFieldObj
class CreateUserPhoneTextFieldObj: CreateUserTextFieldObj {
  override func setFormatedTextIfNeeded() {
    let firstSubStr = "+38 ("
    let secondSubStr = ") "
    let thirdSubStr = " - "
    
    let clearPhoneNumber = getClearPhoneNumber()
    
    let firstPart = String(clearPhoneNumber.prefix(3))
    let firstStage = clearPhoneNumber.dropFirst(3)
    
    let secondPart = String(firstStage.prefix(3))
    let secondStage = firstStage.dropFirst(3)
    
    let thirdPart = String(secondStage.prefix(2))
    let thirdStage = secondStage.dropFirst(2)
    
    let fourghtPart = String(thirdStage.prefix(2))
    
    var maskedPhoneNumber: String = ""
    if !firstPart.isEmpty {
      maskedPhoneNumber = firstSubStr + firstPart
    }
    if !secondPart.isEmpty {
      maskedPhoneNumber += secondSubStr + secondPart
    }
    if !thirdPart.isEmpty {
      maskedPhoneNumber += thirdSubStr + thirdPart
    }
    if !fourghtPart.isEmpty {
      maskedPhoneNumber += thirdSubStr + fourghtPart
    }
    
    guard !text.elementsEqual(maskedPhoneNumber) else { return }
    isErrored = false
    
    text = maskedPhoneNumber
  }
  
  func getClearPhoneNumber() -> String {
    let currentText = text
    
    let firstSubStr = "+38 ("
    let secondSubStr = ") "
    let thirdSubStr = " - "
    let firstStage = currentText.replacingOccurrences(of: firstSubStr, with: "")
    let secondStage = firstStage.replacingOccurrences(of: secondSubStr, with: "")
    let thirdStage = secondStage.replacingOccurrences(of: thirdSubStr, with: "")
    
    return thirdStage
  }
  
  func getReadyToSendPhoneNumber() -> String {
    let currentText = text
    
    let firstStage = currentText.replacingOccurrences(of: "(", with: "")
    let secondStage = firstStage.replacingOccurrences(of: ")", with: "")
    let thirdStage = secondStage.replacingOccurrences(of: " ", with: "")
    let fourghtStage = thirdStage.replacingOccurrences(of: "-", with: "")
    
    return fourghtStage
  }
}

//MARK: - CreateUserPhoneObject
class CreateUserPhoneObject: CreateUserFieldObj {
  private var cancellables: Set<AnyCancellable> = []
  @Published var selectedImageInfo: NewUserAttachmentImageInfo?
  @Published var selectedImageName: String?
  
  override init(type: CreateUserFieldType) {
    super.init(type: type)
    
    subscribeForChanges()
  }
  
  private func subscribeForChanges() {
    $selectedImageInfo
      .receive(on: RunLoop.main)
      .sink { [weak self] _ in
        self?.updateSelectedImageName()
      }
      .store(in: &cancellables)
  }
  
  private func updateSelectedImageName() {
    let newText = selectedImageInfo == nil ? nil : "Image selected"
    
    guard selectedImageName != newText else { return }
    selectedImageName = newText
    isErrored = newText == nil
  }
  
  override func restoreToDefault() {
    super.restoreToDefault()
    
    selectedImageInfo = nil
    selectedImageName = nil
  }
}
//MARK: - Mock's
extension CreateUserPhoneObject {
  static let mock = CreateUserPhoneObject(type: .avatar)
}
