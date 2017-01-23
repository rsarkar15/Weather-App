//
//  ViewController.swift
//  Weather_App
//
//  Created by Reena Sarkar on 1/23/17.
//  Copyright © 2017 Reena Sarkar. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var degreeLabel: UILabel!
    
    var degree: Int!
    var conditon: String!
    var imgUrl: String!
    var cityName: String!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        searchBar.delegate = self
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) { //method gets fired when you press the search bar button
        <#code#>
        let urlRequest = URLRequest(url:URL(string:" http://api.apixu.com/v1/current.json?key=35cc2f938f2d409399d195620172301&q=\(searchBar.text!.replacingOccurrences(of: " ", with: "%20"))")!)
        
        let task = URLSession.shared.dataTask(with: URLRequest) { (data, response, error) in
            
            if error == nil {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String : AnyObject]
                    
                    if let current = json["current"] as? [String : AnyObject] {
                        if let temp = current["temp_f"] as? Int {
                            self.degree = temp
                        }
                        if let conditon = current["conditon"] as? String {
                            self.condition = condition["text"] as! String
                            self.imgUrl =  condition["icon"] as! String
                        }
                    }//end current
                    
                    if let location = json["location"] as? [String : AnyObject] {
                        self.cityName = location["name"] as! String
                    }
                    
                    
                    
                } catch let jsonError { //putting any error into jsonError
                    print(jsonError.localizedDescription)
                }
            }
        }
    }
    

}

