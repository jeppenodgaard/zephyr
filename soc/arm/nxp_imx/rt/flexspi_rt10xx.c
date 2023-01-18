/*
 * Copyright (c) 2023, NXP
 *
 * SPDX-License-Identifier: Apache-2.0
 */

#include <fsl_clock.h>
#include <soc.h>

void flexspi_clock_set_div(uint32_t value)
{
	CLOCK_DisableClock(kCLOCK_FlexSpi);

	CLOCK_SetDiv(kCLOCK_FlexspiDiv, value);

	CLOCK_EnableClock(kCLOCK_FlexSpi);
}

inline uint32_t flexspi_clock_get_freq(void)
{
	uint32_t divider;
	uint32_t frequency;

	divider = CLOCK_GetDiv(kCLOCK_FlexspiDiv);

	frequency = CLOCK_GetFreq(kCLOCK_Usb1PllPfd0Clk) / (divider + 0x01U);

	return frequency;
}
