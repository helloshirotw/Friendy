//
//  ListTableViewCell.swift
//  Friendy
//
//  Created by Gary Chen on 30/4/2018.
//  Copyright © 2018 Gary Chen. All rights reserved.
//

import UIKit
import Firebase

class ListTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var namelabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    var user: User? {
        didSet {
            namelabel.text = user?.name
            if message == nil {
                emailLabel.text = user?.email
            }
            
            if let profileImageUrl = user?.profileImageUrl {
                profileImageView.cacheImage(urlString: profileImageUrl)
            }
        }
    }
    
    var message: Message? {
        didSet {
            setUser()
            emailLabel.text = message?.text
            
            
            setTimeLabel()
        }
    }
    
    private func setUser() {
        guard let id = message?.chatParterId else { return }
        let ref = FirebaseManager.usersRef.child(id)
        ref.observe(.value) { (snapshot) in
            guard let dic = snapshot.value as? [String: AnyObject] else { return }
            self.user = User(dictionary: dic)
            
            // Check if user sent a photo
            if self.message?.imageUrl != nil {
                if let name = self.user?.name {
                    self.emailLabel.text = "\(name) sent a photo"
                }
            }
        }
    }

    
    private func setTimeLabel() {
        if let seconds = message?.timestamp {
            let timeStampDate = Date(timeIntervalSince1970: Double(seconds))
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh:mm:ss a"
            
            timeLabel.text = dateFormatter.string(from: timeStampDate)
            timeLabel.isHidden = false
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    

    
}
