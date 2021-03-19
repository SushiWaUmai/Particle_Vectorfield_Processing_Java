Particle[] particles;
int particleAmount = 10000;
float particleMaxSpeed = 2;

int vectorFieldWidth = 50;
int vectorFieldHeight = 50;
PVector[][] vectorField;

// node size in pixel
float xCellSize;
float yCellSize;

float xOffset;
float yOffset;
float zOffset;

float xOffsetMovement;
float yOffsetMovement;
float zOffsetMovement = 0.1f;

int xScale = 2;
int yScale = 2;

// Colorshift of the hue color
float colorShift = 100;

// Color of the grid
color gridColor = color(64, 64, 64);
color vectorColor = color(255, 0, 0);

int alphaBackground = 5;

void setup()
{
  size(1024,1024);
  initValues();
  background(0);
}

void draw()
{
  drawBackground();
  updateOffset();
  initParticleVectorField();
  // drawGrid();
  // drawVectors();
  loadPixels();
  updateParticles();
  updatePixels();
}

void line(PVector a, PVector b)
{
  line(a.x, a.y, b.x, b.y);
}

void drawBackground()
{
  fill(0, alphaBackground);
  rect(0,0,width,height);
  fill(255);
}

void initValues()
{
  xCellSize = (float)width / vectorFieldWidth;
  yCellSize =  (float)height / vectorFieldHeight;
  
  particles = new Particle[particleAmount];
  for(int i = 0; i < particleAmount; i++)
    particles[i] = new Particle(random(10, 30), color(255, 32));
}

void updateOffset()
{
  xOffset += xOffsetMovement;
  yOffset += yOffsetMovement;
  zOffset += zOffsetMovement;
}

void initParticleVectorField()
{
  vectorField = new PVector[vectorFieldWidth][vectorFieldHeight];
  
  for(int x = 0; x < vectorFieldWidth; x++)
  {
    for(int y = 0; y < vectorFieldHeight; y++)
    {
      float angle = PI * 4 * noise((float)x / vectorFieldWidth * xScale + xOffset, (float)y / vectorFieldHeight * yScale + yOffset, zOffset);
      vectorField[x][y] = PVector.fromAngle(angle);
    }
  }
}

// Draws a grid
void drawGrid()
{
  stroke(gridColor);
  for(int x = 0; x < vectorFieldWidth - 1; x++)
  {
    for(int y = 0; y < vectorFieldHeight - 1; y++)
    {
      line(gridToPixel(x, y), gridToPixel(x + 1, y));
      line(gridToPixel(x, y), gridToPixel(x, y + 1));
      line(gridToPixel(x + 1, y), gridToPixel(x + 1, y + 1));
      line(gridToPixel(x, y + 1), gridToPixel(x + 1, y + 1));
    }
  }
}

void drawVectors()
{
  stroke(vectorColor);
  for(int x = 0; x < vectorFieldWidth; x++)
  {
    for(int y = 0; y < vectorFieldHeight; y++)
    {
      PVector point1 = gridToPixel(x, y);
      PVector vectorDirection = vectorField[x][y].copy();
      PVector point2 = point1.copy().add(vectorDirection.mult(10));
      line(point1, point2);
    }
  }
}

void updateParticles()
{
  for(Particle p : particles)
    p.update();
}

// Converts grid index to pixel position
PVector gridToPixel(PVector grid)
{
  return gridToPixel((int)grid.x, (int)grid.y);
}

PVector gridToPixel(int x, int y)
{
  return new PVector(x * xCellSize + xCellSize * 0.5f, y * yCellSize + yCellSize * 0.5f);
}

PVector pixelToGrid(int x, int y)
{
  return new PVector(floor(x / xCellSize), floor(y / yCellSize));  
}

PVector pixelToGrid(PVector pixel)
{
  return pixelToGrid((int)pixel.x, (int)pixel.y);
}

PVector pixelToVectorField(int x, int y)
{
  PVector index = pixelToGrid(x, y);
  return vectorField[(int)index.x][(int)index.y];
}

PVector pixelToVectorField(PVector pixel)
{
  return pixelToVectorField((int)pixel.x, (int)pixel.y);
}


// converts gray to hue color values
color grayToColor(float val)
{
  colorMode(HSB);
  val *= 255;
  return color((val + colorShift) % 255, 255, 255);
}
