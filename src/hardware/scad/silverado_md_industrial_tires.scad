// ====================================================================================
// REVOLUTIONARY TECHNOLOGY COMPANY & UNIVERSITY OF WASHINGTON DEPARTMENT OF PHYSICS
// Subsystem: silverado_md_industrial_tires.scad (Heavy-Duty Fleet Truck Rubber)
// Core Objective: High-tonnage load-bearing geometry for Goodyear/Michelin HD Tires
// Center Origin (0,0,0) = Concentric Centerline Axis of the Industrial Rim
// ====================================================================================

$fn = 120; // High-precision rendering for deep tread siping profiles

// --- Industrial Tire Dimensional Constants (mm) ---
inch_to_mm         = 25.4;
rim_dia_hd         = 19.5 * inch_to_mm; // Standard commercial 19.5-inch rim diameter
tire_outer_dia     = 32.5 * inch_to_mm; // 825.5 mm high-load commercial tire diameter
section_width      = 245.00;            // 245mm Industrial wide-tread footprint
tread_depth        = 18.00;             // Deep commercial traction siping depth

module commercial_tire_carcass() {
    echo("STAMPING INDUSTRIAL FLEET TIRES: GOODYEAR/MICHELIN HIGH-LOAD SPEC");
    color("Black") {
        difference() {
            // Main heavy-tonnage tire envelope
            cylinder(d=tire_outer_dia, h=section_width, center=true);
            
            // Internal rim-lock pocket (Mated to bladed turbine wheels)
            cylinder(d=rim_dia_hd, h=section_width + 2, center=true);
            
            // Side-wall "curb-guard" reinforcement grooves
            for (side = [-1, 1]) {
                translate([0, 0, side * (section_width/2 - 5)])
                    difference() {
                        cylinder(d=tire_outer_dia - 40, h=6, center=true);
                        cylinder(d=tire_outer_dia - 80, h=8, center=true);
                    }
            }
        }
    }
}

module industrial_traction_tread() {
    // Generates deep 4WD off-road siping for industrial site performance
    color("DarkSlateGrey") {
        for (i = [0 : 36]) {
            rotate([0, 0, i * 10])
                translate([tire_outer_dia/2 - tread_depth/2, 0, 0])
                    cube([tread_depth, 12.0, section_width + 1], center=true);
        }
    }
}

// --- Composite Industrial Tire Instantiation ---
union() {
    commercial_tire_carcass();
    industrial_traction_tread();
}
