//
//  MainBarViewModel.swift
//  KUHAR
//
//  Created by Екатерина Горинова on 15.03.25.
//

import Foundation
import FirebaseAuth

class MainBarViewModel: ObservableObject {
    
    @Published var user: User
    
    init(user: User) {
        self.user = user
    }
}

