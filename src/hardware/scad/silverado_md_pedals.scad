// ====================================================================================
// REVOLUTIONARY TECHNOLOGY COMPANY & UNIVERSITY OF WASHINGTON DEPARTMENT OF PHYSICS
// Subsystem: silverado_md_pedals.scad (Parametric High-Traction Fleet Pedal Box)
// Core Application: 2027-2028 Silverado MD Commercial Crew-Cab Driver Interface
// ====================================================================================

$fn = 120; // High-precision CNC stamping and overmold tooling depth

// --- Drivetrain Selector ---
// 1 = 3-Pedal Manual Array, 2 = 2-Pedal Commercial Automatic Array
TRUCK_DRIVETRAIN_MODE = 2;

// --- Physical Dimensional Parameters (mm) ---
pedal_arm_length   = 280.00;           // Extended commercial lever throw depth
throttle_pad_w     = 55.00;            // Sized to match 2027 Silverado High Country HD
throttle_pad_h     = 110.00;
brake_pad_w        = (TRUCK_DRIVETRAIN_MODE == 1) ? 65.00 : 130.00; // Wide-pad automatic brake profile
brake_pad_h        = 75.00;
lug_depth_mm       = 5.00;              // Deep anti-slip non-slip rubber traction lugs

module stamped_lever_arms() {
    echo(str("COMPILING SILVERADO MD PEDAL MODULE: ", (TRUCK_DRIVETRAIN_MODE == 1) ? "3_PEDAL_MANUAL_SET" : "2_PEDAL_AUTOMATIC_SET"));
    // Heavy-gauge steel structural support arms mounting to the firewall brace
    color("DimGrey") {
        // Throttle Arm Lever
        translate([-120, 0, 0]) rotate([15, 0, 0]) cube([16, 25, pedal_arm_length]);
        // Brake Arm Lever
        translate([0, 0, 0]) rotate([12, 0, 0]) cube([22, 30, pedal_arm_length]);
        // Clutch Arm Lever (Compiled exclusively for manual configurations)
        if (TRUCK_DRIVETRAIN_MODE == 1) {
            translate([120, 0, 0]) rotate([12, 0, 0]) cube([16, 25, pedal_arm_length]);
        }
    }
}

module non_slip_rubber_pads() {
    // 100% Tree-Harvested vulcanized rubber faces containing 5mm traction lugs
    color("Black") {
        // 1. Throttle Pedal Pad Face
        translate([-120 + 8, -12, 0])
            difference() {
                cube([throttle_pad_w, 15.0, throttle_pad_h], center=true);
                // Cuts deep vertical traction slots into the face matrix
                for (z = [-throttle_pad_h/2 + 10 : 15 : throttle_pad_h/2 - 10]) {
                    translate([0, 6.0, z]) cube([throttle_pad_w - 6, lug_depth_mm + 2, 4.0], center=true);
                }
            }
            
        // 2. Commercial Brake Pedal Pad Face
        translate([11, -15, 0])
            difference() {
                cube([brake_pad_w, 18.0, brake_pad_h], center=true);
                for (z = [-brake_pad_h/2 + 12 : 15 : brake_pad_h/2 - 12]) {
                    translate([0, 7.0, z]) cube([brake_pad_w - 8, lug_depth_mm + 2, 5.0], center=true);
                }
            }
    }
}

// --- Composite Pedal System Instantiation ---
union() {
    stamped_lever_arms();
    non_slip_rubber_pads();
}
