

import UIKit

class PlayerCell: UITableViewCell {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var playerIDLabel: UILabel!
    @IBOutlet weak var playerNameLabel: UILabel!
    
    func configureCell() {
        cellView.layer.cornerRadius = 10
        cellView.addShadow(color: .systemYellow, opacity: 0.5, radius: 3.0)
    }
    
    

}
