// ====================================================================================
// REVOLUTIONARY TECHNOLOGY COMPANY & UNIVERSITY OF WASHINGTON DEPARTMENT OF PHYSICS
// Subsystem: silverado_md_extended_structure.scad (Extended Cab / Locked Wheelbase)
// Core Application: Extends Cab Enclosure Back While Keeping Original Wheel Positions
// COMPLIANCE GATE: Maintains absolute 65mm lower open clearance for underbody plates
// Center Origin (0,0,0) = Mid-point of the Original 165-Inch Frame Baseline Rail Axis
// ====================================================================================

$fn = 120; // High-precision CNC profiling and structural weldment resolution

// --- Original 165" Wheelbase Constants (mm) ---
inch_to_mm         = 25.4;
original_wheelbase = 165.0 * inch_to_mm; // Maintained original 4191.00 mm frame length [INDEX]
frame_rail_spacing = 34.0 * inch_to_mm;  // 863.60 mm standard straight truck rail width [INDEX]
rail_height_mm     = 250.00;             // Deep 10-inch heavy commercial profile [INDEX]
rail_thickness_ti  = 8.00;               // Reinforced 8mm structural frame walls [INDEX]

// Structural Extensions & Dimensions (mm)
extended_cab_len   = 2650.00;            // Extended cab back-wall depth (Pushed further back)
short_bed_len      = 78.0 * inch_to_mm;  // Compact 6.5-Foot cargo upfit bed (1981.20 mm depth) [INDEX]
UNDER_ARMOR_CLEARANCE_MM = 65.00;        // Mandatory open installation layer [INDEX]

module original_165_boxed_rails() {
    echo("COMPILING RE-EXTENDED CAB MATRIX WITH LOCKED WHEELBASE HUBS");
    for (side = [-1, 1]) {
        translate([side * (frame_rail_spacing/2 - rail_thickness_ti), -original_wheelbase/2, -rail_height_mm/2]) {
            color("DimGrey") {
                difference() {
                    // Boxed longitudinal Titanium Grade 5 frame rail channel beam [INDEX]
                    cube([50, original_wheelbase, rail_height_mm]);
                    // Hollow interior core step-down saving dead weight
                    translate([rail_thickness_ti, -1, rail_thickness_ti])
                        cube([50 - (2*rail_thickness_ti), original_wheelbase + 2, rail_height_mm - (2*rail_thickness_ti)]);
                }
            }
        }
    }
}

module integrated_extended_armored_cab() {
    // Armored cockpit block extended further back along the frame toward the locked wheels
    translate([0, original_wheelbase/2 - extended_cab_len/2, 600]) {
        color("SlateGrey") {
            difference() {
                cube([82.0 * inch_to_mm, extended_cab_len, 1100], center=true);
                cube([82.0 * inch_to_mm - 40, extended_cab_len - 40, 1060], center=true); // Hollow cockpit [INDEX]
                
                // Lower clearance vector protecting the 65mm skid plate layer [INDEX]
                translate([0, 0, -550])
                    cube([82.0 * inch_to_mm + 10, extended_cab_len + 10, UNDER_ARMOR_CLEARANCE_MM * 2], center=true);
            }
        }
    }
}

module short_bed_placement() {
    // Drops the short bed on the frame right after the extended cab back-wall
    // Maintains the rear wheel center lines matching original dually hubs [INDEX]
    translate([0, original_wheelbase/2 - extended_cab_len - short_bed_len/2, -40]) {
        color("DarkSlateGrey") {
            difference() {
                // Short-bed interface platform grid [INDEX]
                cube([frame_rail_spacing + 40, short_bed_len, 45], center=true);
                // 100mm frame-tail clearance notch to house the 15,000-lb recovery winch [INDEX]
                translate([0, -short_bed_len/2 + 50, 0])
                    cube([320.0, 102.0, 50.0], center=true);
            }
        }
    }
}

// --- Composite Assembly Instantiation ---
union() {
    original_165_boxed_rails();
    integrated_extended_armored_cab();
    short_bed_placement();
}
