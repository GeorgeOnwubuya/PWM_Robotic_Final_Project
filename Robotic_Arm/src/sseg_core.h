/*****************************************************************//**
 * @file sseg_core.h
 *
 * @brief Write 7-segment LED display.
 *
 * @author p chu
 * @version v1.0: initial release
 *********************************************************************/

#ifndef _SSEG_CORE_H_INCLUDED
#define _SSEG_CORE_H_INCLUDED

#include "chu_init.h"

/***********************************************
 *Seven Segment Core Driver
 **********************************************/

class SSEGCore {
public:

	enum {

		DISPLAY_REG = 0
	};

	enum {

		REFRESH_REG = 1
	};

	SSEGCore(uint32_t core_base_addr); //Constructor

	~SSEGCore(); //destructor

	void write_data_sseg(uint32_t data); //Function to write to SSEG

	void write_refresh_rate(uint16_t refresh_rate); //Function to write refresh rate

private:
	uint32_t base_addr;

};

#endif