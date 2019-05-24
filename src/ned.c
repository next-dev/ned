// Ned - Next Editor

// Common headers
#include <arch/zxn.h>
#include <intrinsic.h>
#include <ned.h>


//
// Main entry point
//

int main()
{
    initVideo();

    for(;;)
    {
        if (KFlags & 1)
        {
            *(unsigned char *)0x4000 = Key;
            KFlags &= ~1;
        }
    }
    return 0;
}

