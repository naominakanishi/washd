import UIKit
import CoreNFC

final class ClosetViewController: UIViewController {
 
    private lazy var closetTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ClothesCell.self, forCellReuseIdentifier: "ClothesCell")
        tableView.separatorStyle = .none
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        addSubviews()
        constraintSubviews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
            present(NewEntryViewController(), animated: true, completion: nil)
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
                equalTo: view.leadingAnchor
            ),
            closetTableView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor
            ),
            closetTableView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor
            ),
        ])
    }
    
    private func configureNavigationBar() {
        navigationItem.rightBarButtonItem = .init(
            image: .add,
            style: .done,
            target: self,
            action: #selector(handleAddPiece))
    }
    
    @objc
    private func handleAddPiece() {
        present(NewEntryViewController(), animated: true, completion: nil)
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
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.frame.height / 5
    }
}

