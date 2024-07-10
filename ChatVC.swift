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
    
    var webSocket: URLSessionWebSocketTask?//🧪
    var messages: [String] = [] //🧪 메세지를 받아놓을 통
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.separatorStyle = .none // 셀과 셀사이의 구분선 없애는 기능.
        configure()
     
    }
   private func configure() {
       sendBtn.layer.cornerRadius = 25
       //1단계[웹소켓 열기]
       openWebsocket()
    
    }
    
    func openWebsocket() { // 🧪[웹소켓 여는 메서드]
        let urlString = "아직 미정임"
            if let url = URL(string: urlString) {
                var request = URLRequest(url: url)
                let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
                 webSocket = session.webSocketTask(with: request)
                webSocket?.resume()
            }
        
    }
    
    func receiveMessage() {//🧪[메세지를 받는 메서드]
            webSocket?.receive { [weak self] result in
                switch result {
                case .success(let message):
                    switch message {
                    case .string(let text):
                        print("Received text: \(text)")
                        DispatchQueue.main.async {
                            self?.messages.append(text)
                            self?.tableView.reloadData()
                        }
                    case .data(let data):
                        print("Received data: \(data)")
                    @unknown default:
                        fatalError()
                    }
                    // 다음 메시지를 계속 받기 위해 재귀적으로 호출
                    self?.receiveMessage()
                case .failure(let error):
                    print("Failed to receive message: \(error.localizedDescription)")
                }
            }
        }
    
    @IBAction func tapSendBtn(_ sender: UIButton) {
        print("tapSendBtn - Called")
               guard let message = self.chatTextField.text else { return }
               
               webSocket?.send(URLSessionWebSocketTask.Message.string(message)) { [weak self] error in
                   if let error = error {
                       print("Failed with Error \(error.localizedDescription)")
                   } else {
                       // 메시지 전송 성공 시 텍스트 필드 초기화
                       print("메세지 전송이 성공적으로 이루어짐")
                       DispatchQueue.main.async {
                           self?.chatTextField.text = ""
                       }
                   }
               }
        
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
        return self.messages.count //🧪
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell") as? MyCell else {
           return UITableViewCell()
        }
        cell.subView.layer.cornerRadius = 10
        cell.textLabel?.text = messages[indexPath.row] // 메시지를 셀에 표시🧪
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
}

extension ChatVC: URLSessionWebSocketDelegate {
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
            print("Web socket opened")
        receiveMessage() // 웹소켓이 열리면 메시지를 받기 시작
        }

        
        func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
            print("Web socket closed")
            
        }
   
}
