//
//  ViewController.swift
//  swf-DFP-TableView-demo
//
//  Created by S.Emoto on 2018/07/04.
//  Copyright © 2018年 S.Emoto. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private let dataSource = TableViewProvider()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
}

extension ViewController {
    
    func setup() {
        tableView.dataSource = dataSource
        dataSource.setupDFP(vc: self, tab: tableView)
    }
}
