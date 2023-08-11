import Foundation

// Função para salvar músicas favoritas
func salvarMusicasFavoritas(_ musicas: [Musica]) {
    let encoder = JSONEncoder()
    if let encodedData = try? encoder.encode(musicas) {
        UserDefaults.standard.set(encodedData, forKey: "MusicasFavoritas")
    }
}

// Função para carregar músicas favoritas
func carregarMusicasFavoritas() -> [Musica] {
    if let savedData = UserDefaults.standard.data(forKey: "MusicasFavoritas") {
        let decoder = JSONDecoder()
        if let musicas = try? decoder.decode([Musica].self, from: savedData) {
            return musicas
        }
    }
    return []
}
