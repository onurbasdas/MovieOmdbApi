//
//  ViewController.swift
//  MovieOmdbApi
//
//  Created by Onur Başdaş on 22.02.2021.
//

import UIKit
import Firebase
import FirebaseFirestore
import Network
import NVActivityIndicatorView

class ViewController: UIViewController {
    
    var db: Firestore!
    let monitor = NWPathMonitor()
    
    @IBOutlet weak var lodoosLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        getDataFirestore()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        lodoosLabel.center.x = view.center.x // Place it in the center x of the view.
        lodoosLabel.center.x -= view.bounds.width // Place it on the left of the view with the width = the bounds'width of the view.
        // animate it from the left to the right
        UIView.animate(withDuration: 1, delay: 0, options: [.curveLinear], animations: { [self] in
              lodoosLabel.center.x += view.bounds.width
              self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    fileprivate func startAnimation(){
        let loading = NVActivityIndicatorView(frame: .zero, type: .ballPulse, color: .orange, padding: 0)
        loading.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loading)
        NSLayoutConstraint.activate([
            loading.widthAnchor.constraint(equalToConstant: 40),
            loading.heightAnchor.constraint(equalToConstant: 40),
            loading.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loading.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        loading.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3){
            loading.stopAnimating()
        }
    }
    func getDataFirestore() {
        let citiesRef = db.collection("cities")
        citiesRef.document("SF").setData(["text": "Lodoos"])
        let docRef = db.collection("cities").document("SF")
        
        docRef.getDocument { (document, error) in
            if error != nil{
                print(error?.localizedDescription as Any)
            }else{
                if let document = document, document.exists {
                    if let lodoos = document.get("text") as? String {
                        self.lodoosLabel.text = lodoos
                    }
                } else {
                    print("Document does not exist")
                }
            }
        }
    }
    

    @IBAction func mainButtonClicked(_ sender: Any) {
        
        startAnimation()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if NetworkMonitor.shared.isConnected{
                print("You are on wifi")
                self.performSegue(withIdentifier: "toMainVC", sender: nil)
            }else{
                print("You are not connected!")
                self.showAlert(title: "Error", message: "Network Problem")
                
            }
            
            
        }
    }
    
}

