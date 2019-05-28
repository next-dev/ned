// Ned - Next Editor

// Common headers
#include <arch/zxn.h>
#include <intrinsic.h>
#include <ned.h>
#include <memory.h>

extern u8* testFile;

//
// Main entry point
//

int main()
{
    initVideo();

    u8 handle = arenaNew();
    BREAK;
    u8 page = arenaPageAlign(handle);
    arenaDone(handle);

    for(;;)
    {
        displayScreen();
    }

    return 0;
}

