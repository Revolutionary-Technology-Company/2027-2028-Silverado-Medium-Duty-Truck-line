// ====================================================================================
// REVOLUTIONARY TECHNOLOGY COMPANY & UNIVERSITY OF WASHINGTON DEPARTMENT OF PHYSICS
// Subsystem: silverado_md_cockpit_systems.scad (Unified Cockpit Accessory Modules)
// Core Application: Deploys Bose Speaker Cavities, Peltier Ducts, and Cable Windows
// Center Origin (0,0,0) = Geometric Centerpoint of the Dashboard Sub-Car Beam
// ====================================================================================

$fn = 100; // High-precision CNC laser-cutting and molding path resolution

// --- Core Geometric System Parameters (mm) ---
inch_to_mm         = 25.4;
bose_midrange_dia  = 90.00;            // Sized for tuned Bose Neodymium arrays
peltier_duct_w     = 180.00;           // Matches active thermoelectric hvac housing
crank_spindle_dia  = 12.70;            // Authentic 1969 mechanical window crank shaft
faceplate_width    = 120.00;           // 1969-style sliding lever dial width profile

module bose_acoustic_dashboard_pods() {
    echo("COMPILING SHIELDED BOSE ACOUSTIC SPEECH SPEAKER HOUSINGS");
    // Symmetrical speaker cutouts molded into the OtterBox dashboard deck
    for (side = [-1, 1]) {
        translate([side * 450, 60, 40]) {
            color("DimGrey") {
                difference() {
                    cylinder(d=bose_midrange_dia + 16, h=50, center=true);
                    cylinder(d=bose_midrange_dia, h=52, center=true); // Tuned compression chamber
                }
            }
        }
    }
}

module hvac_peltier_duct_manifolds() {
    echo("COMPILING SOLID-STATE PELTIER AIRFLOW MANIFOLDS");
    // Left and right directional climate venting passages feeding the cabin space
    color("Black") {
        for (side = [-1, 1]) {
            translate([side * 220, 10, -20])
                cube([peltier_duct_w, 80, 45], center=true);
        }
    }
}

module manual_window_cable_regulators() {
    echo("COMPILING 1969 MANUAL KEYWAY WINDOW CRANK SPINDLES WITH EMERGENCY SOLENOIDRelease");
    // Inner door shackle plate holding the crank shaft and emergency dump solenoid casing
    for (side = [-1, 1]) {
        scale([side, 1, 1]) {
            translate([650, -300, -100]) {
                color("Silver") {
                    difference() {
                        cylinder(d=crank_spindle_dia + 14, h=35, center=true);
                        cylinder(d=crank_spindle_dia, h=37, center=true); // Keyed hand-crank slot
                    }
                }
                // High-current emergency escape dump solenoid module block
                translate([-60, 0, -10]) color("FireBrick") cube([45, 45, 65], center=true);
            }
        }
    }
}

module historical_climate_faceplate() {
    echo("COMPILING 1969 CHROME CLIMATE LEVER SURFACE INTERFACE");
    // Standard faceplate component slipping inside the center OtterBox dash cavity
    color("Silver") {
        translate([0, -20, -50])
            difference() {
                cube([faceplate_width, 4.0, 35.0], center=true); // Chrome exterior outline rim
                cube([faceplate_width - 8, 6.0, 27.0], center=true); // Slide track viewport slot
            }
    }
}

// --- Composite Accessory Systems Compilation ---
union() {
    bose_acoustic_dashboard_pods();
    hvac_peltier_duct_manifolds();
    manual_window_cable_regulators();
    historical_climate_faceplate();
}
