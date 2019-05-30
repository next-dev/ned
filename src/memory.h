//----------------------------------------------------------------------------------------------------------------------
// Memory management API
//----------------------------------------------------------------------------------------------------------------------

#pragma once

#include "ned.h"

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
//
// Full "addresses" are 24-bit (despite u32 being used) and take the following form:
//
//      PPPPPPPP 000AAAAA AAAAAAAA
//
//      P = page
//      A = offset into page
//
// If you AND $e0 with the second byte and ZF is not set, you have an overflow.

u8 arenaNew() __preserves_regs(a,b,c,d,e,h) __z88dk_fastcall;

// Destroy an arena
void arenaDone(u8 handle) __preserves_regs(a,b,c,d,e,h,l) __z88dk_fastcall;

// Align to page - this means the next allocation will be at the start of an 8K buffer.
// Will return the page of the new address.  Also the new page will be paged into MMU-6.
u8 arenaPageAlign(u8 handle) __preserves_regs(a,b,c,d,e,h) __z88dk_fastcall;

// Allocate memory, expanding the arena by a page if necessary.  This will guarantee that an allocation will
// not cross an 8K page boundary.  Return a 24-bit virtual address.  The maximum allocation size is 8K.
u32 arenaAlloc(u8 handle, u16 size) __preserves_regs(a,b,c) __z88dk_callee;

// Prepare an allocation by ensuring that the allocation is paged into MMU 6 ($c000-$dfff);
u8* arenaPrepare(u32 address) __preserves_regs(a,b,c) __z88dk_fastcall;

