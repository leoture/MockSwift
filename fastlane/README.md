fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew cask install fastlane`

# Available Actions
## Mac
### mac spm_tests
```
fastlane mac spm_tests
```
Run Swift Package Manager tests
### mac spm_linux_tests
```
fastlane mac spm_linux_tests
```
Run Swift Package Manager tests on linux
### mac mockswift_package_tests
```
fastlane mac mockswift_package_tests
```
Run MockSwift-Package tests
### mac mockswift_example_tests
```
fastlane mac mockswift_example_tests
```
Run MockSwiftExample tests
### mac mac_tests
```
fastlane mac mac_tests
```
Run mac tests
### mac all_tests
```
fastlane mac all_tests
```
Run mac & linux tests

----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
