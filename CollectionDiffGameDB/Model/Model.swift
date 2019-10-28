//
//  Model.swift
//  CollectionDiffGameDB
//
//  Created by Alfian Losari on 20/06/19.
//  Copyright © 2019 Alfian Losari. All rights reserved.
//

import Foundation
import IGDB_SWIFT_API

struct Item: Hashable {
    
    var itemType: ItemType
    
    init(itemType: ItemType) {
        self.itemType = itemType
    }
    
    var identifier: String {
        let identifier: String
        switch itemType {
        case .platform(let name, let isSelected):
            identifier = "platform_\(name.hashValue)_\(isSelected)"
            
        case .genre(let name, let isSelected):
            identifier = "genre_\(name.hashValue)_\(isSelected)"
            
        case .sort(let sort, let isSelected):
            identifier = "sort_\(sort.hashValue)_\(isSelected)"
            
        case .game(let game):
            identifier = "\(game.id)"
        }
        return identifier
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    
    static func ==(lhs: Item, rhs: Item) -> Bool {
        lhs.identifier == rhs.identifier
    }
    
    enum ItemType {
        case platform(type: PlatformType, isSelected: Bool)
        case genre(type: GenreType, isSelected: Bool)
        case sort(type: SortType, isSelected: Bool)
        case game(Proto_Game)
    }
}

enum PlatformType: String, CaseIterable, CustomStringConvertible {
    case ps4 = "PlayStation 4"
    case xboxone = "Xbox One"
    case nintendoswitch = "Nintendo Switch"
    
    init?(rawValue: String) {
        if rawValue == "ps4" || rawValue == "playstation4" || rawValue == "playstation 4" || rawValue == "ps 4" {
            self = .ps4
        } else if rawValue == "xbox one" || rawValue == "xbox" {
            self = .xboxone
        } else if rawValue == "nintendo switch" || rawValue == "switch" {
            self = .nintendoswitch
        } else {
            return nil
        }
    }
    
    var description: String {
        rawValue
    }
    
    var id: Int {
        switch self {
        case .ps4: return 48
        case .xboxone: return 49
        case .nintendoswitch: return 130
        }
    }
    
    static var apocalypseFilterIds: [Int] {
        [PlatformType.ps4.id, PlatformType.xboxone.id, PlatformType.nintendoswitch.id]
    }
    
    static var apocalypseFilterText: String {
        apocalypseFilterIds.map { String($0) }.joined(separator: ",")
    }
}

enum GenreType: String, CaseIterable {
    case adventure
    case arcade
    case platform
    case rpg
    case fps
    case sport
    case racing
    
    
    var description: String {
        self.rawValue.capitalized
    }
    
    var id: Int {
        switch self {
        case .adventure: return 31
        case .arcade: return 25
        case .platform: return 8
        case .rpg: return 12
        case .fps: return 5
        case .sport: return 14
        case .racing: return 10
        }
    }
    
    static var apocalypseFilterIds: [Int] {
        [GenreType.adventure.id, GenreType.arcade.id, GenreType.platform.id, GenreType.rpg.id, GenreType.fps.id]
    }
    
    static var apocalypseFilterText: String {
        apocalypseFilterIds.map { String($0) }.joined(separator: ",")
    }
}

enum SortType: CaseIterable, CustomStringConvertible {
    case popularity
    case releaseDate
    case rating
    
    var description: String {
        switch self {
        case .popularity: return "Popularity"
        case .releaseDate: return "Release Date"
        case .rating: return "Rating"
        }
    }
}

struct SectionLayoutKind: Hashable {
    
    let kind: SectionKind
    
    init(kind: SectionKind) {
        self.kind = kind
    }
    
    var identifier: String {
        let identifier: String
        
        switch kind {
        case is CarouselPlatform:
            identifier = "platforms"
            
        case is CarouselGenres:
            identifier = "genres"
            
        case is CarouselSorts:
            identifier = "sorts"
            
        case is Grid:
            identifier = "grid"
            
        default:
            identifier = ""
        }
        return identifier
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    
    static func ==(lhs: SectionLayoutKind, rhs: SectionLayoutKind) -> Bool {
        lhs.identifier == rhs.identifier
    }
}

protocol SectionKind {
    var items: [Item] { get }
}

struct CarouselPlatform: SectionKind {
    var items: [Item]
}

struct CarouselGenres: SectionKind {
    var items: [Item]
}

struct CarouselSorts: SectionKind {
    var items: [Item]
}

struct Grid: SectionKind {
    var items: [Item]
}

extension Array where Element == SectionLayoutKind {
    
    func index(for kind: SectionKind.Type) -> Int? {
        let index = self.firstIndex { (kindx) -> Bool in
            if type(of: kindx.kind) == kind {
                return true
            }
            return false
        }
        return index
    }
}
