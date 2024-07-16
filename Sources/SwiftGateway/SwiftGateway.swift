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
    /// Creates and initializes a URL request with the given gateway configuration.
    /// - Parameters:
    ///   - gateway: The gateway for the request.
    ///   - url: The URL for the request.
    ///   - serviceName: The service name for the request.
    ///   - serviceId: The service identifier for this request.
    ///   - token: The token for this request.
    ///   - authenticationType: The authentication type for this request.
    ///   - authenticationKey: The authentication key for this request.
    ///   - authenticationPrefix: The authentication prefix for this request.
    ///   - proxy: If proxy for the request. The default is `nil`. If set, the host is used.
    ///   - cachePolicy: The cache policy for the request. The default is ``NSURLRequest.CachePolicy.useProtocolCachePolicy``.
    ///   - timeoutInterval: The timeout interval for the request. The default is 60.0. See the commentary for the [timeoutInterval](https://developer.apple.com/documentation/foundation/nsurlrequest/1418229-timeoutinterval) for more information on timeout intervals.
    init?(
        gateway: URL,
        url: URL,
        serviceName: String?,
        serviceId: String?,
        token: String?,
        authenticationType: GatewayServiceAuthType?,
        authenticationKey: String?,
        authenticationPrefix: String?,
        proxy: URL? = nil,
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

        if let authenticationPrefix {
            self.setValue(authenticationPrefix, forHTTPHeaderField: "x-gateway-service-auth-prefix")
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

        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            self.setValue(version, forHTTPHeaderField: "x-gateway-bundle-version")
        }

        if let proxy {
            self.setValue("GATEWAY", forHTTPHeaderField: "x-gateway-service-type")
            self.setValue(proxy.host, forHTTPHeaderField: "x-gateway-service-proxy")
        }

        self.setValue(host, forHTTPHeaderField: "x-gateway-service-host")
    }
}
