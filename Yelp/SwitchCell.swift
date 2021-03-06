//
//  FilterTableViewCell.swift
//  Yelp
//
//  Created by Weijie Chen on 4/7/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol SwitchCellDelegate{
    @objc optional func switchCell(switchCell: SwitchCell, didChangeValue value: Bool)
}

class SwitchCell: UITableViewCell {

    @IBOutlet weak var switchLabel: UILabel!
    @IBOutlet weak var filterSwtich: UISwitch!
    
    weak var delegate: SwitchCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        filterSwtich.addTarget(self, action: #selector(switchValueChanged(_:)), for: UIControlEvents.valueChanged)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func switchValueChanged(_ filterSwitch: UISwitch) {
        
        print("got swtich!")
        delegate?.switchCell?(switchCell: self, didChangeValue: filterSwtich.isOn)
        //delegate?.switchCell?(switchCell: self, didChangeValue: filterSwtich.isOn)
    }
}
