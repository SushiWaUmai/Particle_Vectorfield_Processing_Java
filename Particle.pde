public class Particle
{
  private PVector position;
  private PVector acceleration;
  private PVector velocity;
  private float force;
  private color col;
  
  public Particle(float f, color c)
  {
    this(new PVector(random(0, width), random(0, height)), new PVector(), new PVector(), f, c); 
  }
  
  public Particle(PVector p, PVector v, PVector a, float f, color c)
  {
    position = p;
    velocity = v;
    acceleration = a;
    force = f;
    col = c;
  }
  
  public void update()
  {
    logic();
    drawParticle();
  }
  
  private void logic()
  {
    float deltaTime = 1/frameRate;
    
    PVector directionalForce = pixelToVectorField(position).mult(force);
    acceleration = directionalForce.mult(deltaTime);
    velocity.add(acceleration);
    velocity.limit(particleMaxSpeed);
    position.add(velocity);
    
    position.x = clampX(position.x);
    position.y = clampY(position.y);
  }
  
  private void drawParticle()
  {
    int size = particleSize;
    for (int x = (int)position.x - size; x <= (int)position.x + size; x++)
    {
      for (int y = (int)position.y - size; y <= (int)position.y + size; y++)
      {
        pixels[(int)clampY(y) * height + (int)clampX(x)] += col;
      }
    }
  }
}
