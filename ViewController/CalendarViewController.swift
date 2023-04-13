//
//  CalendarViewController.swift
//  Groupware
//
//  Created by PC-SYSKAI556 on 2023/03/31.
//

import UIKit
import FSCalendar
import Firebase
import RealmSwift

class CalendarViewController: UIViewController,FSCalendarDataSource,FSCalendarDelegate,FSCalendarDelegateAppearance, UITableViewDataSource, UITableViewDelegate  {

    let realm = try! Realm()
    @IBOutlet weak var scheduleTableViewOutlet: UITableView!
    // スケジュールデータを格納する配列
    var scheduleArray : [ScheduleData] = []
    var scheduleArrayRealm = try! Realm().objects(ScheduleData.self)  // ←追加
    var scheduleDataArray = try! Realm().objects(ScheduleData.self)
    // Firestoreのリスナー
    var listener: ListenerRegistration?
    var countSchedule: Int? //スケジュールの格納数
    let df = DateFormatter()
    
    @IBOutlet weak var fscalendarOutlet: FSCalendar!
    @IBOutlet weak var dateLabelOutlet: UILabel!
    @IBAction func addScheduleButtonAction(_ sender: Any) {
        print("DEBUG_PRINT: プラスボタン押下")
        if countSchedule != nil{
            let scheduleResistViewController = self.storyboard?.instantiateViewController(withIdentifier: "ScheduleResistView") as! ScheduleResistViewController
            scheduleResistViewController.selectedDate = dateLabelOutlet.text
            scheduleResistViewController.countSchedule = countSchedule!+1
            let datestring:String! = dateLabelOutlet.text! + "000000"
            let df = DateFormatter()
            df.locale = Locale(identifier: "en_US_POSIX")
            df.dateFormat = "yyyy-MM-ddHHmmss"
            scheduleResistViewController.mode = true //追加モード
            scheduleResistViewController.initStartDate = df.date(from: datestring)!
            scheduleResistViewController.initEndDate = df.date(from: datestring)!
            self.present(scheduleResistViewController, animated: true, completion: nil)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        fscalendarOutlet.dataSource = self
        fscalendarOutlet.delegate = self
        df.dateFormat = "yyyy-MM-dd"
        dateLabelOutlet.text = df.string(from: Date())
        // Do any additional setup after loading the view.
        scheduleTableViewOutlet.fillerRowHeight = UITableView.automaticDimension
        scheduleTableViewOutlet.delegate = self
        scheduleTableViewOutlet.dataSource = self
        // カスタムセルを登録する
        let nib = UINib(nibName: "ScheduleTableViewCell", bundle: nil)
        scheduleTableViewOutlet.register(nib, forCellReuseIdentifier: "Cell")
    }
    //日付選択時
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        df.dateFormat = "yyyy-MM-dd"
        dateLabelOutlet.text = df.string(from: date)
        //32399秒足して日付＋23:59:59を取得
        let endDate = Calendar.current.date(byAdding:.second ,value: 86399,to: date)
        let startDate = Calendar.current.date(byAdding:.second ,value: 0,to: date)
        print("date= \(date) start= \(startDate) end= \(endDate) ")
        //当日が期間開始終了にまたがるものを抽出
        scheduleDataArray = realm.objects(ScheduleData.self).filter("startDateTime <= %@ AND endDateTime >= %@",endDate,startDate)
        self.scheduleTableViewOutlet.reloadData()
    }
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        let scheduleResistViewController:ScheduleResistViewController =  segue.destination as! ScheduleResistViewController
        // +ボタン押下時は現在日付を渡してスケジュール登録画面を起動
        if segue.identifier == "ScheduleResistViewSegue"{
            
                scheduleResistViewController.selectedDate = dateLabelOutlet.text
            
            return
        }
    }
    */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("DEBUG_PRINT: viewWillAppear")
        // ログイン済みか確認
        if Auth.auth().currentUser != nil {
            let myid: String! = Auth.auth().currentUser?.uid
            do{
                let scheduleRef = try Firestore.firestore().collection("Schedule").whereField(FieldPath.documentID(), isEqualTo:myid)
                listener = scheduleRef.addSnapshotListener() { (querySnapshot, error) in
                    if let error = error {
                        print("DEBUG_PRINT: snapshotの取得が失敗しました。 \(error)")
                        return
                    }
                    guard let snapshot = querySnapshot else{
                        return
                    }
                    // 取得したdocumentをもとにPostDataを作成し、postArrayの配列にする。
                    //for document in querySnapshot!.documents {
                    snapshot.documentChanges.forEach { diff in
                        let document = diff.document
                        print("DEBUG_PRINT: document取得 \(document.documentID)")
                        let scheduleDic = document.data()
                        let mapData = scheduleDic["schedule"] as? [Any]
                        self.countSchedule = mapData?.count
                        if mapData != nil{
                            for data in mapData!{
                                let dicData = data as! NSMutableDictionary
                                let dic = dicData  as NSDictionary as! [String : AnyObject]
                                let allSchedules = try! Realm().objects(ScheduleData.self)
                                self.countSchedule = dic["id"] as? Int
                                let scheduleData = ScheduleData(documentID : document.documentID,data: dic)
                                if(diff.type == .added || diff.type == .modified){
                                    try! self.realm.write {
                                        self.realm.add(scheduleData, update: .modified)
                                    }
                                }
                                else {//(.removed)
                                    try! self.realm.write {
                                        self.realm.delete(scheduleData)
                                    }
                                }
                            }
                        }
                    }
                    //fscalendarを再描画
                    self.fscalendarOutlet.reloadData()
                    self.scheduleTableViewOutlet.reloadData()
                    if self.countSchedule == nil{self.countSchedule = 0}
                }
            }
        }
        self.fscalendarOutlet.reloadData()
        self.scheduleTableViewOutlet.reloadData()
    }
        
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("DEBUG_PRINT: viewWillDisappear")
        // listenerを削除して監視を停止する
        listener?.remove()
    }
    //日付の表示
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        let df: DateFormatter = DateFormatter()
        df.dateFormat = "yyyyMMdd"
        for day in scheduleArrayRealm{
            let startDate = df.string(from: day.startDateTime!)
            let endDate = df.string(from: day.endDateTime!)
            let currentDate = df.string(from: date)
            let currentDateEnd = df.string(from: Calendar.current.date(byAdding:.second ,value: 86399,to: date)!)
            if currentDate >= startDate && currentDateEnd <= endDate{
                return UIColor.green
            }
        }
        return nil
    }
    // セルの中身を設定する
    func tableView(_ table: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ScheduleTableViewCell
        let scheduleData = scheduleDataArray[indexPath.row]
        cell.setSchedule(scheduleData)
        print("DEBUG_PRINT: \(scheduleData.startDateTime) \(scheduleData.endDateTime)")
        // セル内のボタンのアクションをソースコードで設定する
        cell.updateButtonOutlet.addTarget(self, action:#selector(tapUpdateButton(_:forEvent:)), for: .touchUpInside)
        return cell
    }
    @objc func tapUpdateButton(_ sender: UIButton, forEvent event: UIEvent) {
        // タップされたセルのインデックスを求める
        let touch = event.allTouches?.first
        let point = touch!.location(in: self.scheduleTableViewOutlet)
        let indexPath = scheduleTableViewOutlet.indexPathForRow(at: point)
        print("DEBUG_PRINT: 更新ボタンタップ \(indexPath!.row)")
        // 配列からタップされたインデックスのデータを取り出す
        let scheduleData = scheduleDataArray[indexPath!.row]
        let scheduleResistViewController = self.storyboard?.instantiateViewController(withIdentifier: "ScheduleResistView") as! ScheduleResistViewController
        scheduleResistViewController.mode = false //更新モード
        scheduleResistViewController.selectedDate = dateLabelOutlet.text
        scheduleResistViewController.countSchedule = scheduleData.id
        scheduleResistViewController.initStartDate = scheduleData.startDateTime!
        scheduleResistViewController.initEndDate = scheduleData.endDateTime!
        scheduleResistViewController.initTitle = scheduleData.title!
        scheduleResistViewController.initContents = scheduleData.contents!
        self.present(scheduleResistViewController, animated: true, completion: nil)
    }
    // セル数の設定
    func tableView(_ table: UITableView, numberOfRowsInSection section: Int) -> Int {
        if countSchedule != nil{
            if countSchedule != 0{
                return self.scheduleDataArray.count
            }
        }
        return 0
    }
    // セルが削除が可能なことを伝えるメソッド
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath)-> UITableViewCell.EditingStyle {
        return .delete
    }
    // Delete ボタンが押された時に呼ばれるメソッド
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // --- ここから ---
        if editingStyle == .delete {
            // データベースから削除する
            let myid: String! = Auth.auth().currentUser?.uid
            let id = self.scheduleDataArray[indexPath.row].id
            let startDateTime = self.scheduleDataArray[indexPath.row].startDateTime
            let endDateTime = self.scheduleDataArray[indexPath.row].endDateTime
            let title = self.scheduleDataArray[indexPath.row].title
            let contents = self.scheduleDataArray[indexPath.row].contents
            let scheduleRef = Firestore.firestore().collection("Schedule").document(myid!)
            let scheduleDic = [
                    "id":id,
                    "startDate": startDateTime,
                    "endDate": endDateTime,
                    "title": title,
                    "contents": contents
                    ] as [String : Any]
            var updateValue: FieldValue = FieldValue.arrayRemove([scheduleDic])
            scheduleRef.updateData(["schedule": updateValue])
            try! realm.write {
                self.realm.delete(self.scheduleDataArray[indexPath.row])
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        } // --- ここまで追加 ---
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
