//
//  JSONManager.swift
//  iRestaurant
//
//  Created by Mohamed Shemy on 11/29/19.
//  Copyright © 2019 Shemy. All rights reserved.
//

import UIKit

class JSONManager: NSObject
{
    var rootURL: String!
    var finalURL: String!
    var APIKey: String!
    var APIToken: String!
    var APIHasKey: Bool = false
    var request: URLRequest!
    var startIndex: Int = 1
    var headers: [String: Any]!
    
    init(rootURL: String)
    {
        self.rootURL = rootURL
        self.finalURL = "\(rootURL)?"
        self.request = URLRequest(url: URL(string: rootURL)!)
        
    }
   
    func addHeaders()
    {
        var header = ""
        self.finalURL = "\(rootURL!)?"
        for h in headers { header = "\(header)\(h.key)=\(h.value)&" }
        finalURL = "\(finalURL!)\(header)"
    }
    
    func getJSONData(completion: @escaping (_ objects: [NSObject]?) -> ())
    {
        addHeaders()
        guard let url = URL(string: finalURL) else { completion([]); return }
        self.request = URLRequest(url: url)
        if APIHasKey{ request.addValue(APIKey, forHTTPHeaderField: APIToken)}
        let task = URLSession.shared.dataTask(with: request, completionHandler:
        {   (data, response, error) -> Void in
            if let error = error { print(error) ; return }
            //Parse JSON data
            if let data = data { completion(self.parseJsonData(data: data)) }
            else { completion([]) }
        })
        task.resume()
    }
    
    func parseJsonData(data: Data) -> [Restaurant]
    {
        var restaurants = [Restaurant]()
        
        do {
            let jsonResult = try JSONSerialization.jsonObject(with: data, options:
                JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
            // Parse JSON data
            if jsonResult?["businesses"] == nil { return restaurants }
            let jsonRests = jsonResult?["businesses"] as! [AnyObject]
            for jsonRest in jsonRests
            {
                let restaurant = Restaurant()
                restaurant.name = jsonRest["name"] as! String
                restaurant.ID = jsonRest["id"] as! String
                let location = jsonRest["location"] as! [String: AnyObject]
                restaurant.location = (location["display_address"] as! [String]).joined(separator: ", ")
                restaurant.imagePath = jsonRest["image_url"] as! String
                restaurant.phone = jsonRest["phone"] as! String
                let cats = jsonRest["categories"] as! [[String: String]]
                var cts:[String] = []
                for c in cats { cts.append(c["title" ]!) }
                restaurant.type = cts.joined(separator: ", ")
                restaurant.rating = Float(jsonRest["rating"] as! Double)
                restaurants.append(restaurant)
            }
        } catch { print(error) }
        
        return restaurants
    }
    
    func downloadImage(from path: String, completion: @escaping (UIImage?, Error?) -> ())
    {
        let url = URL(string: path)
        getData(from: url!) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() { completion(UIImage(data: data), error) }
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ())
    { URLSession.shared.dataTask(with: url, completionHandler: completion).resume() }
    
    func getRestaurants(completion: @escaping (_ restaurants: [Restaurant]) -> ())
    {
        getJSONData { (objects) in
            completion(objects as! [Restaurant])
        }
    }
}
