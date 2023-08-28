//
//  xxHash128.swift
//  
//
//  Created by Yehor Popovych on 28/08/2023.
//

import Foundation
import CxxHash

public final class xxHash128 {
    public struct HashError: Error {}
    
    private let state: OpaquePointer!
    
    public init(seed: UInt64? = nil, secret: Data? = nil) throws {
        self.state = XXH_INLINE_XXH3_createState()
        try self.reset(seed: seed, secret: secret)
    }
    
    public func reset(seed: UInt64? = nil, secret: Data? = nil) throws {
        let result = {
            if let secret = secret, let seed = seed {
                return secret.withUnsafeBytes { sec in
                    XXH_INLINE_XXH3_128bits_reset_withSecretandSeed(state, sec.baseAddress,
                                                                    sec.count, seed)
                }
            } else if let secret = secret {
                return secret.withUnsafeBytes { sec in
                    XXH_INLINE_XXH3_128bits_reset_withSecret(state, sec.baseAddress,
                                                             sec.count)
                }
            } else if let seed = seed {
                return XXH_INLINE_XXH3_128bits_reset_withSeed(state, seed)
            } else {
                return XXH_INLINE_XXH3_128bits_reset(state)
            }
        }()
        guard result == XXH_NAMESPACEXXH_OK else {
            throw HashError()
        }
    }
    
    public func update(_ bytes: Data) throws {
        let result = bytes.withUnsafeBytes { buffer in
            XXH_INLINE_XXH3_128bits_update(state, buffer.baseAddress, buffer.count)
        }
        guard result == XXH_NAMESPACEXXH_OK else { throw HashError() }
    }
    
    public func update(_ bytes: [UInt8]) throws {
        let result = bytes.withUnsafeBytes { buffer in
            XXH_INLINE_XXH3_128bits_update(state, buffer.baseAddress, buffer.count)
        }
        guard result == XXH_NAMESPACEXXH_OK else { throw HashError() }
    }
    
    public func update(_ utf8: String) throws {
        var utf8 = utf8
        let result = utf8.withUTF8 { buffer in
            XXH_INLINE_XXH3_128bits_update(state, buffer.baseAddress, buffer.count)
        }
        guard result == XXH_NAMESPACEXXH_OK else { throw HashError() }
    }
    
    public func digest() -> (low: UInt64, high: UInt64) {
        XXH_INLINE_XXH3_128bits_digest(state).tuple()
    }
    
    public static func canonical(hash: (low: UInt64, high: UInt64)) -> [UInt8] {
        var canonical = XXH_NAMESPACEXXH128_canonical_t()
        let nhash = XXH_NAMESPACEXXH128_hash_t(low64: hash.low, high64: hash.high)
        XXH_INLINE_XXH128_canonicalFromHash(&canonical, nhash)
        return [canonical.digest.0, canonical.digest.1, canonical.digest.2, canonical.digest.3,
                canonical.digest.4, canonical.digest.5, canonical.digest.6, canonical.digest.7,
                canonical.digest.8, canonical.digest.9, canonical.digest.10, canonical.digest.11,
                canonical.digest.12, canonical.digest.13, canonical.digest.14, canonical.digest.15]
    }
    
    public static func hash(canonical hash: [UInt8]) throws -> (low: UInt64, high: UInt64) {
        guard hash.count == 16 else { throw xxHashError() }
        var canonical = XXH_NAMESPACEXXH128_canonical_t(
            digest: (hash[0], hash[1], hash[2], hash[3], hash[4], hash[5], hash[6], hash[7],
                     hash[8], hash[9], hash[10], hash[11], hash[12], hash[13], hash[14], hash[15])
        )
        let nhash = XXH_INLINE_XXH128_hashFromCanonical(&canonical)
        return (low: nhash.low64, high: nhash.high64)
    }
    
    public static func hash(_ bytes: Data, seed: UInt64? = nil,
                            secret: Data? = nil) -> (low: UInt64, high: UInt64)
    {
        bytes.withUnsafeBytes { buf in
            if let seed = seed, let secret = secret {
                return secret.withUnsafeBytes { sec in
                    XXH_INLINE_XXH3_128bits_withSecretandSeed(buf.baseAddress, buf.count,
                                                              sec.baseAddress, sec.count,
                                                              seed)
                }
            } else if let secret = secret {
                return secret.withUnsafeBytes { sec in
                    XXH_INLINE_XXH3_128bits_withSecret(buf.baseAddress, buf.count,
                                                       sec.baseAddress, sec.count)
                }
            } else if let seed = seed {
                return XXH_INLINE_XXH3_128bits_withSeed(buf.baseAddress, buf.count, seed)
            } else {
                return XXH_INLINE_XXH3_128bits(buf.baseAddress, buf.count)
            }
        }.tuple()
    }
    
    public static func hash(_ bytes: [UInt8], seed: UInt64? = nil,
                            secret: Data? = nil) -> (low: UInt64, high: UInt64)
    {
        bytes.withUnsafeBytes { buf in
            if let seed = seed, let secret = secret {
                return secret.withUnsafeBytes { sec in
                    XXH_INLINE_XXH3_128bits_withSecretandSeed(buf.baseAddress, buf.count,
                                                              sec.baseAddress, sec.count,
                                                              seed)
                }
            } else if let secret = secret {
                return secret.withUnsafeBytes { sec in
                    XXH_INLINE_XXH3_128bits_withSecret(buf.baseAddress, buf.count,
                                                       sec.baseAddress, sec.count)
                }
            } else if let seed = seed {
                return XXH_INLINE_XXH3_128bits_withSeed(buf.baseAddress, buf.count, seed)
            } else {
                return XXH_INLINE_XXH3_128bits(buf.baseAddress, buf.count)
            }
        }.tuple()
    }
    
    public static func hash(_ uft8: String, seed: UInt64? = nil,
                            secret: Data? = nil) -> (low: UInt64, high: UInt64)
    {
        var utf8 = uft8
        return utf8.withUTF8 { buf in
            if let seed = seed, let secret = secret {
                return secret.withUnsafeBytes { sec in
                    XXH_INLINE_XXH3_128bits_withSecretandSeed(buf.baseAddress, buf.count,
                                                              sec.baseAddress, sec.count,
                                                              seed)
                }
            } else if let secret = secret {
                return secret.withUnsafeBytes { sec in
                    XXH_INLINE_XXH3_128bits_withSecret(buf.baseAddress, buf.count,
                                                       sec.baseAddress, sec.count)
                }
            } else if let seed = seed {
                return XXH_INLINE_XXH3_128bits_withSeed(buf.baseAddress, buf.count, seed)
            } else {
                return XXH_INLINE_XXH3_128bits(buf.baseAddress, buf.count)
            }
        }.tuple()
    }
    
    deinit {
        XXH_INLINE_XXH3_freeState(state)
    }
}

private extension XXH_NAMESPACEXXH128_hash_t {
    func tuple() -> (low: UInt64, high: UInt64) {
        (low: low64, high: high64)
    }
}
