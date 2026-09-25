// ====================================================================================
// REVOLUTIONARY TECHNOLOGY COMPANY & UNIVERSITY OF WASHINGTON DEPARTMENT OF PHYSICS
// Subsystem: silverado_md_flatbed.scad (Commercial Flatbed & Toolkit Upfit)
// Core Application: 12-Foot Industrial Widebody Flatbed with Integrated Tool Lockers
// Center Origin (0,0,0) = Mid-point of the Flatbed Frame Mating Axis
// ====================================================================================

$fn = 100; // High-precision CNC cutting and waterjet routing finish depth

// --- Commercial Flatbed Dimensional Constants (mm) ---
inch_to_mm         = 25.4;
bed_length_12ft    = 144.0 * inch_to_mm; // 3657.60 mm continuous flatbed depth
bed_width_dually   = 94.0  * inch_to_mm; // 2387.60 mm extended rear dually track width
mating_rail_w      = 34.0  * inch_to_mm; // 863.60 mm standard straight frame track
stake_post_height  = 600.00;             // Vertical height of removable perimeter gates
tool_box_width     = 450.00;             // Footprint depth of lower side-skirt lockers

module flanged_flatbed_deck() {
    echo("COMPILING 12-FOOT COMMERCIAL FLATBED DECK WITH INTEGRATED SIDE-SKIRT LOCKERS");
    // Main horizontal cargo payload deck plate (Heavy structural steel/aluminum diamond plate)
    color("DimGrey") {
        difference() {
            cube([bed_width_dually, bed_length_12ft, 12.0], center=true);
            // Counter-sunk drilling points to bolt down to the 8mm frame rails
            for (y = [-bed_length_12ft/3, 0, bed_length_12ft/3]) {
                for (side = [-1, 1]) {
                    translate([side * (mating_rail_w/2), y, 0])
                        cylinder(d=16.5, h=20, center=true);
                }
            }
        }
    }
    
    // Front Headache Rack / Cab-Guard Bulkhead
    color("Silver") {
        translate([0, bed_length_12ft/2 - 6, 450])
            cube([bed_width_dually, 12.0, 900], center=true);
    }
}

module integrated_gm_tool_lockers() {
    // Generates the lower side-skirt toolboxes hanging beneath the flatbed wings
    // Engineered using OtterBox dual-density sealing patterns to shield tools from mud/debris
    color("DarkSlateGrey") {
        for (side = [-1, 1]) {
            translate([side * (bed_width_dually/2 - tool_box_width/2), 0, -180]) {
                difference() {
                    // Outer protective tool compartment shell
                    cube([tool_box_width, bed_length_12ft - 600, 280], center=true);
                    // Internal cavity volume clearing the hydraulic bottle jack and tool roll
                    cube([tool_box_width - 16, bed_length_12ft - 632, 264], center=true);
                }
            }
        }
    }
}

module carbon_fiber_stake_posts() {
    // Generates removable side-walls to retain industrial cargo loads
    color("Black") {
        for (x_side = [-bed_width_dually/2, bed_width_dually/2]) {
            for (y_step = [-bed_length_12ft/2 + 200 : 600 : bed_length_12ft/2 - 200]) {
                translate([x_side, y_step, stake_post_height/2]) {
                    // Vertical stake post element
                    cube([40, 40, stake_post_height], center=true);
                    // Interconnecting horizontal rail slates
                    translate([-x_side/abs(x_side)*10, 0, 150])
                        cube([10, 600, 80], center=true);
                }
            }
        }
    }
}

// --- Composite Commercial Flatbed System Instantiation ---
union() {
    flanged_flatbed_deck();
    integrated_gm_tool_lockers();
    carbon_fiber_stake_posts();
}
