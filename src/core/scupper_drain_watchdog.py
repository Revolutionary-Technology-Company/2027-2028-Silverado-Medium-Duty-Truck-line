#!/usr/bin/env python3
# ==============================================================================
# REVOLUTIONARY TECHNOLOGY COMPANY & UNIVERSITY OF WASHINGTON DEPARTMENT OF PHYSICS
# Module: src/core/scupper_drain_watchdog.py (Aerospace Drainage Core Node)
# Core Framework: 16-State Hexadecimal Underbody Condensation Governor
// ==============================================================================

class RTScupperDrainWatchdog:
    def __init__(self):
        # Native 16 discrete voltage intervals mapping moisture saturation curves [INDEX]
        self.HEX_VOLTAGE_STAGES = [0.0, 0.0625, 0.125, 0.1875, 0.25, 0.3125, 0.375, 0.4375,
                                   0.5, 0.5625, 0.625, 0.6875, 0.75, 0.8125, 0.875, 1.0]
        self.CRITICAL_SATURATION_INDEX = 12 # 75% humidity threshold parameter before alert

    def map_humidity_voltage_to_hex(self, line_volts: float) -> int:
        """
        Bypasses binary communication delays by converting analog sensor tracks [INDEX]
        directly to the closest 16-state hexadecimal index value.
        """
        clamped_input = max(0.0, min(1.0, line_volts))
        closest_index = min(range(len(self.HEX_VOLTAGE_STAGES)),
                            key=lambda i: abs(self.HEX_VOLTAGE_STAGES[i] - clamped_input))
        return closest_index

    def audit_underbody_drainage(self, front_humidity_volts: float, rear_humidity_volts: float) -> dict:
        """
        Coordinates environmental weatherproofing variables across the 108-bit register loop.
        Triggers active evacuation blowers if condensation buildup loops [INDEX].
        """
        front_hex_idx = self.map_humidity_voltage_to_hex(front_humidity_volts)
        rear_hex_idx  = self.map_humidity_voltage_to_hex(rear_humidity_volts)
        
        max_active_index = max(front_hex_idx, rear_hex_idx)
        
        active_blowers_forced = False
        scupper_status_string = "UNDERBODY_ENVIRONMENT_DRY_NOMINAL"
        univac_status_code    = 0x000
        
        # Core environmental drainage verification rules
        if max_active_index >= self.CRITICAL_SATURATION_INDEX:
            # High condensation detected inside the vaults: fire active cooling fans to purge vapor [INDEX]
            active_blowers_forced = True
            scupper_status_string = "MOISTURE ACCUMULATION DETECTED: ENFORCING ACTIVE FAN EXHAUST PURGE"
            univac_status_code    = 0x1E4 # Specific thermal fan status display indicator code [INDEX]
            
        # Pack statistics inside the un-truncated 108-bit tracking system register configuration [INDEX]
        # Bits 72-107: Blower State | Bits 36-71: Moisture Indices | Bits 0-35: Alert Index
        blower_bit = 1 if active_blowers_forced else 0
        stacked_word = (blower_bit << 72) | (max_active_index << 36) | univac_status_code
        
        return {
            "FORCE_ACTIVE_BLOWERS": active_blowers_forced,
            "SCUPPER_SAFETY_LOG": scupper_status_string,
            "UNIVAC_IX_36BIT_WORD": f"0x{(stacked_word >> 72) & 0x7FFFFFFFF:09X}"
        }

if __name__ == "__main__":
    watchdog = RTScupperDrainWatchdog()
    print("=======================================================================")
    print("UNIVAC-IX SCUPPER DRAIN MONITOR ACTIVE (NORTHROP-GRUMMAN-GATE-IX)")
    print("=======================================================================")
    
    # Simulation: Humid operating conditions cause condensation inside the computing vault [INDEX]
    mock_front_volts = 0.2500  # Front chamber remains secure
    mock_rear_volts  = 0.7500  # Rear chamber saturation hits the 75% threshold parameter index [INDEX]
    
    drain_report = watchdog.audit_underbody_drainage(mock_front_volts, mock_rear_volts)
    print(f"[DATA SENSE] Front Vapor Index: {watchdog.map_humidity_voltage_to_hex(mock_front_volts)} | Rear Vapor Index: {watchdog.map_humidity_voltage_to_hex(mock_rear_volts)}")
    print(f"[SCUPPER AUDITOR STATUS]: {drain_report['SCUPPER_SAFETY_LOG']}")
    print(f"[FORCE FAN PURGE]: Actuate Silent Centrifugal Blowers: {drain_report['FORCE_ACTIVE_BLOWERS']}")
    print(f"[MAINFRAME PACKET STREAM]: Serializing Word: {drain_report['UNIVAC_IX_36BIT_WORD']}")
    print("=======================================================================")
