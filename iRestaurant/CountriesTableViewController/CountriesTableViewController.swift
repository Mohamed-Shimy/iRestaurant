//
//  CountriesTableViewController.swift
//  iRestaurant
//
//  Created by Mohamed Shemy on 12/1/19.
//  Copyright © 2019 Shemy. All rights reserved.
//

import UIKit

class CountriesTableViewController: UITableViewController, SectionHeaderViewDelegate
{
    let SectionHeaderViewIdentifier = "SectionHeaderViewIdentifier"
    var sectionInfoArray: [SectionInfo] = []
    var countries: [String: [String]]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SetupSectionHeader()
        LoadJSONFile()
    }
    
    func LoadJSONFile()
    {
        if let path = Bundle.main.url(forResource: "countries", withExtension: "json")
        {
            do
            {
                let data = try Data(contentsOf: path, options: .mappedIfSafe)
                let jsonObjects = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                let jsonResult = (jsonObjects as? Dictionary<String, [String]>)!.sorted(by: { $0.key < $1.key })
                for (key,value) in jsonResult
                {sectionInfoArray.append(SectionInfo(itemsInSection: value, sectionTitle: key))}
            } catch { print(error) }
        }
    }
    
    func SetupSectionHeader()
    {
        let sectionHeaderNib: UINib = UINib(nibName: "SectionHeaderView", bundle: nil)
        self.tableView.register(sectionHeaderNib, forHeaderFooterViewReuseIdentifier: SectionHeaderViewIdentifier)
        self.tableView.sectionHeaderHeight = 40
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionInfoArray.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if self.sectionInfoArray.count > 0
        {
            let sectionInfo: SectionInfo = sectionInfoArray[section]
            if sectionInfo.open { return sectionInfo.open ? sectionInfo.itemsInSection.count : 0 }
        }
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath) as! CountriesTableViewCell
        
        cell.city.text = sectionInfoArray[indexPath.section].itemsInSection[indexPath.row]

        return cell
    }
  
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let sectionHeaderView: SectionHeaderView! = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: SectionHeaderViewIdentifier) as? SectionHeaderView
        let sectionInfo: SectionInfo = sectionInfoArray[section]
        
        sectionHeaderView.titleLabel.text = sectionInfo.sectionTitle
        sectionHeaderView.section = section
        sectionHeaderView.delegate = self
        let backview = UIView()
        backview.backgroundColor = Colors.Dark
        sectionHeaderView.backgroundView = backview
        return sectionHeaderView
    }
    
    func sectionHeaderView(sectionHeaderView: SectionHeaderView, sectionOpened: Int)
    {
        let sectionInfo: SectionInfo = sectionInfoArray[sectionOpened]
        let countOfRowsToInsert = sectionInfo.itemsInSection.count
        sectionInfo.open = true
        
        var indexPathToInsert: [IndexPath] = []
        for i in 0..<countOfRowsToInsert {
            indexPathToInsert.append(IndexPath(row: i, section: sectionOpened))
        }
        self.tableView.insertRows(at: indexPathToInsert, with: .top)
    }
    
    func sectionHeaderView(sectionHeaderView: SectionHeaderView, sectionClosed: Int)
    {
        let sectionInfo: SectionInfo = sectionInfoArray[sectionClosed]
        let countOfRowsToDelete = sectionInfo.itemsInSection.count
        sectionInfo.open = false
        if countOfRowsToDelete > 0
        {
            var indexPathToDelete: [IndexPath] = []
            for i in 0..<countOfRowsToDelete
            {
                indexPathToDelete.append(IndexPath(row: i, section: sectionClosed))
            }
            self.tableView.deleteRows(at: indexPathToDelete, with: .top)
        }
    }
    
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
//    {
//
//        let view = UIView(frame: CGRect(x:0, y:0, width:tableView.frame.size.width, height:18))
//        let label = UILabel(frame: CGRect(x:10, y:5, width:tableView.frame.size.width, height:18))
//        label.font = UIFont.systemFont(ofSize: 18)
//        label.text = Array(countries.keys)[section]
//        label.textColor = Colors.TintRed
//        view.addSubview(label);
//        view.backgroundColor = Colors.Light
//
//        return view
//    }
    
   
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
