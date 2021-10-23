
public class DependencyManager {
    
    private var dependencymap: [Key: () -> Any] = [:]
    
    init(_ config: (DependencyManager) -> () = { _ in }) {
        config(self)
    }
    
    func register<T>( _ block: @escaping () -> T, _ label: String) {
        let key = Key(type: T.Type.self, label: label)
        dependencymap[key] = block
    }
    
    func resolve<T>(label: String) -> T {
        let key = Key(type: T.Type.self, label: label)
        let b = dependencymap[key]
        return b!() as! T
    }
//    func resolve<T, U>( _: (T) -> U ) {
//
//    }
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

class SampleClassA {
    var messageFromA: String = ""
    init( _ message : String) {
        self.messageFromA = message
        
    }
}

class SampleClassB {
    
    var messageFromB: String = ""
    
    init(_ message: String) {
        self.messageFromB = message
    }
}
