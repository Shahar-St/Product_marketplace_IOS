// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol. 

final public class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "db01cc52f8b89412258f614271278128"
  
  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: Product.self)
    ModelRegistry.register(modelType: User.self)
  }
}