import UIKit

class ListFavViewController: UIViewController {
    var musicas: [Musica] = []
    private var favoritas = [Musica]()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 42)
        label.textColor = .gray
        label.numberOfLines = 0
        label.text = "Top Músicas Favoritas"
        return label
    }()
    
    private let barraView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .gray
        return view
    }()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .darkGray
        table.separatorStyle = .none
        table.rowHeight = 70
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkGray
        setupTableView()
        addViewHierarchy()
        setupConstraints()
    }
    
    private func setupTableView() {
        tableView.register(MusicaTableFavViewCell.self, forCellReuseIdentifier: "MusicaCell")
        tableView.dataSource = self
    }
    
    private func addViewHierarchy() {
        view.addSubview(titleLabel)
        view.addSubview(barraView)
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
        NSLayoutConstraint.activate([
            barraView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            barraView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            barraView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            barraView.heightAnchor.constraint(equalToConstant: 2) // Altura desejada da barra
        ])
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: barraView.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 6),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -6),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func loadFavoritas() {
        favoritas = musicas.filter { $0.isFavorita }
        print("Total de músicas favoritas: \(favoritas.count)")
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        favoritas = carregarMusicasFavoritas()
        tableView.reloadData()
    }
}

extension ListFavViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MusicaCell", for: indexPath) as! MusicaTableFavViewCell
        let musica = favoritas[indexPath.row]
        cell.configure(with: musica)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritas.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
