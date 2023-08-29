//
//  MusicasFavoritas.swift
//  spotifyiOS
//
//  Created by Lucas Ferreira on 18/08/23.
//

import Foundation

class MusicasFavoritas {
    static let shared = MusicasFavoritas()
    var musicasFavoritadas: [Musica] = []
        
    private init() {}
}
