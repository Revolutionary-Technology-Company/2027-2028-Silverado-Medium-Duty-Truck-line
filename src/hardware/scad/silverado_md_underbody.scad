// ====================================================================================
// REVOLUTIONARY TECHNOLOGY COMPANY & UNIVERSITY OF WASHINGTON DEPARTMENT OF PHYSICS
// Subsystem: silverado_md_underbody.scad (Commercial Underbody Shell & Drainage)
// Core Application: Northrop Grumman Spec Drainage Scuppers & Heavy Fleet Mud Flaps
// Center Origin (0,0,0) = Geometric Centerpoint of Front Underbelly Crossmember Face
// ====================================================================================

$fn = 120; // High-precision waterjet-cutting path profiling resolution

// --- 2027-2028 Silverado MD Underbody Constants (mm) ---
inch_to_mm          = 25.4;
frame_rail_spacing  = 34.0  * inch_to_mm; // 863.60 mm standard straight truck rail width [INDEX]
truck_wheelbase     = 165.0 * inch_to_mm; // 4191.00 mm continuous chassis length [INDEX]
skid_plate_thick    = 6.35;               // Heavy-duty 1/4" aircraft-grade 6061-T6 aluminum plate
scupper_bore_dia    = 19.05;              // 3/4-inch drainage pass-through diameter [INDEX]
dually_wheel_width  = 342.90;             // Section depth matching rear DRW tires [INDEX]

module heavy_aluminum_skid_plates() {
    echo("COMPILING INDUSTRIAL 1/4 INCH ARMOR SHIELD AND NORTHROP GRUMMAN SCUPPERS");
    // Main horizontal underbelly protection armor plate (Bolts straight to 8mm titanium frame rails) [INDEX]
    color("Silver") {
        difference() {
            translate([-frame_rail_spacing/2, -truck_wheelbase + 400, -145])
                cube([frame_rail_spacing, truck_wheelbase - 600, skid_plate_thick]);
            
            // NORTHROP GRUMMAN 5-DEGREE DRAINAGE PORTS
            // Cuts sloped funnel extraction bores at the absolute base of the computing vaults [INDEX]
            for (y_drain = [-truck_wheelbase/4, -truck_wheelbase/2]) {
                translate([0, y_drain, -148])
                    rotate([5, 0, 0]) // 5-degree gravitational gradient slope [INDEX]
                        cylinder(d1=scupper_bore_dia + 12, d2=scupper_bore_dia, h=skid_plate_thick + 6, center=true);
            }
        }
    }
}

module northrop_grumman_check_valves() {
    // Models the battleship-grade anti-splashback check valves extending beneath the skid plate
    color("DarkSlateGrey") {
        for (y_drain = [-truck_wheelbase/4, -truck_wheelbase/2]) {
            translate([0, y_drain, -160]) {
                difference() {
                    // Outer drainage pipe extension neck
                    cylinder(d=scupper_bore_dia + 8, h=25, center=true);
                    // Internal core vapor pass-through line [INDEX]
                    cylinder(d=scupper_bore_dia, h=27, center=true);
                }
                // Internal ball/diaphragm seat ring that seals instantly under pressurized water splashback [INDEX]
                translate([0, 0, -4])
                    difference() {
                        cylinder(d=scupper_bore_dia - 1, h=4.0, center=true);
                        cylinder(d=scupper_bore_dia - 6, h=6.0, center=true);
                    }
            }
        }
    }
}

module commercial_dually_mud_flaps() {
    // Heavy-duty flexible trailing flaps tracking behind the dually tires (Rule Compliance) [INDEX]
    color("Black") { // 100% Tree-Harvested vulcanized polyisoprene anti-ozonant compounds [INDEX]
        for (side = [-1, 1]) {
            translate([side * (frame_rail_spacing/2 + 280), -truck_wheelbase + 100, -220])
                rotate([0, 0, side * 3])
                    // Heavy industrial mud flap shield scaled to match the dually tire section width [INDEX]
                    cube([dually_wheel_width + 20, 16.0, 480], center=true);
        }
    }
}

// --- Composite Underbody Armor System Instantiation ---
union() {
    heavy_aluminum_skid_plates();
    northrop_grumman_check_valves();
    commercial_dually_mud_flaps();
}
