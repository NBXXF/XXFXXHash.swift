//
//  xxHash64.swift
//  
//
//  Created by Yehor Popovych on 28/08/2023.
//

import Foundation
import CxxHash

public struct xxHash64 {
    private var state: XXH_NAMESPACEXXH64_state_t
    
    public init(seed: UInt64 = 0) throws {
        self.state = .init()
        try self.reset(seed: seed)
    }
    
    public mutating func reset(seed: UInt64 = 0) throws {
        guard XXH_INLINE_XXH64_reset(&state, seed) == XXH_NAMESPACEXXH_OK else {
            throw xxHashError()
        }
    }
    
    public mutating func update(_ bytes: Data) throws {
        let result = bytes.withUnsafeBytes { buf in
            XXH_INLINE_XXH64_update(&state, buf.baseAddress, buf.count)
        }
        guard result == XXH_NAMESPACEXXH_OK else { throw xxHashError() }
    }
    
    public mutating func update(_ bytes: [UInt8]) throws {
        let result = bytes.withUnsafeBytes { buf in
            XXH_INLINE_XXH64_update(&state, buf.baseAddress, buf.count)
        }
        guard result == XXH_NAMESPACEXXH_OK else { throw xxHashError() }
    }
    
    public mutating func update(_ utf8: String) throws {
        var utf8 = utf8
        let result = utf8.withUTF8 { buf in
            XXH_INLINE_XXH64_update(&state, buf.baseAddress, buf.count)
        }
        guard result == XXH_NAMESPACEXXH_OK else { throw xxHashError() }
    }
    
    public func digest() -> UInt64 {
        withUnsafePointer(to: state) { XXH_INLINE_XXH64_digest($0) }
    }
    
    public static func canonical(hash: UInt64) -> [UInt8] {
        var canonical = XXH_NAMESPACEXXH64_canonical_t()
        XXH_INLINE_XXH64_canonicalFromHash(&canonical, hash)
        return [canonical.digest.0, canonical.digest.1, canonical.digest.2, canonical.digest.3,
                canonical.digest.4, canonical.digest.5, canonical.digest.6, canonical.digest.7]
    }
    
    public static func hash(canonical hash: [UInt8]) throws -> UInt64 {
        guard hash.count == 8 else { throw xxHashError() }
        var canonical = XXH_NAMESPACEXXH64_canonical_t(
            digest: (hash[0], hash[1], hash[2], hash[3], hash[4], hash[5], hash[6], hash[7])
        )
        return XXH_INLINE_XXH64_hashFromCanonical(&canonical)
    }
    
    public static func hash(_ bytes: Data, seed: UInt64 = 0) -> UInt64 {
        bytes.withUnsafeBytes { buf in
            XXH_INLINE_XXH64(buf.baseAddress, buf.count, seed)
        }
    }
    
    public static func hash(_ bytes: [UInt8], seed: UInt64 = 0) -> UInt64 {
        bytes.withUnsafeBytes { buf in
            XXH_INLINE_XXH64(buf.baseAddress, buf.count, seed)
        }
    }
    
    public static func hash(_ utf8: String, seed: UInt64 = 0) -> UInt64 {
        var utf8 = utf8
        return utf8.withUTF8 { buf in
            XXH_INLINE_XXH64(buf.baseAddress, buf.count, seed)
        }
    }
}
