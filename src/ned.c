// Ned - Next Editor

// Common headers
#include <arch/zxn.h>
#include <intrinsic.h>

// Video API
void initVideo();
void initKeys();
void test();

int main()
{
    initVideo();
    initKeys();
    test();

    return 0;
}

