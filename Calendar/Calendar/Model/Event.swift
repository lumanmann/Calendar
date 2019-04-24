//
//  Event.swift
//  Calendar
//
//  Created by WY NG on 20/4/2019.
//  Copyright © 2019 lumanmann. All rights reserved.
//

import Foundation

struct Event {
    var date: Date!
    var title: String!
    
    init(date: Date, title: String) {
        self.date = date
        self.title = title
    }
}
