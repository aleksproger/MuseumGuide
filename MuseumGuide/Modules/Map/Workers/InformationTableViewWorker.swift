//
//  TableViewWorker.swift
//  MuseumGuide
//
//  Created by Alex on 29.03.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation
import UIKit

class InformationTableViewWorker: NSObject, TableViewWorker {
    
    private var cellInfos: [InfoTableViewCellModel] = MuseumCell.makeDefaultInfos() + ContactsCell.makeDefaultInfos()
    
    func updateDataSource(with data: [InfoTableViewCellModel]) {
        cellInfos = data
    }
    
    //MARK: - UITableView methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellInfos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellModel = cellInfos[indexPath.row]
        switch cellModel {
        case .contacts(let contacts):
            let cell = tableView.dequeueReusableCell(withIdentifier: "\(ContactsCell.self)", for: indexPath) as! ContactsCell
            cell.update(with: contacts)
            return cell
            
        case .info(let museum):
            let cell = tableView.dequeueReusableCell(withIdentifier: "\(MuseumCell.self)", for: indexPath) as! MuseumCell
            cell.update(with: museum)
            return cell
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return MuseumCell.Layout.estimatedHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
