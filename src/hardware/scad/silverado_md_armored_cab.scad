// ====================================================================================
// REVOLUTIONARY TECHNOLOGY COMPANY & UNIVERSITY OF WASHINGTON DEPARTMENT OF PHYSICS
// Subsystem: silverado_md_armored_cab.scad (Heavy Tactical Crew-Cab Cage Base)
// Core Application: 2027-2028 Silverado MD Commercial Fleet Ballistic Capsule
// COMPLIANCE GATE: Maintains absolute 65mm lower open clearance for underbody plates
// Center Origin (0,0,0) = Firewall Structural Interface on the Driveline Axis
// ====================================================================================

$fn = 100; // High-precision CNC milling and heavy-weldment contour depth

// --- Armored Crew-Cab Dimensional Constants (mm) ---
inch_to_mm         = 25.4;
cab_outer_width    = 82.00 * inch_to_mm; // Matches front clip skin boundaries [INDEX]
cab_outer_length   = 1850.00;            // Heavy commercial crew-cab longitudinal bed [INDEX]
armor_plate_thick  = 12.50;              // 1/2" Thick structural Titanium Grade 5 ballistic core
pillar_height_mm   = 1100.00;             // Total vertical cabin height [INDEX]

// Underbody Clearance Rule Compliance [INDEX]
UNDER_ARMOR_CLEARANCE_MM = 65.00;

module structural_ballistic_pillars() {
    echo("COMPILING 2027 SILVERADO MD ARMORED CREW-CAB REINFORCEMENT MATRIX");
    // Main vertical roll-over and anti-intrusion pillar stations (A, B, and C pillars)
    color("DimGrey") {
        for (x_side = [-cab_outer_width/2 + 20, cab_outer_width/2 - 20]) {
            for (y_step = [-cab_outer_length/2, 0, cab_outer_length/2]) {
                translate([x_side, y_step, pillar_height_mm/2])
                    cube([armor_plate_thick * 4, armor_plate_thick * 4, pillar_height_mm], center=true);
            }
        }
    }
}

module reinforced_blast_floor_pan() {
    // Heavy-duty V-hull style deflected blast plates lining the lower cab floor pan bed
    color("DarkSlateGrey") {
        translate([0, 0, -40])
            difference() {
                // Main floor plate raw stock casting
                cube([cab_outer_width - 80, cab_outer_length - 40, armor_plate_thick * 2], center=true);
                
                // Bottom-side clearance relief to protect the 65mm under-armor zone [INDEX]
                translate([0, 0, -armor_plate_thick])
                    cube([cab_outer_width, cab_outer_length + 10, UNDER_ARMOR_CLEARANCE_MM], center=true);
            }
    }
}

module internal_dash_and_steering_braces() {
    // Structural cross-car beam providing zero-deflection mounting ears for the OtterBox console [INDEX]
    color("Silver") {
        translate([0, cab_outer_length/2 - 100, 320]) {
            difference() {
                cube([cab_outer_width - 120, 80, 80], center=true);
                // Center clear pass-through tunnel for the 0.75-inch splined steering column shaft [INDEX]
                rotate([-15, 0, 0])
                    cylinder(d=50.0, h=90, center=true);
            }
        }
    }
}

// --- Composite Armored Cabin Subframe Instantiation ---
union() {
    structural_ballistic_pillars();
    reinforced_blast_floor_pan();
    internal_dash_and_steering_braces();
}
