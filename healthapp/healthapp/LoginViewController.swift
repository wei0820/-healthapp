//
//  LoginViewController.swift
//  healthapp
//
//  Created by mac on 2021/8/27.
//

import UIKit
import AuthenticationServices
import CryptoKit
import Security
import Firebase
class LoginViewController: UIViewController ,ASAuthorizationControllerDelegate,ASAuthorizationControllerPresentationContextProviding{
    @IBOutlet weak var appleLoginButton: UIButton!
    fileprivate var currentNonce: String?

    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!

    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    @IBAction func guestAction(_ sender: Any) {
    
        Auth.auth().signInAnonymously { result, errror in
            if let error  = errror{ return }
            guard let user = result?.user else {return}
            let isGuest = user.isAnonymous
            let uid = user.uid
            
            
            
        }
        

        
        
    }
    
    @IBAction func appleIdLoginAction(_ sender: Any) {
        let nonce = randomNonceString()
               currentNonce = nonce
               let appleIDProvider = ASAuthorizationAppleIDProvider()
               let request = appleIDProvider.createRequest()
                request.requestedScopes = [.fullName, .email]
               request.nonce = sha256(nonce)

               let authorizationController = ASAuthorizationController(authorizationRequests: [request])
               authorizationController.delegate = self
               authorizationController.presentationContextProvider = self
               authorizationController.performRequests()
        
        
        
        
    }
    
    private func randomNonceString(length: Int = 32) -> String {
       precondition(length > 0)
       let charset: Array<Character> =
           Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
       var result = ""
       var remainingLength = length

       while remainingLength > 0 {
         let randoms: [UInt8] = (0 ..< 16).map { _ in
           var random: UInt8 = 0
           let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
           if errorCode != errSecSuccess {
             fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
           }
           return random
         }

         randoms.forEach { random in
           if remainingLength == 0 {
             return
           }

           if random < charset.count {
             result.append(charset[Int(random)])
             remainingLength -= 1
           }
         }
       }

       return result
     }
    
    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        return String(format: "%02x", $0)
      }.joined()

      return hashString
    }
}
