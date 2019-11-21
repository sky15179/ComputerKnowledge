//
//  MYP_C_Config.h
//  SocketConnet
//
//  Created by 王智刚 on 2018/11/15.
//  Copyright © 2018 王智刚. All rights reserved.
//

#ifndef MYP_C_Config_h
#define MYP_C_Config_h

#include <stdio.h>

/* Miscellaneous constants */
#define    MAXLINE        4096    /* max text line length */
#define    BUFFSIZE    8192    /* buffer size for reads and writes */

/* Define some port number that can be used for our examples */
#define    SERV_PORT         9877            /* TCP and UDP */
#define    SERV_PORT_STR    "9877"            /* TCP and UDP */
#define    UNIXSTR_PATH    "/tmp/unix.str"    /* Unix domain stream */
#define    UNIXDG_PATH        "/tmp/unix.dg"    /* Unix domain datagram */

#endif //MYP_C_Config_h
