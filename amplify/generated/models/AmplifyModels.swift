// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol. 

final public class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "4840edfd470c49c2dabc8d99e355418d"
  
  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: User.self)
  }
}