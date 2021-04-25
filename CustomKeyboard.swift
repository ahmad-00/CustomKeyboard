//  Created by Ahmad Mohammadi on 4/23/21.
//
import UIKit

class CustomKeyboard: UIView {
    weak var target   : (UIKeyInput & UIResponder)?
    
    private var customButtonsCharKeyboard = [[CustomButton]]()
    
    private lazy var capsLockButton: CustomButton = {
        let button = CustomButton(title1: "\u{21EA}",
                                  title2: "#+=",
                                  title3: "123",
                                  theme: selectedTheme)
        button.updateTitle()
        button.addTarget(self, action: #selector(didTapCapsLockButton(_:)), for: .touchUpInside)
        button.addTarget(self, action: #selector(didTouchDownButton(_:)), for: .touchDown)
        
        return button
    }()
    
    private lazy var deleteButton: CustomButton = {
        let button = CustomButton(title1: "⌫",
                                  title2: "⌫",
                                  title3: "⌫",
                                  theme: selectedTheme)
        button.updateTitle()
        button.addTarget(self, action: #selector(didTapDeleteButton(_:)), for: .touchUpInside)
        button.addTarget(self, action: #selector(didTouchDownButton(_:)), for: .touchDown)
        return button
    }()
    
    private lazy var returnButton: CustomButton = {
        let button = CustomButton(title1: "return",
                                  title2: "return",
                                  title3: "return",
                                  theme: selectedTheme)
        button.updateTitle()
        button.addTarget(self, action: #selector(didTapReturnButton(_:)), for: .touchUpInside)
        button.addTarget(self, action: #selector(didTouchDownButton(_:)), for: .touchDown)
        return button
    }()
    
    private lazy var spaceButton: CustomButton = {
        let button = CustomButton(title1: "space",
                                  title2: "space",
                                  title3: "space",
                                  theme: selectedTheme)
        button.updateTitle()
        button.addTarget(self, action: #selector(didTapSpaceButton(_:)), for: .touchUpInside)
        button.addTarget(self, action: #selector(didTouchDownButton(_:)), for: .touchDown)
        return button
    }()
    
    private lazy var emojiButton: CustomButton = {
        let button = CustomButton(title1:"😃",
                                  title2: "😃",
                                  title3: "😃",
                                  theme: selectedTheme)
        button.updateTitle()
        button.addTarget(self, action: #selector(didTapEmojiButton(_:)), for: .touchUpInside)
        button.addTarget(self, action: #selector(didTouchDownButton(_:)), for: .touchDown)
        return button
    }()
    
    private lazy var numPadButton: CustomButton = {
        let button = CustomButton(title1: "123",
                                  title2: "ABC",
                                  title3: "ABC",
                                  theme: selectedTheme)
        button.updateTitle()
        button.addTarget(self, action: #selector(didTapNumPadButton(_:)), for: .touchUpInside)
        button.addTarget(self, action: #selector(didTouchDownButton(_:)), for: .touchDown)
        return button
    }()
    
    private var mainStack: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        stackView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        stackView.axis = .vertical
        return stackView
    }()
    
    private var resignOnReturnTap: Bool
    
    private var selectedTheme: Theme = .Light
    
    private var layoutState = KeyboardLayoutState.AlphabeticLowerCase {
        didSet {
            updateKeyboardLayout()
        }
    }
    
    init(target: (UIKeyInput & UIResponder),
         resignOnReturnTap: Bool = true,
         appearance: CustomKeyboardAppearance = .Auto) {
        self.target = target
        self.resignOnReturnTap = resignOnReturnTap
        super.init(frame: .zero)
        switch appearance {
        case .Light:
            selectedTheme = .Light
            break
        case .Dark:
            selectedTheme = .Dark
            break
        case .Auto:
            if traitCollection.userInterfaceStyle == .light {
                selectedTheme = .Light
            } else {
                selectedTheme = .Dark
            }
            break
        }
        createCustomButtonsChars()
        configure()
    }
    
    private var customButtonsCharRow1 = [CustomButton]()
    private var customButtonsCharRow2 = [CustomButton]()
    private var customButtonsCharRow3 = [CustomButton]()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

    //MARK:- Custom Button Init

fileprivate class CustomButton: UIButton {
    var title1 = String()
    var title2 = String()
    var title3 = String()
    
    var currentValue = String()
    
    func updateTitle(state: ButtonTitleState = .first) {
        switch state {
        case .first:
            currentValue = title1
            self.setTitle(title1, for: .normal)
        case .second:
            currentValue = title2
            self.setTitle(title2, for: .normal)
        case .third:
            currentValue = title3
            self.setTitle(title3, for: .normal)
        }
    }
    
    func toUppercase() {
        title1 = title1.uppercased()
    }
    
    func toLowercase() {
        title1 = title1.lowercased()
    }
    
    private var theme : Theme
    
    init(title1: String, title2: String, title3: String, theme: Theme) {
        self.theme = theme
        super.init(frame: CGRect.zero)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        self.titleLabel?.adjustsFontSizeToFitWidth = true
        
        self.title1 = title1
        self.title2 = title2
        self.title3 = title3
        
        switch theme {
        case .Light:
            self.setTitleColor(.gray, for: .normal)
        case .Dark:
            self.setTitleColor(.white, for: .normal)
        }
        self.accessibilityTraits = [.keyboardKey]
        updateTitle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let colors = getGradientColor(for: theme)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colors.0, colors.1]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.bounds
        gradientLayer.cornerRadius = 10
        gradientLayer.masksToBounds = true
            
        self.layer.insertSublayer(gradientLayer, at:0)
        
        self.layer.shadowColor   = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.15
        self.layer.shadowOffset  = CGSize(width: 0.0, height : 0.4)
        self.layer.shadowRadius  = 4
        
    }
    
    private func getGradientColor(for appearance: Theme) -> (CGColor, CGColor) {

        let lightTopColor = UIColor(red: 243.0/255.0, green: 245.0/255.0, blue: 247.0/255.0, alpha: 1.0).cgColor
        let lightBottomColor = UIColor(red: 225.0/255.0, green: 229.0/255.0, blue: 234.0/255.0, alpha: 1.0).cgColor
        let darkTopColor = UIColor(red: 48.0/255.0, green: 55.0/255.0, blue: 62.0/255.0, alpha: 1.0).cgColor
        let darkBottomColor = UIColor(red: 29.0/255.0, green: 31.0/255.0, blue: 37.0/255.0, alpha: 1.0).cgColor

        switch appearance {
        case .Light:
            return (
                lightTopColor,
                lightBottomColor
            )
        case .Dark:
            return (
                darkTopColor,
                darkBottomColor
            )
        }
    }
    
}
    

    // MARK: - Tap Actions

fileprivate extension CustomKeyboard {
    @objc func didTapButton(_ sender: CustomButton) {
        sender.layer.shadowColor = UIColor.black.cgColor
        insert(sender.currentValue)
    }
    
    @objc func didTouchDownButton(_ sender: CustomButton) {
        sender.layer.shadowColor = UIColor.clear.cgColor
    }
    
    @objc func didTapDeleteButton(_ sender: CustomButton) {
        sender.layer.shadowColor = UIColor.black.cgColor
        
        if let targetTextInput = target as? UITextInput {
            let selectedTextRange = targetTextInput.selectedTextRange
            if let selectedTextRange = selectedTextRange {
                // Calculate the selected text to delete
                let startPosition = targetTextInput.position(from: selectedTextRange.start, offset: -1)
                if startPosition == nil {
                    return
                }
                let endPosition = selectedTextRange.end
                var rangeToDelete: UITextRange? = nil
                if let startPosition = startPosition {
                    rangeToDelete = targetTextInput.textRange(
                        from: startPosition,
                        to: endPosition)
                }

                textInput(targetTextInput, replaceTextAt: rangeToDelete, with: "")
            }
        }
    }
    
    @objc func didTapReturnButton(_ sender: CustomButton) {
        sender.layer.shadowColor = UIColor.black.cgColor
        if resignOnReturnTap {
            target?.resignFirstResponder()
        } else {
            insert("\n")
        }
    }
    
    @objc func didTapSpaceButton(_ sender: CustomButton) {
        sender.layer.shadowColor = UIColor.black.cgColor
        insert(" ")
    }
    
    @objc func didTapCapsLockButton(_ sender: CustomButton) {
        sender.layer.shadowColor = UIColor.black.cgColor
        
        switch layoutState {
        case .AlphabeticLowerCase:
            layoutState = .AlphabeticUpperCase
            break
        case .AlphabeticUpperCase:
            layoutState = .AlphabeticLowerCase
            break
        case .NumChar1:
            layoutState = .NumChar2
            break
        case .NumChar2:
            layoutState = .NumChar1
            break
        }
        
    }
    
    @objc func didTapNumPadButton(_ sender: CustomButton) {
        sender.layer.shadowColor = UIColor.black.cgColor
        
        switch layoutState {
        case .AlphabeticLowerCase:
            layoutState = .NumChar1
            break
        case .AlphabeticUpperCase:
            layoutState = .NumChar1
            break
        case .NumChar1:
            layoutState = .AlphabeticLowerCase
            break
        case .NumChar2:
            layoutState = .AlphabeticLowerCase
            break
        }

    }
    
    @objc func didTapEmojiButton(_ sender: CustomButton) {
        sender.layer.shadowColor = UIColor.black.cgColor
    }
    
    private func insert(_ text: String) {
        if let targetTextInput = target as? UITextInput {
            let numberPressed = text
            if numberPressed.count > 0 {
                let selectedTextRange = targetTextInput.selectedTextRange
                if let selectedTextRange = selectedTextRange {
                    textInput(targetTextInput, replaceTextAt: selectedTextRange, with: numberPressed)
                }
            }
        }
    }
}


// MARK: - Private Keyboard Configuration

fileprivate extension CustomKeyboard {
    
    private func createCustomButtonsChars() {
        
        customButtonsCharRow1 = [
            ("q","1","["),
            ("w","2","]"),
            ("e","3","{"),
            ("r","4","}"),
            ("t","5","#"),
            ("y","6","%"),
            ("u","7","^"),
            ("i","8","*"),
            ("o","9","+"),
            ("p","0","=")
        ].map {return createCustomButton(with: $0.0, $0.1, $0.2)}
        
        customButtonsCharRow2 = [
            ("a","-","_"),
            ("s","/","\\"),
            ("d",":","|"),
            ("f",";","~"),
            ("g","(","<"),
            ("h",")",">"),
            ("j","$","€"),
            ("k","&","￡"),
            ("l","@","￥")
        ].map {return createCustomButton(with: $0.0, $0.1, $0.2)}
        
        customButtonsCharRow3 = [("z",".","."),
                                 ("x",",",","),
                                 ("c","?","?"),
                                 ("v","!","!"),
                                 ("b","‘","‘"),
                                 ("n","“","“"),
                                 ("m","•","•")
        ].map {return createCustomButton(with: $0.0, $0.1, $0.2)}
        customButtonsCharRow3.insert(capsLockButton, at: 0)
        customButtonsCharRow3.append(deleteButton)
        let customButtonsCharRow4 = [numPadButton, spaceButton, returnButton]
        
        customButtonsCharKeyboard = [
            customButtonsCharRow1,
            customButtonsCharRow2,
            customButtonsCharRow3,
            customButtonsCharRow4
        ]
        
        _ = customButtonsCharRow4.map{$0.translatesAutoresizingMaskIntoConstraints = false}
        
    }
    
    func configure() {
        switch selectedTheme {
        case .Light:
            self.backgroundColor = UIColor(red: 221/255, green: 225/255, blue: 231/255, alpha: 1)
        case .Dark:
            self.backgroundColor = UIColor(red: 21/255, green: 31/255, blue: 37/255, alpha: 1)
        }
        
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        buildKeyboard()
    }
    
    func buildKeyboard() {
        mainStack.frame = bounds
        addSubview(mainStack)
        
        mainStack.addArrangedSubview(createHStack(buttons: customButtonsCharKeyboard[0]))
        mainStack.addArrangedSubview(createHStack(buttons: customButtonsCharKeyboard[1]))
        mainStack.addArrangedSubview(createHStack(buttons: customButtonsCharKeyboard[2]))
        mainStack.addArrangedSubview(createHStack(buttons: customButtonsCharKeyboard[3], distribution: .equalSpacing))
        
        NSLayoutConstraint.activate([
            numPadButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.125),
//            emojiButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.125),
            spaceButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.55),
            returnButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.225)
        ])
    }
    
    func createHStack(buttons: [CustomButton], distribution: UIStackView.Distribution = .fillEqually) -> UIStackView{
        let st = UIStackView()
        st.axis = .horizontal
        st.distribution = distribution
        st.spacing = 4
        for btn in buttons {
            st.addArrangedSubview(btn)
        }
        return st
    }
    
    func createCustomButton(with title1: String, _ title2: String, _ title3: String) -> CustomButton {
        let button = CustomButton(title1: title1,
                                  title2: title2,
                                  title3: title3,
                                  theme: selectedTheme)
        button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        button.addTarget(self, action: #selector(didTouchDownButton(_:)), for: .touchDown)
        return button
    }
    
    func updateButtonsTitle(to titleState: ButtonTitleState) {
        _ = customButtonsCharRow1.map {$0.updateTitle(state: titleState)}
        _ = customButtonsCharRow2.map {$0.updateTitle(state: titleState)}
        _ = customButtonsCharRow3.map {$0.updateTitle(state: titleState)}
        capsLockButton.updateTitle(state: titleState)
        deleteButton.updateTitle(state: titleState)
        numPadButton.updateTitle(state: titleState)
    }
    
    func updateKeyboardLayout() {
        
        switch layoutState {
        case .AlphabeticLowerCase:
            _ = customButtonsCharRow1.map  {
                $0.updateTitle(state: .first)
                $0.toLowercase()
            }
            _ = customButtonsCharRow2.map  {
                $0.updateTitle(state: .first)
                $0.toLowercase()
            }
            _ = customButtonsCharRow3.map  {
                $0.updateTitle(state: .first)
                $0.toLowercase()
            }
            capsLockButton.updateTitle(state: .first)
            deleteButton.updateTitle(state: .first)
            numPadButton.updateTitle(state: .first)
            break
        case .AlphabeticUpperCase:
            _ = customButtonsCharRow1.map {
                $0.updateTitle(state: .first)
                $0.toUppercase()
            }
            _ = customButtonsCharRow2.map  {
                $0.updateTitle(state: .first)
                $0.toUppercase()
            }
            _ = customButtonsCharRow3.map  {
                $0.updateTitle(state: .first)
                $0.toUppercase()
            }
            capsLockButton.updateTitle(state: .first)
            deleteButton.updateTitle(state: .first)
            numPadButton.updateTitle(state: .first)
            break
        case .NumChar1:
            updateButtonsTitle(to: .second)
            break
        case .NumChar2:
            updateButtonsTitle(to: .third)
            break
        }
        
    }
    
    func textInput(_ textInput: UITextInput?, shouldChangeCharactersIn range: NSRange, with string: String?) -> Bool {
        if let textInput = textInput {
            if textInput is UITextField {
                let textField = textInput as? UITextField
                if textField?.delegate?.responds(to: #selector(UITextFieldDelegate.textField(_:shouldChangeCharactersIn:replacementString:))) ?? false {
                    if let textField = textField {
                        if textField.delegate?.textField?(
                            textField,
                            shouldChangeCharactersIn: range,
                            replacementString: string ?? "") ?? false {
                            return true
                        }
                    }
                } else {
                    // Delegate does not respond, so default to YES
                    return true
                }
            } else if textInput is UITextView {
                let textView = textInput as? UITextView
                if textView?.delegate?.responds(to: #selector(UITextViewDelegate.textView(_:shouldChangeTextIn:replacementText:))) ?? false {
                    if let textView = textView {
                        if textView.delegate?.textView?(
                            textView,
                            shouldChangeTextIn: range,
                            replacementText: string ?? "") ?? false {
                            return true
                        }
                    }
                } else {
                    // Delegate does not respond, so default to YES
                    return true
                }
            }
        }
        return false
    }
    
    func textInput(_ textInput: UITextInput?, replaceTextAt textRange: UITextRange?, with string: String?) {
        if let textInput = textInput {
            if let textRange = textRange {
                // Calculate the NSRange for the textInput text in the UITextRange textRange:
                let startPos = textInput.offset(
                    from: textInput.beginningOfDocument,
                    to: textRange.start)
                let length = textInput.offset(
                    from: textRange.start,
                    to: textRange.end)
                let selectedRange = NSRange(location: startPos, length: length)

                if self.textInput(textInput, shouldChangeCharactersIn: selectedRange, with: string) {
                    // Make the replacement:
                    textInput.replace(textRange, withText: string ?? "")
                }
            }
        }
    }
    
}


    //MARK: - Enums

enum CustomKeyboardAppearance {
    case Auto
    case Light
    case Dark
}

fileprivate enum ButtonTitleState: Int {
    case first = 1
    case second = 2
    case third = 3
}

fileprivate enum Theme {
    case Dark
    case Light
}

fileprivate enum KeyboardLayoutState {
    case AlphabeticLowerCase
    case AlphabeticUpperCase
    case NumChar1
    case NumChar2
}
