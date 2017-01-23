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
    var condition: String!
    var imgUrl: String!
    var cityName: String!
    
    var cityExist: Bool = true
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        searchBar.delegate = self
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) { //method gets fired when you press the search bar button
        
        let urlRequest = URLRequest(url:URL(string:"http://api.apixu.com/v1/current.json?key=35cc2f938f2d409399d195620172301&q=\(searchBar.text!.replacingOccurrences(of: " ", with: "%20"))")!)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            
            if error == nil {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String : AnyObject]
                    
                    if let current = json["current"] as? [String : AnyObject] {
                        if let temp = current["temp_f"] as? Int {
                            self.degree = temp
                        }
                        if let condition = current["condition"] as? [String : AnyObject] {
                            self.condition = condition["text"] as! String
                            let icon = condition["icon"] as! String
                            self.imgUrl = "http:\(icon)"
                        }
                    }//end current
                    
                    if let location = json["location"] as? [String : AnyObject] {
                        self.cityName = location["name"] as! String
                    }
                    
                    if let _ = json["error"] {
                        self.cityExist = false;
                    }
                    
                    DispatchQueue.main.async {
                        
                        if self.cityExist == true {
                            self.degreeLabel.text = self.degree.description + "°"
                            self.cityLabel.text = self.cityName
                            self.conditionLabel.text = self.condition
                            self.imgView.weatherIcon(from: self.imgUrl!)
                            self.degreeLabel.isHidden = false
                            self.conditionLabel.isHidden = false
                            self.imgView.isHidden = false
                        
                        } else {
                            self.degreeLabel.isHidden = true
                            self.cityLabel.text = "This city does not exist!"
                            self.conditionLabel.isHidden = true
                            
                            self.imgView.isHidden = true
                            self.cityExist = true
                        }
                        
                    }
                    
                    
                    
                } catch let jsonError { //putting any error into jsonError
                    print(jsonError.localizedDescription)
                }
            }
        }
        
        task.resume()
    }
    

}

extension UIImageView {
    
    func weatherIcon(from url: String){
        let urlRequest = URLRequest(url: URL(string: url)!)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if error == nil {
                DispatchQueue.main.async {
                    self.image = UIImage(data: data!)
                }
            }
        }
        
        task.resume()
    }
}

