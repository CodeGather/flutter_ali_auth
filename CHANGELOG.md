#

## 1.2.7
* Add return parameter isChecked
* Unified background parameter pageBackgroundPath
* Optimize unified configuration of iOS code parameters
* Fix the issue of Android physical buttons not being able to be reopened after returning

## 1.2.6
* Update android sdk to 2.13.10
* Update ios sdk to 2.13.10
* Update web sdk to 2.1.4
* fastjson2 -> 2.0.51.android5
* Fix the protocol details navigation parameter privacyNavColor in iOS bottom pop-up mode privacyNavBackImage、privacyNavTitleFont、privacyNavTitleColor
* Please note that the following content needs to be added to gradle. properties under the project, as detailed in the demo: org. gradle. jvmargs=- Xmx1536M - Dfile. encoding=UTF-8-- add open=Java. base/Java. io=ALL UNNAMED

## 1.2.5
* Fix dialogHeight、alertCloseImageX、alertCloseImageY、alertCloseImageW、alertCloseImageH field

## 1.2.4
* Fix checkboxHidden field

## 1.2.3
* Update android sdk 为 2.13.5
* Update ios sdk 为 2.13.7
* Fix isLightColor field not taking effect -> Adjust parameters to lightColor

## 1.2.2
* Update android sdk 为 2.13.6
* Update ios sdk 为 2.13.7

## 1.2.1
* Update android sdk 为 2.13.5
* Update ios sdk 为 2.13.7
* Update web sdk 为 2.1.3

## 1.2.0
* Update Android SDK to 2.13.3
* Update iOS SDK to 2.13.3

## 1.1.9
* fix android sdk version

## 1.1.8
* Update iOS SDK to 2.13.2
* Update Android SDK to 2.13.2.1

## 1.1.7
* fix

## 1.1.6
* Update iOS SDK to 2.12.17.2
* Update Android SDK to 2.12.17.2

## 1.1.5
* Update iOS SDK to 2.12.16
* Update Android SDK to 2.12.16

## 1.1.4
* Update iOS SDK to 2.12.15
* Update Android SDK to 2.12.15
* Click on the non pop-up area in the authorization page pop-up mode to exit the authorization page.

## 1.1.3
* Whether to verify the protocol when clicking the switch button when adding iOS ->switchCheck
* Fix the newly added protocol text color parameter
* Removing Workflows Compilation Testing

## 1.1.2
* Update web sdk to 2.0.10
* Update iOS SDK to 2.12.14
* Update Android SDK to 2.12.14
* Authorization page operator agreement text color ->protocolOwnColor
* Authorization page agreement 1 text color ->protocolOwnOneColor
* Authorization page agreement 2 text color ->protocolOwnTwoColor
* Authorization page agreement 3 text color ->protocolOwnThreeColor
* Second authorization page agreement 1 text color ->privacyAlertOwnOneColor
* Second authorization page agreement 2 text color ->privacyAlertOwnTwoColor
* Second authorization page agreement 3 text color ->privacyAlertOwnThreeColor
* Second Authorization Page Operator Agreement Text Color ->PrivacyAlertOperatorColor
* Performance optimization
* Improve stability

## 1.1.1
* Update ios     sdk to 2.12.13.1
* Update android sdk to 2.12.13.1
* Performance optimization
* Improve stability
* fix setLoadingBackgroundPath -> setLogBtnBackgroundPath

## 1.1.0
* Update ios sdk to 2.12.12
* Add autoQuitPage
* Add isHideToast
* Add toastText
* Add toastBackground
* Add toastColor
* Add toastPadding
* Add toastMarginTop
* Add toastMarginBottom
* Add toastPositionMode
* Add toastDelay

## 1.0.9
* Update Android sdk to 2.12.11.2
* Update ios sdk to 2.12.11
* Upgrade fastjson to fix the vulnerability

## 1.0.8
* Check whether the function checkCellular DataEnable is enabled for the new cellular network
* fix _NSPlaceholderArray initWithObjects:count

## 1.0.7
* Fix iOS protocol problems
* Adding pause, resume, and remove events for listening
* Add whether multiple listeners are required according to conditions
* Fix the coordinate problem of switching other titles in iOS

## 1.0.6
* Update plug-in secondary authentication parameters (android completed)
* Fix the parameter configuration problem of iOS pop-up window and bottom pop-up window
* Upgrade Android compileSdkVersion to 33
* Add an Android return button to return to the desktop

## 1.0.5
* Update the android sdk to 2.12.9
* Update the ios sdk to 2.12.9
* Fix iOS protocol coordinates
* Optimize iOS initialization return and eliminate useless return
* Add (the video demonstrating the background restart of the APP includes getting normal when the network is disconnected) demo
* The second pop-up interface will be added in the next version

## 1.0.4

* Update Android SDK to 2.12.9
* Update IOS SDK to 2.12.9
* Fix IOS protocol coordinate problem
* Optimize IOS initialization return and remove useless return
* Add (the video that demonstrates the background restart of the app includes getting normal when the network is disconnected) demo
* The second pop-up interface will be added in the next version

## 1.0.4

* Fix the problem of clicking the desktop icon to restart after Android background
* Fix the problem of SDK version parameters returned from IOS and Android initial initialization
* Fix the inconsistency between IOS third-party layout buttons and Android effects
* The logbtntoasthidden parameter is unique to Android and has no effect on IOS
* Fix the problem that the authorization page is called directly when the plug-in initialization is updated again under the condition of delayed login
* New IOS third-party layout to add text

## 1.0.3
* Fix IOS dependency

## 1.0.2
* Update the Android download source to Alibaba cloud
* Update IOS repeated dependency

## 1.0.1

* Update Android SDK to 2.12.6.3
* Update IOS SDK to 2.12.6
* Fixed the problem of errors reported by some IOS users. Repeated introduction led to issues84

## 1.0.0

* Plug in refactoring

## 0.2.3

* Update Android SDK to 2.12.4
* Android SDK fixes the problem that the so file name is too long and crash occurs occasionally in the old version of the system
* Android SDK optimization protocol button tick experience
* Update IOS SDK to 2.12.4
* IOS SDK open license page protocol animation attribute (privacyanimation)
* The IOS SDK adds a user-defined protocol page to control privacyvciscustomized

## 0.2.2
* Fix Android pop-up and full screen configuration bug

## 0.2.1

* Fix the bug that the Android click user agreement is that the authorization page is closed
* Modify Android to enumeration
* Fix the bug that the page is closed when IOS switches operators

## 0.2.0

* Fix the problem that the page authorization page is closed when the Android end switches multiple boxes

## 0.1.9

* Prompt for modifying initialization
* Update Android SDK to 2.12.3.4

## 0.1.8

* Prompt for modifying initialization
* Update Android SDK to 2.12.3
* Update IOS SDK to 2.12.3.1

## 0.1.7

* Fix IOS no picture path error
* Fix IOS custom return button error
* Remove the parameter checkboximages. If necessary, use uncheckedimgpath instead of checkedimgpath parameter
* Update Android SDK to 2.12.1.4

## 0.1.6

* fix changeBtnIsHidden -> changeBtnTitle

## 0.1.5

* Fix the bug of no button image at IOS end
* Fix that the IOS side image does not display a bug

## 0.1.4

* When adding an immersive layout scheme, customize the return close button and the processing of the protocol page
* Update the IOS SDK version to 2.12.1.3

## 0.1.3

* add isHiddenCustom
* null-safety
* Update the IOS SDK version to 2.12.1
* Update the Android SDK version to 2.12.1

## 0.1.2

* Update the Android SDK version to 2.12.0.1
* Update the IOS SDK version to 2.12.0
* Optimize the default style and background mode of IOS one click login button

## 0.1.1

* Fix ios login Button Image Path In Dislog Model BUG

## 0.1.0

* Fix ios Close Button Image Path In Dislog Model BUG

## 0.0.9

* Fix android And iOS Inconsistency of return status code
* Fix some bugs

## 0.0.8

* Modify the situation that demo can not be connected to the Internet in the case of mobile card
* Update the Android SDK version to 2.11.1.1
* Update the IOS SDK version to 2.11.2

## 0.0.7

* Optimize IOS related

## 0.0.6

* Refactoring code, customizing all configuration parameters, unified monitoring return interface, more configuration, more possibilities, better custom layout, so that your requirements are not in a dilemma
* Remove the interface appleploginlisten and unify it to loginlisten
* Please refer to the interface file for details
* Android complete modification and document improvement

## 0.0.5

* Update the resource file of the new button because the SDK reduces unnecessary resource files
* Fix Android return data type as string when using the latest SDK

## 0.0.4

* Update the SDK to the latest version of 2.11.1
* Add code related comments
* The relevant listening interface should be adjusted as follows: loginlisten > appleploginlisten

## 0.0.3

* Update the SDK to the latest version of 2.10.0
* New notes and related descriptions

## 0.0.2

* iOS Development completed
  
## 0.0.1

* Android Development completed
