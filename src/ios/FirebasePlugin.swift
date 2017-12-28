import FirebaseAnalytics
import FirebaseInstanceID
import FirebaseMessaging
import GoogleMobileAds
import UserNotifications

var admobTestDevices: [Any] = [kGADSimulatorID]

@objc(FirebasePlugin)
class FirebasePlugin : CDVPlugin {

    var admobApplicationId: String = "ca-app-pub-3940256099942544~1458002511"
    var admobInterstitial: GADInterstitial!
    var admobInterstitialUnitId: String = "ca-app-pub-3940256099942544/4411468910"

    @objc(initialize:)
    func initialize(command: CDVInvokedUrlCommand) {
        DispatchQueue.global(qos: .userInitiated).async {
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK)

            self.admobApplicationId = command.arguments[0] as? String ?? "ca-app-pub-3940256099942544~1458002511"

            FirebaseApp.configure()

            DispatchQueue.main.async {
                GADMobileAds.configure(withApplicationID: self.admobApplicationId)

                self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
            }
        }
    }

    @objc(admobAddTestDevice:)
    func admobAddTestDevice(command: CDVInvokedUrlCommand) {
        DispatchQueue.global(qos: .userInitiated).async {
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK)
            let testDeviceId = command.arguments[0] as? String ?? ""

            if !testDeviceId.isEmpty {
                admobTestDevices.append(testDeviceId)
            }

            self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
        }
    }

    @objc(admobRequestInterstitial)
    func admobRequestInterstitial() {
        DispatchQueue.global(qos: .userInitiated).async {
            let request = GADRequest()

            request.testDevices = admobTestDevices

            self.admobInterstitial = GADInterstitial(adUnitID: self.admobInterstitialUnitId)

            self.admobInterstitial.load(request)
        }
    }

    @objc(admobSetInterstitialAdUnitId:)
    func admobSetInterstitialAdUnitId(command: CDVInvokedUrlCommand) {
        DispatchQueue.global(qos: .userInitiated).async {
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK)

            self.admobInterstitialUnitId = command.arguments[0] as? String ?? "ca-app-pub-3940256099942544/4411468910"

            self.admobRequestInterstitial()

            self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
        }
    }

    @objc(admobShowInterstitial:)
    func admobShowInterstitial(command: CDVInvokedUrlCommand) {
        DispatchQueue.global(qos: .userInitiated).async {
            var pluginResult = CDVPluginResult(status: CDVCommandStatus_OK)

            DispatchQueue.main.async {
                if self.admobInterstitial != nil && self.admobInterstitial.isReady {
                    self.admobInterstitial.present(fromRootViewController: self.viewController)
                } else {
                    pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR)
                }

                self.admobRequestInterstitial()

                self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
            }
        }
    }

    @objc(analyticsLogEvent:)
    func analyticsLogEvent(command: CDVInvokedUrlCommand) {
        DispatchQueue.global(qos: .userInitiated).async {
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK)
            let eventName = command.arguments[0] as? String ?? ""
            let eventParameters = command.arguments[1] as? [String: Any] ?? nil

            Analytics.logEvent(eventName, parameters: eventParameters)

            self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
        }
    }

    @objc(analyticsSetUserId:)
    func analyticsSetUserId(command: CDVInvokedUrlCommand) {
        DispatchQueue.global(qos: .userInitiated).async {
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK)
            let userId = command.arguments[0] as? String ?? ""

            Analytics.setUserID(userId)

            self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
        }
    }

    @objc(iidGetToken:)
    func iidGetId(command: CDVInvokedUrlCommand) {
        DispatchQueue.global(qos: .userInitiated).async {
            var pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR)
            let token = InstanceID.instanceID().token()

            if token != nil {
                pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: token)
            }

            self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
        }
    }

    @objc(messagingEnableNotifications:)
    func messagingEnableNotifications(command: CDVInvokedUrlCommand) {
        DispatchQueue.global(qos: .userInitiated).async {
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK)
            let messagingDelegate = self.appDelegate() as? MessagingDelegate
            let application = UIApplication.shared


            Messaging.messaging().delegate = messagingDelegate

            DispatchQueue.main.async {
                if #available(iOS 10.0, *) {
                    let notificationDelegate = self.appDelegate() as? UNUserNotificationCenterDelegate
                    let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]

                    UNUserNotificationCenter.current().delegate = notificationDelegate
                    UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: {_, _ in })
                } else {
                    let settings: UIUserNotificationSettings =
                        UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)

                    application.registerUserNotificationSettings(settings)
                }

                application.registerForRemoteNotifications()

                self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
            }
        }
    }

}
