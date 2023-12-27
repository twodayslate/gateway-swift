import Foundation
#if canImport(UIKit)
import UIKit
#endif

public enum GatewayServiceAuthType: String {
    case header = "HEADER"
    case query = "QUERY"
}

public struct GatewayServiceError {
    public let error: String?
}

public extension URLRequest {
    init?(
        gateway: URL,
        url: URL,
        serviceName: String?,
        serviceId: String?,
        token: String?,
        authenticationType: GatewayServiceAuthType?,
        authenticationKey: String?,
        cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy,
        timeoutInterval: TimeInterval = 60
    ) {
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return nil
        }

        guard let host = components.host, !host.isEmpty else {
            return nil
        }

        components.host = gateway.host

        guard let modifiedUrl = components.url else {
            return nil
        }

        self.init(url: modifiedUrl, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval)

        if let token {
            self.setValue(token, forHTTPHeaderField: "x-gateway-service-token")
        }

        if let authenticationType {
            self.setValue(authenticationType.rawValue, forHTTPHeaderField: "x-gateway-service-auth-type")
        }

        if let authenticationKey {
            self.setValue(authenticationKey, forHTTPHeaderField: "x-gateway-service-auth-key")
        }

#if canImport(UIKit)
        if let user = UIDevice.current.identifierForVendor?.uuidString {
            self.setValue(user, forHTTPHeaderField: "x-gateway-identifier-for-vendor")
        }
#endif

        if let serviceId {
            self.setValue(serviceId, forHTTPHeaderField: "x-gateway-service-id")
        }

        if let serviceName {
            self.setValue(serviceName, forHTTPHeaderField: "x-gateway-service-name")
        }

        if let bundle = Bundle.main.bundleIdentifier {
            self.setValue(bundle, forHTTPHeaderField: "x-gateway-bundle-identifier")
        }

        self.setValue(host, forHTTPHeaderField: "x-gateway-service-host")
    }
}
