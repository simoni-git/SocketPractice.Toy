//
//  ChatVC.swift
//  SocketPractice
//
//  Created by 시모니 on 7/7/24.
//

import UIKit

class ChatVC: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomSubView: UIView!
    @IBOutlet weak var chatTextField: UITextField!
    @IBOutlet weak var sendBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.separatorStyle = .none // 셀과 셀사이의 구분선 없애는 기능.
        configure()
     
    }
   private func configure() {
       sendBtn.layer.cornerRadius = 25
    
    }
    
    
    @IBAction func tapSendBtn(_ sender: UIButton) {
        print("tapSendBtn - Called")
        
    }
    
    //MARK: - 키보드관련
    override func viewWillAppear(_ animated: Bool) {
        print("ChatVC - viewWillApper Called")
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowNotificationHandler(notification: )) , name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideNotificationHandler(notification: )), name: UIResponder.keyboardWillHideNotification, object: self)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("ChatVC - viewWillDisappear Called")
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: self)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: self)
    }
    
    
    
    
    @objc func keyboardWillShowNotificationHandler(notification: Notification) {
        print("keyboardWillShowNotificationHandler() - Called")
        if let keyboardSize =
            (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            print("현재 키보드 사이즈는 >> \(keyboardSize)")
            
            if (keyboardSize.height < self.bottomSubView.frame.origin.y) {
                let distance = keyboardSize.height
                self.view.frame.origin.y = -distance
            }
        }
    }
    
    @objc func keyboardWillHideNotificationHandler(notification: Notification) {
        print("keyboardWillHideNotificationHandler() - Called")
        self.view.frame.origin.y = 0
    }

    @objc func dismissKeyboard() {
        self.view.frame.origin.y = 0
        view.endEditing(true)
    }
    
}

extension ChatVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell") as? MyCell else {
           return UITableViewCell()
        }
        cell.subView.layer.cornerRadius = 10
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
}

class MyCell: UITableViewCell {
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var chatLabel: UILabel!
    
}
