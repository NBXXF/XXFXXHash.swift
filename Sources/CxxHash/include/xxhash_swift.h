//
//  xxhash_swift.h
//  
//
//  Created by Yehor Popovych on 28/08/2023.
//

#ifndef __xxhash_swift_h__
#define __xxhash_swift_h__

#ifdef __BYTE_ORDER__
    #if __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
        #define XXH_CPU_LITTLE_ENDIAN 1
    #elif
        #define XXH_CPU_LITTLE_ENDIAN 0
    #endif
#else
    #error "Byte order is unknown"
#endif

#define XXH_INLINE_ALL
#define XXH_STATIC_LINKING_ONLY

#include "../xxhash.h"

#endif /* __xxhash_swift_h__ */
