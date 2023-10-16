import Foundation
import UIKit
import FBSDKCoreKit

@objcMembers
@objc(NSCFacebookUIAppDelegateExt)
public class NSCFacebookUIAppDelegateExt: NSObject {

    @objc public static let sharedInstance = NSCFacebookUIAppDelegateExt()

    static var observing = false

    @objc public func observe(){
        if(NSCFacebookUIAppDelegateExt.observing){return}
        NotificationCenter.default.addObserver(NSCFacebookUIAppDelegateExt.sharedInstance, selector: #selector(NSCFacebookUIAppDelegateExt.applicationDidFinishLaunchingNotificationEvent(_:)), name: UIApplication.didFinishLaunchingNotification, object: nil)
        NSCFacebookUIAppDelegateExt.observing = true
    }

    // Should call openUrl instead of applicationDidFinishLaunchingNotificationEvent
    @objc func applicationDidFinishLaunchingNotificationEvent(_ notification: NSNotification) {
        guard let info = notification.userInfo else {
            ApplicationDelegate.shared.application(
                UIApplication.shared,
                didFinishLaunchingWithOptions: nil
            )
            return

        }

        let sourceAppKey = info[UIApplication.LaunchOptionsKey.sourceApplication] as? String

        let url = info[UIApplication.LaunchOptionsKey.url] as? URL

        let annotation = info[UIApplication.OpenURLOptionsKey.annotation]

        if(url != nil){
            ApplicationDelegate.shared.application(
                UIApplication.shared,
                open: url!,
                sourceApplication: sourceAppKey,
                annotation: annotation
            )
        }

    }

    // TODO: 
    // we need to add this and make the delegate listen to the applicationOpenURLOptions
    // event. I've verified that this event gets called with what facebook needs, but
    // the modal doesn't get closed because ApplicationDelegate.shared.application isn't 
    // called
    // I'm 90% sure this is the problem, but I can't test my hypothesis because I can't seem to
    // trigger this either directly from the app or from here
    // 
    // My guess is that this has something to do with how the observers are setup that I don't
    // quite understand
    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
        ApplicationDelegate.shared.application(
            app,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )
    }
}
