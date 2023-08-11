import UIKit

class Musica: Codable {
    let posicao: Int
    let imagemURL: URL?
    let nome: String
    let artista: String
    let reproducoesString: String
    let duracao: TimeInterval
    public var isFavorita: Bool = false

    init(posicao: Int, imagemURL: URL?, nome: String, artista: String, reproducoesString: String, duracao: TimeInterval) {
        self.posicao = posicao
        self.imagemURL = imagemURL
        self.nome = nome
        self.artista = artista
        self.reproducoesString = reproducoesString
        self.duracao = duracao
    }
}

extension Musica {
    convenience init?(posicao: Int, imagemURLString: String?, nome: String, artista: String, reproducoesString: String, duracao: TimeInterval) {
        if let imagemURLString = imagemURLString, let imagemURL = URL(string: imagemURLString) {
            self.init(posicao: posicao, imagemURL: imagemURL, nome: nome, artista: artista, reproducoesString: reproducoesString, duracao: duracao)
        } else {
            return nil // Retorna nil se a URL da imagem não for válida.
        }
    }
}

extension Musica {
    var duracaoEmMinutos: String {
        let duracaoEmSegundos = Double(duracao) 
        let minutos = Int(duracaoEmSegundos / 60)
        let segundos = Int(duracaoEmSegundos.truncatingRemainder(dividingBy: 60))
        return String(format: "%d:%02d", minutos, segundos)
    }
}

extension Musica {
    func toggleFavorita() {
        self.isFavorita.toggle()
    }
}

extension Musica {
    enum CodingKeys: String, CodingKey {
        case posicao, imagemURL, nome, artista, reproducoesString, duracao, isFavorita
    }
}
