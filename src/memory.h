//----------------------------------------------------------------------------------------------------------------------
// Memory management API
//----------------------------------------------------------------------------------------------------------------------

#pragma once

#include <ned.h>

//----------------------------------------------------------------------------------------------------------------------
// Arena API
//----------------------------------------------------------------------------------------------------------------------

// Creates a new arena.  An arena starts out as a single 8K block with the first few bytes holding the meta-data
// The initial bytes are as follows:
//
//      Offset  Size    Description
//      0       224     The pages that comprise this arena.
//      224     1       The number of pages in the arena
//      225     3       The current 24-bit address offset into the arena of the next allocation.
//      228             First free byte of arena
//
// Returns a handle.

u8 arenaNew() __preserves_regs(a,b,c,d,e,h) __z88dk_fastcall;

// Destroy an arena
void arenaDone(u8 handle) __preserves_regs(a,b,c,d,e,h,l) __z88dk_fastcall;

// Align to page - this means the next allocation will be at the start of an 8K buffer.
void arenaPageAlign(u8 handle);

// Allocate memory, expanding the arena by a page if necessary.  This will guarantee that an allocation will
// not cross an 8K page boundary.  Return a 24-bit virtual address.  The maximum allocation size is 8K.
u32 arenaAlloc(u8 handle, u16 size);

// Prepare an allocation by ensuring that the allocation is paged into MMU 6 ($c000-$dfff);
u8* arenaPrepare(u32 address);

