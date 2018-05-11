//
//  FriendViewController.swift
//  Friendy
//
//  Created by Gary Chen on 30/4/2018.
//  Copyright © 2018 Gary Chen. All rights reserved.
//

import UIKit
import Firebase

class FriendViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var messages = [Message]()
    var messageDic = [String: Message]()
    var user: User?
    
    func observeMessage() {
        //Get messageId
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = FirebaseManager.userMessagesRef.child(uid)
        
        ref.observe(.childAdded) { (snapshot) in
            let toId = snapshot.key
            let userMessageRef = FirebaseManager.userMessagesRef.child(uid).child(toId)
            
            userMessageRef.observe(.childAdded, with: { (snapshot) in
                
                let messageId = snapshot.key
                self.fetchMessage(messageId: messageId)
            })
        }
        
        ref.observe(.childRemoved) { (snapshot) in
            self.messageDic.removeValue(forKey: snapshot.key)
            self.attemptReloadTable()
        }
    }
    
    private func fetchMessage(messageId: String) {
        
        let messageRef = FirebaseManager.messagesRef.child(messageId)
        messageRef.observeSingleEvent(of: .value) { (snapshot) in
            guard let dic = snapshot.value as? [String: AnyObject] else { return }
            
            let message = Message(dictionary: dic)
            
            if let chatPartnerId = message.chatParterId {
                self.messageDic[chatPartnerId] = message
            }
            self.attemptReloadTable()
        }
    }
    
    var timer: Timer?
    
    private func attemptReloadTable() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
    }
    
    @objc func handleReloadTable() {
        
        self.messages = Array(self.messageDic.values)
        
        self.messages.sort { (message1, message2) -> Bool in
            return message1.timestamp! > message2.timestamp!
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: CellConstants.LIST, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: CellIdentifiers.LIST)
        
        tableView.allowsMultipleSelectionDuringEditing = true
        
        if getCurrentUser() != nil {
            user = getCurrentUser()
        }
        setupNavBar(user: user!)
        messages.removeAll()
        messageDic.removeAll()
        tableView.reloadData()
        observeMessage()
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        print(indexPath.row)
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let message = self.messages[indexPath.row]
        
        if let chatParterId = message.chatParterId {
            FirebaseManager.userMessagesRef.child(uid).child(chatParterId).removeValue { (error, ref) in
                
                if error != nil {
                    print("Failed to delete message:", error!)
                    return
                }
                
                self.messageDic.removeValue(forKey: chatParterId)
                self.attemptReloadTable()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    func pushToChat(user: User) {
        let chatViewController = ChatViewController()
        chatViewController.user = user
        navigationController?.pushViewController(chatViewController, animated: true)
    }
    
}


extension FriendViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.LIST) as! ListTableViewCell

        cell.message = messages[indexPath.row]
        
        return cell
    }
    
    
}

extension FriendViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        let message = messages[indexPath.row]
        guard let chatParterId = message.chatParterId else { return }
        let ref = FirebaseManager.usersRef.child(chatParterId)
        ref.observeSingleEvent(of: .value) { (snapshot) in
            guard let dic = snapshot.value as? [String: AnyObject] else { return }
            let user = User(dictionary: dic)
            user.id = chatParterId
            self.pushToChat(user: user)
        }
    }
}

