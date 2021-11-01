//
//  MLKitManager.swift
//  healthapp
//
//  Created by mac on 2021/11/1.
//

import Foundation
import MLKit
import MLKitTranslate

class MLKitManager{
    static var translator: Translator!

    
    
    static func englishToChinese(translatorTexy :String){
        
        
        let options = TranslatorOptions(sourceLanguage: .english, targetLanguage: .chinese)
           translator = Translator.translator(options: options)
        let conditions = ModelDownloadConditions(
            allowsCellularAccess: false,
            allowsBackgroundDownloading: true
        )
        translator.downloadModelIfNeeded(with: conditions) { error in
            guard error == nil else { return }

            // Model downloaded successfully. Okay to start translating.
        }


        translator.translate(translatorTexy) { translatedText, error in
                guard error == nil, let translatedText = translatedText else { return }
                print("jack_翻譯",translatedText)

                // Translation succeeded.
            }
    }
    
    
    
}
