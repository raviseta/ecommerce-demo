//
//  ChildContent.swift
//  OneClickDriveDemo
//
//  Created by Ravi Seta on 24/05/25.
//


enum ChildContent: Equatable {
    
    case openProductDetail
    case openFilter
    case none
    
    var isfullScreen: Bool {
        switch self {
        case .openProductDetail: return true
        case .none, .openFilter: return false
        }
    }
    
    var isSheet: Bool {
        switch self {
        case .none, .openProductDetail: return false
        case .openFilter:
            return true
        }
    }
}
