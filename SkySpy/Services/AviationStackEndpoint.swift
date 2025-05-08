//
//  AviationStackEndpoint.swift
//  SkySpy
//
//  Created by SofiaLeong on 30/04/2025.
//

import Foundation

struct AviationStackEndpoint: Endpointable {
    enum EndpointType {
        case airlines
        case flights
    }

    let type: EndpointType
    let airlineName: String?
    private let appid: String = "YOUR_API_KEY"

    var path: String {
        switch type {
        case .airlines:
            return "/v1/airlines"
        case .flights:
            return "/v1/flights"
        }
    }

    var parameters: [URLQueryItem]? {
        var items = [URLQueryItem(name: "access_key", value: appid)]
        if let airlineName = airlineName {
            switch type {
            case .airlines:
                items.append(URLQueryItem(name: "search", value: airlineName))
            case .flights:
                items.append(URLQueryItem(name: "airline_name", value: airlineName))
            }
        }
        return items
    }
}
