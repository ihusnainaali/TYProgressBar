//
//  ViewController.swift
//  TYProgressBar
//
//  Created by Yash Thaker on 11/05/18.
//  Copyright © 2018 Yash Thaker. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let progressBar = TYProgressBar()
    
    var timer: Timer!
    var counter: Double = 0
    var isTimerOn = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupProgressBar()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.view.addGestureRecognizer(tap)
    }
    
    func setupProgressBar() {
        progressBar.frame = CGRect(x: 0, y: 0, width: 220, height: 220)
        progressBar.center = self.view.center
        progressBar.gradients = [#colorLiteral(red: 0, green: 0.6588235294, blue: 0.7725490196, alpha: 1), #colorLiteral(red: 1, green: 1, blue: 0.4941176471, alpha: 1)]
        progressBar.textColor = .white
        self.view.addSubview(progressBar)
    }
    
    @objc func handleTap() {
        if isTimerOn {
            guard timer != nil else { return }
            timer?.invalidate()
            timer = nil
            counter = 0
            
        } else {
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(ticker), userInfo: nil, repeats: true)
        }
        
        isTimerOn = !isTimerOn
    }
    
    @objc func ticker() {
        if counter > 1 {
            timer.invalidate()
            counter = 0
            return
        }
        
        counter += 0.02
        progressBar.progress = counter
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}
