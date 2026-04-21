# Implementing a Distributed Email Application Based on Application Continuation

## Overview

This codelab implements a distributed email application based on features such as application continuation and distributed data objects. You will learn how to implement the following features:
1. Data transmission across devices by using distributed data objects
2. Application continuation and data transmission by tapping the Dock bar

## Effect

<img src="./screenshots/devices/email.en.gif" width="300"> 

## How to Use

1. On the application home page, enter the recipient, sender, and subject in the text boxes.
2. Open the distributed mail application on your local device. The distributed mail application icon will appear on the Dock of your peer device. Click the application icon, and you can continue with operations in the app on your peer device.
## Project Directory

```
├──entry/src/main/ets 
│  ├──entryability 
│  │  └──EntryAbility.ets              // Entry ability 
│  ├──pages 
│  │  └──MailHomePage.ets              // Mail home page 
│  └──utils 
│     └──MailInfoManager.ets           // Mail information management class 
└──entry/src/main/resources            // Resource files
```

## How to Implement

1. Set the continuable tag in src/main/module.json5 to true. The default value is false.
2. Call [distributedDataObject.create()](https://developer.huawei.com/consumer/en/doc/harmonyos-references/js-apis-data-distributedobject#distributeddataobjectcreate9) API to create a distributed data object, and fill the data to be migrated into the distributed data object.
3. Call [distributedDataObject.genSessionId()](https://developer.huawei.com/consumer/en/doc/harmonyos-references/js-apis-data-distributedobject#distributeddataobjectgensessionid) to generate a session ID for the distributed data object, and call [setSessionId()](https://developer.huawei.com/consumer/en/doc/harmonyos-references/js-apis-data-distributedobject#setsessionid9) with this ID to add the device to the network and activate the distributed data object.
4. Call [distributedDataObject.save()](https://developer.huawei.com/consumer/en/doc/harmonyos-references/js-apis-data-distributedobject#save9) API to persist the activated distributed data object.
5. Call [setMissionContinueState()](https://developer.huawei.com/consumer/en/doc/harmonyos-references/js-apis-inner-application-uiabilitycontext#setmissioncontinuestate10) to set the migration status to ACTIVE, and create an empty distributed data object for receiving data to be restored.
6. Read the networking ID of the distributed data object from want, and call [setSessionId()](https://developer.huawei.com/consumer/en/doc/harmonyos-references/js-apis-data-distributedobject#setsessionid9) with this ID to add the device to the network and activate the distributed data object.
7. Register on() to listen for data changes. In the callback of the event whose status is restore, the basic email information saved when device A exits is obtained through the distributed data object and saved in the AppStorage for device B to obtain.
8. Manually load the page to be restored in the [onWindowStageRestore()](https://developer.huawei.com/consumer/en/doc/harmonyos-references/js-apis-app-ability-abilitylifecyclecallback#onwindowstagerestore12) lifecycle.

## Required Permissions

N/A.

## Constraints

1. This sample is only supported on Huawei phones running standard systems.
2. The HarmonyOS version must be HarmonyOS 5.0.5 Release or later.
3. The DevEco Studio version must be DevEco Studio 6.0.2 Release or later.
4. The HarmonyOS SDK version must be HarmonyOS 6.0.2 Release SDK or later.
5. Both devices must be logged in with the same HUAWEI ID.
6. Wi-Fi and Bluetooth must be enabled on both devices. If possible, both devices should be connected to the same LAN to improve the data transmission speed.
7. Application continuation can be triggered only between the same application (UIAbility) of both devices, that is, the application must have been installed on the two devices.
