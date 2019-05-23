// Video driver
#include <arch/zxn.h>

void initVideo()
{
    zx_border(INK_BLACK);
    zx_cls(INK_WHITE+PAPER_BLACK);
}
