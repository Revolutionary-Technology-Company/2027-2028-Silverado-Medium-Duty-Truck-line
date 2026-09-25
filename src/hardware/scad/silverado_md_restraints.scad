// ====================================================================================
// REVOLUTIONARY TECHNOLOGY COMPANY & UNIVERSITY OF WASHINGTON DEPARTMENT OF PHYSICS
// Subsystem: silverado_md_restraints.scad (Tactical Harness & Worker Anchors)
// Core Application: 2027-2028 Silverado MD 5-Point Cam Buckles & Fall-Protection D-Rings
// Center Origin (0,0,0) = Geometric Centerpoint of the Central Cam-Lock Release Hub
// ====================================================================================

$fn = 120; // High-fidelity CNC machining and forging resolution

// --- Restraint System Selector ---
// 1 = Tactical 5-Point Racing Harness, 2 = Heavy Industrial Worker Fall-Protection Shackle
RESTRAINT_SYSTEM_MODE = 1;

// --- Geometric Component Constants (mm) ---
inch_to_mm         = 25.4;
cam_buckle_dia     = 70.00;            // Magnesium center rotary release knob
webbing_width      = 3.0 * inch_to_mm; // 76.2 mm aviation-strength shoulder belts
d_ring_inner_dia   = 50.00;            // Industrial OSHA-compliant harness latch hoop
plate_thickness    = 12.50;            // 1/2" Thick anchor foot matching cabin armor [INDEX]

module central_rotary_cam_lock() {
    echo(str("COMPILING SILVERADO MD PASSENGER RESTRAINTS: ", (RESTRAINT_SYSTEM_MODE == 1) ? "5_POINT_TACTICAL_CAM_HARNESS" : "INDUSTRIAL_FALL_PROTECTION_SHACKLE"));
    if (RESTRAINT_SYSTEM_MODE == 1) {
        color("Silver") {
            difference() {
                // Main circular buckle block
                cylinder(d=cam_buckle_dia, h=28, center=true);
                // Center-reamed structural latch release mechanism pin
                cylinder(d=22.0, h=32, center=true);
            }
        }
        // 5x Radially flanged seat belt buckle tongue inserts slipping into center hub
        color("Black") {
            for (a = [0 : 72 : 288]) {
                rotate([0, 0, a])
                    translate([cam_buckle_dia/2 + 10, 0, 0])
                        cube([32, webbing_width + 8, 8], center=true);
            }
        }
    }
}

module industrial_worker_dring_anchor() {
    // Forged heavy-tonnage lanyard shackle anchoring straight into the Titanium B-pillars [INDEX]
    if (RESTRAINT_SYSTEM_MODE == 2) {
        // Base plate mating flush onto the 12.5mm armored cab wall skeleton [INDEX]
        color("DimGrey") {
            translate([0, 0, -plate_thickness/2])
                difference() {
                    cube([120, 80, plate_thickness], center=true);
                    // Dual Grade 12.9 high-tensile frame attachment borehole ports [INDEX]
                    translate([-35, 0, 0]) cylinder(d=14.5, h=25, center=true);
                    translate([35, 0, 0])  cylinder(d=14.5, h=25, center=true);
                }
        }
        // Forged D-Ring loop projecting out into the cabin workspace for lanyard clipping
        color("Silver") {
            translate([0, 0, d_ring_inner_dia/2])
                rotate([90, 0, 0])
                    difference() {
                        cylinder(d=d_ring_inner_dia + 24, h=22, center=true);
                        cylinder(d=d_ring_inner_dia, h=26, center=true); // Clear attachment eyelet
                    }
        }
    }
}

// --- Composite Restraint System Instantiation ---
union() {
    central_rotary_cam_lock();
    industrial_worker_dring_anchor();
}
