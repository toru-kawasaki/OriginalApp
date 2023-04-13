//
//  SendMessageViewController.swift
//  Groupware
//
//  Created by PC-SYSKAI556 on 2023/03/31.
//

import UIKit

class SendMessageViewController: UIViewController {

    @IBOutlet weak var toUserOutlet: UITextField!
    @IBOutlet weak var titleOutlet: UITextField!
    @IBOutlet weak var contentsOutlet: UITextView!
    @IBAction func sendButtonAction(_ sender: Any) {
        if toUserOutlet.text!.isEmpty || titleOutlet.text!.isEmpty || contentsOutlet.text!.isEmpty{
            print("DEBUG_PRINT:項目未入力エラー")
            // ① UIAlertControllerクラスのインスタンスを生成
            let alert = UIAlertController(title: "エラー", message: "いずれかの項目が未入力です。", preferredStyle: .alert)
            // ②アクションの追加
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            // ③アラートの表示
            self.present(alert, animated: true, completion: nil)
            return
        }
        let url: URL = URL(string: "http://localhost:8080/demo/add")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST" // POSTリクエスト
        request.httpBody = "userid=\(self.toUserOutlet.text!)&title=\(self.titleOutlet.text!)&contents=\(self.contentsOutlet.text!)".data(using: .utf8) // Bodyに情報を含める

        let task: URLSessionTask  = URLSession.shared.dataTask(with: request, completionHandler: {data, response, error in
                print("DEBUG_PRINT: + \(error)")
        })
        task.resume()
        // ① UIAlertControllerクラスのインスタンスを生成
        let alert = UIAlertController(title: "Info", message: "メッセージを送信しました。", preferredStyle: .alert)
        // ②アクションの追加
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        // ③アラートの表示
        self.present(alert, animated: true, completion: nil)
        self.toUserOutlet.text = ""
        self.titleOutlet.text = ""
        self.contentsOutlet.text = ""
        return
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
