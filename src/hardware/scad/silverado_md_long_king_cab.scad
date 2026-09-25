// ====================================================================================
// REVOLUTIONARY TECHNOLOGY COMPANY & UNIVERSITY OF WASHINGTON DEPARTMENT OF PHYSICS
// Subsystem: silverado_md_long_king_cab.scad (Extended Cab / Short Bed on 165" Frame)
// Core Application: Re-Apportioning the Original Long-Wheelbase Chassis Matrix
// COMPLIANCE GATE: Maintains absolute 65mm lower open clearance for underbody plates
// Center Origin (0,0,0) = Mid-point of the Original 165-Inch Frame Baseline Rail Axis
// ====================================================================================

$fn = 120; // High-precision CNC cutting and welding profile depth resolution

// --- Original 165" Wheelbase Structural Constants (mm) ---
inch_to_mm         = 25.4;
original_wheelbase = 165.0 * inch_to_mm; // Maintained original 4191.00 mm frame length [INDEX]
frame_rail_spacing = 34.0 * inch_to_mm;  // 863.60 mm standard straight truck rail width [INDEX]
rail_height_mm     = 250.00;             // Deep 10-inch heavy commercial profile [INDEX]
rail_thickness_ti  = 8.00;               // Reinforced 8mm structural frame walls [INDEX]

// Re-Apportioned Superstructure Constraints
extended_cab_len   = 2350.00;            // Extended cabin envelope length [INDEX]
short_bed_len      = 78.0 * inch_to_mm;  // Compact 6.5-Foot cargo upfit bed (1981.20 mm depth) [INDEX]
UNDER_ARMOR_CLEARANCE_MM = 65.00;        // Mandatory open installation layer [INDEX]

module original_165_boxed_rails() {
    echo("COMPILING RE-APPORTIONED SUPERSTRUCTURE OVER ORIGINAL 165 INCH CHASSIS RAILS");
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

module active_magnetic_driveline_tunnel() {
    // Original center electromagnetic tunnel remains physically continuous [INDEX]
    color("DarkSlateGrey") {
        rotate([-90, 0, 0]) {
            difference() {
                cylinder(d=180, h=original_wheelbase - 800, center=true);
                cylinder(d=160, h=original_wheelbase - 798, center=true);
            }
        }
    }
}

module integrated_armored_king_cab_placement() {
    // 12.5mm internal anti-intrusion cage positioned over the original firewall coordinates [INDEX]
    translate([0, original_wheelbase/2 - extended_cab_len/2, 600]) {
        color("SlateGrey") {
            difference() {
                cube([82.0 * inch_to_mm, extended_cab_len, 1100], center=true);
                cube([82.0 * inch_to_mm - 40, extended_cab_len - 40, 1060], center=true); // Hollow inner cockpit [INDEX]
                
                // Lower clearance vector protecting the 65mm skid plate layer [INDEX]
                translate([0, 0, -550])
                    cube([82.0 * inch_to_mm + 10, extended_cab_len + 10, UNDER_ARMOR_CLEARANCE_MM * 2], center=true);
            }
        }
    }
}

module short_bed_indexed_rear_upfit() {
    // Anchors the short bed flush against the frame tail, leaving the mid-chassis utility gap open [INDEX]
    translate([0, -original_wheelbase/2 + short_bed_len/2, -40]) {
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

// --- Composite Chassis Integration Instantiation ---
union() {
    original_165_boxed_rails();
    active_magnetic_driveline_tunnel();
    integrated_armored_king_cab_placement();
    short_bed_indexed_rear_upfit();
}
