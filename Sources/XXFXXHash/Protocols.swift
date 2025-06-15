//
//  Protocols.swift
//  
//
//

import Foundation
import XXFCXXHash

public struct XXHashError: Error {
    public init() {}
}

public protocol XXHashCommon {
    associatedtype Hash
    
    mutating func update(_ buffer: UnsafeRawBufferPointer) throws
    
    func digest() -> Hash
    
    static func canonical(hash: Hash) -> [UInt8]
    static func hash(canonical hash: [UInt8]) throws -> Hash
}

public extension XXHashCommon {
    @inlinable
    mutating func update(_ bytes: Data) throws {
        try bytes.withUnsafeBytes { try update($0) }
    }
    
    @inlinable
    mutating func update(_ bytes: [UInt8]) throws {
        try bytes.withUnsafeBytes { try update($0) }
    }
    
    @inlinable
    mutating func update(_ utf8: String) throws {
        var utf8 = utf8
        return try utf8.withUTF8 { try $0.withUnsafeBytes { try update($0) } }
    }
}

public protocol xxHash2Common: XXHashCommon where Hash: UnsignedInteger & FixedWidthInteger {
    init(seed: Hash) throws
    mutating func reset(seed: Hash) throws
    static func hash(_ buffer: UnsafeRawBufferPointer, seed: Hash) -> Hash
}

public extension xxHash2Common {
    @inlinable
    init() throws { try self.init(seed: 0) }
    
    @inlinable
    mutating func reset() throws { try reset(seed: 0) }
    
    @inlinable
    static func hash(_ bytes: Data, seed: Hash = 0) -> Hash {
        bytes.withUnsafeBytes { hash($0, seed: seed) }
    }
    
    @inlinable
    static func hash(_ bytes: [UInt8], seed: Hash = 0) -> Hash {
        bytes.withUnsafeBytes { hash($0, seed: seed) }
    }
    
    @inlinable
    static func hash(_ utf8: String, seed: Hash = 0) -> Hash {
        var utf8 = utf8
        return utf8.withUTF8 { $0.withUnsafeBytes { hash($0, seed: seed) } }
    }
}

public protocol xxHash3Common: XXHashCommon {
    init(seed: UInt64?, secret: Data?) throws
    func reset(seed: UInt64?, secretBuf: UnsafeRawBufferPointer?) throws
    static func hash(_ buffer: UnsafeRawBufferPointer, seed: UInt64?, secretBuf: UnsafeRawBufferPointer?) -> Hash
}

public extension xxHash3Common {
    @inlinable
    func reset(seed: UInt64? = nil, secret: Data? = nil) throws {
        if let secret = secret {
            try secret.withUnsafeBytes { try reset(seed: seed, secretBuf: $0) }
        } else {
            try reset(seed: seed, secretBuf: nil)
        }
    }
    
    @inlinable
    static func hash(_ bytes: Data, seed: UInt64? = nil, secret: Data? = nil) -> Hash {
        bytes.withUnsafeBytes { buf in
            if let secret = secret {
                return secret.withUnsafeBytes { hash(buf, seed: seed, secretBuf: $0) }
            } else {
                return hash(buf, seed: seed, secretBuf: nil)
            }
        }
    }
    
    @inlinable
    static func hash(_ bytes: [UInt8], seed: UInt64? = nil, secret: Data? = nil) -> Hash {
        bytes.withUnsafeBytes { buf in
            if let secret = secret {
                return secret.withUnsafeBytes { hash(buf, seed: seed, secretBuf: $0) }
            } else {
                return hash(buf, seed: seed, secretBuf: nil)
            }
        }
    }
    
    @inlinable
    static func hash(_ utf8: String, seed: UInt64? = nil, secret: Data? = nil) -> Hash {
        var utf8 = utf8
        return utf8.withUTF8 { $0.withUnsafeBytes { buf in
            if let secret = secret {
                return secret.withUnsafeBytes { hash(buf, seed: seed, secretBuf: $0) }
            } else {
                return hash(buf, seed: seed, secretBuf: nil)
            }
        }}
    }
    
    @inlinable
    static func generateSecret(seed: Data, size: Int = Int(XXH_SECRET_DEFAULT_SIZE)) throws -> Data {
        try seed.withUnsafeBytes { try generateSecret(seed: $0, size: size) }
    }
    
    @inlinable
    static func generateSecret(seed: [UInt8], size: Int = Int(XXH_SECRET_DEFAULT_SIZE)) throws -> Data {
        try seed.withUnsafeBytes { try generateSecret(seed: $0, size: size) }
    }
    
    @inlinable
    static func generateSecret(seed: String, size: Int = Int(XXH_SECRET_DEFAULT_SIZE)) throws -> Data {
        var seed = seed
        return try seed.withUTF8 { try $0.withUnsafeBytes { try generateSecret(seed: $0, size: size) } }
    }
    
    @inlinable
    static func generateSecret(seed: UnsafeRawBufferPointer,
                               size: Int = Int(XXH_SECRET_DEFAULT_SIZE)) throws -> Data {
        var secret = Data(repeating: 0, count: size)
        guard XXH_INLINE_XXH3_generateSecret(
            &secret, size, seed.baseAddress, seed.count
        ) == XXH_NAMESPACEXXH_OK else { throw XXHashError() }
        return secret
    }
    
    @inlinable
    static func generateSecret(seed: UInt64) -> Data {
        var secret = Data(repeating: 0, count: Int(XXH_SECRET_DEFAULT_SIZE))
        XXH_INLINE_XXH3_generateSecret_fromSeed(&secret, seed)
        return secret
    }
}
