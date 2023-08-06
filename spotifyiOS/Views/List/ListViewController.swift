import UIKit

class ListViewController: UIViewController {
    private var musicas = [Musica]()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 42)
        label.textColor = .gray
        label.numberOfLines = 0
        label.text = "Top Músicas"
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
        setupData()
        setupTableView()
        addViewHierarchy()
        setupContraints()
    }

    private func setupTableView() {
        tableView.register(MusicaTableViewCell.self, forCellReuseIdentifier: "MusicaCell")
        tableView.dataSource = self
        tableView.delegate = self
    }

    private func addViewHierarchy() {
        view.addSubview(titleLabel)
        view.addSubview(barraView)
        view.addSubview(tableView)
    }

    private func setupContraints() {
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
}

extension ListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MusicaCell", for: indexPath) as! MusicaTableViewCell
        let musica = musicas[indexPath.row]
        cell.configure(with: musica)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return musicas.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMusica = musicas[indexPath.row]
        let detailViewController = DetailViewController()
        detailViewController.configure(with: selectedMusica)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

extension ListViewController {
    private func setupData() {
        SpotifyAPIManager.shared.getTopTracks { [weak self] musicas in
            guard let self = self, let musicas = musicas else {
                return
            }
            DispatchQueue.main.async {
                self.musicas = musicas
                self.tableView.reloadData()
            }
        }
    }
}
