import UIKit

class DetailViewController: UIViewController {
    enum ReuseIdentifier: String {
        case detailView
    }
    
    private var musica: Musica?

    private let musicaImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let nomeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 36, weight: .bold)
        label.numberOfLines = 0
        return label
    }()

    private let artistaLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()

    private let titleReproducoes: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.text = "Reproduções"
        return label
    }()

    private let reproducoesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()

    private let titleDuracao: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.text = "Duração"
        return label
    }()

    private let duracaoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkGray

        view.addSubview(musicaImageView)
        view.addSubview(nomeLabel)
        view.addSubview(artistaLabel)
        view.addSubview(titleReproducoes)
        view.addSubview(reproducoesLabel)
        view.addSubview(titleDuracao)
        view.addSubview(duracaoLabel)

        setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            musicaImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            musicaImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            musicaImageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            musicaImageView.heightAnchor.constraint(equalToConstant: 300)
        ])

        NSLayoutConstraint.activate([
            nomeLabel.topAnchor.constraint(equalTo: musicaImageView.bottomAnchor, constant: 10),
            nomeLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 45),
            nomeLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -45)
        ])

        NSLayoutConstraint.activate([
            artistaLabel.topAnchor.constraint(equalTo: nomeLabel.bottomAnchor,constant: 5),
            artistaLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 45),
            artistaLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -45)
        ])

        NSLayoutConstraint.activate([
            titleReproducoes.topAnchor.constraint(equalTo: artistaLabel.bottomAnchor, constant: 20),
            titleReproducoes.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 45)
        ])
        
        NSLayoutConstraint.activate([
            reproducoesLabel.topAnchor.constraint(equalTo: titleReproducoes.bottomAnchor, constant: 5),
            reproducoesLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 45)
        ])
        
        NSLayoutConstraint.activate([
            titleDuracao.topAnchor.constraint(equalTo: artistaLabel.bottomAnchor, constant: 20),
            titleDuracao.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -45)
        ])

        NSLayoutConstraint.activate([
            duracaoLabel.topAnchor.constraint(equalTo: titleDuracao.bottomAnchor, constant: 5),
            duracaoLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -45)
        ])
    }

    func configure(with musica: Musica) {
        self.musica = musica
        
        if let imagemURL = musica.imagemURL {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: imagemURL),
                   let imagem = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.musicaImageView.image = imagem
                    }
                }
            }
        } else {
            DispatchQueue.main.async {
                self.musicaImageView.image = nil
                self.musicaImageView.backgroundColor = .black
            }
        }
        
        nomeLabel.text = musica.nome
        artistaLabel.text = musica.artista
        reproducoesLabel.text = musica.reproducoesString
        duracaoLabel.text = musica.duracaoEmMinutos
    }
}

