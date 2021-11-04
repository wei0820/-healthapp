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
        cell.textLabel?.text =  "名稱:"  + dateItem[indexPath.row].name
        cell.detailTextLabel?.text =   "地址:"  +  dateItem[indexPath.row].address
          return cell
          
      }

    @IBOutlet weak var tableview: UITableView!
    var dateItem: [DateItem] = [DateItem]()
    var myIndex : IndexPath = IndexPath()

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
                                self.dateItem.append(data)
                                 
                             }
                            self.dateItem.reverse()

                            self.tableview.reloadData()
                         }
                         
                     })
        }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//            tableView.deselectRow(
//                at: indexPath, animated: true)
        myIndex = IndexPath(row: indexPath.section, section: indexPath.row)

            performSegue(withIdentifier: "detail", sender: nil)
           
        }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let controller = segue.destination as? DetaiViewController
        let indexPath = tableview.indexPathForSelectedRow
        controller?.id =  dateItem[indexPath!.row].id
        controller?.name =  dateItem[indexPath!.row].name
        controller?.address =  dateItem[indexPath!.row].address
        controller?.lat =  dateItem[indexPath!.row].lat
        controller?.lon =  dateItem[indexPath!.row].lon
        controller?.uuid =  dateItem[indexPath!.row].uuid
        controller?.date =  dateItem[indexPath!.row].date
        controller?.like =  dateItem[indexPath!.row].like
        controller?.unlike  = dateItem[indexPath!.row].unlike
        controller?.usermessage = dateItem[indexPath!.row].usermessage
        controller?.key =  dateItem[indexPath!.row].key
        controller?.url_1 = dateItem[indexPath!.row].url_1
        controller?.url_2 = dateItem[indexPath!.row].url_2
        controller?.url_3 = dateItem[indexPath!.row].url_3
        controller?.type = dateItem[indexPath!.row].type
        controller?.scroe = dateItem[indexPath!.row].scroe

        
        
            
        }

}
