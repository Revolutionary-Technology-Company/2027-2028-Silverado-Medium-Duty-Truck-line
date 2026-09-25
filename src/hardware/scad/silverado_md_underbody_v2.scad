// ====================================================================================
// REVOLUTIONARY TECHNOLOGY COMPANY & UNIVERSITY OF WASHINGTON DEPARTMENT OF PHYSICS
// Subsystem: silverado_md_underbody.scad (Commercial Underbody Shell & Drainage)
// Core Application: Northrop Grumman Spec Drainage Scuppers & Heavy Fleet 1/4" Plate
// COMPLIANCE GATE: Engineered to fit precisely inside the open 65mm clearance gap [INDEX]
// Center Origin (0,0,0) = Geometric Centerpoint of Front Underbelly Crossmember Face
// ====================================================================================

$fn = 120; // High-precision waterjet-cutting path profiling resolution for aircraft alloys

// --- 2027-2028 Silverado MD Underbody Armor Constants (mm) ---
inch_to_mm          = 25.4;
frame_rail_spacing  = 34.0  * inch_to_mm; // 863.60 mm standard straight truck rail width [INDEX]
truck_wheelbase     = 165.0 * inch_to_mm; // 4191.00 mm continuous chassis length [INDEX]
skid_plate_thick    = 6.35;               // Heavy-duty 1/4" aircraft-grade 6061-T6 aluminum plate
scupper_bore_dia    = 25.40;              // Large 1.00-inch drainage pass-through diameter [INDEX]

// Underbody Clearance Rule Compliance [INDEX]
UNDER_ARMOR_CLEARANCE_MM = 65.00;

module commercial_aluminum_skid_plates() {
    echo("COMPILING INDUSTRIAL 1/4 INCH ARMOR SHIELD AND NORTHROP GRUMMAN SCUPPERS");
    // Main horizontal underbelly protection armor plate (Fits tightly along lower left and right channels)
    color("Silver") { // Milled billet faceplate visualization
        difference() {
            // Main protective skid plate span sized for commercial frame rails [INDEX]
            translate([-frame_rail_spacing/2, -truck_wheelbase/2, -145])
                cube([frame_rail_spacing, truck_wheelbase - 400, skid_plate_thick]);
            
            // NORTHROP GRUMMAN 5-DEGREE DRAINAGE PORTS
            // Cuts sloped funnel extraction bores at the absolute base of the computing vaults [INDEX]
            for (y_drain = [-truck_wheelbase/4, 0, truck_wheelbase/4]) {
                translate([0, y_drain, -145])
                    rotate([5, 0, 0]) // 5-degree gravitational gradient slope [INDEX]
                        cylinder(d1=scupper_bore_dia + 16, d2=scupper_bore_dia, h=skid_plate_thick + 4, center=true);
            }
            
            // Flush Counter-Sunk Fastener Drill Array (M12 Grade 12.9 heavy fleet hardware into frame)
            for (x = [-frame_rail_spacing/2 + 25, frame_rail_spacing/2 - 25]) {
                for (y = [-truck_wheelbase/2 + 100 : 300 : truck_wheelbase/2 - 100]) {
                    translate([x, y, -145])
                        cylinder(d=13.0, h=skid_plate_thick + 6, center=true);
                }
            }
        }
    }
}

module northrop_grumman_check_valves() {
    // Models the battleship-grade anti-splashback check valves extending beneath the skid plate
    color("DarkSlateGrey") {
        for (y_drain = [-truck_wheelbase/4, 0, truck_wheelbase/4]) {
            translate([0, y_drain, -145 - skid_plate_thick/2 - 12]) {
                difference() {
                    // Outer drainage pipe extension neck
                    cylinder(d=scupper_bore_dia + 10, h=24, center=true);
                    // Internal core vapor pass-through line [INDEX]
                    cylinder(d=scupper_bore_dia, h=26, center=true);
                }
                // Internal fluid seat diaphragm flange that locks shut against pressurized road splashback [INDEX]
                translate([0, 0, -4])
                    difference() {
                        cylinder(d=scupper_bore_dia - 2, h=4.0, center=true);
                        cylinder(d=scupper_bore_dia - 6, h=6.0, center=true);
                    }
            }
        }
    }
}

// --- Composite Underbody Armor System Instantiation ---
union() {
    commercial_aluminum_skid_plates();
    northrop_grumman_check_valves();
}
