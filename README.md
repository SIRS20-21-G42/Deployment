# Deployment

## Requirements
To run the CA, WebApp and Auth Server modules, all we need is `docker` and `docker-compose` installed.

To build the Mobile App (SIRSApp), we have 2 options:
1. Use Android Studio (and download everything from there)
   - We need to select Android SDK 8.0 (API level 26) and download it (through Android Studio)
   - Optionally we can also download and install the Android Emulator
2. Manually compile the apk
   In this case we are going to need:
       - Android SDK 8.0 (API level 26)
       - gradle
       - adb
       - Android Emulator (optional - can be replaced with a VM with Android x86)


## How to build
### Mobile App
#### Android Studio build
Launch Android Studio and click `Ctrl+F9` to start the building process.
The emulator should launch and after a few seconds/minutes the app will be compiled.

(The installation step can be skipped if instead of `Ctrl+F9`, `Shift+F10` is clicked, automatically launching the app afterwards)

#### Manual build
To build the Mobile App, we need to get to the root of the folder containing the source for this module (`MobileApp`).
Then we run:

`gradle wrapper`

After this, depending on wether we chose the emulator or the VM, we can have different ways to build it.
If we chose the emulator and want to build and install the app in one step, we launch the emulator and then run:
(only with Debug version. We have to follow the other method to run the release version)

`./gradlew installDebug`

Otherwise, we run

`./gradlew assemble`

and the `.apk` file will be generated in `app/build/outputs/apk/release/` with name `app-release-unsigned.apk`

### CA, Auth Server and Web App
Build is automatic, just launch container

## How to install
