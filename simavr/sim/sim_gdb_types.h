#ifndef AVR_GDB_H
#define AVR_GDB_H

#include <stdint.h>

#define WATCH_LIMIT (32)

typedef struct {
	uint32_t len; /**< How many points are taken (points[0] .. points[len - 1]). */
	struct {
		uint32_t addr; /**< Which address is watched. */
		uint32_t size; /**< How large is the watched segment. */
		uint32_t kind; /**< Bitmask of enum avr_gdb_watch_type values. */
	} points[WATCH_LIMIT];
} avr_gdb_watchpoints_t;

typedef struct avr_gdb_t {
	avr_t * avr;
	int	listen;	// listen socket
	int	s;	// current gdb connection

	avr_gdb_watchpoints_t breakpoints;
	avr_gdb_watchpoints_t watchpoints;

	// These are used by gdb's "info io_registers" command.

	uint16_t ior_base;
	uint8_t  ior_count, mad;
} avr_gdb_t;

#endif