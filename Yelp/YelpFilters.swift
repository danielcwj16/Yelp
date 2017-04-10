//
//  YelpFilters.swift
//  Yelp
//
//  Created by Weijie Chen on 4/7/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

class YelpFilters{
    class func yelpCategories() -> [[String : String]] {
        let categories = [["name" : "American, New", "code": "newamerican"],
                          ["name" : "American, Traditional", "code": "tradamerican"],
                          ["name" : "Asian Fusion", "code": "asianfusion"],
                          ["name" : "Cajun/Creole", "code": "cajun"],
                          ["name" : "Chinese", "code": "chinese"],
                          ["name" : "Steakhouses", "code": "steak"],
                          ["name" : "Sushi Bars", "code": "sushi"],
                          ["name" : "Thai", "code": "thai"],
                          ["name" : "Vegetarian", "code": "vegetarian"],
                          ["name" : "Minimize","code":"none"]]
        
        return categories
    }
    
    class func yelpDistanceArray() -> [[String:String]]  {
        return   [["distance" : "Auto", "meters": "-1"],
                  ["distance" : "0.3 Miles", "meters": "483"],
                  ["distance" : "1 Miles", "meters": "1609"],
                  ["distance" : "5 Miles", "meters": "8047"],
                  ["distance" : "20 Miles", "meters": "32187"]]
    }
    
    class func featureArray() -> [String]{
            return ["Offering a Deal"]
    }

    class func sections() -> [String]{
        let sectionArray = ["","Distance","Sort By","Category"]
        return sectionArray
    }
    
    class func sortByArray() -> [String]{
        let sortByArray = ["Best Match" , "Distance", "Highest Rating"]
        return sortByArray
    }

    class func sortByValue() -> [YelpSortMode]{
        let sortByValue : [YelpSortMode] = [.bestMatched,.distance,.highestRated]
        return sortByValue
    }
    
    
}

