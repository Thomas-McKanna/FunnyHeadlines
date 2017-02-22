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
        
        self.title = "Settings"

        sourcePickerView.delegate = self
        sourcePickerView.dataSource = self
        
        translatedByPickerView.delegate = self
        translatedByPickerView.dataSource = self
        
        // set picker view to the user's last configuration
        sourcePickerView.selectRow(delegate.sourceRow, inComponent: 0, animated: true)
        translatedByPickerView.selectRow(delegate.translationRow, inComponent: 0, animated: true)
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        
        // get source and translation row selected
        let sourceRow = sourcePickerView.selectedRow(inComponent: 0)
        let translationRow = translatedByPickerView.selectedRow(inComponent: 0)
        
        // using row, get string version of row
        let sourceChosen = SourcesDictionary[SupportedSources[sourceRow]]!
        let translationChosen = TranslationDictionary[SupportedTranslations[translationRow]]!
        
        // set source and translation row in delegate
        delegate.sourceRow = sourceRow
        delegate.translationRow = translationRow
        
        // set strings in delegate
        delegate.source = sourceChosen
        delegate.translation = translationChosen
        
        // persistent storage
        userDefaults.set(sourceRow, forKey: "SourceRow")
        userDefaults.set(translationRow, forKey: "TranslationRow")
        
        userDefaults.set(sourceChosen, forKey: "Source")
        userDefaults.set(translationChosen, forKey: "Translation")
        
        // update UI
        delegate.prepareHeader()
        delegate.loadData()
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
