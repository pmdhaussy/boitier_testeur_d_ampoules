$fn=360;
width=175;
height=130;
depth=50;
wall_thickness=2;
bottom_thickness=2;
roundness=3;

recess_depth=5;
recess_width=1;

support_diameter=6;
support_hole_diameter=3;
support_offset=support_diameter-2;

cover_depth=recess_depth+2;
cover_thickness=2;

cover_accessory_top_row=height*0.72;
cover_accessory_bottom_row=height*0.27;
cover_accessory_first_column=width*0.2;
cover_accessory_second_column=width*0.5;
cover_accessory_third_column=width*0.8;

box();
translate([0, 0, 70])
    cover();


module box() {
    difference() {
        // Box exterior
        roundXYBox([width, height, depth], radius=roundness);
        
        // Box interior
        translate([wall_thickness, wall_thickness, bottom_thickness])
            cube([width-2*wall_thickness, height-2*wall_thickness, depth]);

        // Edge recess
        difference() {
            translate([-1, -1, depth-recess_depth])
                cube([width+2, height+2, recess_depth+2]);
            translate([recess_width, recess_width, depth-recess_depth])
                roundXYBox([width-2*recess_width, height-2*recess_width, depth], radius=roundness);
        }

        // Main cord hole
        translate([-5, height*0.75, depth*0.25])
            rotate([0, 90, 0])
                cylinder(10, 3, 3);
        // Banana plugs
        translate([width-5, height/2-(19/2), depth*0.6])
            rotate([0, 90, 0])
                banana_socket_body();
        translate([width-5, height/2+(19/2), depth*0.6])
            rotate([0, 90, 0])
                banana_socket_body();
        translate([width-5, height/2, depth*0.3])
            rotate([0, 90, 0])
                banana_socket_body();
    }
    
    // Support poles
    translate([support_offset, support_offset, 0])
        fixation_pole();
    translate([width-support_offset, support_offset, 0])
        fixation_pole();
    translate([support_offset, height-support_offset, 0])
        fixation_pole();
    translate([width-support_offset, height-support_offset, 0])
        fixation_pole();
}

module fixation_pole() {
    difference() {
        cylinder(depth, support_diameter/2, support_diameter/2);
        translate([0, 0, 0.1])
            cylinder(depth + 0.2, support_hole_diameter/2, support_hole_diameter/2);
    }
}


module cover() {
    difference() {
        roundXYBox([width, height, cover_depth], radius=roundness);
        translate([recess_width, recess_width, -1])
            roundXYBox([width-2*recess_width, height-2*recess_width, recess_depth+1], radius=roundness);

        // Fixation holes
        translate([support_offset, support_offset, 0])
            fixation_hole();
        translate([width-support_offset, support_offset, 0])
            fixation_hole();
        translate([support_offset, height-support_offset, 0])
            fixation_hole();
        translate([width-support_offset, height-support_offset, 0])
            fixation_hole();

        // Accessories holes
        // Lamps
        translate([cover_accessory_first_column, cover_accessory_top_row, 0])
            cylinder(cover_depth+1, 5, 5);
        translate([cover_accessory_second_column, cover_accessory_top_row, 0])
            cylinder(cover_depth+1, 5, 5);
        translate([cover_accessory_third_column, cover_accessory_top_row, cover_depth-1])
            cylinder(cover_depth+1, 5, 5);
        // Serie/Off/Parallel switch
        translate([cover_accessory_first_column, cover_accessory_bottom_row, 0])
            cylinder(cover_depth+1, 5.505, 5.505);
            // TODO remove pin
        // Permanent switch
        translate([cover_accessory_second_column, cover_accessory_bottom_row, 0])
            cylinder(cover_depth+1, 6, 6);
        // Momentary switch
        translate([cover_accessory_third_column, cover_accessory_bottom_row, 0])
            cylinder(cover_depth+1, 9.5, 9.5);
            
    }
}

module fixation_hole() {
    translate([0, 0, cover_depth-1])
        cylinder(cover_depth-1, support_diameter/2, support_diameter/2);
    cylinder(cover_depth + 0.2, support_hole_diameter/2, support_hole_diameter/2);
}

module banana_socket_body() {
    difference() {
        cylinder(21, 6, 6);
        translate([-6, -6, -0.1])
            cube([0.5, 12, 21.2]);
        translate([5.5, -6, -0.1])
            cube([0.5, 12, 21.2]);
    }
}

module roundXYBox(size, center=false, radius=0.5) {
    translate([radius, radius, 0])
        minkowski() {
            cube(size = [
                size[0] - (radius * 2),
                size[1] - (radius * 2),
                size[2] - 1
            ]);
            cylinder(h=1, r=radius);
        }
}
