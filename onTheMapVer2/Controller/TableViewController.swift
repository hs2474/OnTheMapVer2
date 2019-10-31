//
//  TableViewController.swift
//  onTheMapVer2
//
//  Created by Hema on 10/19/19.
//  Copyright © 2019 Hema. All rights reserved.
//
import UIKit


class TableViewController: UIViewController {
    
       
    @IBOutlet weak var tableView: UITableView!
    var selectedIndex = 0
    var currenPosition: MapPosition!

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.reloadData()
    }
    
    func showLoadFailure(message: String) {
        let alertVC = UIAlertController(title: "Map Load Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        //show(alertVC, sender: nil)
        self.present(alertVC, animated: true,  completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
         print(studentPosition.count)
        DispatchQueue.main.async {
            
            self.tableView.reloadData()
        }
      }

   
        @IBAction func refreshLocation(_ sender: Any) {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    
 

}
    
extension TableViewController: UITableViewDataSource, UITableViewDelegate { // MARK: Table Functions
        
        func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            let numStudents = studentPosition.count
            if numStudents >= 100 { return 100 } else { return numStudents }
            
        }
    
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "studentCell")!
            
            let locationRow = studentPosition[(indexPath as NSIndexPath).row]
            currenPosition = locationRow
            
            cell.textLabel?.text = locationRow.firstName + ", " + locationRow.lastName
            cell.detailTextLabel?.text = locationRow.mediaURL
            return cell
            
        }
    

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        let adata: MapPosition
        adata = studentPosition[(indexPath as NSIndexPath).row]
        print(adata.mediaURL)
        detailController.webData = adata.mediaURL
              
        self.present(detailController, animated: true, completion: nil)
    }
    

    
}



