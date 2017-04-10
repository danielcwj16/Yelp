//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Weijie Chen on 4/6/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

protocol FiltersSearchDelegate {
    func filtersSearch(filtersVC: FiltersViewController, didUpdateFilters filters:[String:AnyObject])
}

class FiltersViewController: UIViewController,UITableViewDataSource,UITableViewDelegate, SwitchCellDelegate {

    @IBOutlet weak var filterTableVIew: UITableView!
    
    var switchState = [IndexPath : Bool]()
    var currentDistance = "Auto"
    var currentDistanceValue = -1
    var currentSortMode : YelpSortMode = .bestMatched
    var IsSectionExpand : [String : Bool] = ["distance":false,"sort":false,"category":false]
    var distanceSectionExpanded = false
    var sortBySectionExpanded = false
    var categorySectionExpanded = false
    var delegate : FiltersSearchDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filterTableVIew.dataSource = self
        filterTableVIew.delegate = self
        filterTableVIew.estimatedRowHeight = 50
        filterTableVIew.rowHeight = UITableViewAutomaticDimension
                
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return YelpFilters.sections().count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return YelpFilters.featureArray().count
        case 1:
            return distanceSectionExpanded ? YelpFilters.yelpDistanceArray().count : 1
        case 2:
            return sortBySectionExpanded ? YelpFilters.sortByArray().count : 1
        default:
            return categorySectionExpanded ? YelpFilters.yelpCategories().count : 4
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return YelpFilters.sections()[section]
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)
    {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 20.0)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchCell
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchCell
            
            cell.delegate = self
            cell.switchLabel.text = YelpFilters.featureArray()[indexPath.row]
            cell.filterSwtich.isOn = switchState[indexPath] ?? false
            cell.filterSwtich.isHidden = false
            
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CheckCell", for: indexPath) as! CheckCell
            
            if !distanceSectionExpanded {
                cell.checkLabel.text = currentDistance
                cell.checkImage.image = #imageLiteral(resourceName: "expandarrow")
            }else{
                cell.checkLabel.text = YelpFilters.yelpDistanceArray()[indexPath.row]["distance"]
                if currentDistance == YelpFilters.yelpDistanceArray()[indexPath.row]["distance"]{
                    cell.checkImage.image = #imageLiteral(resourceName: "check")
                }else{
                    cell.checkImage.image = #imageLiteral(resourceName: "empty")
                }
            }

            return cell
        
        case 2:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "CheckCell", for: indexPath) as! CheckCell
            
            if !sortBySectionExpanded{
                cell.checkLabel.text = YelpFilters.sortByArray()[currentSortMode.rawValue]
                cell.checkImage.image = #imageLiteral(resourceName: "expandarrow")
            }else{
                cell.checkLabel.text = YelpFilters.sortByArray()[indexPath.row]
                
                if currentSortMode.rawValue == indexPath.row{
                    cell.checkImage.image = #imageLiteral(resourceName: "check")
                }else{
                    cell.checkImage.image = #imageLiteral(resourceName: "empty")
                }
            }

            
            return cell
        
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchCell
            cell.delegate = self
            cell.switchLabel.text = YelpFilters.yelpCategories()[indexPath.row]["name"]
            cell.filterSwtich.isOn = switchState[indexPath] ?? false
            cell.filterSwtich.isHidden = false
            
            if !categorySectionExpanded {
                if indexPath.row == 3{
                    cell.switchLabel.text = "See All"
                    cell.filterSwtich.isHidden = true
                }
            }else{
                if (indexPath.row == YelpFilters.yelpCategories().count-1){
                        cell.filterSwtich.isHidden = true
                }
            }
            
            return cell
        }
        
        //return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            return
        case 1:
            if distanceSectionExpanded {
                currentDistance = YelpFilters.yelpDistanceArray()[indexPath.row]["distance"]!
                currentDistanceValue = Int(YelpFilters.yelpDistanceArray()[indexPath.row]["meters"]!)!
            }
            
            distanceSectionExpanded = !distanceSectionExpanded
            filterTableVIew.reloadSections(IndexSet([indexPath.section]), with: .automatic)
        case 2:
            if sortBySectionExpanded {
                currentSortMode = YelpFilters.sortByValue()[indexPath.row]
            }
            
            sortBySectionExpanded = !sortBySectionExpanded
            filterTableVIew.reloadSections(IndexSet([indexPath.section]), with: .automatic)
        default:
            if (indexPath.row == 3 && !categorySectionExpanded){
                categorySectionExpanded = !categorySectionExpanded
                filterTableVIew.reloadSections(IndexSet([indexPath.section]), with: .automatic)
                return
            }
            
            if(indexPath.row == YelpFilters.yelpCategories().count - 1 && categorySectionExpanded){
                categorySectionExpanded = !categorySectionExpanded
                filterTableVIew.reloadSections(IndexSet([indexPath.section]), with: .automatic)
                return
            }
        }
    }
    
    func switchCell(switchCell: SwitchCell, didChangeValue value: Bool) {
        
        let indexPath = filterTableVIew.indexPath(for: switchCell)!
        self.switchState[indexPath] = switchCell.filterSwtich.isOn
    }
    
    @IBAction func backToMainVC(_ sender: Any) {
        
        performSegue(withIdentifier: "unwindSegueToBusinessVC", sender: self)
    }
    
    @IBAction func Search(_ sender: Any){
        
        performSegue(withIdentifier: "unwindSegueToBusinessVC", sender: self)
        
        var filters = [String:AnyObject]()
        
        var categories = [String]()
        var deals = false
        
        for (indexPath,isOn) in switchState {
            if isOn {
                if indexPath.section == 0 {
                    deals = true
                }
                if indexPath.section == 3 {
                    categories.append(YelpFilters.yelpCategories()[indexPath.row]["code"]!)
                }
            }
        }
        
        if categories.count > 0{
            filters["category_filter"] = categories as AnyObject
        }
        
        if currentDistanceValue > 0{
            filters["radius_filter"] = currentDistanceValue as AnyObject
        }
        
        filters["deals_filter"] = deals as AnyObject
        filters["sort"] = currentSortMode.rawValue as AnyObject
        
        delegate?.filtersSearch(filtersVC: self, didUpdateFilters: filters)
    }

   

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
