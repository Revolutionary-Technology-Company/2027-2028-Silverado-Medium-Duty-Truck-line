// ====================================================================================
// REVOLUTIONARY TECHNOLOGY COMPANY & UNIVERSITY OF WASHINGTON DEPARTMENT OF PHYSICS
// Subsystem: silverado_md_dash_components.scad (Motorized Fleet Control Displays)
// Core Application: Deploys Driver Instrument Cluster & Co-Pilot Upfit Console
// Center Origin (0,0,0) = Firewall Center point along Steering Axis
// ====================================================================================

$fn = 120; // High-precision CNC milling and dashboard molding resolution

// --- Parametric Geometric Boundaries (mm) ---
inch_to_mm         = 25.4;
standard_dash_w    = 54.0 * inch_to_mm; // 1371.6 mm interior cabin cross-width [INDEX]
driver_pod_dia     = 133.35;            // Authentic dual-pod pod diameter [INDEX]
copilot_panel_w    = 280.00;            // Extended 11-inch heavy upfit command display

// Motorized Drawer Track Slide Offset (0 = Retracted inside glovebox, 240 = Deployed)
GLOVEBOX_DEPLOY_MM = 240.00; 

module driver_analog_led_pods() {
    echo("COMPILING SILVERADO MD DRIVER ANALOG-LED DUAL POD HOUSINGS");
    // Left and Right circular pods tracking speed and Mega-Flux stator RPM [INDEX]
    color("DarkCharcoal") {
        for (offset = [-90, 90]) {
            translate([-standard_dash_w/4 + offset, 45, 20]) {
                difference() {
                    cylinder(d=driver_pod_dia, h=65, center=true);
                    translate([0, 0, 4])
                        cylinder(d=driver_pod_dia - 8, h=60, center=true); // Internal viewport hollow
                }
            }
        }
    }
}

module motorized_copilot_upfit_console() {
    echo("COMPILING EXTENSIVE CO-PILOT INDUSTRIAL UPFIT COMMAND WORKSTATION");
    // Heavy dual linear roller tracks sliding straight out from the passenger glovebox frame
    translate([standard_dash_w/4 - copilot_panel_w/2, 45 - GLOVEBOX_DEPLOY_MM, -30]) {
        color("Silver") {
            translate([-15, -45, 10]) cube([15, GLOVEBOX_DEPLOY_MM + 50, 15]);
            translate([copilot_panel_w, -45, 10]) cube([15, GLOVEBOX_DEPLOY_MM + 50, 15]);
        }
        
        // Co-Pilot Multi-Mux Command Interface Frame
        color("DimGrey") {
            difference() {
                // Main monitor structural housing cube
                cube([copilot_panel_w, 35, 200]);
                // Viewport display window cutout face
                translate([10, -1, 10])
                    cube([copilot_panel_w - 20, 38, 180]);
            }
        }
        
        // Lower Dedicated Hardware Button Bar
        // Replicates 1969 tactile toggle switches to actuate heavy hydraulics/winches natively
        color("Black") {
            translate([0, 0, -35])
                cube([copilot_panel_w, 45, 30]);
        }
    }
}

// --- Composite Display Matrix Instantiation ---
union() {
    driver_analog_led_pods();
    motorized_copilot_upfit_console();
}
