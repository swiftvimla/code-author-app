//
//  ContentView.swift
//  vimla-code-author-app
//
//  Created by Jonatan Sundqvist on 2019-10-18.
//  Copyright © 2019 Jonatan Sundqvist. All rights reserved.
//

import SwiftUI
import AppKit

// Apparently required for the previews to work
extension Character: ExpressibleByStringLiteral {
  public init(stringLiteral value: StringLiteralType) {
    self.init(value)
  }
}

struct SearchProjectTextFieldStyle: TextFieldStyle {
  func _body(configuration: TextField<Self._Label>) -> some View {
    configuration
      .font(.system(size: 42, weight: .heavy, design: .default))
  }
}

struct QuitButton: View {
  var close: () -> Void
  var body: some View {
    Button(action: {
      self.close()
    }, label: { Text("quit").foregroundColor(.gray) }).keyboardShortcut(.cancelAction)
  }
}

class Model: ObservableObject {
  @Published var projects: [Project] = loadProjects(from: UserDefaults.vimlaURL)!
}

@available(macOS 11.0, *)
struct SearchProjects: View {
  var close: () -> Void
  @State var searchText: String = ""
  @State var selected: Set<URL> = Set()
  @EnvironmentObject var model: Model
  //    var projects: [Project]
  
  init(close: @escaping () -> Void, within directory: URL) {
    self.close = close
  }
  
  var searchResults: [Project] {
    self.model.projects.filter { $0.label.contains(self.searchText) }
  }
  
  var body: some View {
    VStack {
//      TODO: When macOS 12 launches, we'll get rid of AutofocusTextField and use .focused instead!
      AutofocusTextField(text: self.$searchText)
//      TextField("Search for a project", text: self.$searchText)
        .font(.largeTitle.weight(.heavy))
        .overlay(QuitButton(close: { self.close() }).padding(), alignment: Alignment(horizontal: .trailing, vertical: .center))
        .padding()
      List(self.searchResults, id: \.self, selection: self.$selected) { (project: Project) in
        //                Image(systemSymbolName: "hammer", accessibilityDescription: nil)
        Image(systemName: "hammer")
        Button(
          action: { openProject(at: project.root); self.close() },
          label: { Text("OPEN") })
        Button(
          action: { openTerminal(at: project.root); self.close() },
          label: { Text("TERMINAL") })
        Text(project.activeBranch ?? "<no branch>")
          .foregroundColor(.white)
          .padding([.leading, .trailing], 8)
          .padding([.top, .bottom], 3)
          .fixedSize(horizontal: true, vertical: true)
          .background(
            RoundedRectangle(cornerRadius: 6)
              .fill()
              .foregroundColor(.blue)
          )
          .frame(minWidth: 100, alignment: .leading)
        Text(project.label)
          .font(.system(size: 18, weight: .light, design: .rounded))
          .padding()
      }
      .focusable()
      .listStyle(DefaultListStyle())
      .frame(height: 220, alignment: .center)
    }
    .frame(minWidth: 500)
  }
}

@available(macOS 11.0, *)
struct ContentView: View, DropDelegate {
  @State var text: String = ""
  
  func performDrop(info: DropInfo) -> Bool {
    print("Da, dropski boppsky")
    print(info)
    return true
  }
  
  var body: some View {
    HSplitView {
      HStack {
        Image(nsImage: #imageLiteral(resourceName: "heisenberg"))
          .resizable()
          .aspectRatio(contentMode: ContentMode.fit)
          .mask(Circle())
          .shadow(radius: 2)
        Text("Werner von Heisenberg (developer)")
          .frame(maxWidth: .infinity, maxHeight: .infinity)
      }.background(Color.green)
      Text("Jonatan Sundqvist (developer)")
        .frame(maxWidth: .infinity, maxHeight: .infinity)
      TextEditor(text: self.$text)
    }.touchBar {
      Button(action: { print("Hello World") }, label: { Text("Press") })
    }
    .onDrop(of: [.text], delegate: self)
  }
}

class C: NSTextField {
  init() {
    super.init(frame: .zero)
    
    self.focusRingType = .none
    self.isBordered = false
    self.placeholderString = "Search for projects"
    self.drawsBackground = false
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

struct AutofocusTextField: NSViewRepresentable {
  static let font: NSFont? = NSFont(name: "Helvetica", size: 42)
  @Binding var text: String
  func makeNSView(context: NSViewRepresentableContext<AutofocusTextField>) -> NSTextField {
    print("Creating new textfield")
    var tf = C()
    tf.delegate = context.coordinator
    print(context.environment.font)
    tf.font = AutofocusTextField.font
    DispatchQueue.main.async {
//      tf.font = context.environment.font
      tf.becomeFirstResponder()
    }
    return tf
  }

  func updateNSView(_ nsView: NSTextField, context: NSViewRepresentableContext<AutofocusTextField>) {
    print(#function)
    nsView.stringValue = text
    /// It seems as though the NSTextField is recreated on every update, and that some values are not preserved. Hence, we need to set the font on every update.
    nsView.font = AutofocusTextField.font
  }

  func makeCoordinator() -> AutofocusTextField.Coordinator {
    print(#function)
    return Coordinator(parent: self)
  }

  class Coordinator: NSObject, NSTextFieldDelegate  {
    let parent: AutofocusTextField
    init(parent: AutofocusTextField) {
      print(#function)
      self.parent = parent
    }

    func controlTextDidChange(_ obj: Notification) {
      print(#function)
      let textField = obj.object as! NSTextField
      textField.font = AutofocusTextField.font
      parent.text = textField.stringValue
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      ContentView()
      SearchProjects(close: {}, within: UserDefaults.vimlaURL)
    }
  }
}
