//
//  Created by Kurlovich Vitali on 9/28/26.
//

public actor LoggingBootstrap {
    private var isBootstrapped: Bool = false

    private init() {
      
    }
}

public extension LoggingBootstrap {
    static let `default` = LoggingBootstrap()
}
