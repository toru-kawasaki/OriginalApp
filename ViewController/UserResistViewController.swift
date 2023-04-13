//
//  UserResistViewController.swift
//  Groupware
//
//  Created by PC-SYSKAI556 on 2023/04/06.
//

import UIKit
import Firebase
import PKHUD

class UserResistViewController: UIViewController {

    @IBOutlet weak var userIdTextFieldOutlet: UITextField!
    @IBOutlet weak var passwordTextFieldOutlet: UITextField!
    @IBOutlet weak var passwordCheckTextFieldOutlet: UITextField!
    @IBAction func userResistButtonAction(_ sender: Any) {
        if let userId = userIdTextFieldOutlet.text, let password = passwordTextFieldOutlet.text, let passwordCheck = passwordCheckTextFieldOutlet.text {

            // アドレスとパスワードと表示名のいずれかでも入力されていない時は何もしない
            if userId.isEmpty || password.isEmpty || passwordCheck.isEmpty {
                // ① UIAlertControllerクラスのインスタンスを生成
                let alert = UIAlertController(title: "エラー", message: "いずれかの項目が未入力です。", preferredStyle: .alert)
                // ②アクションの追加
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                // ③アラートの表示
                self.present(alert, animated: true, completion: nil)
                print("DEBUG_PRINT: 何かが空文字です。")
                return
            }
            if password != passwordCheck{
                // ① UIAlertControllerクラスのインスタンスを生成
                let alert = UIAlertController(title: "エラー", message: "パスワードが不一致です。", preferredStyle: .alert)
                // ②アクションの追加
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                // ③アラートの表示
                self.present(alert, animated: true, completion: nil)
                print("DEBUG_PRINT: パスワードが不一致です。")
            }
            // アドレスとパスワードでユーザー作成。ユーザー作成に成功すると、自動的にログインする
            Auth.auth().createUser(withEmail: userId, password: password) { authResult, error in
                if let error = error {
                    // ① UIAlertControllerクラスのインスタンスを生成
                    let alert = UIAlertController(title: "エラー", message: "ユーザ作成に失敗しました。", preferredStyle: .alert)
                    // ②アクションの追加
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    // ③アラートの表示
                    self.present(alert, animated: true, completion: nil)
                    // エラーがあったら原因をprintして、returnすることで以降の処理を実行せずに処理を終了する
                    print("DEBUG_PRINT: " + error.localizedDescription)
                    return
                }
                // ① UIAlertControllerクラスのインスタンスを生成
                HUD.flash(.labeledSuccess(title: "ユーザー作成に成功しました。", subtitle: nil), delay: 2)
                print("DEBUG_PRINT: ユーザー作成に成功しました。")
                self.dismiss(animated: true, completion: nil)
            }
        }
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
