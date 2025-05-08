//
//  FakeURLProtocol.swift
//  SkySpyTests
//
//  Created by SofiaLeong on 05/05/2025.
//

import XCTest

final class FakeURLProtocol: URLProtocol {
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?
    
    override class func canInit(with request: URLRequest) -> Bool {
        true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }
}

extension FakeURLProtocol {
    override func startLoading() {
        guard let requestHandler = FakeURLProtocol.requestHandler else {
            XCTFail("No request handler provider")
            return
        }
        
        do {
            let (response, data) = try requestHandler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            XCTFail("Error handling the request: \(error)")
        }
    }
    
    override func stopLoading() {}
}
