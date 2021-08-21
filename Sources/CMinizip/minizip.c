//
//  minizip.c
//  minizip
//
//  Created by Jaehong Kang on 2021/08/21.
//

#include "../../ThirdParty/minizip/mz_crypt.c"
#include "../../ThirdParty/minizip/mz_os.c"
#include "../../ThirdParty/minizip/mz_strm.c"
#include "../../ThirdParty/minizip/mz_strm_buf.c"
#include "../../ThirdParty/minizip/mz_strm_mem.c"
#include "../../ThirdParty/minizip/mz_strm_split.c"
#include "../../ThirdParty/minizip/mz_zip.c"
#include "../../ThirdParty/minizip/mz_zip_rw.c"

#include "../../ThirdParty/minizip/mz_strm_pkcrypt.c"
#include "../../ThirdParty/minizip/mz_strm_wzaes.c"

#ifdef HAVE_LIBCOMP
#include "../../ThirdParty/minizip/mz_strm_libcomp.c"
#endif

#if __has_include(<unistd.h>)
#include "../../ThirdParty/minizip/mz_os_posix.c"
#include "../../ThirdParty/minizip/mz_strm_os_posix.c"
#endif

#if __APPLE__
#include "../../ThirdParty/minizip/mz_crypt_apple.c"
#endif

#ifdef HAVE_BZIP2
#include "../../ThirdParty/minizip/mz_strm_bzip.c"
#endif
