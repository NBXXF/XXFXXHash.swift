//
//  xxHash32.swift
//  
//
//  Created by Yehor Popovych on 28/08/2023.
//

import Foundation
import CxxHash

public struct xxHash32 {
    private var state: XXH_NAMESPACEXXH32_state_t
    
    public init(seed: UInt32 = 0) throws {
        self.state = .init()
        try self.reset(seed: seed)
    }
    
    public mutating func reset(seed: UInt32 = 0) throws {
        guard XXH_INLINE_XXH32_reset(&state, seed) == XXH_NAMESPACEXXH_OK else {
            throw xxHashError()
        }
    }
    
    public mutating func update(_ bytes: Data) throws {
        let result = bytes.withUnsafeBytes { buf in
            XXH_INLINE_XXH32_update(&state, buf.baseAddress, buf.count)
        }
        guard result == XXH_NAMESPACEXXH_OK else { throw xxHashError() }
    }
    
    public mutating func update(_ bytes: [UInt8]) throws {
        let result = bytes.withUnsafeBytes { buf in
            XXH_INLINE_XXH32_update(&state, buf.baseAddress, buf.count)
        }
        guard result == XXH_NAMESPACEXXH_OK else { throw xxHashError() }
    }
    
    public mutating func update(_ utf8: String) throws {
        var utf8 = utf8
        let result = utf8.withUTF8 { buf in
            XXH_INLINE_XXH32_update(&state, buf.baseAddress, buf.count)
        }
        guard result == XXH_NAMESPACEXXH_OK else { throw xxHashError() }
    }
    
    public func digest() -> UInt32 {
        withUnsafePointer(to: state) { XXH_INLINE_XXH32_digest($0) }
    }
    
    public static func canonical(hash: UInt32) -> [UInt8] {
        var canonical = XXH_NAMESPACEXXH32_canonical_t()
        XXH_INLINE_XXH32_canonicalFromHash(&canonical, hash)
        return [canonical.digest.0, canonical.digest.1, canonical.digest.2, canonical.digest.3]
    }
    
    public static func hash(canonical hash: [UInt8]) throws -> UInt32 {
        guard hash.count == 4 else { throw xxHashError() }
        var canonical = XXH_NAMESPACEXXH32_canonical_t(digest: (hash[0], hash[1], hash[2], hash[3]))
        return XXH_INLINE_XXH32_hashFromCanonical(&canonical)
    }
    
    public static func hash(_ bytes: Data, seed: UInt32 = 0) -> UInt32 {
        bytes.withUnsafeBytes { buf in
            XXH_INLINE_XXH32(buf.baseAddress, buf.count, seed)
        }
    }
    
    public static func hash(_ bytes: [UInt8], seed: UInt32 = 0) -> UInt32 {
        bytes.withUnsafeBytes { buf in
            XXH_INLINE_XXH32(buf.baseAddress, buf.count, seed)
        }
    }
    
    public static func hash(_ utf8: String, seed: UInt32 = 0) -> UInt32 {
        var utf8 = utf8
        return utf8.withUTF8 { buf in
            XXH_INLINE_XXH32(buf.baseAddress, buf.count, seed)
        }
    }
}
