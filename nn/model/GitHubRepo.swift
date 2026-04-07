//
//  GitHubRepo.swift
//  nn
//
//  Created by JUNGGWAN KIM on 9/9/25.
//

import Foundation

struct GitHubRepo: Identifiable, Codable {
    let id: Int
    let repoName: String
    let fullName: String
    let isPrivate: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case repoName = "name"
        case fullName = "full_name"
        case isPrivate = "private"
    }
}
