// ====================================================================================
// REVOLUTIONARY TECHNOLOGY COMPANY & UNIVERSITY OF WASHINGTON DEPARTMENT OF PHYSICS
// Module: silverado_md_dually_suspension.scad (2027-2028 Silverado MD Rear DRW Geometry)
// Core Application: Industrial Lifting, Trailer Pin-Load Leveling, & 4WD Offroad Portals
// Center Origin (0,0,0) = Rear Differential Centerpoint along Longitudinal Axis
// ====================================================================================

$fn = 120; // High-precision CNC milling and heavy-tonnage casting render depth

// --- 2027-2028 Silverado MD DRW Geometric Constants (mm) ---
inch_to_mm          = 25.4;
track_width_dually  = 74.50 * inch_to_mm; // 1892.30 mm extended outer track width
dually_wheel_offset = 13.50 * inch_to_mm; // 342.90 mm offset backspacing separating dual tires
axle_housing_dia    = 110.00;             // Solid-core high-strength rear axle tube housing
portal_drop_height  = 75.00;              // 3-inch gear reduction drop for off-road ground clearance

// Industrial Lifting & Toning Parameters
air_ram_max_stroke  = 220.00;             // Total vertical automated chassis lift capacity
leaf_pack_thickness = 90.00;              // Multi-tier heavy freight leaf spring stack depth

// --- Modules ---

module heavy_duty_portal_axle() {
    echo("COMPILING GM INDUSTRIAL DUALLY AXLE STATIONS WITH 4WD OFFROAD PORTALS");
    // Main solid center differential carrier housing (Mated to active torsional tunnel)
    color("DimGrey") {
        translate([0, 0, portal_drop_height])
            cube([220, 180, 180], center=true);
    }
    
    // Left & Right axle tubes projecting out to the portal drop boxes
    for (side = [-1, 1]) {
        scale([side, 1, 1])
            translate([110, 0, portal_drop_height])
                rotate([0, 90, 0])
                    cylinder(d=axle_housing_dia, h=(track_width_dually/2) - 180);
    }
}

module industrial_lifting_air_hydraulic_rams() {
    // Deploys active automated leveling rams to compensate for heavy trailer pin loads
    for (side = [-1, 1]) {
        scale([side, 1, 1])
            translate([(track_width_dually/2) - 240, 0, portal_drop_height + 80]) {
                // Outer heavy-walled hydraulic pressure sleeve chamber
                color("DarkSlateGrey") {
                    difference() {
                        cylinder(d=130, h=280, center=true);
                        cylinder(d=110, h=282, center=true);
                    }
                }
                // Internal high-pressure leveling piston rod (Extends dynamically under load)
                color("Silver")
                    translate([0, 0, -40])
                        cylinder(d=85, h=260, center=true);
            }
    }
}

module gm_fleet_leaf_spring_packages() {
    // Multi-leaf heavy cargo auxiliary spring stacks that cushion heavy bed drop-loads
    for (side = [-1, 1]) {
        translate([side * (frame_rail_spacing/2 + 40), 0, portal_drop_height + 40]) {
            color("SteelBlue")
                rotate([0, 0, 0])
                    cube([45, 950, leaf_pack_thickness], center=true);
            // Heavy-duty cast iron chassis mounting leaf shackles
            for (y_offset = [-475, 475]) {
                translate([side * (frame_rail_spacing/2 + 40), y_offset, portal_drop_height + 110])
                    color("Black") cube([65, 60, 80], center=true);
            }
        }
    }
}

module dually_wheel_assemblies() {
    // Renders the dual rear wheel layout [Two 19-inch wheels bolted back-to-back per side]
    for (side = [-1, 1]) {
        for (wheel_slot =) {
            // Calculates lateral offset coordinates separating inner and outer dually tires
            current_x_offset = side * ((track_width_dually/2) - (wheel_slot * dually_wheel_offset));
            
            translate([current_x_offset, 0, 0])
                rotate([0, 90, 0]) {
                    // Heavy commercial truck tires [31.5" Tall x 11.5" Section Width]
                    color("Black")
                        difference() {
                            cylinder(d=31.5 * inch_to_mm, h=11.5 * inch_to_mm, center=true);
                            cylinder(d=19.0 * inch_to_mm, h=12.0 * inch_to_mm, center=true); // 19-inch HD inner rim
                        }
                    // Milled high-polished heavy dual flange mounting plate rim faces
                    color("Mirror")
                        cylinder(d=19.0 * inch_to_mm, h=40, center=true);
                }
        }
    }
}

// --- Composite Industrial DRW Architecture Compilation ---
union() {
    heavy_duty_portal_axle();
    industrial_lifting_air_hydraulic_rams();
    gm_fleet_leaf_spring_packages();
    dually_wheel_assemblies();
}
