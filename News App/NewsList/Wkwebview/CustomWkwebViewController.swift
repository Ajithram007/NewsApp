//
//  CustomWkwebViewController.swift
//  News App
//
//  Created by Ajithram on 03/03/21.
//

import UIKit
import WebKit

class CustomWkwebViewController: UIViewController {
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    var loadUrl: String?
    
    @IBOutlet weak var customWebview: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        createActivityIndicator()
        customWebview.navigationDelegate = self
        self.customWebview.uiDelegate = self
        setUpWebView()
    }
    
    func setUpWebView() {
        self.startAnimating()
        if let loadUrl = URL(string: loadUrl ?? "") {
            customWebview.load(URLRequest(url: loadUrl))
            customWebview.allowsBackForwardNavigationGestures = true
        } else {
            self.stopAnimating()
        }
    }

}

extension CustomWkwebViewController {
    func createActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        activityIndicator.style = .medium
        activityIndicator.center = self.view.center
        activityIndicator.isHidden = true
        self.view.addSubview(activityIndicator)
    }
    
    func startAnimating(){
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        customWebview.isUserInteractionEnabled = false
    }
    
    func stopAnimating(){
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
        customWebview.isUserInteractionEnabled = true
    }
}

extension CustomWkwebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let url = navigationAction.request.url else {
            decisionHandler(.allow)
            return
        }
        
        if ["tel", "sms", "facetime"].contains(url.scheme) && UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
        
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        stopAnimating()
        customWebview.isHidden = false
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        stopAnimating()
    }
}

extension CustomWkwebViewController: WKUIDelegate {
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil {
            customWebview.load(navigationAction.request)
        }
        return nil
    }
}
