
public class DependencyManager {
    
    private var dependencymap: [Key: () -> SampleClassA] = [:]
    
    init(_ config: (DependencyManager) -> () = { _ in }) {
        config(self)
    }
    
    func register( _ block: @escaping () -> SampleClassA, _ label: String) {
        let key = Key(type: SampleClassA.Type.self, label: label)
        dependencymap[key] = block
    }
    
    func resolve<T>(label: String) -> T {
        let key = Key(type: SampleClassA.Type.self, label: label)
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
    
}
