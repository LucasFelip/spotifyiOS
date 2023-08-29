import Foundation

class GetTopTracks {
    static let shared = GetTopTracks()
    
    private let baseURL = "https://api.spotify.com/v1/playlists/37i9dQZEVXbMDoHDwVN2tF/tracks?limit=49" // URL para a playlist das 50 melhores músicas
    
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
    
    func createPlaylist(accessToken: String, completion: @escaping (String?) -> Void) {
        guard let url = URL(string: "https://api.spotify.com/v1/users/{SEU_USER_ID}/playlists") else {
            print("Erro: URL inválida para criar playlist")
            completion(nil)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let playlistData: [String: Any] = [
            "name": "Minhas Favoritas",
            "description": "Playlist gerada automaticamente com suas músicas favoritas",
            "public": false
        ]
        let jsonData = try? JSONSerialization.data(withJSONObject: playlistData)

        request.httpBody = jsonData

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print("Erro ao criar playlist: \(error)")
                completion(nil)
                return
            }

            guard let data = data else {
                print("Erro: Nenhum dado recebido ao criar playlist")
                completion(nil)
                return
            }

            do {
                let jsonDecoder = JSONDecoder()
                let response = try jsonDecoder.decode(PlaylistResponse.self, from: data)
                let playlistID = response.id
                completion(playlistID)
            } catch {
                print("Erro ao fazer o parsing dos dados da playlist: \(error)")
                completion(nil)
            }
        }.resume()
    }

    func addTracksToPlaylist(accessToken: String, playlistID: String, trackURIs: [String], completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "https://api.spotify.com/v1/playlists/\(playlistID)/tracks") else {
            print("Erro: URL inválida para adicionar músicas à playlist")
            completion(false)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let trackURIsData: [String: Any] = [
            "uris": trackURIs
        ]
        let jsonData = try? JSONSerialization.data(withJSONObject: trackURIsData)

        request.httpBody = jsonData

        URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                print("Erro ao adicionar músicas à playlist: \(error)")
                completion(false)
                return
            }

            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 {
                completion(true)
            } else {
                print("Erro: Falha ao adicionar músicas à playlist")
                completion(false)
            }
        }.resume()
    }
    
    func createAndAddToPlaylist(accessToken: String, trackURIs: [String], completion: @escaping (Bool) -> Void) {
        createPlaylist(accessToken: accessToken) { [weak self] playlistID in
            guard let self = self, let playlistID = playlistID else {
                completion(false)
                return
            }

            self.addTracksToPlaylist(accessToken: accessToken, playlistID: playlistID, trackURIs: trackURIs) { success in
                completion(success)
            }
        }
    }

}
