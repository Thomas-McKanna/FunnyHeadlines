//
//  News.swift
//  FunnyHeadlines
//
//  Created by Thomas McKanna on 2/20/17.
//  Copyright © 2017 ISYS 220. All rights reserved.
//

import Foundation

// This file will use the NewsAPI (https://newsapi.org/)

// NewsAPI Key: f93160eaab9f45f59db70d9c94787988

// TODO: this file will define the functions needed to return an array of headlines.

// structure the encapsulates all the information needed about a news story: the title and its URL
struct News {
    
    let title: String?
    let url: String?
    
    init?(json: [String : Any]) throws {
        // extract title
        guard let title = json["title"] as? String else {
            throw SerializationError.missing("title")
        }
        // extract url
        guard let url = json["url"] as? String else {
            throw SerializationError.missing("url")
        }

        // initialize properties
        self.title = title
        self.url = url
    }
    
    // this function is called to get all the latest news headlines; it performs an API call
    static func getNews(ForSource s: String, completion: @escaping ([News]) -> Void) {
        
        // prepare the API request
        
        // set up the query string (three parameters are required: source, apiKey, and sortBy)
        var queryString = [URLQueryItem]()
        queryString.append(URLQueryItem(name: "source", value: s))
        queryString.append(URLQueryItem(name: "apiKey", value: NEWS_API_KEY))
        queryString.append(URLQueryItem(name: "sortBy", value: "top"))
        
        // set up the different parts of the URL
        let base = "https://newsapi.org"
        let path = "/v1/articles"
        
        // put all of the pieces of the URL together
        var urlComponents = URLComponents(string: base)!
        urlComponents.path = path
        urlComponents.queryItems = queryString
        
        let URL = urlComponents.url!
        
        let request = URLRequest(url: URL)
        
        print("Requesting news headlines over the web...")
        
        var newsArray = [News]()
        
        URLSession.shared.dataTask(with: request as URLRequest) {(data, response, error) -> Void in
            
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else if let data = data {
                print("We received a response from the news API: \(data)")
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) as! [String : Any] {
                    for case let article in json["articles"] as! [[String : Any]] {
                        if let currentArticle = try? News(json: article) {
                            newsArray.append(currentArticle!)
                        }
                    }
                }
            }
            completion(newsArray)
        }.resume()
    }
}

