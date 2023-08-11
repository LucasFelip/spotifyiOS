import Foundation

func salvarMusicasFavoritas(_ musicas: [Musica]) {
    let musicasFavoritas = musicas.filter { $0.isFavorita }
    for (index, musica) in musicasFavoritas.enumerated() {
        musica.posicaoFavorita = index + 1
    }
    
    let encoder = JSONEncoder()
    if let encodedData = try? encoder.encode(musicas) {
        UserDefaults.standard.set(encodedData, forKey: "MusicasFavoritas")
    }
}

func carregarMusicasFavoritas() -> [Musica] {
    if let savedData = UserDefaults.standard.data(forKey: "MusicasFavoritas") {
        let decoder = JSONDecoder()
        if let musicas = try? decoder.decode([Musica].self, from: savedData) {
            return musicas
        }
    }
    return []
}
