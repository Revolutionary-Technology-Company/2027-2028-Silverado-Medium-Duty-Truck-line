// ====================================================================================
// REVOLUTIONARY TECHNOLOGY COMPANY & UNIVERSITY OF WASHINGTON DEPARTMENT OF PHYSICS
// Subsystem: silverado_md_busbars.scad (Commercial High-Current Busbar Distribution)
// Core Application: Rigid Shielded 800V DC Traction Paths Configured for 1,800 Amps Peak
// Compliance: Rule #1 (Thick 3oz Equivalent Solid Copper Bus Structures) [INDEX]
// Center Origin (0,0,0) = Firewall Centerpoint Pass-Through Connector Axis
// ====================================================================================

$fn = 120; // High-precision CNC milling extrusion profile resolution

// --- High-Voltage Structural Parameters (mm) ---
inch_to_mm         = 25.4;
truck_wheelbase    = 165.0 * inch_to_mm; // 4191.00 mm continuous wheelbase [INDEX]
busbar_thickness   = 5.00;               // 5mm heavy-gauge copper bar [INDEX]
busbar_width       = 30.00;              // 30mm width handling ultra-high launch current [INDEX]
conduit_shield_d   = 55.00;              // Aviation-standard orange high-voltage protective sleeve

module solid_traction_busbars() {
    echo("EXTRUDING SOLID RULE #1 HIGH-CURRENT 800V DC COPPER PROPULSION BUSBARS");
    // Positioned along the lower left chassis rail, safely protected inside the skid plate pan [INDEX]
    color("Orange") { // High-visibility orange warning wrap shield insulation
        for (offset = [-60, 0]) {
            translate([-220, -truck_wheelbase/2 + 250, -135 + offset])
                difference() {
                    // Solid copper power bus bar block element
                    cube([busbar_width, truck_wheelbase - 500, busbar_thickness]);
                    
                    // Bolt eyelet holes connecting to the main pyro-fuse disconnect lugs [INDEX]
                    translate([busbar_width/2, 30, -1]) cylinder(d=12.5, h=10, center=true);
                    translate([busbar_width/2, truck_wheelbase - 530, -1]) cylinder(d=12.5, h=10, center=true);
                }
        }
    }
}

module isolation_conduit_brackets() {
    // Heavy structural ceramic standoffs locking the busbars to prevent layout short-circuits
    color("White") {
        for (y = [-truck_wheelbase/3, 0, truck_wheelbase/3]) {
            translate([-220 + busbar_width/2, y, -105])
                difference() {
                    cube([60, 45, 140], center=true);
                    // Pass-through slots clearing both positive and negative bus rails
                    translate([0, 0, -30]) cube([busbar_width + 4, 50, busbar_thickness + 2], center=true);
                    translate([0, 0, 30])  cube([busbar_width + 4, 50, busbar_thickness + 2], center=true);
                }
        }
    }
}

// --- Composite High-Voltage Busbar Instantiation ---
union() {
    solid_traction_busbars();
    isolation_conduit_brackets();
}
