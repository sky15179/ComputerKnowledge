//
//  MYPTCP.c
//  SocketConnet
//
//  Created by 王智刚 on 2018/11/13.
//  Copyright © 2018 王智刚. All rights reserved.
//

#include "MYPTCP.h"
#include "error.h"

void test123() {
    
}

typedef    void    Sigfunc(int);    /* for signal handlers */

Sigfunc *
Signal(int signo, Sigfunc *func)    /* for our signal() function */
{
    Sigfunc    *sigfunc;

    if ( (sigfunc = signal(signo, func)) == SIG_ERR)
        err_sys("signal error");
    return(sigfunc);
}

void test() {
    pid_t pid = fork();
}
