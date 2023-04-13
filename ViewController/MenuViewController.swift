//
//  MenuViewController.swift
//  Groupware
//
//  Created by PC-SYSKAI556 on 2023/03/30.
//

import UIKit
import Firebase


class MenuViewController: UIViewController {
    

    @IBAction func toSendMessage(_ sender: Any) {
        print("タップ")
        performSegue(withIdentifier: "toSendMessage",sender: nil)
    }
    @IBAction func toCalendarView(_ sender: Any) {
        print("タップ")
        performSegue(withIdentifier: "toCalendar",sender: nil)
    }
    
    @IBAction func tapToReadMessageView(_ sender: Any) {
        print("タップ")
        performSegue(withIdentifier: "toReadMessage",sender: nil)
    }
    @IBAction func tapLogout(_ sender: Any) {
        // ログアウトする
        try! Auth.auth().signOut()

        // ログイン画面を表示する
        let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "Login")
        self.present(loginViewController!, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
         super.viewDidAppear(animated)
        // currentUserがnilならログインしていない
        if Auth.auth().currentUser == nil {
            // ログインしていないときの処理
            let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "Login")
            self.present(loginViewController!, animated: true, completion: nil)
        }
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
