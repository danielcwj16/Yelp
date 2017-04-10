//
//  BusinessCell.swift
//  Yelp
//
//  Created by Weijie Chen on 4/5/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessCell: UITableViewCell {

    @IBOutlet weak var iconimage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var reviewcount: UILabel!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var review_image: UIImageView!
    
    
    //Observers for cell properties
    var businessName : String? {
        didSet{
            self.name.text = businessName!
        }
    }
    
    var businessAddress : String? {
        didSet{
            self.address.text = businessAddress!
        }
    }
    
    var businessDistance : String?{
        didSet{
            self.distance.text = businessDistance!
        }
    }
    
    var businessReviewCount: String?{
        didSet{
            self.reviewcount.text = businessReviewCount!
        }
    }
    
    var businessCategory: String?{
        didSet{
            self.category.text = businessCategory!
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.iconimage.layer.cornerRadius = 5
        self.iconimage.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
