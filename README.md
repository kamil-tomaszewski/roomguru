# Roomguru

Roomguru is an open source app for managing meetings in your busy working day. It uses Google resource calendars for representing rooms. Google account is required to authenticate with application. Google app has to be created in Google apps to obtain application identifier.

You can also read our blog post [Introducing: Roomguru Open Source Swift App](https://netguru.co/blog/roomguru-open-source-swift)!

App is under MIT [license](https://github.com/netguru/roomguru/blob/master/LICENSE.md).

## Requirements

Roomguru requires Google app set up in Google apps service. You will also need [resource calendars](https://support.google.com/a/answer/1686462?hl=en) to use this app.

## Configuration

All you have to do to build & run Roomguru is to follow 9 simple steps:

1. Clone project `git clone https://github.com/netguru/roomguru.git`.
2. Create the Google Developers Console project according to [step 1](https://developers.google.com/+/mobile/ios/getting-started). Bundle ID depends on project build configuration:
	- Staging: `co.netguru.roomguru.staging`
	- Development: `co.netguru.roomguru`
	- Production: `co.netguru.roomguru`
	- Test: `co.netguru.roomguru`

	If you wish to change it, go to Roomguru target: `Build settings` -> `User Defined` -> `BUNDLE_ID`.

3. Copy `Constants_Sample.swift` as `Constants.swift` in project root directory: `cd Roomguru/Source\ Files/ && cp Constants_Sample.swift Constants.swift`
4. Rename struct within `Constants.swift` file to `Constants`. You can remove `Constants_Sample.swift` now.
5. If you want store keys on your own repository, remove `Constants.swift` from `.gitignore`.
6. Copy received `ClientID` from Google and paste it to `Constants` -> `GooglePlus` -> `ClientID`.
7. If you wish to distribute Roomguru via [HockeyApp](https://rink.hockeyapp.net/) copy `App ID` from Hockey and paste to `Constants` -> `HockeyApp` -> `ClientID`.
8. Run `carthage update` and `pod install`.
9. Build & Run. Enjoy!

## Distribution

We're not providing any distribution channel for Roomguru. If you want to use our app in your team, we have nothing against it, however we can't provide you with any service to distribute it.

We recommend to use [Hockey App](http://hockeyapp.net), [Testflight](https://developer.apple.com/testflight/) or [Apple Enterprise accounts](https://developer.apple.com/programs/ios/enterprise/). You can also install Roomguru on your colleagues' devices using Xcode - the hard way.

## Contribution

You're more than welcome to contribute. Report issue if you:
* found a problem,
* want to ask question,
* have improvement proposal.

## Authors

* [Patryk Kaczmarek](https://github.com/PatrykKaczmarek)
* [Radosław Szeja](https://github.com/rad3ks)
* [Aleksander Popko](https://github.com/APbjj)
* [Wojciech Trzasko](https://github.com/WojciechTrzasko)

Copyright © 2014 - 2015 [Netguru](https://netguru.co)
