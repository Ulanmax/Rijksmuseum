import Foundation
import UIKit
import RxSwift
import RxCocoa
import PKHUD

extension UIViewController {
    
  var appDelegate:AppDelegate {
    return UIApplication.shared.delegate as! AppDelegate
  }
  
  var errorBinding: Binder<Error> {
    return Binder(self, binding: { (vc, error) in
      print((error as Error).self.localizedDescription)
      PKHUD.sharedHUD.contentView = PKHUDErrorView(title: "Error", subtitle: "Please try again")
      PKHUD.sharedHUD.show()
      PKHUD.sharedHUD.hide(afterDelay: 2.0) { success in
          // Completion Handler
      }
    })
  }
  
  var messageBinding: Binder<String> {
    return Binder(self, binding: { (vc, message) in
      PKHUD.sharedHUD.contentView = PKHUDErrorView(title: "Error", subtitle: message)
      PKHUD.sharedHUD.show()
      PKHUD.sharedHUD.hide(afterDelay: 3.0) { success in
      }
    })
  }

  
  var fetchingBinding: Binder<Bool> {
    return Binder(self, binding: { (vc, valid) in
      if (valid == true) {
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
      } else if let _ = PKHUD.sharedHUD.contentView as? PKHUDProgressView {
        PKHUD.sharedHUD.hide()
      }
    })
  }

}
