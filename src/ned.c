// Ned - Next Editor

// Common headers
#include <arch/zxn.h>
#include <intrinsic.h>
#include "ned.h"
#include "memory.h"

extern u8* testFile;

//
// Main entry point
//

int main()
{
    u8 handle;
    u32 p1, p2;
    u8 *a1, *a2;

    initVideo();

    handle = arenaNew();
    BREAK;
    p1 = arenaAlloc(handle, 8000);
    p2 = arenaAlloc(handle, 8000);

    BREAK;
    a1 = arenaPrepare(p1);
    display16(0, 0, (u16)a1, 0);
    BREAK;
    a2 = arenaPrepare(p2);
    display16(0, 1, (u16)a2, 0);
    BREAK;

    arenaDone(handle);

    for(;;)
    {
        //displayScreen();
    }
}

