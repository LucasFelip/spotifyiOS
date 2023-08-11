import UIKit

class MusicaTableFavViewCell: UITableViewCell {
    enum ReuseIdentifier: String {
        case musicaCell
    }
    
    private let posicaoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 45)
        label.numberOfLines = 0
        return label
    }()
    
    private let nomeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        return label
    }()
    
    private let musicaImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let artistaLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: ReuseIdentifier.musicaCell.rawValue)
        
        contentView.backgroundColor = .darkGray
        contentView.addSubview(posicaoLabel)
        contentView.addSubview(musicaImageView)
        contentView.addSubview(nomeLabel)
        contentView.addSubview(artistaLabel)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            posicaoLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            posicaoLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            musicaImageView.leadingAnchor.constraint(equalTo: posicaoLabel.leadingAnchor, constant: 55),
            musicaImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            musicaImageView.heightAnchor.constraint(equalToConstant: 60),
            musicaImageView.widthAnchor.constraint(equalToConstant: 60)
        ])
        
        NSLayoutConstraint.activate([
            nomeLabel.leadingAnchor.constraint(equalTo: musicaImageView.leadingAnchor, constant: 65),
            nomeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            nomeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30)
        ])
        
        NSLayoutConstraint.activate([
            artistaLabel.bottomAnchor.constraint(equalTo: nomeLabel.bottomAnchor,constant: 16),
            artistaLabel.leadingAnchor.constraint(equalTo: musicaImageView.leadingAnchor, constant: 65),
            artistaLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        posicaoLabel.text = nil
        nomeLabel.text = nil
        artistaLabel.text = nil
        musicaImageView.image = nil
    }
    
    func configure(with musica: Musica) {
        posicaoLabel.text = "\(musica.posicaoFavorita)"
        nomeLabel.text = musica.nome
        artistaLabel.text = musica.artista
        
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
            musicaImageView.image = nil
            musicaImageView.backgroundColor = .black
        }
    }
}
