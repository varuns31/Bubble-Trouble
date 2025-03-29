/*
 * text_mode_vga.c
 * Minimal driver for text mode VGA support
 *
 *  Created on: Jul 17, 2021
 *      Author: zuofu
 */

#include <system.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <alt_types.h>
#include "text_mode_vga_color.h"
#include "palette_test.h"


int main()
{
	while (1) {
//		textVGAColorScreenSaver();}
		paletteTest();}
	return 0;
}
