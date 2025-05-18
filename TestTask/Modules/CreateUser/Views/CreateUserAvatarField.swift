//
//  CreateUserAvatarField.swift
//  TestTask
//
//  Created by Дмитрий Хероим on 17.05.2025.
//

import SwiftUI
import PhotosUI

struct CreateUserAvatarField: View {
  @ObservedObject var itemObj: CreateUserPhoneObject
  private let hIndent: CGFloat
  
  @EnvironmentObject private var orientationInfo: OrientationInfo
  private var constants: Constants { Constants(orientationInfo) }
  
  //---> internal properties
  @State private var showMenu: Bool = false
  @State private var showMenuItem: ImageMenuItem? = nil
  
  private var nonErrorHelpersColor: Color {
    isImageExist ? constants.textColor : constants.placeholderOrBorderColor
  }
  private var currentHelpersColor: Color {
    itemObj.isErrored ? constants.invalidColor : nonErrorHelpersColor
  }
  //<--- internal properties
  
  init(itemObj: CreateUserPhoneObject, hIndent: CGFloat) {
    self.itemObj = itemObj
    self.hIndent = hIndent
  }
  
  var body: some View {
    HStack(spacing: .zero) {
      imageAndTextHStack
      
      uploadButton
    }
    .padding(.horizontal, hIndent)
    .confirmationDialog("", isPresented: $showMenu) {
      Button {
        showMenuItem = .gallery
      } label: {
        Text("Gallery")
      }
      Button {
        showMenuItem = .camera
      } label: {
        Text("Camera")
      }
    } message: {
      Text("Choose how you want to add a photo")
    }
    .sheet(item: $showMenuItem) { result in
      switch result {
      case .gallery:
        ImagePickerView(image: $itemObj.selectedImageInfo, selectedSourceType: .photoLibrary)
          .edgesIgnoringSafeArea(.all)
      case .camera:
        ImagePickerView(image: $itemObj.selectedImageInfo, selectedSourceType: .camera)
          .edgesIgnoringSafeArea(.all)
      }
    }
  }
}

//MARK: - UI elements creating
private extension CreateUserAvatarField {
  var isImageExist: Bool {
    itemObj.selectedImageInfo != nil
  }
  var uploadTextMsg: String {
    if let selectedImageName = itemObj.selectedImageName {
      selectedImageName
    } else {
      itemObj.type.placeholderText
    }
  }
  var uploadText: some View {
    Text(uploadTextMsg)
      .font(constants.helperTextFont)
      .foregroundColor(currentHelpersColor)
      .frame(maxWidth: .infinity, alignment: .leading)
      .animation(.easeInOut, value: itemObj.isErrored)
  }
  
  var imageAndTextHStack: some View {
    HStack(alignment: .center, spacing: hIndent / 2) {
      if let image = itemObj.selectedImageInfo?.image {
        Image(uiImage: image)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .padding(.vertical, hIndent / 2)
      }
      
      uploadText
    }
    .animation(.easeInOut, value: itemObj.selectedImageInfo?.image)
  }
  
  var uploadButton: some View {
    Button {
      UIApplication.shared.hideKeyboard()
      showMenu.toggle()
    } label: {
      Text("Upload")
        .font(constants.uploadTextFont)
        .foregroundColor(constants.uploadTextColor)
        .padding(.horizontal, hIndent)
        .padding(.vertical, hIndent / 2)
    }
  }
}

//MARK: - Preview
#Preview {
  CreateUserAvatarField(itemObj: .mock, hIndent: 16.0)
    .environmentObject(OrientationInfo.phone)
}

//MARK: - Constants
fileprivate struct Constants: CommonConstants {
  private let colorTheme = AppColor.CreateUserView.self
  var orientationInfo: OrientationInfo
  init(_ orientationInfo: OrientationInfo) {
    self.orientationInfo = orientationInfo
  }
  
  var textColor: Color {
    colorTheme.baseText
  }
  var placeholderOrBorderColor: Color {
    colorTheme.placeholderOrBorder
  }
  var invalidColor: Color {
    colorTheme.error
  }
  
  var helperTextFont: Font {
    let phoneFontSize: CGFloat = 16.0
    return AppFont.font(.regular, size: phoneFontSize + additionalValue)
  }
  var uploadTextFont: Font {
    let phoneFontSize: CGFloat = 16.0
    return AppFont.font(.semibold, size: phoneFontSize + additionalValue)
  }
  
  var uploadTextColor: Color {
    colorTheme.selectedOuter
  }
}

fileprivate enum ImageMenuItem: String, Identifiable {
  case gallery
  case camera
  
  var id: String {
    self.rawValue
  }
}
