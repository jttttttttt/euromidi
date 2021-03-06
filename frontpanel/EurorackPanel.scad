panelThickness = 2;
panelHp=6;
holeCount=2;
holeWidth = 5.08; //If you want wider holes for easier mounting. Otherwise set to any number lower than mountHoleDiameter. Can be passed in as parameter to eurorackPanel()


threeUHeight = 133.35; //overall 3u height
panelOuterHeight =128.5;
panelInnerHeight = 110; //rail clearance = ~11.675mm, top and bottom
railHeight = (threeUHeight-panelOuterHeight)/2;
mountSurfaceHeight = (panelOuterHeight-panelInnerHeight-railHeight*2)/2;

echo("mountSurfaceHeight",mountSurfaceHeight);

hp=5.08;
mountHoleDiameter = 3.2;
mountHoleRad =mountHoleDiameter/2;
hwCubeWidth = holeWidth-mountHoleDiameter;

offsetToMountHoleCenterY=mountSurfaceHeight/2;
offsetToMountHoleCenterX = hp - hwCubeWidth/2; // 1 hp from side to center of hole

echo(offsetToMountHoleCenterY);
echo(offsetToMountHoleCenterX);

module eurorackPanel(panelHp,  mountHoles=2, hw = holeWidth, ignoreMountHoles=false)
{
    //mountHoles ought to be even. Odd values are -=1
    difference()
    {
        cube([hp*panelHp,panelOuterHeight,panelThickness]);
        
        if(!ignoreMountHoles)
        {
            eurorackMountHoles(panelHp, mountHoles, holeWidth);
        }
    }
}

module eurorackMountHoles(php, holes, hw)
{
    holes = holes-holes%2;//mountHoles ought to be even for the sake of code complexity. Odd values are -=1
    eurorackMountHolesTopRow(php, hw, holes/2);
    eurorackMountHolesBottomRow(php, hw, holes/2);
}

module eurorackMountHolesTopRow(php, hw, holes)
{
    
    //topleft
    translate([offsetToMountHoleCenterX,panelOuterHeight-offsetToMountHoleCenterY,0])
    {
        eurorackMountHole(hw);
    }
    if(holes>1)
    {
        translate([(hp*php)-hwCubeWidth-hp,panelOuterHeight-offsetToMountHoleCenterY,0])
    {
        eurorackMountHole(hw);
    }
    }
    if(holes>2)
    {
        holeDivs = php*hp/(holes-1);
        for (i =[1:holes-2])
        {
            translate([holeDivs*i,panelOuterHeight-offsetToMountHoleCenterY,0]){
                eurorackMountHole(hw);
            }
        }
    }
}

module eurorackMountHolesBottomRow(php, hw, holes)
{
    
    //bottomRight
    translate([(hp*php)-hwCubeWidth-hp,offsetToMountHoleCenterY,0])
    {
        eurorackMountHole(hw);
    }
    if(holes>1)
    {
        translate([offsetToMountHoleCenterX,offsetToMountHoleCenterY,0])
    {
        eurorackMountHole(hw);
    }
    }
    if(holes>2)
    {
        holeDivs = php*hp/(holes-1);
        for (i =[1:holes-2])
        {
            translate([holeDivs*i,offsetToMountHoleCenterY,0]){
                eurorackMountHole(hw);
            }
        }
    }
}

module eurorackMountHole(hw)
{
    
    mountHoleDepth = panelThickness+2; //because diffs need to be larger than the object they are being diffed from for ideal BSP operations
    
    if(hwCubeWidth<0)
    {
        hwCubeWidth=0;
    }
    translate([0,0,-1]){
    union()
    {
        cylinder(r=mountHoleRad, h=mountHoleDepth, $fn=20);
        translate([0,-mountHoleRad,0]){
        cube([hwCubeWidth, mountHoleDiameter, mountHoleDepth]);
        }
        translate([hwCubeWidth,0,0]){
            cylinder(r=mountHoleRad, h=mountHoleDepth, $fn=20);
            }
    }
}
}

//Samples
//eurorackPanel(4, 2,holeWidth);
//eurorackPanel(60, 8,holeWidth);

difference() {
eurorackPanel(panelHp, holeCount,holeWidth);

mountHoleDepth = panelThickness+2;
w = hp*panelHp;
off = 9;

//linear_extrude(height = mountHoleDepth) { 
//    translate([w/2-10, panelInnerHeight, -1]) text("Hallo", size=7, halign=center);
//}
    
// led
translate([w/2, 13,-1])  cylinder(d=3.3, h=mountHoleDepth, $fn=20); 
// switch
translate([w/2, 23,-1])  cylinder(d=6.5, h=mountHoleDepth, $fn=20); 
// pot
translate([w/2, 35,-1])  cylinder(d=7.5, h=mountHoleDepth, $fn=50); 

// jacks
translate([w/2, 55,-1])  cylinder(d=6.5, h=mountHoleDepth, $fn=20); 
translate([w/2, 65,-1])  cylinder(d=6.5, h=mountHoleDepth, $fn=20); 
translate([w/2, 75,-1])  cylinder(d=6.5, h=mountHoleDepth, $fn=20); 
translate([w/2, 85,-1])  cylinder(d=6.5, h=mountHoleDepth, $fn=20); 
translate([w/2, 95,-1])  cylinder(d=6.5, h=mountHoleDepth, $fn=20); 
translate([w/2, 105,-1])  cylinder(d=6.5, h=mountHoleDepth, $fn=20); 
translate([w/2, 115,-1])  cylinder(d=6.5, h=mountHoleDepth, $fn=20); 
}

translate([3,(panelOuterHeight)/2,-1]) cube([2, panelInnerHeight-10, 5], center=true);
translate([3,84,-10]) cube([2, 15, 15], center=true);
translate([3,42,-10]) cube([2, 15, 15], center=true);