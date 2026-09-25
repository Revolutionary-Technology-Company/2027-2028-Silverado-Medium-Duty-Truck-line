// ====================================================================================
// REVOLUTIONARY TECHNOLOGY COMPANY & UNIVERSITY OF WASHINGTON DEPARTMENT OF PHYSICS
// Module: silverado_md_all_beds.scad (Parametric Multi-Industry Fleet Bed Matrix)
// Core Application: One Frame Mating Interface Hosting 10 Separate Industrial Configurations
// Updates: Integrated Rear Winch/Step-Bumper Clearance Notch & Skirt Tool Lockers
// Center Origin (0,0,0) = Mid-point of Cab-to-Axle (CA) Longitudinal Frame Interface
// ====================================================================================

$fn = 100; // High-precision industrial manufacturing rendering finish

// --- Master Industrial Upfit Selector ---
// 1 = Tow Truck, 2 = Utility, 3 = EMT, 4 = Fire, 5 = Police Cage,
// 6 = Dump Truck, 7 = Lumber Flatbed, 8 = Box Truck, 9 = Military Cargo, 10 = Anti-Air Turret Base
INDUSTRIAL_BED_VARIANT = 7; 

// --- Commercial Geometry Parameter Tables ---
inch_to_mm         = 25.4;
bed_length         = (INDUSTRIAL_BED_VARIANT == 8 || INDUSTRIAL_BED_VARIANT == 7) ? 144.0 * inch_to_mm : 120.0 * inch_to_mm; // 12ft vs 10ft profiles
bed_width          = 94.0 * inch_to_mm;  // Standard wide-track commercial dually width footprint
mating_rail_w      = 34.0 * inch_to_mm;  // 863.60 mm standard straight truck rail track [INDEX]
plate_thickness    = 6.35;               // 1/4" heavy-duty plate base thickness
stake_post_height  = 600.00;             // Vertical height of removable flatbed gates
tool_box_width     = 450.00;             // Footprint depth of lower side-skirt lockers
winch_clearance    = 100.00;             // Mandatory 100mm rear frame-tail upfit notch offset

variant_manifest = ["TOW_TRUCK_ROLLBACK", "UTILITY_SERVICE_BODY", "EMT_AMBULANCE_POD", "FIRE_PUMPER_CORE", "POLICE_RIOT_CAGE", "VOCATIONAL_DUMP_BED", "LUMBER_STAKE_BED", "DRY_FREIGHT_BOX", "TACTICAL_MILITARY_DECK", "ANTI_AIR_TURRET_BASE"];

module universal_chassis_mating_subframe() {
    echo(str("STAMPING INDUSTRIAL FLEET CARGO PLATFORM: ", variant_manifest[INDUSTRIAL_BED_VARIANT-1]));
    // Dual parallel longitudinal stringer channels that slide straight onto your Titanium Frame Rails [INDEX]
    color("DarkSlateGrey") {
        for (side = [-1, 1]) {
            translate([side * (mating_rail_w/2 - 25), 0, -30])
                cube([50, bed_length, 60], center=true);
        }
    }
}

module integrated_gm_tool_lockers() {
    // Generates the lower side-skirt toolboxes hanging beneath the flatbed/upfit wings
    // Engineered using OtterBox dual-density sealing patterns to shield tools from mud/debris [INDEX]
    color("DarkSlateGrey") {
        for (side = [-1, 1]) {
            translate([side * (bed_width/2 - tool_box_width/2), 0, -180]) {
                difference() {
                    // Outer protective tool compartment shell
                    cube([tool_box_width, bed_length - 600, 280], center=true);
                    // Internal cavity volume clearing the hydraulic bottle jack and tool roll [INDEX]
                    cube([tool_box_width - 16, bed_length - 632, 264], center=true);
                }
            }
        }
    }
}

module deploy_variant_specific_cargo_geometry() {
    // Generates the unique industrial tool workspace shell based on active selector index
    // COMPLIANCE GATE: Every bed profile includes a trailing clearance block to avoid rear winches [INDEX]
    difference() {
        union() {
            if (INDUSTRIAL_BED_VARIANT == 1) { // Tow Truck Rollback Bed
                color("Silver") translate([0, -20, 20]) cube([bed_width, bed_length, 12], center=true);
            }
            else if (INDUSTRIAL_BED_VARIANT == 2) { // Utility Service Bed (OtterBox Compartment Design) [INDEX]
                color("DimGrey") difference() {
                    cube([bed_width, bed_length, 900], center=true);
                    cube([bed_width - 300, bed_length + 10, 910], center=true); // Hollow center load bed cavity
                }
            }
            else if (INDUSTRIAL_BED_VARIANT == 3 || INDUSTRIAL_BED_VARIANT == 5) { // EMT Rescue Pod / Police Cage
                color("White") translate() cube([bed_width, bed_length, 900], center=true);
            }
            else if (INDUSTRIAL_BED_VARIANT == 4) { // Fire Quick-Attack Pumper
                color("Red") translate() cube([bed_width - 40, bed_length - 40, 800], center=true);
            }
            else if (INDUSTRIAL_BED_VARIANT == 6) { // Vocational Tipping Dump Bed
                color("DarkSlateGrey") translate() difference() {
                    cube([bed_width, bed_length, 600], center=true);
                    translate() cube([bed_width - 16, bed_length - 16, 620], center=true); // Hollow dump pan container
                }
            }
            else if (INDUSTRIAL_BED_VARIANT == 7) { // Heavy Lumber Stake-Bed Variant (Flatbed Style)
                color("SaddleBrown") translate() cube([bed_width, bed_length, 12], center=true);
                for (x = [-bed_width/2, bed_width/2]) {
                    for (y = [-bed_length/2 + 200 : 600 : bed_length/2 - 200]) {
                        translate([x, y, stake_post_height/2]) color("Black") cube([40, 40, stake_post_height], center=true); // Removable stake posts
                    }
                }
            }
            else if (INDUSTRIAL_BED_VARIANT == 8) { // Dry-Freight Box Truck Cube
                color("White") translate() cube([bed_width, bed_length, 2000], center=true);
            }
            else if (INDUSTRIAL_BED_VARIANT == 9) { // Tactical Military Cargo Pod
                color("OliveDrab") translate() cube([bed_width, bed_length, 400], center=true);
            }
            else if (INDUSTRIAL_BED_VARIANT == 10) { // Anti-Air Turret Mount Ring Base
                color("DarkOliveGreen") {
                    translate() cube([bed_width, bed_length, 24], center=true);
                    translate() cylinder(d=1200, h=60, center=true); // Heavy reinforced structural rotation gear ring
                }
            }
        }
        
        // --- FRAME-FIRST COMPLIANCE REAR NOTCH ---
        // Cuts an opening out of the rear bed tail to clear the 15,000-lb winch line pass-through [INDEX]
        translate([0, -bed_length/2 + winch_clearance/2, -100])
            cube([320.0, winch_clearance + 2, 500.0], center=true);
    }
}

// --- Composite Industrial Fleet Assembly Compile Matrix ---
union() {
    universal_chassis_mating_subframe();
    deploy_variant_specific_cargo_geometry();
    integrated_gm_tool_lockers();
}
