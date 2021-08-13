//
//  SceneDelegate.swift
//  TableViewApp
//
//  Created by 김모경 on 2021/07/16.
//

import UIKit
import UserNotifications

///UNUserNotificationCenterDelegate 추가함
class SceneDelegate: UIResponder, UIWindowSceneDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?

/*
     @UIApplicationMain
     class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
         
         var window: UIWindow?
         
         // 애플리케이션 실행 직후 호출
         func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
             
             // User Notification Center를 통해서 노티피케이션 권한 획득
             let center: UNUserNotificationCenter = UNUserNotificationCenter.current()
             center.requestAuthorization(options: [UNAuthorizationOptions.alert, UNAuthorizationOptions.sound, UNAuthorizationOptions.badge]) { (granted, error) in
                 print("허용여부 \(granted), 오류 : \(error?.localizedDescription ?? "없음")")
             }
             
             // 맨 처음 화면의 뷰 컨트롤러(TodosTableViewController)를 UserNotificationCenter의 delegate로 설정
             if let navigationController: UINavigationController = self.window?.rootViewController as? UINavigationController,
                 let todosTableViewController: TodosTableViewController = navigationController.viewControllers.first as? TodosTableViewController {
                 
                 UNUserNotificationCenter.current().delegate = todosTableViewController
             }
             
             return true
         }
         
     }
     
     
     
     */
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    /*
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }*/
    func sceneWillResignActive(_ scene: UIScene) {//알림 동의 여부를 확인
            print("WillResign")
            if #available(iOS 10.0, *){
                UNUserNotificationCenter.current().getNotificationSettings { settings in
                    if settings.authorizationStatus == UNAuthorizationStatus.authorized{
                        let content = UNMutableNotificationContent()
                        content.badge = 1
                        content.title = "로컬 푸시"
                        content.subtitle = "서브 타이틀"
                        content.body = "바디바디바디받비ㅏ디바딥다비답디ㅏㅂ딥다비다비답다ㅣ"
                        content.sound = .default
                        content.userInfo = ["name": "tree"]
                        
                        //5초 후, 반복하지 않음
                        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
                        
                        let request = UNNotificationRequest(identifier: "firstPush", content: content, trigger: trigger)
                        
                        //발송을 위한 센터에 추가
                        UNUserNotificationCenter.current().add(request)
                    }else{
                        //사용자가 알림을 허용하지 않음
                        print("알림 허용 않음")
                    }
                }
            }else{
                //사용자의 폰이 iOS 9 이하임
                print("9버전 이하")
            }
        }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

