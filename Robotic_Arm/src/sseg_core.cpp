/*****************************************************************//**
 * @file sseg_core.cpp
 *
 * @brief implementation of SsegCore class
 *
 * @author p chu
 * @version v1.0: initial release
 ********************************************************************/

#include "sseg_core.h"
#include "chu_io_rw.h"

SSEGCore::SSEGCore(uint32_t core_base_addr) {
		base_addr = core_base_addr;
}

SSEGCore::~SSEGCore() {

}

void SSEGCore::write_data_sseg(uint32_t data) {

	io_write(base_addr, DISPLAY_REG, data);
}

void SSEGCore::write_refresh_rate(uint16_t refresh_rate) {

	io_write(base_addr, REFRESH_REG, refresh_rate);
}


