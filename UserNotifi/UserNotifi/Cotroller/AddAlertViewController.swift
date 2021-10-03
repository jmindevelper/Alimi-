//
//  AddAlertViewController.swift
//  UserNotifi
//
//  Created by J_Min on 2021/09/11.
//

import UIKit
import DropDown
import MaterialComponents.MaterialBottomSheet

class AddAlertViewController: UIViewController {
    
    let dropDown = DropDown()
    var group = [Category]()
    var groupName = [String]()
    var sendAlertDataClosure: ((Alert) -> Void)?
    var dateString = ""
    var dateString2 = ""
    var dateString3 = ""
    var categoryName = ""
    
    @IBOutlet weak var groupView: UIView!
    @IBOutlet weak var repeatView: UIView!
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var groupBtn: UIButton!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var repeatLabel: UILabel!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var categoryLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isModalInPresentation = true
        
        viewLayout(groupView)
        viewLayout(repeatView)
        viewLayout(dateView)
        
        textField.layer.cornerRadius = 20
        textField.layer.shadowRadius = 2
        textField.layer.shadowOpacity = 0.3
        textField.layer.masksToBounds = false
        textField.layer.shadowOffset = CGSize(width: 1, height: 1)
        textField.layer.shadowColor = UIColor.gray.cgColor
        
        textView.layer.cornerRadius = 20
        textView.layer.shadowRadius = 2
        textView.layer.shadowOpacity = 0.3
        textView.layer.masksToBounds = false
        textView.layer.shadowOffset = CGSize(width: 1, height: 1)
        textView.layer.shadowColor = UIColor.gray.cgColor
        
        for i in 0..<ListAlertViewController.categoryList.count {
            let a = ListAlertViewController.categoryList[i].categoryName
            groupName.append(a)
        }
        
        dropDown.dataSource = groupName
        
        // 초기데이타
        dateLabel.text = "날짜를 선택해주세요"
        categoryLabel.text = categoryName
        if categoryLabel.text == "전체" || categoryLabel.text == "예정" || categoryLabel.text == "오늘" || categoryLabel.text == "즐겨찾기" {
            categoryLabel.text = "미리알림"
        }
    }
    
    func viewLayout(_ view: UIView) {
        view.layer.cornerRadius = 20
        view.layer.shadowRadius = 2
        view.layer.shadowOpacity = 0.3
        view.layer.masksToBounds = false
        view.layer.shadowOffset = CGSize(width: 1, height: 1)
        view.layer.shadowColor = UIColor.gray.cgColor
    }
    
    @IBAction func selectGroupBtn(_ sender: Any) {
        dropDown.show()
        dropDown.anchorView = groupBtn
        dropDown.width = 300
        dropDown.cornerRadius = 15
        
        dropDown.selectionAction = { (index: Int, item: String) in
            self.categoryLabel.text = item
        }
        
        dropDown.bottomOffset = CGPoint(x:0, y: (dropDown.anchorView?.plainView.bounds.height)!)
    }
    
    func showAlert(message: String) -> UIAlertController {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(okAction)
        return alert
    }
    
    
    @IBAction func datePickerBtn(_ sender: Any) {
        
        guard let DatePickerVC = self.storyboard?.instantiateViewController(identifier: "DatePickerViewController") as? DatePickerViewController else { return }
        let bottomSheet = MDCBottomSheetController(contentViewController: DatePickerVC)

        let screenBounds = UIScreen.main.bounds
        
        bottomSheet.mdc_bottomSheetPresentationController?.preferredSheetHeight = screenBounds.width + 90
        
        DatePickerVC.sendDateStringClosure = { date, date2, date3 in
            self.dateString = date
            self.dateString2 = date2
            self.dateString3 = date3
            self.dateLabel.text = ("\(self.dateString) \(self.dateString3) \(self.dateString2)")
        }
        
        self.present(bottomSheet, animated: true, completion: nil)
    
    }
    
    @IBAction func cancelBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func repeatBtn(_ sender: Any) {
        
        guard let repeatVC = self.storyboard?.instantiateViewController(identifier: "RepeatViewController") as? RepeatViewController else { return }
        
        repeatVC.sendRepeatCycleDataDelegate = { data in
            
            if data == "안함" {
                self.repeatLabel.text = "안함"
            } else {
                self.repeatLabel.text = "\(data) 반복됨"
            }
            
        }
        
        let bottomSheet = MDCBottomSheetController(contentViewController: repeatVC)
        let screenBounds = UIScreen.main.bounds
        bottomSheet.mdc_bottomSheetPresentationController?.preferredSheetHeight = screenBounds.width + 60
        
        self.present(bottomSheet, animated: true, completion: nil)
        
    }
    
    @IBAction func saveBtn(_ sender: Any) {
        
        for _ in 0...0 {
            if dateLabel.text == "날짜를 선택해주세요" {
                self.present(showAlert(message: "날짜를 선택해주세요"), animated: true, completion: nil)
                break
            }
            if textField.text == "" {
                self.present(showAlert(message: "알림을 입력해주세요"), animated: true, completion: nil)
                break
            }
            
            if let sendAlertDataClosure = sendAlertDataClosure {
                
                if repeatLabel.text == "안함" {
                    sendAlertDataClosure(Alert(category: categoryLabel.text!, date: Date(), repeatNoti: false, repeatCycle: Date(), repeatCycleFormatter: "", dateFormatter: dateString, timeFormatter: dateString2, meridiemFormatter: dateString3, title: textField.text!, memo: textView.text, flag: false, isOn: true))
                } else {
                    sendAlertDataClosure(Alert(category: categoryLabel.text!, date: Date(), repeatNoti: true, repeatCycle: Date(), repeatCycleFormatter: repeatLabel.text!, dateFormatter: dateString, timeFormatter: dateString2, meridiemFormatter: dateString3, title: textField.text!, memo: textView.text, flag: false, isOn: true))
                }
            }
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}
