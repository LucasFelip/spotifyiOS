import Foundation

class GetTopTracks {
    static let shared = GetTopTracks()
    
    private let baseURL = "https://api.spotify.com/v1/playlists/37i9dQZEVXbMDoHDwVN2tF/tracks?limit=50"
    
    private init() {}
    
    
    func getTopTracks(completion: @escaping ([Musica]?) -> Void) {
        guard let url = URL(string: baseURL) else {
            print("Erro: URL inválida para a API do Spotify")
            completion(nil)
            return
        }
        
        SpotifyAuth.shared.getToken { token in
            guard let token = token else {
                print("Erro ao obter o token de acesso")
                completion(nil)
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            
            URLSession.shared.dataTask(with: request) { data, _, error in
                if let error = error {
                    print("Erro na solicitação: \(error)")
                    completion(nil)
                    return
                }
                
                guard let data = data else {
                    print("Erro: Nenhum dado recebido da API")
                    completion(nil)
                    return
                }
                
                do {
                    let jsonDecoder = JSONDecoder()
                    let response = try jsonDecoder.decode(SpotifyAPIResponse.self, from: data)
                    let items = response.items
                    
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
                                            reproducoesString: "\(track.popularity)",
                                            duracao: duracao,
                                            spotifyURL: URL(string: track.external_urls.spotify))
                        musicasArray.append(musica)
                    }
                    completion(musicasArray)
                } catch {
                    print("Erro ao fazer o parsing dos dados da API: \(error)")
                    completion(nil)
                }
            }.resume()
        }
    }
}
