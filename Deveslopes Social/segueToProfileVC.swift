//
//  segueToProfileVC.swift
//  Deveslopes Social
//
//  Created by Christopher Heins on 12/14/16.
//  Copyright © 2016 Christopher Todd Heins. All rights reserved.
//

import UIKit

class segueToProfileVC: UIStoryboardSegue {
    override func perform() {
        
        let src = self.source
        let dest = self.destination
        let id = self.identifier?.description
        print("TODD:  Source: \(src) Destination: \(dest)")
        src.performSegue(withIdentifier: id!, sender: PostCell())
        //src.navigationController?.pushViewController(dest, animated: true)
    }
}
