//
//  SectionHeaderView.swift
//  iRestaurant
//
//  Created by Mohamed Shemy on 12/1/19.
//  Copyright © 2019 Shemy. All rights reserved.
//

import UIKit

protocol SectionHeaderViewDelegate
{
    func sectionHeaderView(sectionHeaderView: SectionHeaderView, sectionOpened: Int)
    func sectionHeaderView(sectionHeaderView: SectionHeaderView, sectionClosed: Int)
}

class SectionInfo: NSObject
{
    var open: Bool = false
    var itemsInSection: [String] = []
    var sectionTitle: String?
    
    init(itemsInSection: [String], sectionTitle: String)
    {
        self.itemsInSection = itemsInSection
        self.sectionTitle = sectionTitle
    }
}

class SectionHeaderView: UITableViewHeaderFooterView
{
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var disclosureButton: UIButton!
    
    var delegate: SectionHeaderViewDelegate?
    var section: Int?
    
    override func awakeFromNib()
    {
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.toggleOpen))
        self.addGestureRecognizer(tapGesture)
    }
    
    @IBAction func toggleOpen()
    {
        self.toggleOpenWithUserAction(userAction: true)
    }
    
    func toggleOpenWithUserAction(userAction: Bool)
    {
        self.disclosureButton.isSelected = !self.disclosureButton.isSelected
        
        if userAction {
            if self.disclosureButton.isSelected {
                self.delegate?.sectionHeaderView(sectionHeaderView: self, sectionOpened: self.section!)
            } else {
                self.delegate?.sectionHeaderView(sectionHeaderView: self, sectionClosed: self.section!)
            }
        }
    }
}
