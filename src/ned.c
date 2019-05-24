// Ned - Next Editor

// Common headers
#include <arch/zxn.h>
#include <intrinsic.h>

// Keyboard
extern unsigned char Key;
extern unsigned char KFlags;
extern unsigned short Counter;

// Video API
void initVideo();

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

