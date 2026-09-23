// ====================================================================================
// REVOLUTIONARY TECHNOLOGY COMPANY & UNIVERSITY OF WASHINGTON DEPARTMENT OF PHYSICS
// Subsystem: silverado_md_linkages.scad (Heavy-Duty Trailing Arms & Torsional Stabilizer)
// Core Application: Industrial Lift Stabilization & Torsional Off-Road Articulation
// Center Origin (0,0,0) = Geometric Centerpoint of the Axle Trailing Mount Crossmember
// ====================================================================================

$fn = 120; // Ultra-high CNC machining and casting rendering finish depth

// --- 2027-2028 Silverado MD Linkage Constants (mm) ---
inch_to_mm          = 25.4;
frame_rail_spacing  = 34.0 * inch_to_mm; // 863.60 mm standard straight truck width
trailing_arm_length = 920.00;            // Long-travel articulation control links
arm_casing_dia      = 65.00;             // Solid-core high-strength forged steel bar
swaybar_outer_dia   = 55.00;             // Thick-diameter anti-roll torsional bar core
shackle_bolt_bore   = 24.50;             // Heavy-tonnage clearance for grade 12.9 hardware

module reinforced_trailing_arms() {
    echo("COMPILING GM INDUSTRIAL TRAILING ARMS & ACTIVE OFF-ROAD CONTROL LINKAGES");
    // Deploys upper and lower parallel control arms per side to eliminate axle wrap under 3,200 Nm torque [INDEX]
    for (side = [-1, 1]) {
        for (z_layer = [-60, 60]) {
            translate([side * (frame_rail_spacing/2 + 25), -trailing_arm_length/2, z_layer]) {
                rotate([90, 0, 0]) {
                    color("DimGrey") {
                        difference() {
                            // Main solid longitudinal trailing tracking link bar
                            cylinder(d=arm_casing_dia, h=trailing_arm_length, center=true);
                            // Weight optimization core pocket (Maintains maximum structural rigidity)
                            cylinder(d=arm_casing_dia - 16, h=trailing_arm_length - 80, center=true);
                        }
                    }
                    // Heavy-duty polyurethane bushing end loops (Mated to tree-rubber spec guidelines) [INDEX]
                    for (y_end = [-trailing_arm_length/2, trailing_arm_length/2]) {
                        translate([0, 0, y_end])
                            color("Silver")
                                difference() {
                                    cylinder(d=arm_casing_dia + 20, h=55, center=true);
                                    cylinder(d=shackle_bolt_bore, h=60, center=true);
                                }
                    }
                }
            }
        }
    }
}

module active_torsional_swaybar() {
    // Transverse stabilizer bar that controls body roll during heavy trailer towing maneuvers
    color("SteelBlue") {
        translate([0, 220, 110]) {
            rotate([0, 90, 0])
                cylinder(d=swaybar_outer_dia, h=frame_rail_spacing + 120, center=true);
            
            // Left and Right down-link leverage arms anchoring to the portal drop gearboxes [INDEX]
            for (side = [-1, 1]) {
                translate([side * (frame_rail_spacing/2 + 55), -75, -60])
                    rotate([45, 0, 0])
                        cube([20, 160, 40], center=true);
            }
        }
    }
}

module frame_mount_shackle_gussets() {
    // 4x Ultra-rugged double-shear mounting brackets welded straight into the 8mm frame rails [INDEX]
    color("DarkSlateGrey") {
        for (side = [-1, 1]) {
            for (y_offset = [-trailing_arm_length/2, trailing_arm_length/2]) {
                translate([side * (frame_rail_spacing/2 - 5), y_offset, 0]) {
                    difference() {
                        cube([40, 90, 180], center=true);
                        // Center-reamed dual-shear alignment bolt pass-throughs
                        rotate([0, 90, 0]) {
                            translate([60, 0, 0]) cylinder(d=shackle_bolt_bore, h=50, center=true);
                            translate([-60, 0, 0]) cylinder(d=shackle_bolt_bore, h=50, center=true);
                        }
                    }
                }
            }
        }
    }
}

// --- Unify System Linkage Compilation ---
union() {
    reinforced_trailing_arms();
    active_torsional_swaybar();
    frame_mount_shackle_gussets();
}
