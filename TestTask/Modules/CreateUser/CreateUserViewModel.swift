//
//  CreateUserViewModel.swift
//  TestTask
//
//  Created by Дмитрий Хероим on 17.05.2025.
//

import SwiftUI
import Combine

@MainActor
class CreateUserViewModel: ObservableObject {
  private var cancellables: Set<AnyCancellable> = []
  @Published private(set) var loadingState: LoadingState = .idle
  
  @Published private(set) var nameObj = CreateUserTextFieldObj.init(type: .name)
  @Published private(set) var emailObj = CreateUserTextFieldObj.init(type: .email)
  @Published private(set) var phoneObj = CreateUserTextFieldObj.init(type: .phone)
  
  @Published private(set) var avatarObj = CreateUserPhoneObject.init(type: .avatar)
  
  @Published var signUpAvailability: Bool = false
  
  @Published var selectedPostion: Position?
  @Published private(set) var positions = [Position]()
  
  init() {
    fetchPositions()
    subscribeForChanges() //Call once on init
    print("CreateUserViewModel init")
  }
  deinit {
    print("CreateUserViewModel deinit")
  }
  
  func signUpAction() {
    CreateUserFieldType.allCases.forEach { checkErrors(for: $0) }
    
    guard signUpAvailability else { return }
    let newUserInfo = NewUserDTO(name: nameObj.text, email: emailObj.text, phone: getReadyToSendPhoneNumber(), position_id: selectedPostion?.id, photo: avatarObj.selectedImageInfo?.toDTO)
    
    guard let newUserInfo else { return }
    register(newUser: newUserInfo)
  }
  func resetErroredStateIfNeeded() {
    switch loadingState {
    case .error(_):
      let orgState = loadingState
      
      loadingState = .idle
      Task {
        try? await Task.sleep(for: .seconds(1))
        
        loadingState = orgState
      }
    default: break
    }
  }
}

//MARK: - Network layer
extension CreateUserViewModel {
  func fetchPositions() {
    loadingState = .loading
    
    Task {
      do {
        let res = try await NetworkAdapter.fetchPositions()
        positions = res.positions
        selectedPostion = res.positions.first
        
        loadingState = .success
      } catch {
        if !NetworkMonitor.shared.isConnected {
          loadingState = .error(ErrorProcessing.noInterner)
        } else {
          loadingState = .error(error)
        }
      }
    }
  }
  
  private func register(newUser: NewUserDTO) {
    Task {
      do {
        let token = try await NetworkAdapter.fetchToken()
        
        let responce = try await NetworkAdapter.create(newUser, with: token.token)
        
        if responce.success {
          //reset fields (prepair to new registration)
          resetToDefaultFields()
          
          //add to sharedData for showing in UserList
        }
        
        //show modal view
        print(token)
      } catch {
        debugPrint(error.localizedDescription)
      }
    }
  }
}

//MARK: - Helpers
private extension CreateUserViewModel {
  func resetToDefaultFields() {
    nameObj = CreateUserTextFieldObj.init(type: .name)
    emailObj = CreateUserTextFieldObj.init(type: .email)
    phoneObj = CreateUserTextFieldObj.init(type: .phone)
    avatarObj = CreateUserPhoneObject.init(type: .avatar)
    selectedPostion = positions.first
  }
  
  func checkErrors(for type: CreateUserFieldType) {
    switch type {
    case .name:
      nameObj.isEmptyValue = nameObj.text.isEmpty
      nameObj.isErrored = nameObj.text.isEmpty
    case .email:
      emailObj.isEmptyValue = emailObj.text.isEmpty
      emailObj.isErrored = !isValidEmail(emailObj.text)
    case .phone:
      phoneObj.isEmptyValue = phoneObj.text.isEmpty
      phoneObj.isErrored = !isValidPhoneNumber(getClearPhoneNumber())
    case .avatar:
      avatarObj.isEmptyValue = avatarObj.selectedImageInfo == nil
      avatarObj.isErrored = avatarObj.selectedImageInfo == nil
    }
  }
  
  func isValidEmail(_ email: String) -> Bool {
    let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let emailPredicate = NSPredicate(format: "SELF MATCHES[c] %@", emailRegex)
    return emailPredicate.evaluate(with: email)
  }
  
  func isValidPhoneNumber(_ number: String) -> Bool {
    let regEx = "[0-9]{10}"
    let phoneCheck = NSPredicate(format: "SELF MATCHES[c] %@", regEx)
    return phoneCheck.evaluate(with: number)
  }
  func getClearPhoneNumber() -> String {
    let currentText = phoneObj.text
    
    let firstSubStr = "+38 ("
    let secondSubStr = ") "
    let thirdSubStr = " - "
    let firstStage = currentText.replacingOccurrences(of: firstSubStr, with: "")
    let secondStage = firstStage.replacingOccurrences(of: secondSubStr, with: "")
    let thirdStage = secondStage.replacingOccurrences(of: thirdSubStr, with: "")
    
    return thirdStage
  }
  func getReadyToSendPhoneNumber() -> String {
    let currentText = phoneObj.text
    
    let firstStage = currentText.replacingOccurrences(of: "(", with: "")
    let secondStage = firstStage.replacingOccurrences(of: ")", with: "")
    let thirdStage = secondStage.replacingOccurrences(of: " ", with: "")
    let fourghtStage = thirdStage.replacingOccurrences(of: "-", with: "")
    
    return fourghtStage
  }
}
//MARK: - Subscribers + Helpers
private extension CreateUserViewModel {
  func subscribeForChanges() {
    nameObj.$text
      .receive(on: RunLoop.main)
      .sink { [weak self] _ in
        self?.updateSignUpAvailability()
      }
      .store(in: &cancellables)
    emailObj.$text
      .receive(on: RunLoop.main)
      .sink { [weak self] _ in
        self?.emailObj.isErrored = false
        self?.updateSignUpAvailability()
      }
      .store(in: &cancellables)
    phoneObj.$text
      .receive(on: RunLoop.main)
      .sink { [weak self] _ in
        self?.updatePhoneNumberTextIfNeeded()
        self?.updateSignUpAvailability()
      }
      .store(in: &cancellables)
  }
  
  func updateSignUpAvailability() {
    signUpAvailability = !emailObj.text.isEmpty
  }
  
  func updatePhoneNumberTextIfNeeded() {
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
    
    guard !phoneObj.text.elementsEqual(maskedPhoneNumber) else { return }
    phoneObj.isErrored = false
    
    phoneObj.text = maskedPhoneNumber
  }
}
