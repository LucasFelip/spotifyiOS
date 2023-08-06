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

extension ListViewController {
    private static let clientID = "5b76e4ca1a634733bf6e1804b9a301d6"
    private static let clientSecret = "28593edf5c8f4ef98be6f900311a68e6"
    private static let baseURL = "https://api.spotify.com/v1/playlists/37i9dQZEVXbMDoHDwVN2tF/tracks?limit=50" // URL para a playlist das 50 melhores músicas

    private func getAuthorizationHeader() -> String {
        let credentials = "\(ListViewController.clientID):\(ListViewController.clientSecret)"
        let data = credentials.data(using: .utf8)!
        let base64Credentials = data.base64EncodedString()
        return "Basic \(base64Credentials)"
    }
}

extension ListViewController {
    private func setupData() {
        guard let url = URL(string: ListViewController.baseURL) else {
            print("Erro: URL inválida para a API do Spotify")
            return
        }

        getToken { [weak self] token in
            guard let self = self else { return }
            guard let token = token else {
                print("Erro ao obter o token de acesso")
                return
            }

            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

            URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
                guard self != nil else { return }
                if let error = error {
                    print("Erro na solicitação: \(error)")
                    return
                }
                
                guard let data = data else {
                    print("Erro: Nenhum dado recebido da API")
                    return
                }
                
                do {
                    let jsonDecoder = JSONDecoder()
                    let response = try jsonDecoder.decode(SpotifyAPIResponse.self, from: data)
                    let items = response.items
                    
                    // Mapear os dados para o array de objetos Musica
                    var musicasArray = [Musica]()
                    for (index, item) in items.enumerated() {
                        let track = item.track
                        let imagemURLString = track.album.images.first?.url
                        let imagemURL = URL(string: imagemURLString ?? "")
                        let duracao = TimeInterval(track.duration_ms) / 1000
                        
                        let musica = Musica(posicao: index + 1,
                                            imagemURL: imagemURL,
                                            nome: track.name,
                                            artista: track.artists.first?.name ?? "",
                                            reproducoesString: "\(track.popularity) reproduções",
                                            duracao: duracao)
                        
                        musicasArray.append(musica)
                    }
                    
                    // Atualizar o array de musicas e recarregar a tabela
                    DispatchQueue.main.async { [weak self] in
                        self?.musicas = musicasArray
                        self?.tableView.reloadData()
                    }
                } catch {
                    print("Erro ao fazer o parsing dos dados da API: \(error)")
                }
            }.resume()
        }
    }

    
    private func getToken(completion: @escaping (String?) -> Void) {
        guard let url = URL(string: "https://accounts.spotify.com/api/token") else {
            print("Erro: URL inválida para obter o token de acesso")
            completion(nil)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let clientCredentials = "\(ListViewController.clientID):\(ListViewController.clientSecret)"
        let clientCredentialsData = clientCredentials.data(using: .utf8)!
        let base64ClientCredentials = clientCredentialsData.base64EncodedString()
        request.addValue("Basic \(base64ClientCredentials)", forHTTPHeaderField: "Authorization")
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let body = "grant_type=client_credentials"
        request.httpBody = body.data(using: .utf8)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Erro ao obter o token de acesso: \(error)")
                completion(nil)
                return
            }

            guard let data = data else {
                print("Erro: Nenhum dado recebido ao obter o token de acesso")
                completion(nil)
                return
            }

            do {
                let jsonDecoder = JSONDecoder()
                let response = try jsonDecoder.decode(TokenResponse.self, from: data)
                let token = response.access_token
                completion(token)
            } catch {
                print("Erro ao fazer o parsing do token de acesso: \(error)")
                completion(nil)
            }
        }.resume()
    }

    struct TokenResponse: Codable {
        let access_token: String
    }

}


struct SpotifyAPIResponse: Codable {
    let href: String
    let items: [Item]
}

struct Item: Codable {
    let added_at: String
    let track: Track
}

struct Track: Codable {
    let album: Album
    let artists: [Artist]
    let duration_ms: Int
    let name: String
    let popularity: Int
}

struct Album: Codable {
    let images: [Image]
    let name: String
}

struct Artist: Codable {
    let name: String
}

struct Image: Codable {
    let url: String
}
