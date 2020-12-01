class Boid{
  
  Vec3D position, velocity, acceleration;
  Vec3D gravityForce, rotationForceY;
  Vec3D mouseSeparation;
  
  Vec3D collisionForce;
  int collisionCount;
  
  Vec3D cohesionForce;
  int cohesionCount;
  Vec3D averageGroupPos;
  
  Vec3D alignForce;
  int alignCount;
  
  Vec3D rotationalForce;
  
  float boidRad;
  float collisionRad, cohesionRad, alignRad;
  
  Boid(float x, float y, float z, float _boidRad){
    position = new Vec3D(x, y, z); 
    boidRad = _boidRad;
    
    // preset position
    velocity = new Vec3D(random(-1, 1), random(-1, 1), random(-1, 1));    // give random orientation
    velocity.normalize();                                                 // make unit vector, start from 1
    acceleration = new Vec3D();
    
    gravityForce = new Vec3D();
    
    collisionRad = 2 * boidRad;
    cohesionRad = 6 * boidRad; 
    alignRad =  8 * boidRad;
    
    collisionForce = new Vec3D();            
    collisionCount = 0;
  
    cohesionForce = new Vec3D();      
    cohesionCount = 0;
    averageGroupPos = new Vec3D();
  
    alignForce = new Vec3D();
    alignCount = 0;
    
    rotationForceY = new Vec3D();
    mouseSeparation = new Vec3D();
  }
  
  void calcForces(Boid other, float d){
    // align > cohesion > collision distance
    if (d < (this.alignRad + other.alignRad)){  // alignRad * 2 (from this boid center to other) 
      if (d < (this.cohesionRad + other.cohesionRad)){
        if (d < (this.collisionRad + other.collisionRad)){
          this.calcCollisionForce(other, d);
        }
        this.calcCohesionForce(other);
      }
      this.calcCollisionForce(other, d);
    }
    
  }
  
  void calcCollisionForce(Boid other, float d){
    // separation force
    Vec3D separationForce = other.position.sub(this.position);  // set separation force direction
    separationForce.normalize();
    
    float d_Overlap = (this.collisionRad + other.collisionRad) - d;
    separationForce.scaleSelf(d_Overlap * 0.2);       // magnitude acording to distance
    other.collisionForce.addSelf(separationForce);    // 
    separationForce.scaleSelf(-1);
    this.collisionForce.addSelf(separationForce);
    other.collisionCount++;
    this.collisionCount++;
  }
  
  void calcCohesionForce(Boid other){
    // mutual attraction -- calculate center:
    this.averageGroupPos.addSelf(other.position);
    other.averageGroupPos.addSelf(this.position);
    this.cohesionCount++;
    other.cohesionCount++;
  
  }
  
  void calcAlignForce(Boid other){
    this.alignForce.addSelf(other.velocity);
    other.alignForce.addSelf(this.velocity);
    this.alignCount++;
    other.alignCount++;
    
  }
  
  void calcRotationalForce(){
    // Rotation relevant to position --> magnitude relevant to distance from center
    //this.rotationalForce.addSelf(position);
    
  }
  
  void finishForceCalculations(){
    if (collisionCount > 0) {
      collisionForce.scaleSelf(1 / float(collisionCount));
      acceleration.addSelf(collisionForce);
      
      // Reset for next Calculation (tn ---> t(n+1))
      averageGroupPos = new Vec3D();
      collisionForce = new Vec3D();
      collisionCount = 0;
    }
    
    if (cohesionCount > 0){
      //averageGroupPos.scaleSelf(1 / float(cohesionCount));
      cohesionForce = averageGroupPos.sub(position);
      cohesionForce.normalize();
      cohesionForce.scaleSelf(cohesionCount * 0.05);  //(cohesionCount * 0.05)
      acceleration.addSelf(alignForce);
      
      // Reset for next Calculation 
      alignForce = new Vec3D();
      alignCount = 0;
    }
    
    
    // Universal forces
    rotationForceY = center.position.sub(this.position); 
    rotationForceY.scaleSelf(0.006);
    rotationForceY.rotateZ(PI/2);               // set vertical direction
    acceleration.addSelf(rotationForceY);
    
    gravityForce = center.position.sub(this.position); // set gravity direction
    gravityForce.scaleSelf(0.002);     // control magnitude
    acceleration.addSelf(gravityForce);

    // Explosion
    Vec3D mousePos = new Vec3D(mouseX, mouseY, 0);
    mouseSeparation = mousePos.sub(averageGroupPos.sub(this.position));
    mouseSeparation.scaleSelf(random(-0.2, 0.2));
    if (keyPressed) acceleration.addSelf(mouseSeparation);
  }
  
  void update(){
    velocity.addSelf(acceleration);
    //wrap();
    position.addSelf(velocity);
    velocity.limit(2);  // Limit vector magnitude 
    acceleration = new Vec3D();
  }
  
  void display(){
    // Boid direction
    //Vec3D head = position.add(velocity); 
    //line(position.x, position.y, position.z, head.x, head.y, head.z);
    pushMatrix(); 
    translate(position.x, position.y, position.z);
    stroke(240);
    sphere(boidRad);
    popMatrix();
  }

// world boundaries
  //void wrap (){
  //  if (position.x > worldSize/2) position.x = worldSize / 2;
  //}
}
