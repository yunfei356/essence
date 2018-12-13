//
//  ChatViewController.swift
//  zhiyouios
//
//  Created by Yun Fei Guo on 2018-10-30.
//  Copyright © 2018 Yun Fei Guo. All rights reserved.
//

import UIKit

struct Connection {
    let personId: String
    let displayName: String
}

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var connectionList = [Connection]()
    private var selectedRow: Int?
    
    @IBAction func onCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        initializeConnections()
    }
    
    func initializeConnections() {
        //TODO: call GraphQL API to get list of connections.
        self.connectionList.append(Connection(personId: "y0x0", displayName: "Nancy"))
        self.connectionList.append(Connection(personId: "y1x1", displayName: "Jim"))
        self.connectionList.append(Connection(personId: "y2x2", displayName: "May"))
        self.connectionList.append(Connection(personId: "y3x3", displayName: "Susan"))
        self.connectionList.append(Connection(personId: "y4x4", displayName: "Bob"))
    }
    
    // The following four functions render the tableview and its contents
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.register(ChatConvoTableViewCell.self,
                           forCellReuseIdentifier: "redCell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "redCell", for: indexPath)
        cell.textLabel?.text = self.connectionList[indexPath.row].displayName
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.connectionList.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedRow = indexPath.row
        self.performSegue(withIdentifier: "OpenConvo", sender: self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension;
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? ConversationViewController {
            destinationViewController.connectionPersonId = self.connectionList[self.selectedRow!].personId
            destinationViewController.connection.name = self.connectionList[self.selectedRow!].displayName
        }
    }
}
