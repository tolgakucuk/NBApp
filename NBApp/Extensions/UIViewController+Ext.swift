

import Foundation
import UIKit

extension UIViewController {
    
    //API'den veri çekerken loading animasyonunu gösteren fonksiyon
    class func displaySpinner(onView : UIView) -> UIView {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView(style: .large)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        return spinnerView
    }
    
    //API'den veri çekerken loading animasyonunu gizleyen fonksiyon
    class func removeSpinner(spinner: UIView) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            spinner.removeFromSuperview()
        }
    }
}
