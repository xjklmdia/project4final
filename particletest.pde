class Sprite {
  float x;
  float y;
  float dx;
  float dy;

  void update() {
    x += dx;
    y += dy;
  }
}

class Particle extends Sprite {
  float diam;
  color fillColor;

  void render() {
    pushMatrix();

    noStroke();
    fill(fillColor);

    ellipse(x,y,5,5);

    popMatrix();
  }
}

Particle randomParticle() {
  Particle ball = new Particle();
  ball.x = 250;
  ball.y = 250;
  ball.dx = random(-4, 4);
  ball.dy = random(-4, 4);
  ball.diam = random(3, 5);
  ball.fillColor = color(13,144, 64);
  return ball;
}

ArrayList<Particle> particles;  // initially null
final int NUM_PARTICLES = 12;

void setup() {
  size(500, 500);

  // create the initially empty ArrayList of Particle objects
  particles = new ArrayList<Particle>();
}

void draw() {
  background(255);

  // render and update all the particles
  for (Particle p : particles) {
    p.render();
    p.update();
  }
}

void mousePressed() {
  particles = new ArrayList<Particle>();
  int i = 0;
  while (i < NUM_PARTICLES) {
    Particle p = randomParticle();
    p.x = mouseX;
    p.y = mouseY;
    particles.add(p);
    i += 1;
  }
}