//
//  GoogleDriveResponse.swift
//  nn
//
//  Created by JUNGGWAN KIM on 8/29/25.
//

import Foundation

struct GoogleDriveResponse: Codable {
    let rootKey: [SavedDiary]
}

struct SavedDiary: Codable {
    let date: String
    let note: String
    let registrationDate: String
    let revisionDate: String
    let imgId: String?
}
