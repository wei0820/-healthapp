//
//  ListViewController.swift
//  healthapp
//
//  Created by mac on 2021/10/27.
//

import UIKit
import Firebase

class ListViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{
    // 設定表格section的列數
      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return self.dateItem.count
      }
      
      // 表格的儲存格設定
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cellIdentifier = "Cell"
          let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier,for:indexPath)
        cell.textLabel?.text =  dateItem[indexPath.row].address
        cell.detailTextLabel?.text =   dateItem[indexPath.row].date
          return cell
          
      }

    @IBOutlet weak var tableview: UITableView!
    var dateItem: [DateItem] = [DateItem]()
    var imageArr = [UIImage]()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "討論分享區"
        tableview.delegate = self
        tableview.dataSource = self
        getData()



    }
    
    func  getData(){

        let reference: DatabaseReference! = Database.database().reference().child("SharePlace").child("SharePlace")

            reference.queryOrderedByKey().observe(.value, with: { snapshot in
                         if snapshot.childrenCount > 0 {
                            self.dateItem.removeAll()

                             for item in snapshot.children {
            
                                 let data = DateItem(snapshot: item as! DataSnapshot)
                                print("jack",data.address)
                                self.dateItem.append(data)
                                 
                             }
                            self.dateItem.reverse()

                            self.tableview.reloadData()
                         }
                         
                     })
        }

}
