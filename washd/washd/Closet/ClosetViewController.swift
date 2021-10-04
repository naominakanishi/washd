import UIKit
import CoreNFC

final class ClosetViewController: UIViewController {
 
    private lazy var closetTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ClothesCell.self, forCellReuseIdentifier: "ClothesCell")
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.allowsSelection = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        addSubviews()
        constraintSubviews()
        view.backgroundColor = .washdColors.background
    }
    
    private func addSubviews() {
        view.addSubviews(closetTableView)
    }
    
    private func constraintSubviews() {
        closetTableView.layout(using: [
            closetTableView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor
            ),
            closetTableView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 30
            ),
            closetTableView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor
            ),
            closetTableView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -30
            ),
        ])
    }
    
    private func configureNavigationBar() {
        let moreButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        moreButton.setBackgroundImage(UIImage(systemName: "plus"), for: .normal)
        moreButton.tintColor = .black
        moreButton.addTarget(self, action: #selector(handleAddPiece), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: moreButton)
        title = "Suas roupas"
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    @objc
    private func handleAddPiece() {
        let controller = NewEntryViewController()
        controller.completion = {
            self.closetTableView.reloadData()
        }
        present(controller, animated: true, completion: nil)
    }
}


extension ClosetViewController: UITableViewDelegate, UITableViewDataSource {
    
    var closet: Closet { ClosetDatabase.instance.closet() }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return closet.clothes.count
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClothesCell") as! ClothesCell
        let clothing = closet.clothes[indexPath.item]
        cell.configure(using: clothing)
        return cell
    }
}

