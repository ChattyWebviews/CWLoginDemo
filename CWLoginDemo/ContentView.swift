//
//  ContentView.swift
//  CWLoginDemo
//
//  Created by Teodor Dermendzhiev on 14.07.23.
//

import SwiftUI
import ChattyWebviews

struct SheetView: UIViewControllerRepresentable, CWMessageDelegate {
    typealias UIViewControllerType = CWViewController
    @Environment(\.dismiss) var dismiss
    
    func controller(_ controller: ChattyWebviews.CWViewController, didReceive message: ChattyWebviews.CWMessage) {
        print(message)
        dismiss()
        
    }
    
    func makeUIViewController(context: Context) -> ChattyWebviews.CWViewController {
        let module = WebViewFactory.getModules()[0]
        let scheduleVC = WebViewFactory.createWebview(from: module, path: nil)
        scheduleVC?.messageDelegate = self
        return scheduleVC!
    }
    
    func updateUIViewController(_ uiViewController: ChattyWebviews.CWViewController, context: Context) {
        
    }
    
}


struct ContentView: View {
    @State private var showingSheet = false
    
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Button("Login") {
                        showingSheet.toggle()
                    }
                    .sheet(isPresented: $showingSheet) {
                        SheetView()
                    }
        }
        .padding()
    }
    
    init(showingSheet: Bool = false) {
        self.showingSheet = showingSheet
        self.setupModules()
    }
    
    func setupModules() {
        ModuleSynchronizer.updateCheckUrl = "<YOUR-FUNCTION-URL>"
      
        let module = CWModule(name: "demo", location: .Resources)
        WebViewFactory.initModules(modules: [module])
        ModuleSynchronizer.shared.updateIfNeeded(module: module, email: "tester@test.com", appId: "cw-login-demo") { success in
            print("Module \(module.name) updated! Please restart the app.")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
