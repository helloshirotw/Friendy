//
//  Video.swift
//  yoututbe
//
//  Created by SnoopyKing on 2017/11/18.
//  Copyright © 2017年 SnoopyKing. All rights reserved.
//

import UIKit
class Video : NSObject{
    var thumbnail_image_name : String?
    var title : String?
    var number_of_views : NSNumber?
    var uploadDate : NSDate?
    var duration: NSNumber?
    
    var channel : Channel?

}
class Channel : NSObject{
    var name : String?
    var profile_image_name : String?
}
