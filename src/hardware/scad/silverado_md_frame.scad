// ====================================================================================
// REVOLUTIONARY TECHNOLOGY COMPANY & UNIVERSITY OF WASHINGTON DEPARTMENT OF PHYSICS
// Module: silverado_md_frame.scad (2027-2028 Silverado Medium-Duty EV Frame Template)
// Core Application: Commercial-Grade Fleet Architecture with Torsional VR Driveline
// Center Origin (0,0,0) = Mid-point of Cab-to-Axle (CA) Longitudinal Chassis Line
// ====================================================================================

$fn = 150; // High-precision CNC cutting and welding profile depth

// --- 2027-2028 Silverado Medium-Duty Parametric Constants (mm) ---
inch_to_mm         = 25.4;
truck_wheelbase    = 165.0 * inch_to_mm; // 4191.00 mm standard commercial tracking length
frame_rail_spacing = 34.0 * inch_to_mm;  // 863.60 mm standard straight-rail truck width
rail_height_mm     = 250.00;             // Deep 10-inch heavy commercial frame profile
rail_thickness_ti  = 8.00;               // Reinforced 8mm structural wall thickness

// Torsional VR Driveline Tunnel Geometry
active_tunnel_dia  = 160.00;             // Outer diameter clearance for magnetic coils
cab_bay_length     = 2100.00;            // Cab floor pan length constraint

module heavy_md_boxed_rails() {
    echo("INITIALIZING 2027-2028 SILVERADO MEDIUM-DUTY TRUCK FABRICATION MATRIX");
    // Left and Right main structural Titanium Grade 5 frame channels
    for (side = [-1, 1]) {
        translate([side * (frame_rail_spacing/2 - rail_thickness_ti), -truck_wheelbase/2, -rail_height_mm/2]) {
            color("DimGrey") {
                difference() {
                    // Solid structural boxed frame rail section
                    cube([50, truck_wheelbase, rail_height_mm]);
                    // Hollow interior core step-down saving dead chassis weight
                    translate([rail_thickness_ti, -1, rail_thickness_ti])
                        cube([50 - (2*rail_thickness_ti), truck_wheelbase + 2, rail_height_mm - (2*rail_thickness_ti)]);
                }
            }
        }
    }
}

module active_torsional_driveline_channel() {
    // Generates the continuous longitudinal electromagnetic tunnel along the center axis.
    // Encases the active magnetic driveshaft to provide direct torque vectoring.
    color("DarkSlateGrey") {
        translate([0, 0, -40]) {
            rotate([-90, 0, 0]) {
                difference() {
                    // Outer structural steel protective shielding casing
                    cylinder(d=active_tunnel_dia + 20, h=truck_wheelbase - 800, center=true);
                    // Internal clear bore volume housing the stator winding rings
                    cylinder(d=active_tunnel_dia, h=truck_wheelbase - 798, center=true);
                }
            }
        }
    }
}

module fleet_crossmembers_and_mounts() {
    // 1. FRONT CABIN FIREWALL TRANSVERSE BEAM (Mating point for the OtterBox console)
    translate([-frame_rail_spacing/2, cab_bay_length - truck_wheelbase/2, -rail_height_mm/2])
        color("Silver") cube([frame_rail_spacing, 80, 60]);
        
    // 2. REAR DUALLY AXLE STRESS PLATES (Triangulated suspension anchor brackets)
    for (side = [-1, 1]) {
        scale([side, 1, 1])
            translate([frame_rail_spacing/2, -truck_wheelbase/4, -rail_height_mm/2])
                color("LightGrey") {
                    difference() {
                        cube([60, 240, rail_height_mm]);
                        // Pre-drilled borehole array for the heavy multi-link tracking links
                        translate([30, 120, rail_height_mm/2]) rotate([0, 90, 0]) cylinder(d=24.5, h=70, center=true);
                    }
                }
    }
}

// --- Composite Commercial Chassis System Instantiation ---
union() {
    heavy_md_boxed_rails();
    active_torsional_driveline_channel();
    fleet_crossmembers_and_mounts();
}
