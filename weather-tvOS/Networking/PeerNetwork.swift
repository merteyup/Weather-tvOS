//
//  PeerNetwork.swift
//  Multipeertest
//
//  Created by Brian Advent on 04.01.19.
//  Copyright © 2019 Brian Advent. All rights reserved.
//

import Foundation
import MultipeerConnectivity

protocol PeerNetworkDelegate : AnyObject {
    func dataChanged(manager:PeerNetwork, dataPackage:Data)
    func sendDataDidFailed(error: Error)
}

class PeerNetwork : NSObject {
    weak var delegate: PeerNetworkDelegate?
    
    private let serviceType = "weather-service"
    private let peerID = MCPeerID(displayName: UIDevice.current.name)
    private let serviceAdvertiser: MCNearbyServiceAdvertiser
    private let serviceBrowser: MCNearbyServiceBrowser
    
    lazy var session: MCSession = {
        let session = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        session.delegate = self
        return session
    }()
    
    override init() {
        serviceAdvertiser = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: nil, serviceType: serviceType)
        serviceBrowser = MCNearbyServiceBrowser(peer: peerID, serviceType: serviceType)
        super.init()
        
        serviceAdvertiser.delegate = self
        serviceAdvertiser.startAdvertisingPeer()
        
        serviceBrowser.delegate = self
        serviceBrowser.startBrowsingForPeers()
    }
    
    deinit {
        serviceAdvertiser.stopAdvertisingPeer()
        serviceBrowser.stopBrowsingForPeers()
    }
    
    func send(dataPackage: Data) {
        if session.connectedPeers.count > 0 {
            do {
                try session.send(dataPackage, toPeers: session.connectedPeers, with: .reliable)
            } catch {
                delegate?.sendDataDidFailed(error: error)
            }
        }
    }
    
}

extension PeerNetwork : MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        print(error.localizedDescription)
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        print("Did Receive Invitation from Peer: \(peerID)")
        
        invitationHandler(true, session)
    }
}

extension PeerNetwork : MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        print(error.localizedDescription)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        print("found peer \(peerID)")
        print("invite peer \(peerID)")
        browser.invitePeer(peerID, to: session, withContext: nil, timeout: 10)
       
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        print("list peer \(peerID)")
    }
}

extension PeerNetwork : MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        print("peer \(peerID) changed state to \(state)")
        
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        print("Data: \(data)")
        
        delegate?.dataChanged(manager: self, dataPackage: data)
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        print("stream")
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        print("started receiving resource")
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        print("fnished receiving resource")
    }
    
}
