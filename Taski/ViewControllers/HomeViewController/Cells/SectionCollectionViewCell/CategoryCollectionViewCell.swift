//
//  CollectionViewCell.swift
//  Taski
//
//  Created by Driveline on 9/3/22.
//

import UIKit

protocol CategoryCollectionDelegate {
    func addTask(for category: SectionInfo)
}

class SectionCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addTaskButton: UIButton!
    
    weak var viewController: UIViewController?
    var sectionInfo: SectionInfo?
    var delegate: CategoryCollectionDelegate?
    
    private var arrayTaskList: [TaskInfo] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupTableView()
    }
}

// MARK: - Private Methods
private extension SectionCollectionViewCell {
    
    func setupTableView() {
//        self.tableView.register(TaskTableViewCell.self, forCellReuseIdentifier: "")
        self.tableView.register(UINib(nibName: "TaskTableViewCell", bundle: nil), forCellReuseIdentifier: "TaskTableViewCell")

        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 100
        self.tableView.tableFooterView = UIView(frame: .zero)
        
        if let categoryInfo = self.sectionInfo {
            self.arrayTaskList = categoryInfo.taskInfoList
        }
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let nibName = UINib(nibName: "TaskHeaderViewCell", bundle: nil)
        self.tableView.register(nibName, forHeaderFooterViewReuseIdentifier: "TaskHeaderViewCell")
    }
}

// MARK: - Action Methods
extension SectionCollectionViewCell {
    
    @IBAction func addTaskButtonClicked(_ sender: UIButton) {
        viewController?.alertWithTextField(title: "Task", message: "Which task would you like to add?", placeholder: "Task name", completion: { result in
            let taskInfo = TaskInfo(taskId: "task_\(Date())", taskName: result)
            self.arrayTaskList.insert(taskInfo, at: 0)
            if let sectionInfo = self.sectionInfo {
                let sectionDetail = SectionInfo(sectionId: sectionInfo.sectionId, sectionName: sectionInfo.sectionName, taskInfoList: self.arrayTaskList)
                self.delegate?.addTask(for: sectionDetail)
                
                DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                    self.tableView.reloadData()
                }
            }
        })
    }
}

// MARK: - Private Methods
extension SectionCollectionViewCell: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: "TaskHeaderViewCell") as! TaskHeaderViewCell
        
        if let categoryInfo = self.sectionInfo {
            headerView.categoryNameLabel.text = categoryInfo.categoryName
            headerView.taskNumberLabel.text = "\(categoryInfo.taskInfoList.count) tasks"
        }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayTaskList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell", for: indexPath) as! TaskTableViewCell
        cell.taskNameLabel.text = self.arrayTaskList[indexPath.row].taskName
        cell.backgroundColor = UIColor.red
        return cell
    }
}
