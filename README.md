# XXFXXHash
### Swift wrapper for [XXHash C library](https://github.com/Cyan4973/XXHash)

Wrapped:
* XXHash32
* XXHash64
* XXHash3 64bit (class XXHash3)
* XXHash3 128bit (class XXHash128)

## Getting started

### Installation

#### [Package Manager](https://swift.org/package-manager/)

Add the following dependency to your [Package.swift](https://github.com/apple/swift-package-manager/blob/master/Documentation/Usage.md#define-dependencies):

```swift
.package(url: "https://github.com/NBXXF/XXFXXHash.swift.git", from: "0.0.2")
```

Run `swift build` and build your app.

### Examples

### One Shot methods
```swift
import XXFXXHash

let hash64 = XXHash64.hash("UTF8 string")
let hash32 = XXHash32.hash([1, 255, 127, 0], seed: 1234)
let hash3_64 = XXHash3.hash(Data())
let hash3_128 = XXHash128.hash(Data(), seed: 1234, secret: Data(repeating: 0xff, count: 32))
```

### Streaming api
```swift
import XXFXXHash

var hasher = try XXHash64(seed: 1234) // or XXHash64() for empty seed
try hasher.update("Some string") // string
try hasher.update([1, 2, 255, 127]) // byte array
try hasher.update(Data(repeating: 0xff, count: 32)) // data
let hash = hasher.digest()
```

### Helper methods
```swift
import XXFXXHash

// Canonical form of hash (BE bytes array)
let intHash = XXHash64.hash("UTF8 string")
let hashBytes = XXHash64.canonical(hash: intHash)
let restored = try XXHash64.hash(canonical: hashBytes)
assert(intHash == restored)

// Secret generation for XXHash3
let secret1 = XXHash3.generateSecret(seed: 12345678) // from UInt64
let secret2 = try XXHash3.generateSecret(seed: Data(repeating: 0xff, count: 32)) // from seed data
let secret3 = try XXHash3.generateSecret(seed: "Some string") // from seed string
let secret4 = try XXHash3.generateSecret(seed: [1, 255, 254, 127]) // from byte array
```

## License

XXFXXHash.swift is available under the Apache 2.0 license. See [the LICENSE file](./LICENSE) for more information.
