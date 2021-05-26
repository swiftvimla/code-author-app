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
            TextField(
              "Search for project",
              text: self.$searchText,
              onEditingChanged: { _ in },
              onCommit: { print("Done") }
            )
                .focusable()
                .textFieldStyle(SearchProjectTextFieldStyle())
                .overlay(QuitButton(close: { self.close() }).padding(), alignment: Alignment(horizontal: .trailing, vertical: .center))
                .padding()
            List(self.searchResults, id: \.self, selection: self.$selected) { (project: Project) in
                Button(
                    action: { openProject(at: project.root) },
                    label: { Text("OPEN") })
                Button(
                    action: { openTerminal(at: project.root) },
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
          ContentView()
          SearchProjects(close: {}, within: UserDefaults.vimlaURL)
        }
    }
}
