# Just another iOS project

Welcome to the **just another iOS swift** project.

### Tools & requirements

- Xcode 6.0 with iOS 8.0 SDK
- [Carthage](https://github.com/Carthage/Carthage) 0.5
- [CocoaPods](https://github.com/CocoaPods/CocoaPods) 0.36.0.rc1 or newer

### Configuration

Assuming the above tools are already installed, run the following commands after cloning the repository:

- `carthage update`
- `pod install`

### Coding guidelines

- Respect [Ray Wenderlich's Swift style guide](https://github.com/raywenderlich/swift-style-guide).
- Use [clang-format Xcode plugin](https://github.com/travisjeffery/ClangFormat-Xcode). Enable the "File" and "Format on save" options. 
- The code must be readable and self-explanatory - full variable names, meaningful methods, etc.
- Write documentation comments in header files **only when needed** (eg. hacks, tricky parts).
- **Write tests** for every bug you fix and every feature you deliver.
- **Don't leave** any commented-out code.
- Don't use pure `#pragma message` for warnings. Use the `NGRTemporary` and `NGRWorkInProgress` macros accordingly.
- Use **feature flags** (located in `Project-Features.h` file) for enabling or disabling major features.

### Workflow

- Always hit ⌘U (Product → Test) before committing.
- Always commit to master. No remote branches, forks and pull requests.
- Wait for CI build to succeed before delivering a Pivotal story.
- Use `[ci skip]` in the commit message just for non-code changes.

### Push notifications

Use [Houston gem](https://github.com/nomad/Houston) for dealing with push notifications.

### Examples

#### Good commit message

```none
Fix foo in bar using baz

[#12345678]
[0a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b]
```

#### Correct push notification format

```js
{
   'aps': {
       'alert': 'Title string',
       // ...
   },
   'url': 'project://uri',
   // ...
}
```

#### Sending a notification from command-line

```bash
$ gem install houston
$ apn push "<device_registration_token>" \
   -c project_apn.pem \
   -m "Notification Title"
```

#### Sending push notifications from ruby

```ruby
# push.rb
require 'houston'

APN = Houston::Client.development
APN.certificate = File.read("/path/to/apple_push_notification.pem")

token = "<device_registration_token>" # Find in Installations table

notification = Houston::Notification.new(device: token)
notification.alert = "Hello, World!"
notification.badge = 57
notification.content_available = true
notification.custom_data = {
  url: 'project://uri'
}

APN.push(notification)
```

```bash
$ gem install houston
$ ruby push.rb
```
