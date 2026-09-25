#!/usr/bin/env python3
# ==============================================================================
# REVOLUTIONARY TECHNOLOGY COMPANY & UNIVERSITY OF WASHINGTON DEPARTMENT OF PHYSICS
# Module: src/core/fleet_long_wheelbase_mux.py (165" Long-Wheelbase Proportions Router)
# ==============================================================================

class RTLongWheelbaseMuxAdapter:
    def __init__(self):
        #Teletank register bit assignments mapping structural proportion flags [INDEX]
        self.REG_BIT_EXT_CAB    = 0x00010000  # Bit 16 - Extended cockpit footprint active [INDEX]
        self.REG_BIT_SHORT_BED  = 0x00020000  # Bit 17 - 6.5ft cargo upfit bed active [INDEX]
        self.REG_BIT_LONG_FRAME = 0x00040000  # Bit 18 - Original 165" frame rails confirmed [INDEX]

    def configure_reapportioned_chassis(self, frame_inch: float, bed_feet: float) -> dict:
        """
        Calibrates the active torque vectoring and air-hydraulic leveling pressure metrics [INDEX]
        to account for the mid-chassis utility gap center-of-gravity distribution.
        """
        active_bitmask = 0x00
        chassis_log_msg = "CHASSIS_GEOMETRY_UNKNOWN_PRESET"
        load_distribution_ratio = 40.60 # Default static split percentage (Front/Rear balance)
        
        if frame_inch == 165.0 and bed_feet == 6.5:
            active_bitmask |= (self.REG_BIT_EXT_CAB | self.REG_BIT_SHORT_BED | self.REG_BIT_LONG_FRAME)
            chassis_log_msg = "GEOSPATIAL STAGING LOCKED: EXTENDED CAB / SHORT BED ON ORIGINAL 165\" MATRIX"
            load_distribution_ratio = 52.40 # Shifts static weight forward due to cab length and short bed [INDEX]
            
        # Pack data into the un-truncated 108-bit register mask representation [INDEX]
        # Bits 72-107: Load Split | Bits 36-71: Bitmask Configuration | Bits 0-35: Alert Index
        stacked_word = (int(load_distribution_ratio * 100) << 72) | (active_bitmask << 36) | 0x0A3
        
        return {
            "GEOMETRY_STATUS_STRING": chassis_log_msg,
            "FRONT_AXLE_WEIGHT_BIAS_PCT": load_distribution_ratio,
            "UNIVAC_IX_36BIT_WORD": f"0x{(stacked_word >> 72) & 0x7FFFFFFFF:09X}"
        }

if __name__ == "__main__":
    adapter = RTLongWheelbaseMuxAdapter()
    print("=======================================================================")
    print("UNIVAC-IX 165\" RE-APPORTIONED CHASSIS MATRIX RUNNING (LONG-PROPORTION-IX)")
    print("=======================================================================")
    
    # Simulation: Core boot system polls the active structural proportion configurations
    measured_frame = 165.0
    measured_bed   = 6.5
    
    config_report = adapter.configure_reapportioned_chassis(measured_frame, measured_bed)
    print(f"[ASSEMBLY DATA] Frame Length: {measured_frame}\" | Cargo Bed Length: {measured_bed} Feet")
    print(f"[PROPORTIONS LOG]: {config_report['GEOMETRY_STATUS_STRING']}")
    print(f"[DYNAMIC MATRIX] Setting Front Axle Weight Bias To: {config_report['FRONT_AXLE_WEIGHT_BIAS_PCT']}%")
    print(f"[MAINFRAME PACKET STREAM]: Serializing Word: {config_report['UNIVAC_IX_36BIT_WORD']}")
    print("=======================================================================")
