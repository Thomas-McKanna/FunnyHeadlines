//
//  Shared.swift
//  FunnyHeadlines
//
//  Created by Thomas McKanna on 2/20/17.
//  Copyright © 2017 ISYS 220. All rights reserved.
//

import Foundation

// API key
let NEWS_API_KEY = "f93160eaab9f45f59db70d9c94787988"

// the default source for the headlines
let Source: String = "cnn"

let SupportedTranslations = ["Yoda", "Pirate", "Elmer Fudd", "Shakespeare"]

let TranslationDictionary = [["Yoda" : "yoda"], ["Pirate" : "pirate"], ["Elmer Fudd" : "fudd"], ["Shakespeare" : "shakespeare"]]

let SupportedSources = ["CNN", "CNBC", "Business Insider", "Google News", "Entertainment Weekly"]

let SourcesDictionary = [["CNN" : "cnn"], ["CNBC" : "cnbc"], ["Business Insider" : "business-insider"], ["Google News" : "google-news"], ["Entertainment Weekly" : "entertainment-weekly"]]

//  serialization error cases
enum SerializationError: Error {
    case missing(String)
    case invalid(String, Any)
}
