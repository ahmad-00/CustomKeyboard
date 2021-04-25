# CustomKeyboard
Fully customized in app custom Keyboard

# Usage - UIKit
Just copy CustomKeyboard.swift to your project. 
for any textfield that you want to have custome keyboard add the following line:

```swift
let textfield = UITextField()
textfield.inputView = CustomKeyboard(target: textfield)
```

# Usage - SwiftUI
Copy CustomKeyboard.swift & TextFieldWithCustomKeyboard.swift to your project. 
instead of TextField use TextFieldWithCustomKeyboard.
