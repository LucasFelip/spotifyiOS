import UIKit

class ListViewController: UIViewController {
    private var musicas = [Musica]()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 42)
        label.textColor = .darkText
        label.numberOfLines = 0
        label.text = "Top Músicas"
        return label
    }()
    
    private let barraView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .darkText
        return view
    }()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .darkGray
        table.separatorColor = .none
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
    
    private func setupData() {
        // Criar instâncias de Musica e adicionar à array musicas
        let musica1 = Musica(posicao: 1, imagemURLString: "https://i.scdn.co/image/ab67616d0000b273d67feb28d4f481dac9ae1a8d", nome: "AmEN!", artista: "Bring Me The Horizon", reproducao: 9303364, duracao: "3:09")
        musicas.append(musica1)
        
        let musica2 = Musica(posicao: 2, imagemURLString: "https://i.scdn.co/image/ab67616d0000b27360f41c1043f678c81ca373a2", nome: "Everytime We Touch - TEKKNO Version", artista: "Electric Callboy", reproducao: 9303364, duracao: "3:09")
        musicas.append(musica2)
        
        let musica3 = Musica(posicao: 3, imagemURLString:"https://i.scdn.co/image/ab67616d0000b273fdf16e6dc8b69f3e7c2b258b", nome: "Freak On a Leash", artista: "Korn", reproducao: 9303364, duracao: "3:09")
        musicas.append(musica3)
        
        let musica4 = Musica(posicao: 4, imagemURLString:"https://i.scdn.co/image/ab67616d0000b273fdf16e6dc8b69f3e7c2b258b", nome: "Your Love", artista: "The Outfield", reproducao: 9303364, duracao: "3:09")
        musicas.append(musica4)
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
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
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

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MusicaCell", for: indexPath) as! MusicaTableViewCell
        let musica = musicas[indexPath.row]
        cell.configure(with: musica)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return musicas.count
    }
}

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

