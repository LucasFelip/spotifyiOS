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
        table.backgroundColor = .secondarySystemBackground
        table.separatorStyle = .none
        table.rowHeight = 70
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        setupData()
        setupTableView()
        addViewHierarchy()
        setupContraints()
    }
    
    private func setupData() {
        // Criar instâncias de Musica e adicionar à array musicas
        let musica1 = Musica(posicao: 1, imagemURLString: "https://i.scdn.co/image/ab67616d0000b273d67feb28d4f481dac9ae1a8d", nome: "AmEN!", artista: "Bring Me The Horizon", reproducao: "9.303.364", duracao: "3:09")
        musicas.append(musica1)
        
        let musica2 = Musica(posicao: 2, imagemURLString: "https://i.scdn.co/image/ab67616d0000b27360f41c1043f678c81ca373a2", nome: "Everytime We Touch - TEKKNO Version", artista: "Electric Callboy", reproducao: "9.303.364", duracao: "3:09")
        musicas.append(musica2)
        
        let musica3 = Musica(posicao: 3, imagemURLString:"https://i.scdn.co/image/ab67616d0000b27350d216aebaf98e8ac9947fd5", nome: "Freak On a Leash", artista: "Korn", reproducao: "9.303.364", duracao: "3:09")
        musicas.append(musica3)
        
        let musica4 = Musica(posicao: 4, imagemURLString:"https://i.scdn.co/image/ab67616d0000b273d8b8307316208d35b9d7094d", nome: "Your Love", artista: "The Outfield", reproducao: "9.303.364", duracao: "3:09")
        musicas.append(musica4)
        
        let musica5 = Musica(posicao: 5, imagemURLString:"https://i.scdn.co/image/ab67616d0000b27352f64465cdb6b0f4f469ec8b", nome: "Dona", artista: "Roupa Nova", reproducao: "9.303.364", duracao: "3:09")
        musicas.append(musica5)
        
        let musica6 = Musica(posicao: 6, imagemURLString:"https://i.scdn.co/image/ab67616d0000b273b11078ee23dcd99e085ac33e", nome: "Dream on", artista: "Aerosmith", reproducao: "9.303.364", duracao: "3:09")
        musicas.append(musica6)
        
        let musica7 = Musica(posicao: 7, imagemURLString:"https://i.scdn.co/image/ab67616d0000b27395313a5eee00d9bdf37883e2", nome: "Somebody to Love", artista: "Queen", reproducao: "9.303.364", duracao: "3:09")
        musicas.append(musica7)
        
        let musica8 = Musica(posicao: 8, imagemURLString:"https://i.scdn.co/image/ab67616d0000b27320322645c7e2e28c9d50beae", nome: "Boss", artista: "Lil pump", reproducao: "9.303.364", duracao: "3:09")
        musicas.append(musica8)
        
        let musica9 = Musica(posicao: 9, imagemURLString:"https://i.scdn.co/image/ab67616d0000b27360cf7c8dd93815ccd6cb4830", nome: "Can You Feel My Heart", artista: "Bring Me The Horizon", reproducao: "9.303.364", duracao: "3:09")
        musicas.append(musica9)
        
        let musica10 = Musica(posicao: 10, imagemURLString:"https://i.scdn.co/image/ab67616d0000b27347f20c3f01aa0c731ac82d23", nome: "We Got The Moves", artista: "Electric Callboy", reproducao: "9.303.364", duracao: "3:09")
        musicas.append(musica10)
        
        let musica11 = Musica(posicao: 11, imagemURLString:"https://i.scdn.co/image/ab67616d0000b2735602ed5181842ed7a69d1df8", nome: "Pass The Nirvana", artista: "Pierce The Veil", reproducao: "9.303.364", duracao: "3:09")
        musicas.append(musica11)
        
        let musica12 = Musica(posicao: 12, imagemURLString:"https://i.scdn.co/image/ab67616d0000b2731bb1db39abc18755d7ab2114", nome: "Holiday", artista: "Green Day", reproducao: "9.303.364", duracao: "3:09")
        musicas.append(musica12)
        
        let musica13 = Musica(posicao: 13, imagemURLString:"https://i.scdn.co/image/ab67616d0000b273579b9602ae484950d95d0ab8", nome: "Black Summer", artista: "Red Hot Chilli Peppers", reproducao: "9.303.364", duracao: "3:09")
        musicas.append(musica13)
        
        let musica14 = Musica(posicao: 14, imagemURLString:"https://i.scdn.co/image/ab67616d0000b273b5259c23afd536b2b440fe53", nome: "ZOMBIFIED", artista: "Fallin In Reverse", reproducao: "9.303.364", duracao: "3:09")
        musicas.append(musica14)
        
        let musica15 = Musica(posicao: 15, imagemURLString:"https://i.scdn.co/image/ab67616d0000b27306e5ecc6db28e5fd181e50c7", nome: "Nippon Manju", artista: "LADYBABY", reproducao: "9.303.364", duracao: "3:09")
        musicas.append(musica15)
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
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
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

