# Register Form

## Dependencies and any external libraries used:
1) Moya for network layer
   -easely and faster write network queries
2) Kingfisher
   -allow to load and cashing images

## Brief overview of the code structure and important modules:
NetworkMonitor - singleton which allow checking connection to network
OrientationInfo - singleton which allow detecting device type (iPhone / iPad)

## Features:
MainView - is TabView, which initialize both screens (UsersView and CreateUserView).  
I decide to use it most of all because it allow not sent network query to getting userList on server each time while user switch to UsersView tab.  
**Bonus:** allow to switch between tabs by horizontal pan gesture.

---
UsersView constains loading info with pagination.  
**Bonus:** while network query error tap on "Try again" button at NoInternetView will reLaunch last network query (fetchingUsers).

---
CreateUserView contains field validation.  
**Bonus:** reseting field after success new user creation.

---
And I decide to change UI and add small image and text after adding image by user. For showing what image added.  
**Bonus:** while network query error tap on "Try again" button at NoInternetView will reLaunch last network query (fetchPositions or creating new user).

---

NoInternetView - showing text "There is no internet connection" or text of server error  
CreationUserResult - showing text of success user creation or server message


## Additionaly:
App for 16.0 and neawest iOS.  
All app contains smooth animations.  
Add logic for sizing font and spacing indent for different devices (iPhone / iPad).  
User Combine for get subscribers on changes and provide additional changes like set text by phone mask (+38 (XXX) XXX - XX - XX) at CreateUserView phone field.  


## Link on Media:  
https://drive.google.com/drive/folders/1-fZkFzGYk0J10VEDbtkjYu3-Grheosk1?usp=sharing
