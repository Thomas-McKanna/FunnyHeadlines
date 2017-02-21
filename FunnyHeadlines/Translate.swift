//
//  Translate.swift
//  FunnyHeadlines
//
//  Created by Thomas McKanna on 2/20/17.
//  Copyright © 2017 ISYS 220. All rights reserved.
//

import Foundation

// This file will use the Fun Translations API (http://funtranslations.com/api)

// Note: that some of the fun translations require $5 a month to get more than 5 translations an hour. We can just avoid those particular ones. I don't anticipate having to spend any money.

// Fun Translations do not need an API key

// TODO: this file will define the functions needed to take as input an array of headlines and output an array of "translated" headlines.

// this function translates an array of news
func translate(Headline h: String, WithTranslation t: String, completion: @escaping (String) -> Void) {
    // prepare the API request
    // set up the query string (one parameter is required: text)
    var queryString = [URLQueryItem]()
    queryString.append(URLQueryItem(name: "text", value: h))
    
    // set up the different parts of the URL
    let base = "http://api.funtranslations.com"
    let path = "/translate/" + t + ".json"
    
    // put all of the pieces of the URL together
    var urlComponents = URLComponents(string: base)!
    urlComponents.path = path
    urlComponents.queryItems = queryString
    let URL = urlComponents.url!
    // embed the URL into a request
    var request = URLRequest(url: URL)
    request.addValue("4V9_OUXmRNktTdftKTE8egeF", forHTTPHeaderField: "X-FunTranslations-Api-Secret")

    // make the request over the internet. The variable "data" contains a JSON containing news articles
    URLSession.shared.dataTask(with: request as URLRequest) {(data, response, error) -> Void in
            
        if let error = error {
            print("Error: \(error.localizedDescription)")
        } else if let data = data {
            // attempt to parse the JSON data into dictionaries
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as! [String : Any] {
                guard let article = json["contents"] as? [String : Any] else {
                    print("FunTranslations: invalid JSON")
                    print(String(describing: json))
                    return
                }
                
                guard let translated = article["translated"] as? String else {
                    print("FunTranslations: translation not present")
                    return
                }
                
                print("Successful translation! - \(translated)")
                // when the data has been parsed, it must be passed to the calling function. It can do what it wants with the data there
                completion(translated)
            }
        }
    }.resume()
}
