
//
//  ViewController.swift
//  DragDropTableCell
//
//  Created by Rath! on 11/11/24.
//

import UIKit


class ViewController: UIViewController {

    var tableView = UITableView()
    
    var itemList:[[String]] = []  {
        didSet{
            DispatchQueue.main.async { [self] in
                tableView.reloadData()
                UserDefaults.standard.saveObject(object: itemList, forKey: "saveDataList")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let data = DataManager.shared.getDragDropMenu()
        
        if data?.count ?? 0 > 0 {
            itemList = data ?? []
        }else{
            itemList = [
                ["Section 0"],
                ["1","2","3","4"],
            ]
        }
        
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        tableView.backgroundColor = .orange
        tableView.register(Cell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.dragInteractionEnabled = true
        tableView.dragDelegate = self
        tableView.dropDelegate = self
    }

  
}

extension ViewController: UITableViewDataSource, UITableViewDelegate{
    // MARK: - UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        return itemList.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemList[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! Cell
        
        if indexPath.section == 0{
            cell.lblName.text = "Selct 0"
        }else{
            cell.lblName.text = itemList[indexPath.section][indexPath.row]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 200
        }else{
            return 100
        }
    }
}


extension ViewController: UITableViewDragDelegate, UITableViewDropDelegate {
    
    // MARK: - UITableViewDragDelegate

    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        guard indexPath.section != 0 else { return [] } // Prevent dragging from section 0
        let item = itemList[indexPath.section][indexPath.row] as NSString
        let itemProvider = NSItemProvider(object: item)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        return [dragItem]
    }

    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        let destinationIndexPath: IndexPath
        if let indexPath = coordinator.destinationIndexPath {
            destinationIndexPath = indexPath
        } else {
            let section = tableView.numberOfSections - 1
            let row = tableView.numberOfRows(inSection: section)
            destinationIndexPath = IndexPath(row: row, section: section)
        }

        guard destinationIndexPath.section != 0 else { return } // Prevent dropping into section 0

        coordinator.session.loadObjects(ofClass: NSString.self) { items in
            guard let stringItems = items as? [String] else { return }
            var indexPaths: [IndexPath] = [] // Explicitly declare the type as an array of IndexPath

            tableView.performBatchUpdates({
                for (index, item) in stringItems.enumerated() {
                    // Find the original index path of the item if it exists
                    if let originalIndexPath = self.indexPath(for: item) {
                        self.itemList[originalIndexPath.section].remove(at: originalIndexPath.row)
                        tableView.deleteRows(at: [originalIndexPath], with: .automatic)
                    }

                    let indexPath = IndexPath(row: destinationIndexPath.row + index, section: destinationIndexPath.section)
                    self.itemList[destinationIndexPath.section].insert(item, at: indexPath.row)
                    indexPaths.append(indexPath)
                }
                tableView.insertRows(at: indexPaths, with: .automatic)
            }, completion: nil)
        }
    }


    // Helper method to find the index path of an item
    func indexPath(for item: String) -> IndexPath? {
        for (sectionIndex, section) in itemList.enumerated() {
            if let rowIndex = section.firstIndex(of: item) {
                return IndexPath(row: rowIndex, section: sectionIndex)
            }
        }
        return nil
    }



    func tableView(_ tableView: UITableView, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSString.self)
    }

    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        if let destinationIndexPath = destinationIndexPath, destinationIndexPath.section == 0 {
            return UITableViewDropProposal(operation: .forbidden) // Prevent dropping into section 0
        }
        return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
    }
    
    func tableView(_ tableView: UITableView, dragPreviewParametersForRowAt indexPath: IndexPath) -> UIDragPreviewParameters? {
        let parameters = UIDragPreviewParameters()
        
        // Optionally, you can change the background color or add a custom view.
        let cell = tableView.cellForRow(at: indexPath) as! Cell
    
        // setup background like cell bgView
        parameters.visiblePath =  UIBezierPath(roundedRect: CGRect(x: cell.bgView.frame.minX,
                                                                   y: 0,
                                                                   width: cell.bgView.bounds.width,
                                                                   height: cell.bgView.bounds.height),
                                               cornerRadius: 10) // Optional: Rounded corners

        return parameters
    }
}
