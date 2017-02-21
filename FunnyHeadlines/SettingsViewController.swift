//
//  SettingsViewController.swift
//  FunnyHeadlines
//
//  Created by Thomas McKanna on 2/21/17.
//  Copyright © 2017 ISYS 220. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    // properties
    @IBOutlet weak var sourcePickerView: UIPickerView!
    @IBOutlet weak var translatedByPickerView: UIPickerView!
    
    var delegate = CollectionViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        sourcePickerView.delegate = self
        sourcePickerView.dataSource = self
        
        translatedByPickerView.delegate = self
        translatedByPickerView.dataSource = self
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        // update the value of "source" in the delegate. Source must be translated into a form that the API accepts
        //let sourceChosen = SupportedSources[sourcePickerView.selectedRow(inComponent: <#T##Int#>)]
        //delegate.source = SourcesDictionary[sourceChosen]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SettingsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == sourcePickerView {
            return SupportedSources.count
        }
        else {
            return SupportedTranslations.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == sourcePickerView {
            return SupportedSources[row]
        }
        else {
            return SupportedTranslations[row]
        }
    }
}
