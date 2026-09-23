// ====================================================================================
// REVOLUTIONARY TECHNOLOGY COMPANY & UNIVERSITY OF WASHINGTON DEPARTMENT OF PHYSICS
// Subsystem: silverado_md_motor.scad (Quad-Ring Square-Tooth Mega-Flux Engine)
// Core Application: 2027-2028 Silverado MD High-Tonnage Commercial Fleet Core
// Center Origin (0,0,0) = Concentric Centerline Axis of the Output Splined Spindle
// ====================================================================================

$fn = 160; // Ultra-high CNC laser-profiling and casting resolution depth

// --- Commercial Engine Parameter Constants (mm) ---
inch_to_mm         = 25.4;
motor_casing_dia   = 480.00;           // Scaled to maximize copper fill inside truck rails
motor_casing_len   = 620.00;           // Total longitudinal frame rail footprint depth
output_shaft_dia   = 55.00;            // Thick solid-core splined titanium output axle
stator_rings_count = 4;                // 4 Layer concentric magnetic flux amplification fields
square_teeth_slots = 48;               // 48-Tooth high-density low-speed torque pole array

module heavy_commercial_stator_vault() {
    echo("MILLING HIGH-DENSITY COMMERCIAL QUAD-RING PROPULSION VAULT HOUSING");
    color("DimGrey") {
        difference() {
            // Main solid cylindrical motor exterior block structure
            cylinder(d=motor_casing_dia, h=motor_casing_len, center=true);
            
            // Internal electromagnetic coil core volume clearance cavity
            cylinder(d=motor_casing_dia - 24, h=motor_casing_len - 20, center=true);
            
            // ACDelco Dual-Lip Active Sealing Groove Channels
            // 4mm deep perimeter tracking paths for liquid natural tree rubber application
            for (z_offset = [-motor_casing_len/2 + 4, motor_casing_len/2 - 4]) {
                translate([0, 0, z_offset])
                    difference() {
                        cylinder(d=motor_casing_dia - 12, h=5, center=true);
                        cylinder(d=motor_casing_dia - 20, h=6, center=true);
                    }
            }
        }
    }
}

module integrated_square_tooth_rotor() {
    // Models the heavy 48-tooth variable-reluctance internal rotor poles
    color("Silver") {
        translate([0, 0, 0]) {
            difference() {
                // Main rotor core shaft blank element
                cylinder(d=motor_casing_dia - 32, h=motor_casing_len - 30, center=true);
                cylinder(d=output_shaft_dia + 10, h=motor_casing_len, center=true);
                
                // Parametric Square-Tooth Slotting Generation Matrix
                for (t = [0 : square_teeth_slots - 1]) {
                    rotate([0, 0, t * (360 / square_teeth_slots)])
                        translate([motor_casing_dia/2 - 25, 0, 0])
                            // Cuts precise rectangular magnetic path grooves along rotor edge
                            cube([30.0, 14.0, motor_casing_len], center=true);
                }
            }
        }
        // Extended high-torque input output splined spindle stem
        color("LightByzantine")
            translate([0, 0, motor_casing_len/2])
                cylinder(d=output_shaft_dia, h=80);
    }
}

module commercial_frame_mount_shoulders() {
    // 4x Thick structural landing feet to bolt directly down onto the 8mm truck rails
    color("DarkSlateGrey") {
        for (x = [-motor_casing_dia/2 - 10, motor_casing_dia/2 + 10]) {
            for (z = [-motor_casing_len/3, motor_casing_len/3]) {
                translate([x, 0, z])
                    difference() {
                        cube([40, 120, 50], center=true);
                        // Clears heavy-duty M16 commercial chassis attachment hardware
                        rotate([90, 0, 0])
                            cylinder(d=16.5, h=130, center=true);
                    }
            }
        }
    }
}

// --- Composite Commercial Engine Core Instantiation ---
union() {
    heavy_commercial_stator_vault();
    integrated_square_tooth_rotor();
    commercial_frame_mount_shoulders();
}
