//
//  Views.swift
//  Rebu
//
//  Created by Oisín Lavery on 5/4/16.
//  Copyright © 2016 Oisin Lavery. All rights reserved.
//

import UIKit

enum Views: String {

    case AuthView = "AuthView" //Change View1 to be the name of your nib
    case ProfileView = "ProfileView"

    func getView() -> UIView {
        return NSBundle.mainBundle().loadNibNamed(self.rawValue, owner: nil, options: nil)[0] as! UIView
    }
}