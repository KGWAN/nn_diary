//
//  NnUserDefaults.swift
//  nn
//
//  Created by JUNGGWAN KIM on 9/2/25.
//

import Foundation
import SwiftUI

struct NnUserDefaults {
    @AppStorage("PASSWORD") static var password: String = "000000"
    
    @AppStorage("GOOGLE_ACCESS_TOKEN") static var googleAccessToken: String = ""
    @AppStorage("GOOGLE_FILE_ID") static var googleFileId: String = ""
    
    @AppStorage("GIT_ACCESS_TOKEN") static var gitAccessToken: String = ""
    @AppStorage("GIT_REPO") static var gitRepo: String = ""
}
