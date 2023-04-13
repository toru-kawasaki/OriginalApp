//
//  LoginViewController.swift
//  Groupware
//
//  Created by PC-SYSKAI556 on 2023/04/06.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var userIdTextFieldOutlet: UITextField!
    @IBOutlet weak var passwordTextFieldOutlet: UITextField!
    //ログイン処理
    @IBAction func loginButtonAction(_ sender: Any) {
        if let userId = userIdTextFieldOutlet.text, let password = passwordTextFieldOutlet.text {
             // アドレスとパスワードと表示名のいずれかでも入力されていない時は何もしない
             if userId.isEmpty || password.isEmpty {
                 return
             }
            Auth.auth().signIn(withEmail: userId, password: password) { authResult, error in
                if let error = error {
                    print("DEBUG_PRINT: " + error.localizedDescription)
                    return
                }
                print("DEBUG_PRINT: ログインに成功しました。")

                // 画面を閉じてメニュー画面に移動
                let MenuViewController = self.storyboard?.instantiateViewController(withIdentifier: "MenuView")
                self.present(MenuViewController!, animated: true, completion: nil)
            }
         }
    }
    //ユーザ登録ボタン処理
    @IBAction func userResistButtonAction(_ sender: Any) {
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
