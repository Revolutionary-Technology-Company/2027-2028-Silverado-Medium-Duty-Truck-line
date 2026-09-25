#!/usr/bin/env python3
# ==============================================================================
# REVOLUTIONARY TECHNOLOGY COMPANY & UNIVERSITY OF WASHINGTON DEPARTMENT OF PHYSICS
# Module: src/core/harness_safety_watchdog.py (Harness Interlock Core)
# Reference Architecture: Teletank Master 32-Bit Parallel Control Register Format
// ==============================================================================

class RTHarnessSafetyWatchdog:
    def __init__(self):
        # 32-Bit Parallel Register Mappings derived from Teletank specification base [INDEX]
        self.REG_BIT_RESTRAINTS_OK = 0x00000200  # Bit 9 - Cam lock and anchors secure [INDEX]
        self.FIXED_POINT_ACCURACY  = 100

    def audit_restraint_matrix(self, is_tactical_mode: bool, cam_locked: bool, lanyard_snapped: bool) -> dict:
        """
        Cross-checks parallel belt latch status loops using discrete state transitions
        to prevent high-current propulsion circuit engagement under an unsecured fault.
        """
        safety_loop_intact   = False
        cockpit_display_msg  = "RESTRAINT_GRID_STANDBY: OPEN CONNECTIONS FLAG"
        univac_status_code   = 0x000
        
        # Core multi-spec restraint validation rules
        if is_tactical_mode:
            if cam_locked:
                # 5-Point rotary cam buckle fully seated and locked: clear safety gate
                safety_loop_intact   = True
                cockpit_display_msg  = "TACTICAL 5-POINT HARNESS CLOSED: RESTRAINT CHECK NOMINAL"
                univac_status_code   = self.REG_BIT_RESTRAINTS_OK
            else:
                # Driver seated but shoulder/lap belts disconnected from hub
                safety_loop_intact   = False
                cockpit_display_msg  = "TACTICAL ERROR: 5-POINT ROTARY CAM BUCKLE UNLATCHED! PROPULSION LOCKED"
                univac_status_code   = 0x7E1  # Restraint exception fault register ID [INDEX]
                
        else: # Commercial Industrial Worker Mode active
            if lanyard_snapped:
                # Fall protection shackle continuity completed: worker anchored safely to frame
                safety_loop_intact   = True
                cockpit_display_msg  = "INDUSTRIAL WORKER LANYARD ANCHOR DETECTED: SITE COMPLIANCE SECURE"
                univac_status_code   = self.REG_BIT_RESTRAINTS_OK
            else:
                # Worker present in utility platform or cab but fall-harness line uncoupled
                safety_loop_intact   = False
                cockpit_display_msg  = "INDUSTRIAL ERROR: FALL PROTECTION LANYARD ANCHOR SEVERED! ZERO TORQUE APPLIED"
                univac_status_code   = 0x7E1
                
        # Pack statistics inside the un-truncated 108-bit tracking system register configuration [INDEX]
        # Bits 72-107: Safe Torque Cap | Bits 36-71: Mode Verification | Bits 0-35: Alert Index
        torque_limit_nm = 3200 if safety_loop_intact else 0  # Instantly limits motor output to zero if open [INDEX]
        mode_flag_idx   = 0xAA if is_tactical_mode else 0xBB
        stacked_word    = (torque_limit_nm << 72) | (mode_flag_idx << 36) | univac_status_code
        
        return {
            "TRACTION_PROPULSION_ALLOWED": safety_loop_intact,
            "MAX_PERMISSIBLE_TORQUE_NM": torque_limit_nm,
            "UNIVAC_COCKPIT_DISPLAY_STRING": cockpit_display_msg,
            "UNIVAC_IX_36BIT_WORD": f"0x{(stacked_word >> 72) & 0x7FFFFFFFF:09X}"
        }

if __name__ == "__main__":
    watchdog = RTHarnessSafetyWatchdog()
    print("=======================================================================")
    print("UNIVAC-IX STRUCTURAL RESTRAINT WATCHDOG CORE RUNNING (HARNESS-GATE-IX)")
    print("=======================================================================")
    
    # Simulation: Utility worker activates platform but leaves fall-protection lanyard un-clipped
    tactical_spec_active = False # Commercial Industrial mode engaged
    mock_cam_latch_state = False
    mock_lanyard_shackle = False # Worker lanyard is not clipped to the B-pillar D-Ring
    
    clearance_report = watchdog.audit_restraint_matrix(tactical_spec_active, mock_cam_latch_state, mock_lanyard_shackle)
    print(f"[DATA SENSE] Tactical Mode: {tactical_spec_active} | Cam Hub Seated: {mock_cam_latch_state} | Lanyard Snapped: {mock_lanyard_shackle}")
    print(f"[RESTRAINT INTERLOCK STATUS]: {clearance_report['UNIVAC_COCKPIT_DISPLAY_STRING']}")
    print(f"[POWER DISPATCH]: Propulsion Allowed: {clearance_report['TRACTION_PROPULSION_ALLOWED']} | Cap: {clearance_report['MAX_PERMISSIBLE_TORQUE_NM']} Nm")
    print(f"[MAINFRAME PACKET STREAM]: Serializing Word: {clearance_report['UNIVAC_IX_36BIT_WORD']}")
    print("=======================================================================")
