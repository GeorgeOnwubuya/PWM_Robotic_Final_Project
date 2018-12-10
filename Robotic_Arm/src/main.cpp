/*
 * Empty C++ Application
 */
#include "chu_init.h"
#include "sseg_core.h"
#include "gpio_cores.h"
#include "chu_io_rw.h"
#include "timer_core.h"

uint32_t switches(SSEGCore *sseg, SSEGCore *ref_rate, GpiCore *sw){

	uint32_t sw_detect;
	sw_detect = sw -> read_sw();
	sseg -> write_data_sseg(sw_detect);
	ref_rate -> write_refresh_rate(1);
	return sw_detect;
}

int ld_button(GpiCore *btn){

	int btn_press;
	btn_press = btn -> read_btn(1);
	return btn_press;
}

int run_button(GpiCore *btn){

	int btn_press;
	btn_press = btn -> read_btn(0);
	return btn_press;
}

void pwm(PwmCore *pwm_p, uint32_t duty_hex){

	double duty;
	const double P20 =1.2589; //P20 = 100^(1/20)
	pwm_p -> set_freq(50);
	duty_hex = duty_hex * P20;;
	duty = duty_hex/100.0;
	pwm_p -> set_duty(duty,0);

}

void pwm_1(PwmCore *pwm_p, uint32_t duty_hex){

	double duty;
	const double P20 =1.2589; //P20 = 100^(1/20)
	pwm_p -> set_freq(50);
	duty_hex = duty_hex * P20;;
	duty = duty_hex/100.0;
	pwm_p -> set_duty(duty,1);
}

//Instantiate SSEG, switches, buttons, timer core and pwm
GpiCore sw(get_slot_addr(BRIDGE_BASE, S3_SW));
SSEGCore sseg(get_slot_addr(BRIDGE_BASE, S8_SSEG));
SSEGCore ref_rate(get_slot_addr(BRIDGE_BASE, S8_SSEG));
PwmCore pwm_p(get_slot_addr(BRIDGE_BASE, S6_PWM));
GpiCore btn(get_slot_addr(BRIDGE_BASE, S7_BTN));

//TimerCore

int main()
{
	int curr_btn_val = ld_button(&btn);
	int prev_btn_val = 0;

	int curr_btn_val_run = run_button(&btn);
	int prev_btn_val_run = 0;

	bool ld_val = false;
	bool run_val = false;

	uint8_t ld_count = 0;
	uint8_t run_count = 0;

	uint32_t duty_array[3];


	while(1){

		uint32_t duty_sw = switches(&sseg, &ref_rate, &sw);
		uint32_t duty_sw_1 = switches(&sseg, &ref_rate, &sw);

		pwm(&pwm_p, duty_sw);
		pwm_1(&pwm_p,duty_sw_1);

		prev_btn_val = curr_btn_val;
		curr_btn_val = ld_button(&btn);

		if((prev_btn_val == 0) && (curr_btn_val == 1)){

			ld_val = true;
		}

			if(ld_val){

				if (ld_count < 3){

					duty_array[ld_count] = duty_sw;
					duty_array[ld_count] = duty_sw_1;
					pwm(&pwm_p, duty_array[ld_count]);
					pwm_1(&pwm_p, duty_array[ld_count]);
					ld_count++;
				}

				if(ld_count >= 3){

					ld_count = 0;
				}
				ld_val = false;
			}


		prev_btn_val_run = curr_btn_val_run;
		curr_btn_val_run = run_button(&btn);

		if((prev_btn_val_run == 0) && (curr_btn_val_run == 1)){

			run_val = true;
		}

			if(run_val){

				while(run_count < 3){

					pwm(&pwm_p, duty_array[run_count]);
					pwm_1(&pwm_p, duty_array[run_count]);
					run_count++;
					sleep_ms(1000);
				}

				run_count = 0;
				run_val = false;

			}
	}
}
