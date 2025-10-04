//
//  OpenURLUseCase.swift
//  buntan
//
//  Created by 二木裕也 on 2025/09/23.
//

import UIKit

protocol OpenURLUseCaseProtocol {
    func open(_ target: ExternalURL)
}

enum ExternalURL: String {
    case appStore = "https://x.gd/R38a3"
}

struct OpenURLUseCase: OpenURLUseCaseProtocol {
    func open(_ target: ExternalURL) {
        guard let url = URL(string: target.rawValue) else { return }
        UIApplication.shared.open(url)
    }
}
