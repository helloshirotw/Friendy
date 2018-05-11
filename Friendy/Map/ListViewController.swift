//
//  ListViewController.swift
//  Friendy
//
//  Created by Gary Chen on 30/4/2018.
//  Copyright © 2018 Gary Chen. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!

    var users = [User]()
    var mapTabBarController: UITabBarController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "People Nearby"
        setupView()
        fetchUsers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.hidesBackButton = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        popToMap()
    }
    
    func fetchUsers() {
        
        FirebaseManager.usersRef.observe(.childAdded) { (snapshot) in
            guard let dic = snapshot.value as? [String: AnyObject] else { return }
            let user = User(dictionary: dic)
            
            user.id = snapshot.key
            self.users.append(user)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
    }
    
    private func setupView() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "map_nav"), style: .plain, target: self, action: #selector(popToMap))
        
        let nib = UINib(nibName: CellConstants.LIST, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: CellIdentifiers.LIST)
    }
    
    @objc func popToMap() {
        navigationController?.popViewController(animated: false)
    }

}

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.LIST, for: indexPath) as! ListTableViewCell
        cell.user = users[indexPath.row]
        
        return cell
    }
    
}


extension ListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = self.users[indexPath.row]
        tabBarController?.selectedIndex = 0

        guard let navController = mapTabBarController?.viewControllers![0] as? UINavigationController else { return }
        navController.popToRootViewController(animated: true)
        if let friendViewController = navController.topViewController as? FriendViewController {
            friendViewController.pushToChat(user: user)
        }        
        
    }
}
