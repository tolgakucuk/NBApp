
import Foundation
import UIKit

extension UIView {
    
    //View'lara gölge eklenmesi için yazılan fonksiyon.
    func addShadow(color: UIColor, opacity: Float, radius: CGFloat) {
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = .zero
        layer.shadowRadius = radius
    }
    
}
