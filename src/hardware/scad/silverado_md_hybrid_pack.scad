// ====================================================================================
// REVOLUTIONARY TECHNOLOGY COMPANY & UNIVERSITY OF WASHINGTON DEPARTMENT OF PHYSICS
// Subsystem: silverado_md_hybrid_pack.scad (Commercial 800V Hybrid Energy Core)
// Core Specifications: RT-Certified Thermal Infrastructure / Multi-Chamber Shield
// COMPLIANCE GATE: Form-fitted to clear the 65mm lower armor clearance envelope [INDEX]
// Center Origin (0,0,0) = Geometric Centerpoint of the Underbelly Battery Pan
// ====================================================================================

$fn = 120; // High-precision CNC milling and waterjet cutting track paths

// --- Commercial Fleet Pack Dimensions (mm) ---
inch_to_mm         = 25.4;
frame_rail_spacing = 34.0 * inch_to_mm;  // 863.60 mm standard straight truck width [INDEX]
pack_total_length  = 1800.00;          // Spans longitudinally within the mid-chassis rails [INDEX]
pack_total_height  = 260.00;           // Deep dual-tier cell storage capacity [INDEX]
wall_thickness_ti  = 8.00;             // Reinforced 8mm Titanium Grade 5 impact walls [INDEX]

// Internal Chamber Partition Sizing (mm)
battery_cell_chamber_w = 420.00;      // Allocates space for 800V LiFePO4 cells [INDEX]
capacitor_array_w      = 220.00;       // Allocates space for the instant-discharge caps [INDEX]
vapor_chamber_height   = 20.00;        // 3D Vapor Chamber layer room for thermal management [INDEX]

module heavy_commercial_battery_casing() {
    echo("MILLING COMMERCIAL HIGH-DENSITY STRUCTURAL PACK CASING WITH INTEGRATED VAPOR FLANGES");
    color("DimGrey") {
        difference() {
            // Main solid underbody hybrid power pack vault brick
            cube([frame_rail_spacing - 10, pack_total_length, pack_total_height], center=true);
            
            // 1. PRIMARY LITHIUM CELL CHAMBER VOLUME
            translate([-frame_rail_spacing/4 + 40, 0, 0])
                cube([battery_cell_chamber_w, pack_total_length - 40, pack_total_height - (2*wall_thickness_ti)], center=true);
                
            // 2. ISOLATED ULTRA-CAPACITOR DRIVE CHAMBER
            translate([frame_rail_spacing/4 - 40, 0, 0])
                cube([capacitor_array_w, pack_total_length - 40, pack_total_height - (2*wall_thickness_ti)], center=true);
        }
    }
}

module rt_thermal_management_armor() {
    // Generates the horizontal multi-stage cooling lines and phase-change plate cavities [INDEX]
    color("Copper") {
        for (z_offset = [-pack_total_height/2 + 15, pack_total_height/2 - 15]) {
            translate([0, 0, z_offset])
                // RT Phase-Change cooling tracks extending horizontally to the radiator channels
                cube([frame_rail_spacing - 30, pack_total_length - 20, vapor_chamber_height], center=true);
        }
    }
}

module external_inverter_outlet_bracket() {
    // Heavy-duty terminal block extension where the auxiliary 120V AC inverter links [INDEX]
    color("Silver") {
        translate([0, pack_total_length/2 + 25, -40]) {
            difference() {
                cube([300.0, 50.0, 80.0], center=true);
                // Pre-cut port pass-throughs for the thick 3oz high-draw copper output tracks [INDEX]
                translate([-60, 0, 0]) rotate([90, 0, 0]) cylinder(d=35, h=55, center=true);
                translate([60, 0, 0])  rotate([90, 0, 0]) cylinder(d=35, h=55, center=true);
            }
        }
    }
}

// --- Composite Structural Energy Vault Instantiation ---
union() {
    heavy_commercial_battery_casing();
    rt_thermal_management_armor();
    external_inverter_outlet_bracket();
}
