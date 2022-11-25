//
//  ErrorMessageHelper.swift
//  NASAImagesAndVideo
//
//  Created by Subbareddy l on 11/25/22.
//

import UIKit

struct ErrorMessageHelper {
    static func getErrorMessageAlertController(error: Error) -> UIAlertController
    {
        let alertController = UIAlertController(title: "Error",
                                                message: error.localizedDescription,
                                                preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(alertAction)
        return alertController
    }
}
