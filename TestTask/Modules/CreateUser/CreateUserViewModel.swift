//
//  CreateUserViewModel.swift
//  TestTask
//
//  Created by Дмитрий Хероим on 17.05.2025.
//

import SwiftUI
import Combine

@MainActor
final class CreateUserViewModel: ObservableObject {
  @ObservedObject private(set) var sharedData: SharedData
  
  private var cancellables: Set<AnyCancellable> = []
  @Published private(set) var loadingState: LoadingState = .idle
  
  @Published private(set) var nameObj = CreateUserTextFieldObj(type: .name)
  @Published private(set) var emailObj = CreateUserTextFieldObj(type: .email)
  @Published private(set) var phoneObj = CreateUserPhoneTextFieldObj(type: .phone)
  
  @Published private(set) var avatarObj = CreateUserPhoneObject(type: .avatar)
  
  @Published var signUpAvailability: Bool = false
  
  @Published var selectedPostion: Position?
  @Published private(set) var positions = [Position]()
  
  private var lastOperation: LastTaskOperation?
  
  init(_ sharedData: SharedData) {
    self.sharedData = sharedData
    
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
    
    let isAllValid = [
    !nameObj.isErrored,
    !emailObj.isErrored,
    !phoneObj.isErrored,
    !avatarObj.isErrored
    ].allSatisfy { $0 == true }
    
    guard isAllValid else { return }
    
    let newUserInfo = NewUserDTO(name: nameObj.text, email: emailObj.text, phone: phoneObj.getReadyToSendPhoneNumber(), position_id: selectedPostion?.id, photo: avatarObj.selectedImageInfo?.toDTO)
    
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
  
  func createionUserResultAction() {
    loadingState = .idle
  }
  func repeatLastOperation() {
    switch lastOperation {
    case .fetchingPositions:
      fetchPositions()
    case .userCreation:
      signUpAction()
    case nil: break
    }
    
    lastOperation = nil
  }
}

//MARK: - Network layer
private extension CreateUserViewModel {
  func fetchPositions() {
    loadingState = .loading
    
    Task {
      do {
        let res = try await NetworkAdapter.fetchPositions()
        positions = res.positions
        selectedPostion = res.positions.first
        
        loadingState = .success
      } catch {
        lastOperation = .fetchingPositions
        
        if !NetworkMonitor.shared.isConnected {
          loadingState = .error(ErrorProcessing.noInterner)
        } else {
          loadingState = .error(error)
        }
      }
    }
  }
  
  func register(newUser: NewUserDTO) {
    loadingState = .loading
    
    Task {
      do {
        let token = try await NetworkAdapter.fetchToken()
        let responce = try await NetworkAdapter.create(newUser, with: token.token)
        
        if responce.success {
          //reset fields (prepair to new registration)
          resetToDefaultFields()
          
          //add to sharedData for showing in UserList
          sharedData.isReloadNeeded = true
        }
        
        //show modal view
        loadingState = .userCreationResult(responce)
      } catch {
        lastOperation = .userCreation
        
        if !NetworkMonitor.shared.isConnected {
          loadingState = .error(ErrorProcessing.noInterner)
        } else {
          loadingState = .error(error)
        }
      }
    }
  }
}

//MARK: - Helpers
private extension CreateUserViewModel {
  func resetToDefaultFields() {
    [nameObj, emailObj, phoneObj, avatarObj].forEach {
      $0.restoreToDefault()
    }
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
      phoneObj.isErrored = !isValidPhoneNumber(phoneObj.getClearPhoneNumber())
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
        self?.updateSignUpAvailability()
      }
      .store(in: &cancellables)
    $loadingState
      .receive(on: RunLoop.main)
      .sink { [weak self] _ in
        self?.updateSignUpAvailabilityAccordingLoadingState()
      }
      .store(in: &cancellables)
  }
  
  func updateSignUpAvailabilityAccordingLoadingState() {
    if loadingState == .loading {
      signUpAvailability = false
    } else {
      updateSignUpAvailability()
    }
  }
  func updateSignUpAvailability() {
    signUpAvailability = !emailObj.text.isEmpty
  }
}
