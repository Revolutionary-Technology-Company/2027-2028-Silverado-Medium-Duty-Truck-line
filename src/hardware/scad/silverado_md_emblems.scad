// ====================================================================================
// REVOLUTIONARY TECHNOLOGY COMPANY & UNIVERSITY OF WASHINGTON DEPARTMENT OF PHYSICS
// Subsystem: silverado_md_emblems.scad (2027 Silverado HD Commercial Trim Matrix)
// Core Application: Stamped Billet Emblems and Modular Grille Cross-Bar Panels
// Center Origin (0,0,0) = Geometric Centerpoint of the Front Grille Cross-Bar Face
// ====================================================================================

$fn = 100; // High-precision tooling path and stamping profile resolution

// --- Fleet Trim Configurator ---
// 1 = High Country HD (Chrome Script), 2 = ZR2 Bison (Matte Black Block CHEVROLET), 3 = Work Truck (Debossed Polymer)
FLEET_TRIM_SELECTOR = 2;

// --- Physical Dimensional Constants (mm) ---
inch_to_mm         = 25.4;
grille_bar_width   = 82.0 * inch_to_mm;  // Spans the full front clip width natively [INDEX]
grille_bar_height  = 145.00;             // Vertical height matching the main split-bar trim
lettering_depth    = 8.00;               // Thick billet stamping profile relief

module multi_trim_grille_crossbar() {
    echo(str("COMPILING SILVERADO MD FASCIA ACCENTS TRIM INDEX: ", 
        (FLEET_TRIM_SELECTOR == 1) ? "HIGH_COUNTRY_CHROME_SCRIPT" : 
        (FLEET_TRIM_SELECTOR == 2) ? "ZR2_BISON_MATTE_BLOCK" : "WORK_TRUCK_POLYMER_BASE"));
        
    // Central horizontal split-bar trim panel wrapping the front clip grid [INDEX]
    color((FLEET_TRIM_SELECTOR == 1) ? "Silver" : 
          (FLEET_TRIM_SELECTOR == 2) ? "DarkCharcoal" : "Black") {
        difference() {
            // Main horizontal trim bar raw block
            cube([grille_bar_width - 120, grille_bar_height, 25.0], center=true);
            
            // Integrated debossed block lettering channels cut directly into the polymer face if WT spec
            if (FLEET_TRIM_SELECTOR == 3) {
                translate([0, 0, 10])
                    cube([grille_bar_width - 400, grille_bar_height - 40, lettering_depth], center=true);
            }
        }
    }
}

module stamped_chevrolet_block_letters() {
    // Recreates the bold stamped block lettering fixed across the grille center plane
    if (FLEET_TRIM_SELECTOR == 2) {
        color("Black") { // Low-glare matte black tactical finish
            translate([0, 0, 14]) {
                // Central horizontal structural core stringer linking the block lettering faces
                cube([grille_bar_width - 360, 45.0, 4.0], center=true);
                
                // Parametric Lettering Anchor Tabs (Mates with backing mesh slots) [INDEX]
                for (x = [-grille_bar_width/4 : 120 : grille_bar_width/4]) {
                    translate([x, 0, -6])
                        cylinder(d=6.5, h=12, center=true);
                }
            }
        }
    }
}

module premium_high_country_scripts() {
    // Models the intricate High Country door script and backing plates [INDEX]
    if (FLEET_TRIM_SELECTOR == 1) {
        color("Gold") { // Polished bronze/gold accent trim configurations
            translate([0, 0, 15]) {
                difference() {
                    cube([450.0, 55.0, 8.0], center=true);
                    translate([0, 0, -2]) cube([440.0, 45.0, 8.0], center=true); // Script silhouette relief
                }
            }
        }
    }
}

// --- Composite Front Trim Instantiation ---
union() {
    multi_trim_grille_crossbar();
    stamped_chevrolet_block_letters();
    premium_high_country_scripts();
}
