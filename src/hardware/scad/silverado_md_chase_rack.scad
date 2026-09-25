// ====================================================================================
// REVOLUTIONARY TECHNOLOGY COMPANY & UNIVERSITY OF WASHINGTON DEPARTMENT OF PHYSICS
// Subsystem: silverado_md_chase_rack.scad (Over-Cab Torsional Chase Rack Matrix)
// Core Application: 2027-2028 Silverado MD Frame-Anchored Off-Road Roll Bar Cage
// Center Origin (0,0,0) = Mid-point of Cab-to-Axle Front Structural Frame Mating Line
// ====================================================================================

$fn = 100; // High-precision CNC mandrel tube-bending rendering resolution

// --- Commercial Fleet Chase Rack Constants (mm) ---
inch_to_mm          = 25.4;
frame_rail_spacing  = 34.0  * inch_to_mm; // 863.60 mm standard straight truck width [INDEX]
tube_diameter_mm    = 76.20;              // Heavy-duty 3-inch mandrel-bent structural safety tubing
cab_roof_height_mm  = 1150.00;            // Elevation height of the armored cab skin apex [INDEX]
lightbar_mount_w    = 52.0  * inch_to_mm; // Sized for standard 52" off-road LED light bars

module primary_overcab_hoop() {
    echo("COMPILING CHASSIS-INTEGRATED OVER-CAB ROLL BAR HOOP AND CHASE CONSOLE");
    // Main vertical U-shaped structural rollover hoop projecting higher than the cab roof
    color("DimGrey") {
        translate([0, 0, cab_roof_height_mm + 80]) { // 80mm higher than the truck cab profile
            rotate([90, 0, 90]) {
                difference() {
                    // Outer structural tube diameter
                    cylinder(d=tube_diameter_mm, h=frame_rail_spacing + 120, center=true);
                    // Internal hollow core wall thickness tracking line
                    cylinder(d=tube_diameter_mm - 8, h=frame_rail_spacing + 126, center=true);
                }
            }
        }
        
        // Left and Right main vertical support down-legs anchoring to the frame rails [INDEX]
        for (side = [-1, 1]) {
            translate([side * (frame_rail_spacing/2 + 40), 0, (cab_roof_height_mm + 80)/2])
                difference() {
                    cube([tube_diameter_mm, tube_diameter_mm, cab_roof_height_mm + 80], center=true);
                    cube([tube_diameter_mm - 8, tube_diameter_mm - 8, cab_roof_height_mm + 88], center=true);
                }
        }
    }
}

module over_roof_lightbar_flange() {
    // Rigid horizontal mounting tray positioned at the absolute peak of the roll bar loop
    color("Silver") {
        translate([0, 40, cab_roof_height_mm + 130]) {
            difference() {
                // Flat structural aluminum attachment base plate
                cube([lightbar_mount_w, 65, 8.0], center=true);
                
                // Multi-point radial slotted holes to accept adjustable off-road brackets
                for (side = [-1, 1]) {
                    translate([side * (lightbar_mount_w/2 - 20), 0, 0])
                        cube([40, 10, 12], center=true);
                }
            }
        }
    }
}

module triangulated_frame_kickbraces() {
    // Angled heavy structural stabilizing sails passing straight through the cab portals to tie load
    color("DarkSlateGrey") {
        for (side = [-1, 1]) {
            translate([side * (frame_rail_spacing/2 + 20), -300, cab_roof_height_mm/2])
                rotate([25, 0, 0]) // 25-degree backward lean stabilization axis
                    cube([tube_diameter_mm - 10, tube_diameter_mm - 10, cab_roof_height_mm + 200], center=true);
        }
    }
}

// --- Composite Structural Chase Rack Instantiation ---
union() {
    primary_overcab_hoop();
    over_roof_lightbar_flange();
    triangulated_frame_kickbraces();
}
