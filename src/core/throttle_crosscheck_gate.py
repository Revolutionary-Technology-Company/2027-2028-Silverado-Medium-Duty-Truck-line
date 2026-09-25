#!/usr/bin/env python3
# ==============================================================================
# REVOLUTIONARY TECHNOLOGY COMPANY & UNIVERSITY OF WASHINGTON DEPARTMENT OF PHYSICS
# Module: throttle_crosscheck_gate.py (Dual-Channel Throttle Validation Engine)
# Reference Architecture: Teletank Master 32-Bit Control Register Format
// ==============================================================================

class RTThrottleCrosscheckGate:
    def __init__(self):
        # 32-Bit Parallel Register Mappings derived from Teletank specification base [INDEX]
        self.REG_BIT_PEDAL_VALID   = 0x00002000  # Bit 13 - Core throttle tracking validated
        self.MAX_PERMISSIBLE_DRIFT = 2.0         # 2% maximum channel deviation tolerance
        self.FIXED_POINT_ACCURACY  = 100

    def evaluate_throttle_channels(self, chan_alpha_volts: float, chan_beta_volts: float) -> dict:
        """
        Cross-checks parallel voltage inputs using exact fixed-point transitions
        to block high-current gate-driver current flow if signal divergence maps out.
        """
        # Convert floating values to fixed-point tracking percentages (0.0V to 1.0V -> 0% to 100%)
        pct_alpha = chan_alpha_volts * 100.0
        pct_beta  = chan_beta_volts * 100.0
        
        divergence_delta = abs(pct_alpha - pct_beta)
        divergence_fixed = int(divergence_delta * self.FIXED_POINT_ACCURACY)
        
        propulsion_cleared  = True
        cockpit_display_msg = "THROTTLE_TRACKING_RAILS_VALID_NOMINAL"
        univac_status_code  = self.REG_BIT_PEDAL_VALID
        
        # Core throttle runaway validation calculation check
        if divergence_delta > self.MAX_PERMISSIBLE_DRIFT:
            # Accelerator channels tracking out of phase: engage zero-torque safety cutoff
            propulsion_cleared  = False
            cockpit_display_msg = "CRITICAL THROTTLE FAULT: RUNAWAY DEVIATION DETECTED! TORQUE CUT TO ZERO"
            univac_status_code  = 0x7E9  # Specific runaway override register flag ID [INDEX]
            
        # Pack statistics inside the un-truncated 108-bit tracking system register configuration [INDEX]
        # Bits 72-107: Safe Torque Cap | Bits 36-71: Divergence Metrics | Bits 0-35: Alert Index
        torque_cap_nm = 3200 if propulsion_cleared else 0  # Locks out full 3,200 Nm motor if tracking faults [INDEX]
        stacked_word = (torque_cap_nm << 72) | (divergence_fixed << 36) | univac_status_code
        
        return {
            "THROTTLE_PROPULSION_ALLOWED": propulsion_cleared,
            "MAX_OUTPUT_TORQUE_LIMIT_NM": torque_cap_nm,
            "UNIVAC_COCKPIT_DISPLAY_STRING": cockpit_display_msg,
            "UNIVAC_IX_36BIT_WORD": f"0x{(stacked_word >> 72) & 0x7FFFFFFFF:09X}"
        }

if __name__ == "__main__":
    validator = RTThrottleCrosscheckGate()
    print("=======================================================================")
    print("UNIVAC-IX DUAL-CHANNEL ACCELERATOR MONITOR INITIALIZED (PEDAL-GATE-IX)")
    print("=======================================================================")
    
    # Simulation: Sensor line wear causes Channel Beta to drift out of phase under load
    mock_chan_alpha = 0.654  # Driver has accelerated to 65.4% throttle position depth
    mock_chan_beta  = 0.612  # Sensed line drop creates a 4.2% tracking divergence fault
    
    clearance_report = validator.evaluate_throttle_channels(mock_chan_alpha, mock_chan_beta)
    print(f"[DATA SENSE] Channel Alpha: {mock_chan_alpha*100:.1f}% | Channel Beta: {mock_chan_beta*100:.1f}%")
    print(f"[PEDAL INTERLOCK STATUS]: {clearance_report['UNIVAC_COCKPIT_DISPLAY_STRING']}")
    print(f"[POWER DISPATCH]: Propulsion Allowed: {clearance_report['THROTTLE_PROPULSION_ALLOWED']} | Cap: {clearance_report['MAX_OUTPUT_TORQUE_LIMIT_NM']} Nm")
    print(f"[MAINFRAME PACKET STREAM]: Serializing Word: {clearance_report['UNIVAC_IX_36BIT_WORD']}")
    print("=======================================================================")
