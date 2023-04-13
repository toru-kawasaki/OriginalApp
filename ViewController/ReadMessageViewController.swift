//
//  ReadMessageViewController.swift
//  Groupware
//
//  Created by PC-SYSKAI556 on 2023/03/31.
//

import UIKit

class ReadMessageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var messageTableViewOutlet: UITableView!
    
    var jsonMap: [[String: Any]] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        messageTableViewOutlet.fillerRowHeight = UITableView.automaticDimension
        
        messageTableViewOutlet.delegate = self
        messageTableViewOutlet.dataSource = self
        // カスタムセルを登録する
        let nib = UINib(nibName: "MessageTableViewCell", bundle: nil)
        messageTableViewOutlet.register(nib, forCellReuseIdentifier: "Cell")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let url: URL = URL(string: "http://localhost:8080/demo/getbyuserid")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST" // POSTリクエスト
        request.httpBody = "userid=user01".data(using: .utf8) // Bodyに情報を含める

        let task: URLSessionTask  = URLSession.shared.dataTask(with: request, completionHandler: {data, response, error in
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! [Any]
                self.jsonMap = json.map { (jsonMap) -> [String: Any] in
                    return jsonMap as! [String: Any]
                }
                print(self.jsonMap)
                DispatchQueue.main.sync {
                    self.messageTableViewOutlet.reloadData()
                }
            }
            catch {
                print("DEBUG_PRINT: + \(error)")
            }
        })
        task.resume()
        
    }
    // セルの設定
    // ここで、セルの中身を設定する
    func tableView(_ table: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell: UITableViewCell = table.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath)
        //cell.textLabel?.text = self.jsonMap[indexPath.row]["userid"] as? String
        //cell.detailTextLabel?.text = self.jsonMap[indexPath.row]["title"] as? String
        let messageData = MessageData(json: self.jsonMap[indexPath.row])
        let cell = table.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MessageTableViewCell
        cell.setMessage(messageData)
        print("DEBUG_PRINT output table")
        return cell
    }

    // セル数の設定
    // 今回は、apiを叩いた後、jsonMapにデータが格納されるので、`jsonMap.count`を設定
    func tableView(_ table: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.jsonMap.count
    }

    // セルの高さを設定
    //func tableView(_ table: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //    return 90.0
    //}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
