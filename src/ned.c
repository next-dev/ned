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

    BREAK;
    u8 handle = arenaNew();
    arenaDone(handle);

    for(;;)
    {
        displayScreen();
    }

    return 0;
}

