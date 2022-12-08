//
//  Product_MarketplaceApp.swift
//  Product Marketplace
//
//  Created by Stahi, Shahar on 07/12/2022.
//

import SwiftUI
import Amplify
import AWSCognitoAuthPlugin
import AWSDataStorePlugin




@main
struct Product_MarketplaceApp: App {
    var body: some Scene {
        WindowGroup {
            SessionView()
        }
    }
    
    init() {
        configureAmplify()
    }
    
    func configureAmplify() {
        do {
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            let models = AmplifyModels()
            try Amplify.add(plugin: AWSDataStorePlugin(modelRegistration: models))
            try Amplify.configure()
            print("Successfully configured Amplify")
        } catch {
            print("Failed to initialize Amplify", error)
        }
    }

}
