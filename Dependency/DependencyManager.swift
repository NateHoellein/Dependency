

public enum DependencyError: Error {
    case RegistrationOfClassNotFound(String)
    case UnableToInvokeCreationClosure(String)
}

public class DependencyManager {
    private var dependencymap: [Key: (DependencyManager) -> Any] = [:]
    
    public init(_ config: (DependencyManager) -> () = { _ in }) {
        config(self)
    }
    
    public func register<T>(_ type:T.Type, _ block: @escaping (_ manager:DependencyManager) -> T, _ label: String) {
        let key = Key(type: type.self, label: label)
        self.dependencymap[key] = block
    }
    
    public func resolve<T>(_ type: T.Type, label: String) throws -> T {
        let key = Key(type: type.self, label: label)
        let initBlock = dependencymap[key]
        guard let b = initBlock else {
            throw DependencyError.RegistrationOfClassNotFound("Somethinge \(label)")
        }
        guard let bfunc = b(self) as? T else {
            throw DependencyError.UnableToInvokeCreationClosure("Something 2 \(T.Type.self)")
        }
        return bfunc
    }
}

class Key: Hashable {
    private var type: Any.Type
    private var label: String
    
    static func == (lhs: Key, rhs: Key) -> Bool {
        return lhs.type == rhs.type && lhs.label == rhs.label
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(type))
        hasher.combine(label)
    }
    
    init(type: Any.Type, label: String) {
        self.type = type
        self.label = label
    }
}


