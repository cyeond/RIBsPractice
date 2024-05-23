//
//  AppInfo.swift
//  AppStoreClone
//
//  Created by YD on 5/20/24.
//

import Foundation

struct AppInfo: Decodable {
    let title, developerName, description, iconUrl, primaryGenreName, trackContentRating, releaseNote, version, releaseDate: String
    let id, userRatingCount: Int
    let averageUserRating: Double
    let screenshotUrls, languageCodes: [String]
    
    enum CodingKeys: String, CodingKey {
        case id = "trackId"
        case title = "trackName"
        case iconUrl = "artworkUrl100"
        case developerName = "artistName"
        case releaseNote = "releaseNotes"
        case releaseDate = "currentVersionReleaseDate"
        case languageCodes = "languageCodesISO2A"
        case version, description, primaryGenreName, trackContentRating, userRatingCount, averageUserRating, screenshotUrls
    }
}
