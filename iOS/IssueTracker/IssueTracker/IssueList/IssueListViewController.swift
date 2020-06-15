import UIKit

class IssueListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    
    private var dataSource: IssueListDataSource = .init()
    
    var cancelBarButton: UIBarButtonItem  {
        return UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didCancelButtonPressed))
    }
    
    var editBarButton: UIBarButtonItem {
        return UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(didEditButtonPressed))
    }
    
    var filterBarButton: UIBarButtonItem {
        return UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(didFilterButtonPressed))
    }
    
    var selectAllBarButton: UIBarButtonItem {
        return UIBarButtonItem(title: "Select All", style: .plain, target: self, action: #selector(didSelectAllButtonPressed))
        navigationController?.setToolbarHidden(true, animated: false)
    }
    
    var deselectAllBarButton: UIBarButtonItem {
        return UIBarButtonItem(title: "Deselect All", style: .plain, target: self, action: #selector(didDeselectAllButtonPressed))
    }
    
    var closeBarButton: UIBarButtonItem {
        return UIBarButtonItem(title: "Close Issue", style: .plain, target: self, action: #selector(didCloseButtonPressed))
    }
    
    override var isEditing: Bool {
        didSet {
            setupButtons()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return !tableView.isEditing
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: true)
    }
    
    private func setupTableView() {
        let user = User(id: 1, name: "모오오오스")
        let issueList: IssueCollection = [Issue(id: 1, title: "title1", body: nil, owner: user),Issue(id: 2, title: "title2", body: "Something", owner: user),Issue(id: 3, title: "title3", body: "Special", owner: user)]
        self.dataSource = IssueListDataSource(issueList)
        self.tableView.dataSource = dataSource
        self.tableView.delegate = self
        tableView.allowsMultipleSelectionDuringEditing = true
        self.navigationItem.rightBarButtonItem = editBarButton
        navigationController?.setToolbarHidden(true, animated: false)
        self.navigationItem.leftBarButtonItem = filterBarButton
    }
    
    private func setupButtons() {
        switch isEditing {
        case true:
        self.navigationItem.rightBarButtonItem = cancelBarButton
        self.navigationItem.leftBarButtonItem = selectAllBarButton
            
        case false:
            navigationController?.setToolbarHidden(true, animated: false)
            self.navigationItem.rightBarButtonItem = editBarButton
            self.navigationItem.leftBarButtonItem = filterBarButton
        }
    }
    
    @objc private func didCancelButtonPressed() {
        isEditing = false
    }
    
    
    @objc private func didEditButtonPressed() {
        tableView.allowsMultipleSelectionDuringEditing = true
        isEditing = true
    }
    
    // TODO: present view to select filtering options.
    @objc private func didFilterButtonPressed() {
        
    }
    
    @objc private func didSelectAllButtonPressed(_ sender: UIBarButtonItem) {
        for row in 0..<tableView.numberOfRows(inSection: 0) {
            tableView.selectRow(at: IndexPath(row: row, section: 0), animated: true, scrollPosition: .none)
        }
        navigationItem.leftBarButtonItem = deselectAllBarButton
        toolbarItems = [closeBarButton]
        navigationController?.setToolbarHidden(false, animated: false)
    }
    
    @objc private func didDeselectAllButtonPressed() {
        for row in 0..<tableView.numberOfRows(inSection: 0) {
            tableView.deselectRow(at: IndexPath(row: row, section: 0), animated: true)
        }
        navigationItem.leftBarButtonItem = selectAllBarButton
        navigationController?.setToolbarHidden(true, animated: false)
        navigationController?.setToolbarHidden(true, animated: false)
    }
    
    @objc private func didCloseButtonPressed() {
        tableView.indexPathsForSelectedRows?.forEach{
            dataSource.closeIssue(at: $0.row)
        }
        isEditing = !isEditing
        navigationController?.setToolbarHidden(true, animated: false)
    }
  
    // MARK: - Navigation

    @IBAction func newIssueDidCreated(_ segue: UIStoryboardSegue) {
        guard let viewController = segue.source as? IssueFormViewController,
            let issue = viewController.issue else { return }

        dataSource.add(issue: issue)
        tableView.reloadData()
    }

    @IBSegueAction func showDetail(coder: NSCoder, sender: IssueCell) -> IssueDetailViewController? {
        guard let indexPath = tableView.indexPathForSelectedRow else { return nil }

        let issue = dataSource.issue(at: indexPath.row)
        return IssueDetailViewController(coder: coder, issue: issue)
    }

}

extension IssueListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let share = UIContextualAction(style: .normal, title: "Share") { action, view, completion in
            guard let dataSource = tableView.dataSource as? IssueListDataSource else { return }
            dataSource.closeIssue(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            debugPrint("Share")
            completion(true)
        }
        
        let delete = UIContextualAction(style: .destructive, title: "Delete") { action, view, completion in
            guard let dataSource = tableView.dataSource as? IssueListDataSource else { return }
            dataSource.removeIssue(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            debugPrint("Delete")
            completion(true)
        }
        
        share.backgroundColor = .systemGreen
        share.image = UIImage(systemName: SystemImageName.cellShare)
        delete.image = UIImage(systemName: SystemImageName.cellDelete)
        
        let swipeAction = UISwipeActionsConfiguration(actions: [share, delete])
        
        return swipeAction
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationItem.leftBarButtonItem = deselectAllBarButton
        if tableView.indexPathsForSelectedRows != nil {
            titleLabel.text = "\(tableView.indexPathsForSelectedRows!.count)개 선택"
            toolbarItems = [closeBarButton]
            navigationController?.setToolbarHidden(false, animated: false)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if tableView.indexPathsForSelectedRows == nil {
            navigationItem.leftBarButtonItem = selectAllBarButton
            navigationController?.setToolbarHidden(true, animated: false)
            titleLabel.text = "0개 선택"
        } else {
            titleLabel.text = "\(tableView.indexPathsForSelectedRows!.count)개 선택"
        }
    }
    
}
