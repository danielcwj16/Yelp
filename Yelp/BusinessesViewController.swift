//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,FiltersSearchDelegate,UISearchBarDelegate{
    
    @IBOutlet weak var table_view: UITableView!
    var businesses: [Business]! = []
    var isMoreDataLoading = false
    var loadingMoreView : InfiniteScrollActivityView?
    var contentOffset : CGPoint?
    var filters = [String:AnyObject]()
    var searchBar : UISearchBar!
    var offset = 0
    var currentSearch = "Restaurant"
    
    override func viewDidLoad() {
    
        super.viewDidLoad()

        table_view.dataSource = self
        table_view.delegate  = self
        table_view.estimatedRowHeight = 100
        table_view.rowHeight = UITableViewAutomaticDimension
        
        
        //filters["category_filter"] = nil
        self.filters["sort"] = YelpSortMode.bestMatched.rawValue as AnyObject
        self.filters["deals_filter"] = false as AnyObject
        self.filters["radius_filter"] = 4000 as AnyObject
        self.filters["offset"] = 0 as AnyObject
        //filters["term"] = currentSearch as AnyObject
        
        //Set up search bar in Navigation Bar
        searchBar = UISearchBar()
        searchBar.sizeToFit()
        searchBar.placeholder = "Restaurant"
        searchBar.tintColor = UIColor.white
        searchBar.delegate = self
        
        self.navigationItem.titleView = searchBar
        
    
        // Set up Infinite Scroll loading indicator
        let frame = CGRect(x: 0, y: table_view.contentSize.height, width: table_view.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.isHidden = true
        table_view.addSubview(loadingMoreView!)
        
        var insets = table_view.contentInset
        insets.bottom += InfiniteScrollActivityView.defaultHeight
        table_view.contentInset = insets
        
        Business.searchWithTerm(filters: filters,term: currentSearch, completion: { (businesses: [Business]?, error: Error?) -> Void in
            
            self.businesses = businesses
            if let businesses = businesses {
                for business in businesses {
                    print(business.name!)
                    print(business.address!)
                    print(business.imageURL!)
                }
            }
            self.table_view.reloadData()
            }
        )
        
        contentOffset = table_view.contentOffset
        
        /* Example of Yelp search with more search options specified
         Business.searchWithTerm("Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
         self.businesses = businesses
         
         for business in businesses {
         print(business.name!)
         print(business.address!)
         }
         }
         */
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.businesses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell",for: indexPath) as! BusinessCell
        
        let business = businesses[indexPath.row]
        
        //Assign bussiness info to cell
        cell.businessName = business.name
        cell.businessDistance = business.distance
        cell.businessReviewCount = "\(business.reviewCount!) reviews"
        cell.businessAddress = business.address
        cell.businessCategory = business.categories
        cell.iconimage.setImageWith(business.imageURL!)
        cell.review_image.setImageWith(business.ratingImageURL!)
    
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(!isMoreDataLoading){
            let scrollViewContentHeight = table_view.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - table_view.bounds.size.height
            
            if(scrollView.contentOffset.y > scrollOffsetThreshold && table_view.isDragging){
                isMoreDataLoading = true
                
                // Update position of loadingMoreView, and start loading indicator
                let frame = CGRect(x: 0, y: table_view.contentSize.height, width: table_view.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
                self.loadingMoreView?.frame = frame
                self.loadingMoreView!.startAnimating()
                
                loadMoreData()
            }
        }
    }
    
    func loadMoreData(){
        offset = businesses.count
        filters["offset"] = offset as AnyObject
        Business.searchWithTerm(filters: filters,term: currentSearch, completion: { (businesses: [Business]?, error: Error?) -> Void in
            // Update flag
            self.isMoreDataLoading = false
            
            //self.businesses.append(contentsOf: Sequence)
            if let businesses = businesses {
                for business in businesses {
                    print(business.name!)
                    print(business.address!)
                    print(business.imageURL ?? "")
                    self.businesses.append(business)
                }
            }
            
            // Stop the loading indicator
            self.loadingMoreView!.stopAnimating()

            
            self.table_view.reloadData()
        }
        )
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationController = segue.destination as! UINavigationController
        let filtersViewController = navigationController.topViewController as! FiltersViewController
        
        filtersViewController.delegate = self
    }
    
    func filtersSearch(filtersVC: FiltersViewController, didUpdateFilters filters: [String : AnyObject]) {
        self.filters = filters
        Business.searchWithTerm(filters: filters,term: currentSearch, completion: { (businesses: [Business]?, error: Error?) -> Void in
            // Update flag
            self.isMoreDataLoading = false
            
            //self.businesses.append(contentsOf: Sequence)
            if let businesses = businesses {
                self.businesses = businesses
                for business in businesses {
                    print(business.name!)
                    print(business.address!)
                    print(business.imageURL!)
                    
                }
            }
            
            // Stop the loading indicator
            //self.loadingMoreView!.stopAnimating()
            
            self.table_view.reloadData()
        }
        )
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        
        return true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(false, animated: true)
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        offset = 0
        currentSearch = searchBar.text!
        filters["term"] = searchBar.text! as AnyObject?
        filters["offset"] = offset as AnyObject
        
        searchBar.resignFirstResponder()
        Business.searchWithTerm(filters: filters,term: currentSearch, completion: { (businesses: [Business]?, error: Error?) -> Void in
            // Update flag
            self.isMoreDataLoading = false
            
            //self.businesses.append(contentsOf: Sequence)
            if let businesses = businesses {
                self.businesses = businesses
                for business in businesses {
                    print(business.name!)
                    print(business.address!)
                    print(business.imageURL!)
                    
                }
            }
            
            // Stop the loading indicator
            //self.loadingMoreView!.stopAnimating()
            
            self.table_view.reloadData()
        }
        )

    }
    
    @IBAction func unwindToBusinessVC(segue: UIStoryboardSegue){
        
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
