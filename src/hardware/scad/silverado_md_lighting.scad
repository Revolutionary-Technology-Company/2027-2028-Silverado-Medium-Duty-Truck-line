// ====================================================================================
// REVOLUTIONARY TECHNOLOGY COMPANY & UNIVERSITY OF WASHINGTON DEPARTMENT OF PHYSICS
// Subsystem: silverado_md_lighting.scad (Commercial Fleet FMVSS 108 Light Packages)
// Core Application: 2027-2028 Silverado MD Roof Marker Pods & Vertical Rear Dually Boxes
// Center Origin (0,0,0) = Geometric Centerpoint of the Rear Taillight Mounting Flange Face
// ====================================================================================

$fn = 100; // Plastic injection tooling path surface resolution finish

// --- Commercial Fleet Lighting Constants (mm) ---
inch_to_mm          = 25.4;
cab_marker_width    = 90.00;              // Aerodynamic roof clearance pods
cab_marker_height   = 35.00;
rear_dually_box_w   = 110.00;             // Heavy stacked rear vertical dually tail lamp box
rear_dually_box_h   = 320.00;             // Deep vertical footprint to match high-walled beds [INDEX]
rear_dually_box_d   = 45.00;

module roof_cab_marker_pods() {
    echo("COMPILING FIVE-POD ROOF CLEARANCE COMMERCIAL MARKER ARRAY");
    color("Amber", 0.6) { // Amber high-transparency visualization lens caps
        difference() {
            // Main teardrop aerodynamic marker shell
            scale([1.5, 1.0, 0.8]) sphere(d=cab_marker_height + 15);
            scale([1.5, 1.0, 0.8]) sphere(d=cab_marker_height + 9);
            // Lower slice plane to mate flush onto the armored roof halo frame [INDEX]
            translate([0, 0, -20]) cube([100, 100, 40], center=true);
        }
    }
}

module vertical_dually_taillight_housing() {
    echo("COMPILING REAR STACKED TRIPLE-LENS VERTICAL DUALLY LIGHT BOXES");
    // Main structural housing casting (Bolts right outside the rear 100mm winch notch) [INDEX]
    color("DarkCharcoal") {
        difference() {
            // Outer stacked light compartment block
            cube([rear_dually_box_w, rear_dually_box_d, rear_dually_box_h], center=true);
            
            // 3-Tier Stacked Partition Windows (Top=Turn/Hazard, Mid=Brake/Tail, Bottom=Reverse)
            for (z_step = [-100, 0, 100]) {
                translate([0, 4, z_step])
                    cube([rear_dually_box_w - 12, rear_dually_box_d, 85], center=true);
            }
            
            // Rear wire trunk pass-through sleeve routing to the logic backplane
            translate([0, -rear_dually_box_d/2 + 2, 0])
                cube([30, 10, 40], center=true);
        }
    }
}

// --- Composite Commercial Light Fixture System Instantiation ---
union() {
    translate([-200, 0, 150]) roof_cab_marker_pods();
    translate()  vertical_dually_taillight_housing();
}
