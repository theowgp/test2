/*
Lord of the flies
 Motion Detection from webcamera for interactive art
 
 Licensed under Creative Commons 2.0. https://creativecommons.org/licenses/by-sa/2.0/ca/
 Free to resuse as is or with modification in any non-commercial content.
 You must give appropriate credit, provide a link to the license  and indicate if changes were made. 
 
 Author: Marta Kryven
 Required libraries: Video for Processing
 */
 

import ddf.minim.*;

AudioPlayer player;
Minim minim;//audio context
 
//bird frames
PImage[] frms = new PImage[4];

//background picture
PImage bg;

float w = 640;
float h = 480;

// constraining the range(and velocity range) at which birds can move at a time
float floater_xr = 10;
float floater_yr = 10;
float floater_vr = 10;


//independent movement's laws
float floater_cr = 10;//repulsion range
float floater_crf = 7;//repulsion force
float floater_ca = 40;//attraction range
float bird_sight = 100;
float floater_caf = 5;//attraction force

float dforce_repulsion(float d){
  return (-d/floater_cr + 1);
}
float dforce_attraction(float d){
  return ( (d-floater_ca)/(w+h-floater_ca) );
}
float vforce(float vxa, float vya, float vxb, float vyb){
 float cosab = (float)((vxa*vxb+vya*vyb)/Math.sqrt((vxa*vxa+vya*vya)*(vxb*vxb+vyb*vyb)));
 return (1-cosab)/2;
  
}





// an array of birds
floater[] floaters = new floater[10];

void setup() {
  
  minim = new Minim(this);
  player = minim.loadFile("bm.mp3", 2048);
  player.play();
  
  //background
  bg = loadImage("bg1.jpg");
  bg.resize((int)w, (int)h);
  
  frms[0] = loadImage("f1.png");
  frms[1] = loadImage("f2.png");
  frms[2] = loadImage("f3.png");
  frms[3] = loadImage("f4.png");

  size(640, 480);
  background(bg);
  frameRate(30);
  noFill(); 
  stroke(0);
  strokeWeight(1);


  // creating birds
  for (int i = 0; i < floaters.length; i++) {
    floaters[i] = new floater();
  }
}


void draw() {
  background(bg );
  
 
  for (int i = 0; i < floaters.length; i++) {
    floaters[i].determine_velocity(i);
  }
  
  for (int i = 0; i < floaters.length; i++) {
   
    floaters[i].move();
    floaters[i].draw();
  }
}


void mouseDragged()  {
  for (int i = 0; i < floaters.length; i++) {
      floaters[i].vx = floaters[i].addd(floaters[i].vx, /*floater_vr*/(mouseX-floaters[i].x)/dist(mouseX, mouseY, floaters[i].x, floaters[i].y));
      floaters[i].vy = floaters[i].addd(floaters[i].vy, /*floater_vr*/(mouseY-floaters[i].y)/dist(mouseX, mouseY, floaters[i].x, floaters[i].y));
   }
}

void mouseClicked()  {
  for (int i = 0; i < floaters.length; i++) {
      floaters[i].vx = floaters[i].addd(floaters[i].vx, /*floater_vr*/(mouseX-floaters[i].x)/dist(mouseX, mouseY, floaters[i].x, floaters[i].y));
      floaters[i].vy = floaters[i].addd(floaters[i].vy, /*floater_vr*/(mouseY-floaters[i].y)/dist(mouseX, mouseY, floaters[i].x, floaters[i].y));
   }
}





// ----------------------------------------------------------------


class floater {
  float x; 
  float y; // location
  float vx; 
  float vy; // velocities
  float s; // size
  
  int i;
  int frameCounter;

  floater() {
    x = (int)random(100, width-100);
    y = (int)random(100, height-100);
    vx = random(-floater_vr, floater_vr);
    vy = random(-floater_vr, floater_vr);
    //s = (floater_ca + floater_ca)/2;
    s = 50;
    
    i = (int)random(4);
    frameCounter = 0;
  }

  void move() {

    float ddx = 0;
    float ddy = 0;
    
 
   
    //jiggling
    //ddx += random(-floater_xr/2, floater_xr/2);
    //ddy += random(-floater_yr/2, floater_yr/2);

    //if ( x + ddx > 10 && x + ddx < w - 10) x+=ddx;
    //if ( y + ddy > 10 && y + ddy < h - 10) y+=ddy;
    
    
    
    //if ( x + ddx + vx > s && x + ddx + vx < w - s) x +=  vx + ddx;
    //if ( y + ddy + vy > s && y + ddy + vy < h - s) y +=  vy + ddy;
    
    x += vx;
    y += vy;
    
    if(x<=0) x = w-1;
    if(x>=w) x = 0;
    if(y<=0) y = h-1;
    if(y>=h) y = 0;
    
        
  }
  
  
  
  
  void determine_velocity(int j){
    //determine relative velocities
    for (int i = 0; i < floaters.length; i++) {
      if (i!=j){//doesn't consider itself
        float d   = dist(floaters[i].x, floaters[i].y, x, y);//(float)( Math.sqrt( (floaters[i].x-x)*(floaters[i].x-x) + (floaters[i].y-y)*(floaters[i].y-y) ) );
        //repulsion
        if(d <= floater_cr){
          //if(Math.abs(floaters[i].x-x)<=Math.abs(floaters[i].y-y)){
          // if(floaters[i].x >= x) 
          // //vx -= floater_crf * vforce(-1, 0, vx, vy) * dforce_repulsion(d);
          // vx = addd(vx, -floater_crf * vforce(-1, 0, vx, vy) * dforce_repulsion(d));
          // else 
          //   //vx += floater_crf * vforce(1, 0, vx, vy) * dforce_repulsion(d);
          //   vx = addd(vx, floater_crf * vforce(1, 0, vx, vy) * dforce_repulsion(d));
          //}
          //else{
          // if(floaters[i].y >= y) 
          //   //vy -= floater_crf * vforce(0, -1, vx, vy) * dforce_repulsion(d);
          //   vy = addd(vy, -floater_crf * vforce(0, -1, vx, vy) * dforce_repulsion(d));
          //   else  
          //     //vy += floater_crf * vforce(0, 1, vx, vy) * dforce_repulsion(d);     
          //     vy = addd(vy, floater_crf * vforce(0, 1, vx, vy) * dforce_repulsion(d));
          //}
          vx = addd(vx, -((floaters[i].x-x)/d) * floater_crf * dforce_attraction(d));
          vy = addd(vy, -((floaters[i].y-y)/d) * floater_crf  * dforce_attraction(d));
          
        }
        else//attraction
        //if(d >= floater_ca && d <= floater_ca + bird_sight){
        if(d <= floater_ca){
          //if(Math.abs(floaters[i].x-x)>=Math.abs(floaters[i].y-y)){
          // if(floaters[i].x >= x) 
          //   //vx += floater_caf * vforce(1, 0, vx, vy) * dforce_attraction(d);
          //   vx = addd(vx, floater_caf * vforce(1, 0, vx, vy) * dforce_attraction(d));
          //   else 
          //     //vx -= floater_caf * vforce(-1, 0, vx, vy) * dforce_attraction(d);
          //     vx = addd(vx, -floater_caf * vforce(-1, 0, vx, vy) * dforce_attraction(d));
          //}
          //else{
          // if(floaters[i].y >= y) 
          //  //vy += floater_caf * vforce(0, 1, vx, vy) * dforce_attraction(d);
          //  vy = addd(vy, floater_caf * vforce(0, 1, vx, vy) * dforce_attraction(d));
          //  else 
          //    //vy -= floater_caf * vforce(0, -1, vx, vy) * dforce_attraction(d);     
          //    vy = addd(vy, -floater_caf * vforce(0, -1, vx, vy) * dforce_attraction(d));
          //}
          vx = addd(vx, ((floaters[i].x-x)/d) * floater_caf * dforce_attraction(d));
          vy = addd(vy, ((floaters[i].y-y)/d) * floater_caf  * dforce_attraction(d));
        }
          
      }
    }
 }
 
float addd(float a, float b){
   if(Math.abs(a + b) < floater_vr){
     return a+b;
   }
   else{
     if( a+b <= 0 ) return -floater_vr;
     else return floater_vr;
   }
 }
 
 
 



  void draw() {
    stroke(255);
    //ellipse(x, y, s, s);
    
    image(frms[i], x, y, s, s);
    frameCounter++;

    if (frameCounter > 8) {
      frameCounter=0;
      i++;
    }

    if (i == 3) i = 0;
  }
}