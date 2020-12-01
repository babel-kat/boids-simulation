import toxi.audio.*;
import toxi.geom.*;

import peasy.*;

PeasyCam cam;

int boidCount = 200;
ArrayList<Boid> boids = new ArrayList<Boid>();

float worldSize = 2000;

float collisionRad, cohesionRad, alignRad;

Gravity center;

;void setup() {
  size(1000, 1000, P3D);
  
  cam = new PeasyCam(this, 500);
  
  float boidRad = 0;
  for (int i = 0; i < boidCount; i++) {
    //create boids
    boidRad = random(3, 15);
    Boid b = new Boid(random(-worldSize/2, worldSize/2), random(-worldSize/2, worldSize/2), random(-worldSize/2, worldSize/2), boidRad);
    boids.add(b);
  }
  
  center = new Gravity(0, 0, 0, 2);
}

void draw() {
  background(0);
  fill(255, 0, 0);
  stroke(255, 0, 0);
  //Center
  sphere(2);
  //As boid - attractor
  
  fill(220);
  // Draw world as Box
  //noFill();
  //stroke(0);
  //box(worldSize);
  
  //dots
  for(int i = -20; i < 20; i++){
    for (int j = -20; j < 20; j ++){
      for (int k = -10; k < 10; k++) {
        stroke(random(20, 150));
        point(i * 50 + random(-30, 30), j * 50 + random(-30, 30), k * 60 + random(-30, 30));
      }
    }
  
  }
  
  //check relations
  for (int i = 0; i < boidCount; i++) {
    Boid b1 = boids.get(i);
    for (int j = 0; j < i; j++) {
      Boid b2 = boids.get(j);
      float d = b1.position.distanceTo(b2.position); // distance b1, b2
      b1.calcForces(b2, d);
    }
  }
  
  for (Boid b : boids) {
    b.finishForceCalculations();
    b.update();
    b.display();
  }
  
}
