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
    u32 p = arenaAlloc(handle, 8192-229);
    display32(0, 0, p, 0);
    arenaDone(handle);

    for(;;)
    {
        //displayScreen();
    }
}

