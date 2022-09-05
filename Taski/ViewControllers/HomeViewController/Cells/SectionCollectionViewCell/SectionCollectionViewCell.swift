//
//  CollectionViewCell.swift
//  Taski
//
//  Created by Sam Kishline
//

import UIKit
import Malert
import UserNotifications

protocol SectionCollectionDelegate {
    func addTask(for section: SectionInfo)
    func deleteSection()
}

class SectionCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addTaskButton: UIButton!
    
    weak var viewController: UIViewController?
    var sectionInfo: SectionInfo?
    var delegate: SectionCollectionDelegate?
    
    private var arrayTaskList: [TaskInfo] = []
    private let sectionManager = SectionManager()
    private let taskManager = TaskManager()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupTableView()
    }
    
    func update() {
        if let sectionInfo = self.sectionInfo {
            self.getTasksData(for: sectionInfo)
        }
    }
    
    @objc func deleteCategoryButtonClicked() {
        
        viewController?.alertWithTextField(title: "Delete Section", message: "Which section would you like to delete?", placeholder: "Section name", completion: { result in
            if let sectionInfo = self.sectionInfo {
                if result == sectionInfo.sectionName {
                    if self.sectionManager.deleteSection(for: sectionInfo.sectionId) {
                        self.delegate?.deleteSection()
                    }
                }
            }
        })
    }
    
    @objc func deleteTaskButtonPressed(_ sender: UIButton) {
        viewController?.showAlert(title: "Delete Task", message: "Would you like to delete task?", completion: { isDeleted in
            if isDeleted {
                if self.taskManager.deleteTasks(for: self.arrayTaskList[sender.tag].taskId) {
                    self.update()
                }
            }
        })
    }
}

// MARK: - Private Methods
private extension SectionCollectionViewCell {
    
    func setupTableView() {
        self.tableView.register(UINib(nibName: "TaskTableViewCell", bundle: nil), forCellReuseIdentifier: "TaskTableViewCell")
        
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 100
        self.tableView.tableFooterView = UIView(frame: .zero)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let nibName = UINib(nibName: "TaskHeaderViewCell", bundle: nil)
        self.tableView.register(nibName, forHeaderFooterViewReuseIdentifier: "TaskHeaderViewCell")
    }
    
    func getTasksData(for sectionInfo: SectionInfo) {
        if let tasks = taskManager.getAll(for: sectionInfo.sectionId) {
            self.arrayTaskList.removeAll()
            self.arrayTaskList = tasks
        } else {
            self.arrayTaskList = []
        }
        
        self.tableView.reloadData()
    }
    
    private func scheduleLocalNotification(for task: TaskInfo) {
        // Create Notification Content
        let notificationContent = UNMutableNotificationContent()
        
        // Configure Notification Content
        notificationContent.title = "Taski"
        notificationContent.subtitle = task.taskName
        
        // Add Trigger
        if let triggerDate = task.notifyTime {
            let notificationTrigger = UNCalendarNotificationTrigger(
                dateMatching: Calendar.current.dateComponents([.timeZone, .year, .month, .day, .hour, .minute], from: triggerDate),
                repeats: false
            )
            
            // Create Notification Request
            let notificationRequest = UNNotificationRequest(identifier: "cocoacasts_local_notification", content: notificationContent, trigger: notificationTrigger)
            
            // Add Request to User Notification Center
            UNUserNotificationCenter.current().add(notificationRequest) { (error) in
                if let error = error {
                    print("Unable to Add Notification Request (\(error), \(error.localizedDescription))")
                }
            }
        }
    }
    
    private func requestAuthorization(completionHandler: @escaping (_ success: Bool) -> ()) {
        // Request Authorization
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (success, error) in
            if let error = error {
                print("Request Authorization Failed (\(error), \(error.localizedDescription))")
            }
            
            completionHandler(success)
        }
    }
}

// MARK: - Action Methods
extension SectionCollectionViewCell {
    
    @IBAction func addTaskButtonClicked(_ sender: UIButton) {
        
        let addTaskView = AddTaskView.instantiateFromNib()
        
        let alert = Malert(title: "Add Task", customView: addTaskView)
        alert.textAlign = .center
        alert.textColor = .gray
        alert.titleFont = UIFont.systemFont(ofSize: 20)
        alert.margin = 16
        alert.buttonsAxis = .horizontal
        alert.separetorColor = .clear
        
        let cancelAction = MalertAction(title: "Cancel", backgroundColor: UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.0))
        cancelAction.tintColor = .red
        alert.addAction(cancelAction)
        
        let addAction = MalertAction(title: "Add", backgroundColor: UIColor(red:0.10, green:0.14, blue:0.49, alpha:1.0)) {
            if !addTaskView.addTaskTextView.text.isEmpty {
                let random64 = Int64(arc4random()) + (Int64(arc4random()) << 32)
                if let sectionInfo = self.sectionInfo {
                    let taskInfo = TaskInfo(_taskId: random64, _taskName: addTaskView.addTaskTextView.text, _sectionId: sectionInfo.sectionId, _isNotify: addTaskView.notificationSwitch.isOn, _notifyTime: addTaskView.notificationSwitch.isOn ? addTaskView.selectedDate : nil)
                    let section = SectionInfo(_sectionId: sectionInfo.sectionId, _sectionName: sectionInfo.sectionName, _taskInfo: [taskInfo])
                    let result = self.sectionManager.updateSection(record: section)
                    if result {
                        debugPrint("record saved successfully")
                    } else {
                        debugPrint("Create failed")
                    }
                    
                    if addTaskView.notificationSwitch.isOn {
                        UNUserNotificationCenter.current().getNotificationSettings { (notificationSettings) in
                            switch notificationSettings.authorizationStatus {
                            case .notDetermined:
                                // Request Authorization
                                self.requestAuthorization(completionHandler: { (success) in
                                    guard success else { return }
                                    
                                    // Schedule Local Notification
                                    self.scheduleLocalNotification(for: taskInfo)
                                })
                            case .authorized:
                                // Schedule Local Notification
                                self.scheduleLocalNotification(for: taskInfo)
                            case .denied:
                                print("Application Not Allowed to Display Notifications")
                            case .provisional:
                                print("provisional")
                            case .ephemeral:
                                print("ephemeral")
                            @unknown default:
                                print("default")
                            }
                        }
                    }
                    UserDefaults.standard.set(Date().convertDateTimeInFormat(), forKey: "LastUpdateAt")
                    self.getTasksData(for: sectionInfo)
                    self.delegate?.addTask(for: sectionInfo)
                }
            }
        }
        addAction.tintColor = .white
        alert.addAction(addAction)
        
        viewController?.present(alert, animated: true)
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: "TaskHeaderViewCell") as! TaskHeaderViewCell
        
        if let sectionInfo = self.sectionInfo {
            headerView.categoryNameLabel.text = sectionInfo.sectionName
            if self.arrayTaskList.count > 0 {
                headerView.taskNumberLabel.text = "\(self.arrayTaskList.count) tasks"
            } else {
                headerView.taskNumberLabel.text = "0 task"
            }
        }
        headerView.deleteCategoryButton.addTarget(self, action: #selector(deleteCategoryButtonClicked), for: .touchUpInside)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayTaskList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell", for: indexPath) as! TaskTableViewCell
        cell.taskNameLabel.text = self.arrayTaskList[indexPath.row].taskName
        cell.notificationView.isHidden = true
        if self.arrayTaskList[indexPath.row].isNotify {
            cell.notificationView.isHidden = false
            if let notifyTime = self.arrayTaskList[indexPath.row].notifyTime {
                cell.notiticationTimeLable.text = notifyTime.convertDateTimeInFormat()
            }
        }
        cell.deleteTaskButton.tag = indexPath.row
        cell.deleteTaskButton.addTarget(self, action: #selector(deleteTaskButtonPressed(_ :)), for: .touchUpInside)
        cell.backgroundColor = UIColor.red
        return cell
    }
}
