import Foundation

class SpotifyAPIManager {
    static let shared = SpotifyAPIManager()
    
    private let clientID = "5b76e4ca1a634733bf6e1804b9a301d6"
    private let clientSecret = "28593edf5c8f4ef98be6f900311a68e6"
    private let baseURL = "https://api.spotify.com/v1/playlists/37i9dQZEVXbMDoHDwVN2tF/tracks?limit=50" // URL para a playlist das 50 melhores músicas
    
    private init() {}
    
    private func getAuthorizationHeader() -> String {
        let credentials = "\(clientID):\(clientSecret)"
        let data = credentials.data(using: .utf8)!
        let base64Credentials = data.base64EncodedString()
        return "Basic \(base64Credentials)"
    }

    func getTopTracks(completion: @escaping ([Musica]?) -> Void) {
        guard let url = URL(string: baseURL) else {
            print("Erro: URL inválida para a API do Spotify")
            completion(nil)
            return
        }

        getToken { token in
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
                
                /*
                 if let jsonString = String(data: data, encoding: .utf8) {
                    print("Resposta da API:")
                    print("\n\n"+jsonString)
                }
                 */
                
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
                                            reproducoesString: "\(track.popularity) reproduções",
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

    private func getToken(completion: @escaping (String?) -> Void) {
        guard let url = URL(string: "https://accounts.spotify.com/api/token") else {
            print("Erro: URL inválida para obter o token de acesso")
            completion(nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let clientCredentials = "\(clientID):\(clientSecret)"
        let clientCredentialsData = clientCredentials.data(using: .utf8)!
        let base64ClientCredentials = clientCredentialsData.base64EncodedString()
        request.addValue("Basic \(base64ClientCredentials)", forHTTPHeaderField: "Authorization")
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let body = "grant_type=client_credentials"
        request.httpBody = body.data(using: .utf8)

        URLSession.shared.dataTask(with: request) { data, _, error in
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
}
