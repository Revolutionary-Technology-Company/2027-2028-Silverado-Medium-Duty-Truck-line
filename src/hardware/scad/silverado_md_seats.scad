// ====================================================================================
// REVOLUTIONARY TECHNOLOGY COMPANY & UNIVERSITY OF WASHINGTON DEPARTMENT OF PHYSICS
// Subsystem: silverado_md_seats.scad (Heavy-Duty Ergonomic Seating Framing)
// Core Application: GM High-Tonnage Structural Seats / Bose Headrest Cavities
// Center Origin (0,0,0) = Geometric Centerpoint of the Lower Seat Adjustment Track
// ====================================================================================

$fn = 100; // High-fidelity injection toolpath and stamping resolution finish

// --- Commercial Fleet Seating Dimensional Constants (mm) ---
inch_to_mm         = 25.4;
seat_cushion_w     = 22.0 * inch_to_mm;   // 558.8 mm broad driver support platform
seat_cushion_d     = 20.0 * inch_to_mm;   // 508.0 mm longitudinal thigh support depth
backrest_height    = 850.00;              // High-back profile protecting neck junctions
cushion_thickness  = 120.00;             // High-density poly-foam dampening depth

module structural_seat_bottom_cushion() {
    echo("COMPILING GM FLEET PARAMETRIC SEATING MATRIX: RETENTION TRACKS AND BOLSTERS");
    // Lower cushion support base (Bolts right into the armored cabin floor pan) [INDEX]
    color("DarkCharcoal") {
        difference() {
            // Main seating bottom foam/frame block
            cube([seat_cushion_w, seat_cushion_d, cushion_thickness], center=true);
            
            // Left and Right structural thigh bolster contour relief paths
            for (side = [-1, 1]) {
                translate([side * (seat_cushion_w/2 - 20), 0, cushion_thickness/2])
                    scale([1, 1.5, 0.5]) sphere(r=40);
            }
        }
    }
}

module highback_ergonomic_backrest() {
    // Vertical backrest core with integrated deep torso support contours
    color("DimGrey") {
        translate([0, seat_cushion_d/2 - 30, backrest_height/2 - cushion_thickness/2]) {
            difference() {
                // Main vertical back support shell
                cube([seat_cushion_w - 10, 140.0, backrest_height], center=true);
                
                // INTEGRATED BOSE AUDIO HEADREST TERMINAL CAVITY
                // Pre-cut enclosure pocket to mount the twin Neodymium speech transducers [INDEX]
                translate([0, 40, backrest_height/2 - 100])
                    cube([320.0, 80.0, 120.0], center=true); 
            }
        }
    }
}

module titanium_mounting_slider_rails() {
    // Heavy dual adjustment rail runners that lock directly into the frame cross-beams [INDEX]
    color("Silver") {
        for (side = [-1, 1]) {
            translate([side * (seat_cushion_w/2 - 40), 0, -cushion_thickness/2 - 15]) {
                difference() {
                    cube([30.0, seat_cushion_d + 60, 30.0], center=true);
                    // Fastener channels to pass heavy Grade 10.9 structural locking hardware
                    translate([0, -seat_cushion_d/2, 0]) rotate([90, 0, 0]) cylinder(d=10.5, h=40, center=true);
                    translate([0, seat_cushion_d/2, 0])  rotate([90, 0, 0]) cylinder(d=10.5, h=40, center=true);
                }
            }
        }
    }
}

// --- Composite Seating Platform Instantiation ---
union() {
    structural_seat_bottom_cushion();
    highback_ergonomic_backrest();
    titanium_mounting_slider_rails();
}
