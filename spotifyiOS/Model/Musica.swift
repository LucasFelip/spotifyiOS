import UIKit

class Musica {
    var posicao: Int
    var imagemURL: URL?
    var nome: String
    var artista: String
    var reproducoes: String
    var duracao: String

    init(posicao: Int, imagemURL: URL?, nome: String, artista: String, reproducoes: String, duracao: String) {
        self.posicao = posicao
        self.imagemURL = imagemURL
        self.nome = nome
        self.artista = artista
        self.reproducoes = reproducoes
        self.duracao = duracao
    }
}

extension Musica {
    convenience init(posicao: Int, imagemURLString: String?, nome: String, artista: String, reproducao: String, duracao: String) {
        let imagemURL = URL(string: imagemURLString ?? "")
        self.init(posicao: posicao, imagemURL: imagemURL, nome: nome, artista: artista, reproducoes: reproducao, duracao: duracao)
    }
}
