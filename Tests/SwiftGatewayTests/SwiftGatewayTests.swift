import XCTest
@testable import SwiftGateway

final class SwiftGatewayTests: XCTestCase {
    func testExample() throws {
        let request = try XCTUnwrap(
            URLRequest(
                gateway: URL(string: "https://gateway.netutils.workers.dev")!,
                url: URL(string: "https://api.openai.com/v1/models")!,
                serviceName: nil,
                serviceId: nil,
                token: nil,
                authenticationType: .header,
                authenticationKey: nil,
                authenticationPrefix: nil
            )
        )

        XCTAssertEqual(request.value(forHTTPHeaderField: "x-gateway-service-host"), "api.openai.com")
        XCTAssertEqual(request.url?.host, "gateway.netutils.workers.dev")
    }
}
