//
//  xxHash3.swift
//  
//
//  Created by Yehor Popovych on 28/08/2023.
//

import Foundation
import CxxHash

public final class xxHash3 {
    private let state: OpaquePointer!
    
    public init(seed: UInt64? = nil, secret: Data? = nil) throws {
        self.state = XXH_INLINE_XXH3_createState()
        try self.reset(seed: seed, secret: secret)
    }
    
    public func reset(seed: UInt64? = nil, secret: Data? = nil) throws {
        let result = {
            if let secret = secret, let seed = seed {
                return secret.withUnsafeBytes { sec in
                    XXH_INLINE_XXH3_64bits_reset_withSecretandSeed(state, sec.baseAddress,
                                                                   sec.count, seed)
                }
            } else if let secret = secret {
                return secret.withUnsafeBytes { sec in
                    XXH_INLINE_XXH3_64bits_reset_withSecret(state, sec.baseAddress,
                                                            sec.count)
                }
            } else if let seed = seed {
                return XXH_INLINE_XXH3_64bits_reset_withSeed(state, seed)
            } else {
                return XXH_INLINE_XXH3_64bits_reset(state)
            }
        }()
        guard result == XXH_NAMESPACEXXH_OK else {
            throw xxHashError()
        }
    }
    
    public func update(_ bytes: Data) throws {
        let result = bytes.withUnsafeBytes { buffer in
            XXH_INLINE_XXH3_64bits_update(state, buffer.baseAddress, buffer.count)
        }
        guard result == XXH_NAMESPACEXXH_OK else { throw xxHashError() }
    }
    
    public func update(_ bytes: [UInt8]) throws {
        let result = bytes.withUnsafeBytes { buffer in
            XXH_INLINE_XXH3_64bits_update(state, buffer.baseAddress, buffer.count)
        }
        guard result == XXH_NAMESPACEXXH_OK else { throw xxHashError() }
    }
    
    public func update(_ utf8: String) throws {
        var utf8 = utf8
        let result = utf8.withUTF8 { buffer in
            XXH_INLINE_XXH3_64bits_update(state, buffer.baseAddress, buffer.count)
        }
        guard result == XXH_NAMESPACEXXH_OK else { throw xxHashError() }
    }
    
    public func digest() -> UInt64 {
        XXH_INLINE_XXH3_64bits_digest(state)
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
    
    public static func hash(_ bytes: Data, seed: UInt64? = nil,
                            secret: Data? = nil) -> UInt64
    {
        bytes.withUnsafeBytes { buf in
            if let seed = seed, let secret = secret {
                return secret.withUnsafeBytes { sec in
                    XXH_INLINE_XXH3_64bits_withSecretandSeed(buf.baseAddress, buf.count,
                                                              sec.baseAddress, sec.count,
                                                              seed)
                }
            } else if let secret = secret {
                return secret.withUnsafeBytes { sec in
                    XXH_INLINE_XXH3_64bits_withSecret(buf.baseAddress, buf.count,
                                                      sec.baseAddress, sec.count)
                }
            } else if let seed = seed {
                return XXH_INLINE_XXH3_64bits_withSeed(buf.baseAddress, buf.count, seed)
            } else {
                return XXH_INLINE_XXH3_64bits(buf.baseAddress, buf.count)
            }
        }
    }
    
    public static func hash(_ bytes: [UInt8], seed: UInt64? = nil,
                            secret: Data? = nil) -> UInt64
    {
        bytes.withUnsafeBytes { buf in
            if let seed = seed, let secret = secret {
                return secret.withUnsafeBytes { sec in
                    XXH_INLINE_XXH3_64bits_withSecretandSeed(buf.baseAddress, buf.count,
                                                             sec.baseAddress, sec.count,
                                                             seed)
                }
            } else if let secret = secret {
                return secret.withUnsafeBytes { sec in
                    XXH_INLINE_XXH3_64bits_withSecret(buf.baseAddress, buf.count,
                                                      sec.baseAddress, sec.count)
                }
            } else if let seed = seed {
                return XXH_INLINE_XXH3_64bits_withSeed(buf.baseAddress, buf.count, seed)
            } else {
                return XXH_INLINE_XXH3_64bits(buf.baseAddress, buf.count)
            }
        }
    }
    
    public static func hash(_ utf8: String, seed: UInt64? = nil,
                            secret: Data? = nil) -> UInt64
    {
        var utf8 = utf8
        return utf8.withUTF8 { buf in
            if let seed = seed, let secret = secret {
                return secret.withUnsafeBytes { sec in
                    XXH_INLINE_XXH3_64bits_withSecretandSeed(buf.baseAddress, buf.count,
                                                             sec.baseAddress, sec.count,
                                                             seed)
                }
            } else if let secret = secret {
                return secret.withUnsafeBytes { sec in
                    XXH_INLINE_XXH3_64bits_withSecret(buf.baseAddress, buf.count,
                                                      sec.baseAddress, sec.count)
                }
            } else if let seed = seed {
                return XXH_INLINE_XXH3_64bits_withSeed(buf.baseAddress, buf.count, seed)
            } else {
                return XXH_INLINE_XXH3_64bits(buf.baseAddress, buf.count)
            }
        }
    }
    
    deinit {
        XXH_INLINE_XXH3_freeState(state)
    }
}
