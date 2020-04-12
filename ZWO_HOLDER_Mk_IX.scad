        echo(version=version());
        
        // Holder for ZWO ASI 224 MC camera, and a stepper-motor, with baseplate
        // Peter Thejll, peter.thejll@gmail.com, March 2019.
        
        // Universals
        epsilon=0.05; // Small clearance to build in
        
        ID = 62.45;    // Camera body diameter
        wall = 2.1;  // Wall thickness of parts
        OD = (ID+2*wall)/2;  // Outer diameter of camera holder
        body_height = 28.1+epsilon+0.4 ; // Height of the red ZWO ASI224 to the first ledge
        kerf = 12.2; // height of step on red body up to movable lens-part 
        aperture=51; // Diameter of ledge with lens
        port=15; // width and height of USB port
        screws=3.15; // Diameter of screw-holes to be used for clip
        offset=-6+9; // Distance below ledge of clip top
        motor_h1=10; // Height of the clip part
        motor_D=14.9+0.4; // Diameter of the stepper motor body
        gap=wall/3; // Gap in the lips of the clip holding camera
       
       // fudge
        magic=40.55-(ID+wall+motor_D)/2;
        
        difference(){
        // Do the camera-holder first
            co();
        // Now make port holes in it - first one
                translate([ID/2,0,-0.01])
                    linear_extrude(height=port+2)
                    square([port,port], center = true);
        // Then the second one at right angles
                translate([0,ID/2,-0.01])
                    linear_extrude(height=port+2)
                    square([port,port], center = true);
        // Then the third one at right angles
        translate([0,-ID/2,-0.01])
            linear_extrude(height=port+2)
            square([port,port], center = true);
            
    // Now also some gaps at the top edge
        // Nfirst one
    //            translate([ID/2,0,body_height])
    //                linear_extrude(height=port+2)
    //                square([port,port/3], center = true);
        // Then the second one at right angles
    //            translate([0,ID/2,body_height])
    //                linear_extrude(height=port+2)
    //                square([port/3,port], center = true);
        // Then the third one at right angles
    //    translate([0,-ID/2,body_height])
     //       linear_extrude(height=port+2)
     //       square([port/3,port], center = true);      
            
// Subtract a 90 degree cylinder  
rotate(a=90,v=[1,0,0]) 
rotate(a=90,v=[0,1,0]) 
translate([0,body_height-10,+15])
cylinder(h=1000,r=7.5);
// Subtract another cylinder  
rotate(a=90,v=[1,0,0]) 
rotate(a=180,v=[0,1,0]) 
translate([0,body_height-10,-35])
cylinder(h=1000,r=7.5); 

        }
        
        
        // And then add the clip
  //     translate([-ID/2-motor_D/2-wall-0.6,
         translate([-(ID+wall+motor_D)/2-magic,
                        0,
                        body_height+kerf-motor_h1-offset-3.5])
         rotate(a=180,v=[0,0,1])
            clip(motor_D/2,wall,motor_h1,screws);
        
        //=================================================================
        // Define a bunch of modules
        
        module clip_part(motor_D,wall,motor_h1){
               
        // Extrude a cylinder
            color("green")
            translate([0, 0, 0])
                rotate_extrude($fn = 100)
                    polygon( points=[
                    [motor_D,0],
           [motor_D+wall,0],
           [motor_D+wall,motor_h1],
           [motor_D,motor_h1],
           [motor_D,0] 
        ]);
        // The 'tabs'
            translate([0,0,0])
            linear_extrude(height=motor_h1)
               polygon( points=[
                    [motor_D,-wall],
                     [motor_D+4*wall,-wall],         
                     [motor_D+4*wall,wall],
                              [motor_D,wall],
                   [motor_D,-wall]
                    ]);
             };
            
        module wall(gap){

            r=motor_D/2;
            translate([0,0,-motor_h1/3])
            linear_extrude(height=2*motor_h1)
               polygon( points=[
                     [0,-gap],
                     [3*r,-gap],         
                     [3*r,gap],
                     [0,gap],
                     [0,-gap]
                    ]);   
            
            };
            
         module hole(screws){
             r=motor_D/2;
             translate([r+wall*2,-10,motor_h1/2])
             rotate(a=-90,v=[1,0,0]) cylinder(d=screws,h=500,centre=true);   
             };
        
        
         // Now for the difference of the co and a wall
             
        module clip(r,wall,motor_h1,screws){
            difference(){
                // Between
                clip_part(r,wall,motor_h1);
                // and ..
                wall(gap);     
                hole(screws); 
             }
         };
         
        
        module co(){
        // Shroud
        color("green")
            translate([0, 0, 0])
                rotate_extrude($fn = 100)
                    polygon( points=[
                    [ID/2.,0], 
                    [ID/2.,body_height], 
                    [ID/2.-(ID/2-aperture/2),body_height], 
                    [ID/2.-(ID/2-aperture/2),body_height+kerf],
                    [ID/2.+wall,body_height+kerf],
                    [ID/2.+wall,0]
                    ]);
           
        
         // Subtract a cylinder from a baseplate to allow for camera insert
        
            difference() {
         // Baseplate          
            color("red")
            translate([0, 0, 0])
                    linear_extrude(height =wall)
                    square([ID+wall*2-1.4,ID+wall*2-1.4], center = true);
        
        // Hole in baseplate for camera insert
                translate([0,0,-0.1]) cylinder(d=ID, h=9.002, center=true);
        // Mounting holes
                translate([29,29,-0.1]) cylinder(d=screws,h=10,centre=true);
                translate([-29,29,-0.1]) cylinder(d=screws,h=10,centre=true);
                translate([29,-29,-0.1]) cylinder(d=screws,h=10,centre=true);
                translate([-29,-29,-0.1]) cylinder(d=screws,h=10,centre=true);
                
        
            }
        }    
                 