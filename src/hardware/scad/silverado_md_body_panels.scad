// ====================================================================================
// REVOLUTIONARY TECHNOLOGY COMPANY & UNIVERSITY OF WASHINGTON DEPARTMENT OF PHYSICS
// Subsystem: silverado_md_body_panels.scad (2027 Silverado HD Exterior Shell Matrix)
// Core Application: Replicates GM 2027-2028 Premium Exterior Shell Geometries
// COMPLIANCE GATE: Leaves a mandatory 65mm vertical open clearance for underbody armor
// Center Origin (0,0,0) = Firewall Structural Interface on the Driveline Axis
// ====================================================================================

$fn = 100; // Parametric curve panel surface finish resolution

// --- 2027 Silverado HD Commercial Constants (mm) ---
inch_to_mm          = 25.4;
truck_wheelbase     = 165.0 * inch_to_mm; // 4191.00 mm continuous wheelbase alignment [INDEX]
body_width_front    = 82.00 * inch_to_mm; // Front fender broad tracking stance
body_width_rear     = 94.00 * inch_to_mm; // 2387.60 mm flanged rear dually fender width [INDEX]
sheet_metal_thick   = 1.50;               // Heavy fleet-gauge stamped steel skin scale

// UNDERBODY COMPLIANCE CLEARANCE VECTOR
UNDER_ARMOR_CLEARANCE_MM = 65.00; // 65mm open space left below the lower frame step

module stamped_front_clip_assembly() {
    echo("STAMPING 2027 CHEVY SILVERADO HD EXTERIOR PANEL MASK");
    // Main front dual-rising cowl induction hood and dual-fender quarter panel skins
    color("LightSteelBlue") {
        difference() {
            // Front clip exterior boundary envelope
            translate([0, truck_wheelbase/3, 300])
                cube([body_width_front, 1400, 750], center=true);
            
            // Hollow interior engine bay core clearance cavity [Clears Mega-Flux Motor] [INDEX]
            translate([0, truck_wheelbase/3, 300])
                cube([body_width_front - 30, 1404, 730], center=true);
                
            // LOWER CHASSIS STANDOFF: Cuts away the base profile to preserve armor space [INDEX]
            translate([0, truck_wheelbase/3, -50])
                cube([body_width_front + 10, 1410, UNDER_ARMOR_CLEARANCE_MM * 3], center=true);
                
            // 7-INCH ROUND HEADLIGHT BUCKETS: Sockets cut into front fascia for H4 conversion lights [INDEX]
            for (side = [-1, 1]) {
                translate([side * (body_width_front/2 - 120), 1400/2 + truck_wheelbase/3 - 5, 420])
                    rotate([-90, 0, 0])
                        cylinder(d=177.8, h=40, center=true); // Exactly 7.00 inches diameter [INDEX]
            }
        }
    }
}

module premium_crew_cab_shell() {
    // Structural passenger cabin outer shell spanning over the active steering firewall [INDEX]
    color("SlateGrey") {
        difference() {
            // Main cab exterior dimension block
            translate([0, -400, 650])
                cube([body_width_front, 1850, 1100], center=true);
            // Hollow inner cockpit cave [Leaves space for OtterBox dashboard console] [INDEX]
            translate([0, -400, 650])
                cube([body_width_front - 40, 1830, 1060], center=true);
                
            // LOWER CABINET ARMOR STRIP OVERRIDE (Rule Compliance)
            translate([0, -400, 100])
                cube([body_width_front + 10, 1860, UNDER_ARMOR_CLEARANCE_MM * 2], center=true);
        }
    }
}

module flanged_dually_rear_wheel_arches() {
    // Stamped high-walled exterior fender skins wrapping over the dually tires [INDEX]
    for (side = [-1, 1]) {
        scale([side, 1, 1])
            translate([body_width_rear/2 - 20, -truck_wheelbase/3 - 100, 220]) {
                color("LightSteelBlue") {
                    difference() {
                        // Flanged flared wheel arch bulge block
                        scale([1.2, 1.8, 1.1]) sphere(r=440);
                        scale([1.2, 1.8, 1.1]) sphere(r=440 - sheet_metal_thick);
                        
                        // Lower cut plane preserving the 65mm under-armor installation gap [INDEX]
                        translate([0, 0, -380])
                            cube([900, 1200, UNDER_ARMOR_CLEARANCE_MM * 4], center=true);
                    }
                }
            }
    }
}

// --- Compile Parametric Stamped 2027 Skin Matrix ---
union() {
    stamped_front_clip_assembly();
    premium_crew_cab_shell();
    flanged_dually_rear_wheel_arches();
}
