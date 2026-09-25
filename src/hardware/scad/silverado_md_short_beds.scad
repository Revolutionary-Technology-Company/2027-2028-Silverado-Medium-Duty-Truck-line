// ====================================================================================
// REVOLUTIONARY TECHNOLOGY COMPANY & UNIVERSITY OF WASHINGTON DEPARTMENT OF PHYSICS
// Module: silverado_md_all_beds.scad (Parametric Multi-Industry Short-Bed Matrix)
// Updates: Optimized for 143.5" Wheelbase Extended King Cab & 6.5-Foot Cargo Limits
// Center Origin (0,0,0) = Mid-point of King Cab-to-Axle (CA) Longitudinal Frame Interface
// ====================================================================================

$fn = 100;

// --- Master Industrial Upfit Selector ---
INDUSTRIAL_BED_VARIANT = 2; // 1=Tow, 2=Utility, 3=EMT, 4=Fire, 5=Police, 6=Dump, 7=Lumber, 8=Box, 9=Military, 10=Anti-Air

// --- Short-Bed Fleet Geometry Parameter Tables ---
inch_to_mm         = 25.4;
bed_length         = 78.0 * inch_to_mm;  // Scaled down to exactly 1981.20 mm for short-bed upfits
bed_width          = 94.0 * inch_to_mm;  // Standard wide-track commercial dually width [INDEX]
mating_rail_w      = 34.0 * inch_to_mm;  // 863.60 mm standard straight truck rail track [INDEX]
tool_box_width     = 400.00;             // Compressed pocket size fitting shorter wheelbase
winch_clearance    = 100.00;             // Mandatory rear winch notch offset [INDEX]

variant_manifest = ["TOW_TRUCK_ROLLBACK", "UTILITY_SERVICE_BODY", "EMT_AMBULANCE_POD", "FIRE_PUMPER_CORE", "POLICE_RIOT_CAGE", "VOCATIONAL_DUMP_BED", "LUMBER_STAKE_BED", "DRY_FREIGHT_BOX", "TACTICAL_MILITARY_DECK", "ANTI_AIR_TURRET_BASE"];

module universal_chassis_mating_subframe() {
    echo(str("COMPILING SHORT-BED INDUSTAL UPFIT PACK: ", variant_manifest[INDUSTRIAL_BED_VARIANT-1]));
    for (side = [-1, 1]) {
        translate([side * (mating_rail_w/2 - 25), 0, -30])
            cube([50, bed_length, 60], center=true);
    }
}

module integrated_gm_tool_lockers() {
    // Hangs below the shorter side-skirts to protect the GM Fleet Industrial Toolkit [INDEX]
    color("DarkSlateGrey") {
        for (side = [-1, 1]) {
            translate([side * (bed_width/2 - tool_box_width/2), 0, -180]) {
                difference() {
                    cube([tool_box_width, bed_length - 200, 280], center=true); // Shortened locker footprint
                    cube([tool_box_width - 16, bed_length - 232, 264], center=true);
                }
            }
        }
    }
}

module deploy_short_cargo_geometry() {
    difference() {
        union() {
            if (INDUSTRIAL_BED_VARIANT == 1) { // Tow Truck rollback plate short spec
                color("Silver") translate() cube([bed_width, bed_length, 12], center=true);
            }
            else if (INDUSTRIAL_BED_VARIANT == 2) { // Utility Body (OtterBox Compartments) [INDEX]
                color("DimGrey") difference() {
                    cube([bed_width, bed_length, 800], center=true);
                    cube([bed_width - 300, bed_length + 10, 810], center=true);
                }
            }
            else if (INDUSTRIAL_BED_VARIANT == 6) { // Vocational Dump Pan
                color("DarkSlateGrey") translate() difference() {
                    cube([bed_width, bed_length, 600], center=true);
                    translate() cube([bed_width - 16, bed_length - 16, 620], center=true);
                }
            }
            // Other variants fallback directly into the standardized short-envelope box blocks
            else {
                color("White") translate() cube([bed_width, bed_length, 800], center=true);
            }
        }
        
        // --- FRAME-FIRST COMPLIANCE REAR NOTCH ---
        // Clears the 15,000-lb rear recovery winch cable line pass-through [INDEX]
        translate([0, -bed_length/2 + winch_clearance/2, -100])
            cube([320.0, winch_clearance + 2, 500.0], center=true);
    }
}

// --- Composite Structural Short-Bed Execution Matrix ---
union() {
    universal_chassis_mating_subframe();
    deploy_short_cargo_geometry();
    integrated_gm_tool_lockers();
}
