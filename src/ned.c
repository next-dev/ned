// Ned - Next Editor

// Common headers
#include <arch/zxn.h>
#include <intrinsic.h>

// Video API
void initVideo();
void initKeys();

int main()
{
    initVideo();
    initKeys();

    for(;;);
    return 0;
}

