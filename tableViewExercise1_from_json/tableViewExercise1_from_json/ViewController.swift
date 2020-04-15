//
//  ViewController.swift
//  tableViewExercise1_from_json
//
//  Created by Third Rock Techkno on 29/01/20.
//  Copyright © 2020 Third Rock Techkno. All rights reserved.
//

import UIKit
import Foundation

struct Appoitment {
    var dateAndTime : String
    var questionAnswer : String?
}

var datasource = [Appoitment]()
var dataSourceWithSection = [[Appoitment]]()
var dateDictionaryMain:String = ""
var selectedButtonList = [IndexPath]()
var sections =  [String]()
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    
    let dateformatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datasource = fetchDataFromJson()
        setupTableView()
    }
    
    func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "AppoitmentCell", bundle: nil), forCellReuseIdentifier: "reusableCell")
        tableView.register(UINib(nibName: "SectionHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "sectionHeader")
        updateSectionData()
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action:
                                              #selector(handleRefreshControl),
                                              for: .valueChanged)
        }
            
        @objc func handleRefreshControl() {
           datasource = []
            dataSourceWithSection = []
            sections = []
           datasource = fetchDataFromJson()
           setupTableView()
            tableView.reloadData()
            DispatchQueue.main.async {
              self.tableView.refreshControl?.endRefreshing()
           }
        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        dataSourceWithSection.count
        
    }
    
    
    
    func updateSectionData(){
        sections = Array(Set(datasource.map{(data:Appoitment) -> String in
            formattedDateAndTime(dateDictionary: data.dateAndTime).1
        })).sorted(by:{dateformatter.date(from: $0)! > dateformatter.date(from: $1)!})
        for section in sections{
            var list = [Appoitment]()
            for i in datasource{
                if formattedDateAndTime(dateDictionary: i.dateAndTime).1 == section{
                    list.append(i)
                }
            }
            dataSourceWithSection.append(list)
        }
//        sections = sections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSourceWithSection[section].count
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "sectionHeader") as? SectionHeaderView else{return nil}
        view.label.text = sections[section]
        view.label.backgroundColor = .lightGray
//        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 18))
//        let label = UILabel(frame: CGRect(x: 5, y: 5, width: tableView.frame.size.width, height: 18))
//        label.text = sections[section]
//        view.addSubview(label)
//        label.backgroundColor = .yellow
        return view
    }
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return sections[section]
//    }
//
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        print(indexPath)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "reusableCell", for: indexPath) as! AppoitmentCell
        let dateDictionary = dataSourceWithSection[indexPath.section][indexPath.row]
        let tupleDateTime = formattedDateAndTime(dateDictionary: dateDictionary.dateAndTime)
        cell.indexPath = indexPath
        cell.onSelectionChange = { selectedValue, selectedIndexPath in
            
            if selectedValue == true{
                selectedButtonList.append(selectedIndexPath)
                tableView.reloadRows(at: [indexPath], with: .none)
            }
            else{
                while let idx = selectedButtonList.firstIndex(of:selectedIndexPath) {
                    selectedButtonList.remove(at: idx)
                    tableView.reloadRows(at: [indexPath], with: .none)
                }
            }
        }
        
        let queAnswer = dataSourceWithSection[indexPath.section][indexPath.row].questionAnswer
        if selectedButtonList.contains(indexPath){
            cell.questionAnswerLabel.text = queAnswer
        }
        else{
            cell.questionAnswerLabel.text = ""
        }
        
        cell.timeLabel.text = tupleDateTime.0
        cell.dateLabel.text = tupleDateTime.1
        cell.checkButton.tag = indexPath.row
        
        if selectedButtonList.contains(indexPath){
            cell.checkButton.isSelected = true
        }
        else{
            cell.checkButton.isSelected = false
        }
        return cell
    }
    
    func formattedDateAndTime(dateDictionary:String = dateDictionaryMain) -> (String,String){
        if dateDictionaryMain .isEmpty{
            let data = dateDictionary
            dateDictionaryMain = data
            
        }
        dateformatter.dateFormat = "YYYY-MM-dd'T'HH:mm:ss'Z'"
        let date = dateDictionary
        
        if let dateTime = dateformatter.date(from: date)
        {
            dateformatter.dateFormat = "h:mm a"
            let time = "KI: \(dateformatter.string(from: dateTime))"
            dateformatter.dateFormat = "EEEE d MMMM"
            let date = dateformatter.string(from: dateTime)
            return (time,date)
        }
        return ("","")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
        
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            dataSourceWithSection[indexPath.section].remove(at: indexPath.row)
//            if sections[indexPath.section].count == 0{
//                sections.remove(at: indexPath.section)
//            }
            tableView.deleteRows(at: [indexPath], with: .fade)
            
//            tableView.reloadData()
        }
    }
    
    
    
    func fetchDataFromJson() -> [Appoitment]{
        let startDate = Date()
        var list = [Appoitment]()
        
        do{
            guard let urlpath = Bundle.main.path(forResource: "Appointments", ofType: "json") else {return []}
            let url = URL(fileURLWithPath: urlpath)
            guard let jsonObj = try String(contentsOf: url).data(using: String.Encoding.utf8) else{return []}
            func dataIsArray(_ data:[Any]){
                for value in data{
                    if let val = value as? [String:Any]{
                        dataIsDictionary(val)
                    }
                }
            }
            func dataIsDictionary(_ data:[String:Any]){
                var timeAndDate : String = ""
                var questionAnswerMain : String?
                
                for (key,value) in data{
                    if let val2 = value as? [Any]{
                        dataIsArray(val2)
                    }
                    
                    if key == "time"{
                        if let time = value as? String{
                            timeAndDate = time
                        }
                    }
                   
                    if key == "patientCheckouts"{
                        var queAns = ""
                        func dataIsDictionary2(_ data:[String:Any]){
                            
                            for (key,val) in data.sorted(by : {$0.key>$1.key}){
                                if key == "question"{
                                    if let val2 = val as? [String:String]{
                                        if let value2 = val2["value"]{
                                            queAns = "\(queAns) \n Q: \(value2)"
                                        }
                                    }
                                }
                                else if key == "answer"{
                                    if let val2 = val as? [String:String]{
                                        if let value2 = val2["value"]{
                                            queAns = "\(queAns) A: \(value2)"
                                        }
                                    }
                                }
                                else if let value = val as? [String:Any]{
                                    dataIsDictionary2(value)
                                }
                                else if let value = val as? [Any]{
                                    dataIsArray2(value)
                                }
                            }
                        }
                        func dataIsArray2(_ data:[Any]){
                            for value in data{
                                if let val = value as? [String:Any]{
                                    dataIsDictionary2(val)
                                }
                            }
                            
                        }
                        if let val4 = value as? [String:Any]{
                            dataIsDictionary2(val4)
                        }
                        else if let val4 = value as? [Any]{
                            dataIsArray2(val4)
                        }
                        questionAnswerMain = queAns
                    }
                }
                if timeAndDate != "" {
                    list.append(Appoitment(dateAndTime: timeAndDate, questionAnswer: questionAnswerMain))
                }
                
            }
            
            if let parsedData = try JSONSerialization.jsonObject(with: jsonObj , options: []) as? [String:Any]{
                dataIsDictionary(parsedData)
            }
        }catch{
            print(error)
        }
        let endDate = Date()
        let seconds = endDate.timeIntervalSince1970 - startDate.timeIntervalSince1970
        print("Time took to parse dictionary: \(seconds)")
        return list
    }
}
