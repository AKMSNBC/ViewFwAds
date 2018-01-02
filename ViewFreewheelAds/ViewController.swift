//
//  ViewController.swift
//  ViewFreewheelAds
//

import Foundation
import UIKit
import AVFoundation

class ViewController: UIViewController, FWAdControllerDelegate {
    
    //MARK: Properties
    @IBOutlet weak var networkIdTextField: UITextField?
    @IBOutlet weak var serverUrlTextField: UITextField?
    @IBOutlet weak var playerProfileTextField: UITextField?
    @IBOutlet weak var siteSectionTextField: UITextField?
    @IBOutlet weak var videoAssetTextField: UITextField?
    @IBOutlet weak var videoDurationTextField: UITextField?
    @IBOutlet weak var videoView: UIView?
    @IBOutlet weak var trailingVideoView: NSLayoutConstraint?
    @IBOutlet weak var leadingVideoView: NSLayoutConstraint?
    @IBOutlet weak var videoDisplayBaseView: UIView?

    //MARK: Actions
    @IBAction func settingsButton(_ sender: UIBarButtonItem) {
        settingsViewSlide()
    }
    
    @IBAction func getPrerollAdButton(_ sender: UIButton) {
        preRollAdLoad()
    }
    
    //MARK: ViewController overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        initPlaceholders()
        initSettings()
    }
    
    //MARK: locals
    private var settingsIsVisible:Bool = false
    private var networkId:Int = Constants.NetworkId
    private var serverUrl:String = Constants.ServerUrl
    private var playerProfile:String = Constants.PlayerProfile
    private var siteSection:String = Constants.SiteSection
    private var videoAsset:String = Constants.VideoAsset
    private var videoDuration:TimeInterval = TimeInterval(Constants.VideoDuration)
    
    private var adManager: FWAdManager? = newAdManager()
    private var player: AVPlayer?
    private var adController: FWAdController?
    
    //MARK: local methods
    private func initAdManager() {
        if let adManager = adManager {
            adManager.setNetworkId(UInt(networkId))
            adManager.setCurrentViewController(self)
        }
    }
    
    private func initSettings() {
        networkId = Constants.NetworkId
        serverUrl = Constants.ServerUrl
        playerProfile = Constants.PlayerProfile
        siteSection = Constants.SiteSection
        videoAsset = Constants.VideoAsset
        videoDuration = Constants.VideoDuration
    }
    
    private func initPlaceholders() {
        if let networkIdTextField = networkIdTextField {
            networkIdTextField.placeholder = String(Constants.NetworkId)
        }
        if let serverUrlTextField = serverUrlTextField {
            serverUrlTextField.placeholder = Constants.ServerUrl
        }
        if let playerProfileTextField = playerProfileTextField {
            playerProfileTextField.placeholder = Constants.PlayerProfile
        }
        if let siteSectionTextField = siteSectionTextField {
            siteSectionTextField.placeholder = Constants.SiteSection
        }
        if let videoAssetTextField = videoAssetTextField {
            videoAssetTextField.placeholder = Constants.VideoAsset
        }
        if let videoDurationTextField = videoDurationTextField {
            videoDurationTextField.placeholder = String(Constants.VideoDuration)
        }
    }
    
    private func getSettings() {
        initSettings()
        
        if let networkIdText = networkIdTextField?.text {
            if networkIdText.isEmpty == false, let netId = Int(networkIdText) {
                networkId = netId
            }
        }
        if let serverUrlText = serverUrlTextField?.text {
            if serverUrlText.isEmpty == false {
                serverUrl = serverUrlText
            }
        }
        if let playerProfileText = playerProfileTextField?.text {
            if playerProfileText.isEmpty == false {
                playerProfile = playerProfileText
            }
        }
        if let siteSectionText = siteSectionTextField?.text {
            if siteSectionText.isEmpty == false {
                siteSection = siteSectionText
            }
        }
        if let videoAssetText = videoAssetTextField?.text {
            if videoAssetText.isEmpty == false {
                videoAsset = videoAssetText
            }
        }
        if let videoDurationText = videoDurationTextField?.text {
            if videoDurationText.isEmpty == false, let vidDuration = TimeInterval(videoDurationText) {
                videoDuration = vidDuration
            }
        }
    }
    
    private func settingsViewSlide() {
        guard let leadingVideoView = leadingVideoView else {
            return
        }
        guard let trailingVideoView = trailingVideoView else {
            return
        }
        
        if settingsIsVisible {
            leadingVideoView.constant = 0
            trailingVideoView.constant = 0
            settingsIsVisible = false
        } else {
            leadingVideoView.constant = Constants.SettingsViewDisplayWidth
            trailingVideoView.constant = Constants.SettingsViewDisplayWidth
            settingsIsVisible = true
        }
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
            if let videoView = self.videoView {
                if self.settingsIsVisible {
                    videoView.backgroundColor = UIColor.gray
                } else {
                    videoView.backgroundColor = UIColor.white
                }
            }
        }) { (animationComplete) in
            print("The animation is complete!")
        }
    }
    
    func preRollAdLoad() {
        getSettings()
        initAdManager()
        if let adManager = adManager {
            adController = FWAdController(adManager: adManager)
            
            if let adController = adController {
                adController.delegate = self
                
                adController.configAdRequest(serverUrl, playerProfile: playerProfile)
                adController.setSiteSection(siteSection)
                adController.setVideoAsset(videoAsset, duration: videoDuration)
                adController.addValue("JSAMDemoPlayer", forKey: "customTargetingKey")
                adController.addPrerollSlot("pre1")
                adController.loadAds()
            }
        }
    }

    //MARK: FWAdControllerDelegate protocol methods
    func adController(_ adController: FWAdController, didLoadAdsSuccess success: Bool) {
        if let videoDisplayBaseView = videoDisplayBaseView {
            adController.playPrerollsInView(videoDisplayBaseView)
        }
    }
    
    func adController(_ adController: FWAdController, willStartSlot slot: FWSlot) {
        
    }
    
    func adController(_ adController: FWAdController, didFinishSlot slot: FWSlot) {
        
    }
    
    func prerollDidFinishWithAdController(_ adController: FWAdController) {
        
    }
    
    func postrollDidFinishWithAdController(_ adController: FWAdController) {
        
    }
    
    func adController(_ adController: FWAdController, shouldAutoplayCuePointSlot slot: FWSlot) -> Bool {
        return false
    }
    
}

