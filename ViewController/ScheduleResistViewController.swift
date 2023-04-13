//
//  ScheduleResistViewController.swift
//  Groupware
//
//  Created by PC-SYSKAI556 on 2023/04/05.
//

import UIKit
import Firebase
import PKHUD

class ScheduleResistViewController: UIViewController {

    @IBOutlet weak var scheduleStartDateTimeOutlet: UIDatePicker!
    @IBOutlet weak var scheduleEndDateTimeOutlet: UIDatePicker!
    @IBOutlet weak var scheduleTitleOutlet: UITextField!
    @IBOutlet weak var scheduleContentsOutlet: UITextView!
    var mode: Bool = true //更新モード　true:追加　false:更新
    var selectedDate: String! = ""
    var countSchedule: Int = 0
    var initStartDate: Date?
    var initEndDate: Date?
    var initTitle: String! = ""
    var initContents: String! = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    // 表示するごとに開始日終了日を初期化
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        scheduleStartDateTimeOutlet.date = initStartDate!
        scheduleEndDateTimeOutlet.date = initEndDate!
        scheduleTitleOutlet.text = initTitle
        scheduleContentsOutlet.text = initContents


    }
    //スケジュールボタン押下時の挙動
    @IBAction func resistScheduleButtonAction(_ sender: Any) {
        //未入力エラー
        if scheduleTitleOutlet.text!.isEmpty {
            // ① UIAlertControllerクラスのインスタンスを生成
            let alert = UIAlertController(title: "エラー", message: "予定が未入力です。", preferredStyle: .alert)
            // ②アクションの追加
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            // ③アラートの表示
            self.present(alert, animated: true, completion: nil)
            return
        }
        //登録中のプログレス表示
        HUD.show(.progress)
        //ユーザIDを取得してfirestoreのドキュメントIDに設定
        let myid: String! = Auth.auth().currentUser?.uid
        //スケジュールデータをFireStoreに追加
        let scheduleRef = Firestore.firestore().collection("Schedule").document(myid!)
        //更新モードの場合は先に削除
        if mode == false {
            let scheduleDic = [
                "id":countSchedule,
                "startDate": initStartDate,
                "endDate": initEndDate,
                "title": initTitle,
                "contents": initContents,
                ] as [String : Any]
            var updateValue: FieldValue = FieldValue.arrayRemove([scheduleDic])
            scheduleRef.updateData(["schedule": updateValue])
        }
        let scheduleDic = [
            "id":countSchedule,
            "startDate": scheduleStartDateTimeOutlet.date,
            "endDate": scheduleEndDateTimeOutlet.date,
            "title": scheduleTitleOutlet.text,
            "contents": scheduleContentsOutlet.text,
            ] as [String : Any]
        var updateValue: FieldValue = FieldValue.arrayUnion([scheduleDic])
        scheduleRef.getDocument { (document, error) in
            if let document = document, document.exists {
                scheduleRef.updateData(["schedule": updateValue])
            } else {
                scheduleRef.setData(["schedule": updateValue])
            }
        }
        //プログレス終了
        HUD.hide()
        HUD.flash(.labeledSuccess(title: "スケジュールを登録しました。", subtitle: nil), delay: 2)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
