// ====================================================================================
// REVOLUTIONARY TECHNOLOGY COMPANY & UNIVERSITY OF WASHINGTON DEPARTMENT OF PHYSICS
// Module: silverado_md_armor.scad (Commercial Fleet Push Bumpers & Dual Winches)
// Core Application: 2027-2028 Silverado MD Frame-Anchored Recovery & Interception Armor
// Center Origin (0,0,0) = Mid-point of Front Frame Crossmember Structural Face
// ====================================================================================

$fn = 120; // High-precision CNC plasma-profile and heavy weldment resolution

// --- 2027-2028 Silverado MD Armor Constants (mm) ---
inch_to_mm          = 25.4;
frame_rail_spacing  = 34.0  * inch_to_mm; // 863.60 mm standard straight truck width [INDEX]
truck_wheelbase     = 165.0 * inch_to_mm; // 4191.00 mm continuous chassis length [INDEX]
bumper_plate_thick  = 8.00;               // Heavy 8mm industrial plate armor steel
winch_drum_large    = 280.00;             // Heavy 20,000-lb front extraction winch spool
winch_drum_small    = 220.00;             // Heavy 15,000-lb rear recovery winch spool

module front_interceptor_push_bumper() {
    echo("COMPILING REINFORCED CHASSIS-MOUNTED FRONT DEFENSE BUMPER AND WINCH CELL");
    // Front impact assembly (Welds straight into the front frame horn plates)
    color("Black") {
        translate([-frame_rail_spacing/2 - 120, -150, -180]) {
            difference() {
                // Main heavy horizontal push fascia block
                cube([frame_rail_spacing + 240, 100, 380]);
                // Clear hawse fairlead roller window cutout passage for the front winching line
                translate([frame_rail_spacing/2 + 120 - winch_drum_large/2, -1, 60])
                    cube([winch_drum_large, 102, 45]);
            }
            // Left heavy push vertical push-knee tooth
            translate([120, -60, -80]) cube();
            // Right heavy push vertical push-knee tooth
            translate([frame_rail_spacing + 60, -60, -80]) cube();
        }
    }
}

module rear_tactical_step_bumper() {
    echo("COMPILING REAR HEAVY-TONNAGE IMPACT RAM STEP BUMPER");
    // Rear impact step assembly (Bolts to frame tails, providing 100mm upfit clearance notch)
    color("DarkSlateGrey") {
        translate([-frame_rail_spacing/2 - 80, -truck_wheelbase + 120, -160]) {
            difference() {
                // Main rear wide bumper block profile
                cube([frame_rail_spacing + 160, 120, 260]);
                // Center clear cutout cavity for the heavy-duty Class V trailer receiver hitch post
                translate([frame_rail_spacing/2 + 80 - 45, -1, -1])
                    cube([90, 122, 90]);
                // Window passage for the rear recovery winch guide cable
                translate([frame_rail_spacing/2 + 80 - winch_drum_small/2, -1, 140])
                    cube([winch_drum_small, 122, 35]);
            }
        }
    }
}

module dual_chassis_extraction_winches() {
    // 1. FRONT WINCH CELL (20,000-lb planetary recovery winch inside front crossmember)
    color("DimGrey") {
        translate([-winch_drum_large/2, -50, -40]) {
            rotate([-90, 0, 0])
                cylinder(d=140, h=winch_drum_large);
            // High-amperage terminal block casing
            translate([winch_drum_large/3, -40, 80])
                cube();
        }
    }
    
    // 2. REAR RECOVERY WINCH (15,000-lb assistance winch nested behind rear differential)
    color("SlateGrey") {
        translate([-winch_drum_small/2, -truck_wheelbase + 220, -40]) {
            rotate([-90, 0, 0])
                cylinder(d=120, h=winch_drum_small);
        }
    }
}

// --- Composite Commercial Armor Matrix Instantiation ---
union() {
    front_interceptor_push_bumper();
    rear_tactical_step_bumper();
    dual_chassis_extraction_winches();
}
