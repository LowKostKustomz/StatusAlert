//
//  StatusAlert
//  Copyright (c) 2017-2018 LowKostKustomz. All rights reserved.
//

import UIKit
import StatusAlert

class ViewController: UIViewController {
    
    typealias Section = (header: String?, models: [TableViewCellModel], footer: String?)
    
    struct TableViewCellModel {
        let title: String
        let action: () -> Void
    }
    
    private let cellReuseIdentifier = "reuseIdentifier"
    private let tableView = UITableView(frame: .zero,
                                        style: .grouped)
    
    private var sections: [Section] = []
    private var preferredPosition: StatusAlert.VerticalPosition = .center
    private var isPickable: Bool = true
    
    static func instantiate() -> ViewController {
        let controller = ViewController()
        controller.title = "StatusAlert"
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationItems()
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
        let differentContentSectionModels: [TableViewCellModel]
            = [TableViewCellModel(title: "With image, title and message",
                                  action: { [weak self] in
                                    self?.showStatusAlert(withImage: UIImage(named: "Success image"),
                                                          title: "StatusAlert",
                                                          message: "With image, title and message")
            }),
               TableViewCellModel(title: "With image and title only",
                                  action: { [weak self] in
                                    self?.showStatusAlert(withImage: UIImage(named: "Success image"),
                                                          title: "StatusAlert with image and title",
                                                          message: nil)
               }),
               TableViewCellModel(title: "With image and message only",
                                  action: { [weak self] in
                                    self?.showStatusAlert(withImage: UIImage(named: "Success image"),
                                                          title: nil,
                                                          message: "StatusAlert with image and message")
               }),
               TableViewCellModel(title: "With title and message only",
                                  action: { [weak self] in
                                    self?.showStatusAlert(withImage: nil,
                                                          title: "StatusAlert",
                                                          message: "With title and message")
               }),
               TableViewCellModel(title: "Only with image",
                                  action: { [weak self] in
                                    self?.showStatusAlert(withImage: UIImage(named: "Success image"),
                                                          title: nil,
                                                          message: nil)
               }),
               TableViewCellModel(title: "Only with title",
                                  action: { [weak self] in
                                    self?.showStatusAlert(withImage: nil,
                                                          title: "StatusAlert with title",
                                                          message: nil)
               }),
               TableViewCellModel(title: "Only with message",
                                  action: { [weak self] in
                                    self?.showStatusAlert(withImage: nil,
                                                          title: nil,
                                                          message: "StatusAlert with message")
               })]
        let differentContentSection: Section = ("Different content", differentContentSectionModels, "See these to find out how many opportunities to use StatusAlert there is.\nYou can also try different modes with navigation bar buttons.")
        sections.append(differentContentSection)
        
        let fromAppsSectionModels: [TableViewCellModel]
            = [TableViewCellModel(title: "From the Apple Music app",
                                  action:  { [weak self] in
                                    self?.showStatusAlert(withImage: UIImage(named: "Loved icon"),
                                                          title: "Loved",
                                                          message: "We’ll recommend more like this in For You.")
            }),
               TableViewCellModel(title: "From the Podcasts app",
                                  action:  { [weak self] in
                                    self?.showStatusAlert(withImage: UIImage(named: "Success icon"),
                                                          title: "С подпиской",
                                                          message: nil)
               }),
               TableViewCellModel(title: "From the News app",
                                  action:  { [weak self] in
                                    self?.showStatusAlert(withImage: UIImage(named: "Loved icon"),
                                                          title: "Loved",
                                                          message: "We’ll show more stories about this in For You.")
               })]
        let fromAppsSection: Section = ("From the Apple apps", fromAppsSectionModels, "See these to be sure that everything looks similar to the Apple apps")
        sections.append(fromAppsSection)
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func showStatusAlert(withImage image: UIImage?,
                                 title: String?,
                                 message: String?) {
        let statusAlert = StatusAlert.instantiate(withImage: image,
                                                  title: title,
                                                  message: message,
                                                  canBePickedOrDismissed: isPickable)
        statusAlert.show(withVerticalPosition: preferredPosition)
    }
    
    @objc private func selectVerticalPosition() {
        let actionSheet = UIAlertController(title: "StatusAlert vertical position",
                                            message: nil,
                                            preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Top",
                                            style: .default,
                                            handler: { [weak self] (_) in
                                                self?.preferredPosition = .top
                                                self?.setNavigationItems()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Center",
                                            style: .default,
                                            handler: { [weak self] (_) in
                                                self?.preferredPosition = .center
                                                self?.setNavigationItems()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Bottom",
                                            style: .default,
                                            handler: { [weak self] (_) in
                                                self?.preferredPosition = .bottom
                                                self?.setNavigationItems()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel",
                                            style: .cancel,
                                            handler: nil))
        actionSheet.popoverPresentationController?.barButtonItem = navigationItem.leftBarButtonItems?.first
        present(actionSheet,
                animated: true,
                completion: nil)
    }
    
    @objc private func selectPickable() {
        let actionSheet = UIAlertController(title: "Pickable",
                                            message: "If the StatusAlert can be picked or dismissed by tap",
                                            preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Yes",
                                            style: .default,
                                            handler: { [weak self] (_) in
                                                self?.isPickable = true
                                                self?.setNavigationItems()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "No",
                                            style: .default,
                                            handler: { [weak self] (_) in
                                                self?.isPickable = false
                                                self?.setNavigationItems()
        }))
        actionSheet.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItems?.first
        present(actionSheet,
                animated: true,
                completion: nil)
    }
    
    private func setNavigationItems() {
        var leftTitle: String
        
        switch preferredPosition {
        case .top:
            leftTitle = "Top"
        case .center:
            leftTitle = "Center"
        case .bottom:
            leftTitle = "Bottom"
        }
        
        navigationItem.leftBarButtonItems = [UIBarButtonItem(title: leftTitle,
                                                             style: .plain,
                                                             target: self,
                                                             action: #selector(selectVerticalPosition))]
        
        var rightTitle: String
        
        switch isPickable {
        case true:
            rightTitle = "Pickable"
        case false:
            rightTitle = "Not pickable"
        }
        
        navigationItem.rightBarButtonItems = [UIBarButtonItem(title: rightTitle,
                                                              style: .plain,
                                                              target: self,
                                                              action: #selector(selectPickable))]
    }
}

// MARK: - UITableViewDelegate

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        sections[indexPath.section].models[indexPath.row].action()
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return sections[section].models.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier,
                                                 for: indexPath)
        cell.textLabel?.text = sections[indexPath.section].models[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   titleForHeaderInSection section: Int) -> String? {
        return sections[section].header
    }
    
    func tableView(_ tableView: UITableView,
                   titleForFooterInSection section: Int) -> String? {
        return sections[section].footer
    }
}

