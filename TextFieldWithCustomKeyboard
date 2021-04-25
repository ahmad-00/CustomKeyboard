//  Created by Ahmad Mohammadi on 4/26/21.
//

import SwiftUI
import Combine

struct TextFieldWithCustomKeyboard: UIViewRepresentable {

    private var textField = UITextField()
    private var placeholder: String
    @Binding private var text: String
    
    init(_ placeholder: String, text: Binding<String>) {
        self.placeholder = placeholder
        self._text = text
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(textField: self.textField, text: self._text)
    }
    
    func makeUIView(context: Context) -> UITextField {
        textField.inputView = CustomKeyboard(target: textField)
        textField.delegate = context.coordinator
        return textField
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        textField.text = uiView.text
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        private var dispose = Set<AnyCancellable>()
        @Binding var text: String

        init(textField: UITextField, text: Binding<String>) {
          self._text = text
          super.init()

          NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: textField)
            .compactMap { $0.object as? UITextField }
            .compactMap { $0.text }
            .receive(on: RunLoop.main)
            .assign(to: \.text, on: self)
            .store(in: &dispose)
        }
        
    }
    
}
