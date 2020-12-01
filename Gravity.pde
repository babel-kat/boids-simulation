class Gravity extends Boid{
  
  Vec3D position, velocity;
  float boidRad;
  boolean toggle;
  
  Gravity(float x, float y, float z, float _boidRad) {
    super(x, y, z, _boidRad);
    
    position = new Vec3D(x, y, z); 
    boidRad = _boidRad;
    
    velocity = new Vec3D(0, 0, 0);
  }
  
  Gravity(float x, float y, float z, float _boidRad, boolean _toggle) {
    super(x, y, z, _boidRad);
    
    position = new Vec3D(x, y, z); 
    boidRad = _boidRad;
    
    velocity = new Vec3D();
    toggle = _toggle;
  }
  
  void display(color col){
    // Boid direction
    //Vec3D head = position.add(velocity); 
    //line(position.x, position.y, position.z, head.x, head.y, head.z);
    pushMatrix(); 
    translate(position.x, position.y, position.z);
    stroke(col);
    sphere(boidRad);
    popMatrix();
  }
  
}
