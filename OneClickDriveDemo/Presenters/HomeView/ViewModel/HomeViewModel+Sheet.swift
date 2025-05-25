//
//  HomeViewModel+Sheet.swift
//  OneClickDriveDemo
//
//  Created by Ravi Seta on 25/05/25.
//
import SwiftUI

extension HomeViewModel {
    var isFullScreenPresenting: Binding<Bool> {
        return Binding<Bool>.init(get: { return self.childContent.isfullScreen },
                                  set: { [weak self] isPresenting,_ in
            guard let `self` = self else { return }
            if !isPresenting && self.childContent.isfullScreen { self.childContent = .none  }
        })
    }
    
    var isBottomSheetPresenting: Binding<Bool> {
        return Binding<Bool>.init(get: { return self.childContent.isSheet },
                                  set: { [weak self] isPresenting,_ in
            guard let `self` = self else { return }
            if !isPresenting && self.childContent.isSheet { self.childContent = .none  }
        })
    }
}
