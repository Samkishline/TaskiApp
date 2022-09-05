//Starting View Controller


//Welcome to my iOS App Taski

import UIKit
import CoreData
import UserNotifications

class HomeViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var lastUpdatedLabel: UILabel!
    
    private var arraySectionList: [SectionInfo] = []
    private let manager = SectionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.uiSetup()
        
        // Configure User Notification Center
        UNUserNotificationCenter.current().delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now()+1.0) {
            self.setupUserDefaults()
        }
    }
    
    func setupUserDefaults() {
        if let startUpName = UserDefaults.standard.value(forKey: "StartUpName") as? String {
            self.welcomeLabel.text = "Welcome \(startUpName)"
        } else {
            self.alertWithTextField(title: "", message: "Welcome to the Taski App", placeholder: "Your nice name please? Enter name") { value in
                UserDefaults.standard.set(value, forKey: "StartUpName")
                self.welcomeLabel.text = "Welcome \(value)"
            }
        }
        
        if let lastUpdatedAt = UserDefaults.standard.value(forKey: "LastUpdateAt") as? String {
            self.lastUpdatedLabel.text = "Last updated at \(lastUpdatedAt)"
        } else {
            self.lastUpdatedLabel.text = "Last updated at \(Date().convertDateTimeInFormat())"
        }
    }
}

// MARK: - Private Methods -
private extension HomeViewController {
    
    func uiSetup() {
        
        self.getSectionData()
        self.collectionView.allowsSelection = false
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        self.collectionView.cornerRadius = 8.0
    }
    
    func getSectionData() {
        if let section = manager.getAll() {
            self.arraySectionList = section
        } else {
            self.arraySectionList = []
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
            self.collectionView.reloadData()
            self.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .left, animated: false)
        }
    }
}

// MARK: - CollectionView Delegate & Data Source
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arraySectionList.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if self.arraySectionList.count == indexPath.row {
            let cell: AddSectionCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddSectionCollectionViewCell", for: indexPath) as! AddSectionCollectionViewCell
            cell.delegate = self
            return cell
        } else {
            let cell: SectionCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SectionCollectionViewCell", for: indexPath) as! SectionCollectionViewCell
            cell.sectionInfo = self.arraySectionList[indexPath.row]
            cell.viewController = self
            cell.delegate = self
            cell.update()
            return cell
        }
    }
}

// MARK:- CollectionView Delegate -
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let collectionViewWidth = collectionView.frame.size.width
        let collectionViewHeight = collectionView.frame.size.height
        return CGSize(width: collectionViewWidth, height: collectionViewHeight)
    }
}

// MARK: - AddCategory Delegate
extension HomeViewController: AddSectionDelegate {
    
    func addCategoryButtonClicked() {
        self.alertWithTextField(title: "Add Category", message: "Which category would you like to add?", placeholder: "Category name") { result in
            
            if result.count > 0 {
                let random64 = Int64(arc4random()) + (Int64(arc4random()) << 32)
                let sectionInfo = SectionInfo(_sectionId: random64, _sectionName: result, _taskInfo: nil)
                let result = self.manager.createSection(record: sectionInfo)
                
                if result {
                    debugPrint("record saved successfully")
                } else {
                    debugPrint("Create failed")
                }
                self.getSectionData()
            }
        }
    }
}

// MARK: - AddCategory Delegate
extension HomeViewController: SectionCollectionDelegate {
    
    func deleteSection() {
        UserDefaults.standard.set(Date().convertDateTimeInFormat(), forKey: "LastUpdateAt")
        self.getSectionData()
    }
    
    func addTask(for section: SectionInfo) {
        UserDefaults.standard.set(Date().convertDateTimeInFormat(), forKey: "LastUpdateAt")
        self.collectionView.reloadData()
    }
}

extension HomeViewController: UNUserNotificationCenterDelegate {

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert])
    }
}
