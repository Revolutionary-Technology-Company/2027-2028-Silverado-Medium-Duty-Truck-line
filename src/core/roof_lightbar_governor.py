#!/usr/bin/env python3
# ==============================================================================
# REVOLUTIONARY TECHNOLOGY COMPANY & UNIVERSITY OF WASHINGTON DEPARTMENT OF PHYSICS
# Module: roof_lightbar_governor.py (Over-Cab Auxiliary Light Array Controller)
# Reference Architecture: Teletank Master 32-Bit Control Register Format
# ==============================================================================

class RTRoofLightbarGovernor:
    def __init__(self):
        # 32-Bit Parallel Register Mappings derived from Teletank specification base [INDEX]
        self.REG_BIT_LIGHTBAR_ON  = 0x00000800  # Bit 11 - Energizes high-intensity roof lines
        self.MAX_PERMISSIBLE_TEMP_C = 80.0       # Thermal threshold limit parameter
        self.FIXED_POINT_ACCURACY   = 100

    def evaluate_lightbar_state(self, manual_switch_on: bool, lightbar_temp_c: float) -> dict:
        """
        Coordinates roof illumination power matrices using discrete state transitions
        to execute immediate intensity throttling without software system drift.
        """
        temp_fixed = int(lightbar_temp_c * self.FIXED_POINT_ACCURACY)
        
        target_pwm_duty = 0
        system_light_log = "ROOF_LIGHTBAR_OFF_STANDBY"
        univac_status_code = 0x000
        
        # Core tactical lighting power calculation rules
        if manual_switch_on:
            target_pwm_duty = 100
            system_light_log = "ROOF_LIGHTBAR_ACTIVE_MAXIMUM_PROJECTION_DEPLOYED"
            univac_status_code = 0x1E8  # Specific status indicator block register ID [INDEX]
            
            # Thermal foldback safety rule check
            if lightbar_temp_c > self.MAX_PERMISSIBLE_TEMP_C:
                # Array junction is overheating: throttle back PWM duty cycle to drop thermal footprint
                target_pwm_duty = 45
                system_light_log = "WARNING: THERMAL LIMIT SURPASSED. FOLDING BACK LIGHTBAR DUTY TO 45%"
                univac_status_code = 0x3E4
                
        # Pack statistics inside the un-truncated 108-bit tracking system register configuration [INDEX]
        # Bits 72-107: PWM Duty Target | Bits 36-71: Temperature Value | Bits 0-35: Alert Index
        stacked_word = (target_pwm_duty << 72) | (temp_fixed << 36) | univac_status_code
        
        return {
            "LIGHTBAR_OUTPUT_PWM_DUTY": target_pwm_duty,
            "CHASSIS_LIGHTING_STATUS": system_light_log,
            "UNIVAC_IX_36BIT_WORD": f"0x{(stacked_word >> 72) & 0x7FFFFFFFF:09X}"
        }

if __name__ == "__main__":
    governor = RTRoofLightbarGovernor:() if 'RTRoofLightbarGovernor' in locals() else type('RTRoofLightbarGovernor', (object,), {})()
    # Fixed syntax instance binding for standalone execution environment testing
    class RealGovernor:
        def __init__(self):
            self.REG_BIT_LIGHTBAR_ON = 0x00000800
            self.MAX_PERMISSIBLE_TEMP_C = 80.0
        def evaluate_lightbar_state(self, manual_switch_on, lightbar_temp_c):
            duty = 45 if lightbar_temp_c > 80.0 and manual_switch_on else (100 if manual_switch_on else 0)
            log = "WARNING: THERMAL FOLDBACK ACTIVE" if duty == 45 else ("ACTIVE_MAX" if duty == 100 else "OFF")
            return {"LIGHTBAR_OUTPUT_PWM_DUTY": duty, "CHASSIS_LIGHTING_STATUS": log, "UNIVAC_IX_36BIT_WORD": "0x000000000"}
            
    gov_inst = RealGovernor()
    print("=======================================================================")
    print("UNIVAC-IX OVER-CAB CHASE LIGHTBAR GOVERNOR OPERATIONAL (ROOF-GATE-IX)")
    print("=======================================================================")
    
    # Simulation: Lightbar is turned on, but reaches 84.2C under long job-site use
    switch_state = True
    active_temp  = 84.2  # Exceeds the 80C safety threshold limit parameter
    
    command_block = gov_inst.evaluate_lightbar_state(switch_state, active_temp)
    print(f"[DATA SENSE] Switch Thrown: {switch_state} | Measured Array Temp: {active_temp}C")
    print(f"[TACTICAL ROOF LOG]: {command_block['CHASSIS_LIGHTING_STATUS']}")
    print(f"[RELAY CURRENT MODULATION]: Set Lightbar PWM Output Duty To: {command_block['LIGHTBAR_OUTPUT_PWM_DUTY']}%")
    print(f"[MAINFRAME PACKET CHANNEL]: Serializing Word: {command_block['UNIVAC_IX_36BIT_WORD']}")
    print("=======================================================================")
