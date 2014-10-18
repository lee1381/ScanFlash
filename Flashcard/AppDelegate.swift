//
//  AppDelegate.swift
//  Flashcard
//
//  Created by George Lo on 10/18/14.
//  Copyright (c) 2014 Boilermake Fall 2014. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UITableViewDelegate {

    var window: UIWindow?
    var open: Bool = false
    
    var slidingViewController: ECSlidingViewController?
    var topViewSnapshot: UIView?
    var rowNames: [String]?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        DatabaseHelper.executeUpdate("create table if not exists Cards (id INTEGER PRIMARY KEY, englishText TEXT, foreignText TEXT, favorite INT")
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        let viewController : ListViewController = ListViewController()
        viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "SideMenu"), style: UIBarButtonItemStyle.Done, target: self, action: "showMenu")
        let navigationController: UINavigationController = createNavController(viewController)
        slidingViewController = ECSlidingViewController(topViewController: navigationController)
        
        let sideMenuVC : SideMenuViewController = SideMenuViewController()
        rowNames = sideMenuVC.rowNames
        sideMenuVC.tableView.delegate = self
        slidingViewController?.underLeftViewController = sideMenuVC
        slidingViewController?.anchorLeftRevealAmount = 250.0;
        
        self.window?.rootViewController = slidingViewController
        self.window?.makeKeyAndVisible()
        return true
    }
    
    func createNavController(viewController: UIViewController) -> UINavigationController {
        let navigationController: UINavigationController = UINavigationController()
        navigationController.viewControllers = [viewController]
        navigationController.view.backgroundColor = UIColor.whiteColor()
        navigationController.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "HelveticaNeue-Bold", size: CGFloat(25))]
        return navigationController
    }
    
    func showMenu() {
        if open {
            open = false
            slidingViewController?.resetTopViewAnimated(true)
        } else {
            open = true
            slidingViewController?.anchorTopViewToRightAnimated(true)
        }
    }
    
    // MARK: - Table view delegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let realNames = rowNames {
            var navigationController: UINavigationController?
            
            /*
            if (realNames[indexPath.row] as NSString).isEqualToString("MyMail") {
                navigationController = createNavController(MyMailViewController())
            } else if (realNames[indexPath.row] as NSString).isEqualToString("Blackboard") {
                navigationController = createNavController(BlackboardViewController())
            } else if (realNames[indexPath.row] as NSString).isEqualToString(NSLocalizedString("SCHEDULE", comment: "")) {
                navigationController = createNavController(GameViewController())
            } else if (realNames[indexPath.row] as NSString).isEqualToString(NSLocalizedString("BUS", comment: "")) {
                navigationController = createNavController(GameViewController())
            } else if (realNames[indexPath.row] as NSString).isEqualToString(NSLocalizedString("MAP", comment: "")) {
                navigationController = createNavController(GameViewController())
            } else if (realNames[indexPath.row] as NSString).isEqualToString(NSLocalizedString("LABS", comment: "")) {
                navigationController = createNavController(GameViewController())
            } else if (realNames[indexPath.row] as NSString).isEqualToString(NSLocalizedString("COREC", comment: "")) {
                navigationController = createNavController(GameViewController())
            } else if (realNames[indexPath.row] as NSString).isEqualToString(NSLocalizedString("GAMES", comment: "")) {
                navigationController = createNavController(GameViewController())
            } else if (realNames[indexPath.row] as NSString).isEqualToString(NSLocalizedString("MENU", comment: "")) {
                navigationController = createNavController(GameViewController())
            } else if (realNames[indexPath.row] as NSString).isEqualToString(NSLocalizedString("NEWS", comment: "")) {
                navigationController = createNavController(GameViewController())
            } else if (realNames[indexPath.row] as NSString).isEqualToString(NSLocalizedString("WEATHER", comment: "")) {
                navigationController = createNavController(WeatherViewController())
            } else if (realNames[indexPath.row] as NSString).isEqualToString(NSLocalizedString("LIBRARY", comment: "")) {
                navigationController = createNavController(GameViewController())
            } else if (realNames[indexPath.row] as NSString).isEqualToString(NSLocalizedString("PHOTOS", comment: "")) {
                navigationController = createNavController(PhotoViewController())
            } else if (realNames[indexPath.row] as NSString).isEqualToString(NSLocalizedString("VIDEOS", comment: "")) {
                navigationController = createNavController(VideoViewController())
            } else if (realNames[indexPath.row] as NSString).isEqualToString(NSLocalizedString("DIRECTORY", comment: "")) {
                navigationController = createNavController(GameViewController())
            } else if (realNames[indexPath.row] as NSString).isEqualToString(NSLocalizedString("BANDWIDTH", comment: "")) {
                navigationController = createNavController(GameViewController())
            } else {
                navigationController = createNavController(NewsViewController())
            }
*/
            
            slidingViewController?.topViewController = navigationController
            (slidingViewController?.topViewController as UINavigationController).viewControllers[0].navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "SideMenu"), style: .Done, target: self, action: "showMenu")
            open = false
            slidingViewController?.resetTopViewAnimated(true)
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 180
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView: UIView = UIView(frame: CGRectMake(0, 0, 250, 180))
        let imageView: UIImageView = UIImageView(image: UIImage(named: "PU_Logo"))
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        imageView.frame = CGRectMake(30, 50, 210, 80)
        headerView.addSubview(imageView)
        headerView.backgroundColor = UIColor(red: 44.0/255.0, green: 44.0/255.0, blue: 44.0/255.0, alpha: 1)
        let bottomLayer: CALayer = CALayer()
        bottomLayer.frame = CGRectMake(0, 180-2, 1000, 2)
        bottomLayer.backgroundColor = UIColor(white: 0.5, alpha: 0.6).CGColor
        headerView.layer.addSublayer(bottomLayer)
        return headerView
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50;
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView: UIView = UIView(frame: CGRectMake(0, 0, 250, 50))
        footerView.backgroundColor = UIColor(red: 44.0/255.0, green: 44.0/255.0, blue: 44.0/255.0, alpha: 1)
        let settingBtn: UIButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
        settingBtn.tintColor = UIColor.whiteColor()
        settingBtn.frame = CGRectMake(0, 2, 48, 48)
        settingBtn.setImage(UIImage(named: "Settings").imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate), forState: UIControlState.Normal)
        footerView.addSubview(settingBtn)
        let copyrightLbl: UILabel = UILabel(frame: CGRectMake(48, 2, 250-48, 48))
        copyrightLbl.text = "© PURDUE UNIVERSITY"
        copyrightLbl.textColor = UIColor.whiteColor()
        copyrightLbl.textAlignment = NSTextAlignment.Right
        copyrightLbl.font = UIFont(name: "Avenir-Book", size: 15)
        footerView.addSubview(copyrightLbl)
        let upperLayer: CALayer = CALayer()
        upperLayer.frame = CGRectMake(0, 0, 1000, 2)
        upperLayer.backgroundColor = UIColor(white: 0.5, alpha: 0.6).CGColor
        footerView.layer.addSublayer(upperLayer)
        return footerView
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

