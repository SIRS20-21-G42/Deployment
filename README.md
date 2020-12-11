# Deployment

Here we present the instructions to correctly setup our environment, as well as some requirements and
options.

## Requirements
To run the CA, WebApp and Auth Server modules, all we need is `docker` and `docker-compose` installed.

To build the Mobile App (SIRSApp), we have 2 options:
1. Use Android Studio (and download everything from there)
   - We need to select at least Android SDK 8.0 (API level 26) and download it (through Android Studio)
   - Optionally we can also download and install the Android Emulator
2. Manually compile the apk
   In this case we are going to need:
       - Android SDK 8.0 (API level 26) at least
       - gradle
       - adb
       - Android Emulator (optional - can be replaced with a VM with Android x86, or even a smartphone with
       at least Android 8.0)

## Certificate/Key Distribution
When running this environment, we suppose that all keys and certificates are already distributed in this way:
- Web App has CA's (root) certificate, private key, certificate signed by the CA and Auth Server's certificate
  - Directory: `WebApp/facefive/app/auth/`
    - CA's certificate filename:          `CA.cert`
    - Private key's filename:             `FaceFive.key`
    - Own certificate's filename:         `FaceFive.cert`
    - Auth Server's certificate filename: `AUTH.cert`

- Auth Server has CA's (root) certificate, private key, certificate signed by the CA and Web App's certificate
  - Directory: `AuthServer/auth/app/`
    - CA's certificate filename:     `CA.cert`
    - Private key's filename:        `AUTH.key`
    - Own certificate's filename:    `AUTH.cert`
    - Web App's certificatefilename: `FaceFive.cert`

- CA has its own certificate, private key and the certificates it signed
  - Directory: `CA/files/CA/`
    - Private key's filename: `priv.key`
  - Directory: `CA/files/PUBLIC/`
    - Own certificate's filename: `CA.cert`
    - Public key's filename (optional): `pub.key`
  - Directory: `CA/files/CERTIFICATES/`
      Contains all signed certificates, with filename `<org>.cert` where `<org>` is the Organization Name in the CSR

- Mobile App has CA's (root) certificate and Auth Server's certificate
  - Directory: `MobileApp/app/src/main/res/raw/`
    - CA's certificate filename:          `ca.crt`
    - Auth Server's certificate filename: `auth.crt`

By default, CA's private key has a password which is `1234`. Since this is a weak password, it is only suitable for
demonstration purposes, so, we are able to change it by editing the environment variable `CA_PASS` inside the `Dockerfile`

We provide some example certificates and keys that should be used only for demonstration purposes. They are located
in the `resources` folder, with the names mentioned above (except for the app, that already has the certificates builtin).

Although we suppose this keys/certificates are already generated, we can generate them everytime the environment is
started (the environment only generates what it needs). The CA has persistence, so if the environment is run 2 times
in a row without cleaning at least the Web App and Auth Server's certificates, it won't work. We need to either
clean the aforementioned certificates or put them (along with the private keys) in the needed folders (by acessing
the containers and getting the files).

The Mobile App doesn't get the certificates it needs automatically, so we need to start the environment and get both
the CA and Auth Server's certificate (we can get them in by accessing the path mentioned above, where CA stores the
signed certificates) and place them in the path mentioned above.

## How to build
### Mobile App

**NOTE:** The build instructions are for the debug version of the apk. In order to build the release version,
the steps are very similar, but the apk needs to be signed before it is installed in the device.

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

`./gradlew assembleDebug`

and the `.apk` file will be generated in `app/build/outputs/apk/debug/` with name `app-debug.apk`

### CA, Auth Server and Web App
Build is automatic, just launch container

## How to install
### MobileApp

#### Emulator

The following command must be enough to install the app:

`adb install MobileApp/app/build/outputs/apk/debug/app-debug.apk`

otherwise, list the devices and connect directly to it.

#### VM
With the VM with its interface bridged, run (in the host machine):

`adb connect <IP>:5555`

and then to install run:

`adb install MobileApp/app/build/outputs/apk/debug/app-debug.apk`

### CA, Auth Server and Web App
No need to install


The environment is now setup and ready to run, if no errors occurred

**P.S:** the file named `upload.sh` can be used to push images (QRCodes) to the VM/Emulator to be used in the application
