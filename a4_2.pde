PImage ballimg;
PFont  font;
PFont  font2;
int rows = 7; //Number of bricks per row
int columns = 7; //Number of columns
int total = rows * columns; //Total number of bricks
int score = 0; //How many bricks have been hit by the player
int gameScore = 0; //The player's score which displays on the screen.
int lives = 4; //lives

Paddle p1 = new Paddle(); //initialize paddle
Ball ball1 = new Ball(); //initialize ball
Brick[] box = new Brick[total]; //initialize array

/*Particle randomParticle() {
  Particle ball = new Particle();
  ball.x = 250;
  ball.y = 250;
  ball.dx = random(-4, 4);
  ball.dy = random(-4, 4);
  ball.diam = random(3, 5);
  ball.fillColor = color(13,144, 64);
  return ball;
}*/

void setup(){
  size(600, 600);
  background(0);
  smooth();
  font = loadFont("ComicSansMS-32.vlw");
  font2 = loadFont("Consolas-Bold-32.vlw");
  ballimg = loadImage("kwest.jpg");
  //Setup array of all bricks on screen
  for (int i = 0; i < rows; i++){
    for (int j = 0; j < columns; j++){
      box[i*rows + j] = new Brick((i+1) *width/(rows + 2), (j+1) * 50);
    }
  }
}


void draw(){
  background(0);
  //array of bricks
  for (int i = 0; i<total; i++){
    box[i].update();
  }
  //draw sprite
  //explosion sprite here
  p1.update();
  ball1.update();
  if (ball1.y == p1.y && ball1.x > p1.x && ball1.x <= p1.x + (p1.w / 2) ){
    ball1.goleft();
    ball1.changeY();
  }

  if (ball1.y == p1.y && ball1.x > p1.x + (p1.w/2) && ball1.x <= p1.x + p1.w ){
    ball1.goright();
    ball1.changeY();
  }

  if (ball1.x + ball1.diam / 2 >= width){
    ball1.goleft();
  }

  if (ball1.x - ball1.diam / 2 <= 0){
    ball1.goright();
  }
  if (ball1.y - ball1.diam / 2 <= 0){
    ball1.changeY();
  }


  //BALL,  BRICK

  for (int i = 0; i < total; i ++){
    //check top of box
    if (ball1.y - ball1. diam / 2 <= box[i].y + box[i].h &&  ball1.y - ball1.diam/2 >= box[i].y && ball1.x >= box[i].x && ball1.x <= box[i].x + box[i].w  && box[i].hit == false ){
      ball1.changeY();
      box[i].gotHit();
      score += 1;
      gameScore += 10;
   }
   //check bottom of box
    if (ball1.y + ball1.diam / 2 >= box[i].y && ball1.y - ball1.diam /2 <= box[i].y + box[i].h/2 && ball1.x >= box[i].x && ball1.x <= box[i].x + box[i].w && box[i].hit == false ) {
      ball1.changeY();
      box[i].gotHit();
      score += 1;
      gameScore += 10;
    }
    //check left of box
    if (ball1.x + ball1.diam / 2 >= box[i].x && ball1.x + ball1.diam / 2 <= box[i].x + box[i].w / 2 && ball1.y >= box[i].y && ball1.y <= box[i].y + box[i].h  && box[i].hit == false){
      ball1.goleft();
      box[i].gotHit();
      score += 1;
      gameScore += 10;
    }
    //check right of box
    if (ball1.x - ball1.diam/2 <= box[i].x + box[i].w && ball1.x +ball1.diam / 2 >= box[i].x + box[i].w / 2 && ball1.y >= box[i].y && ball1.y <= box[i].y + box[i].h  && box[i].hit == false){
      ball1.goright();
      box[i].gotHit();
      score += 1;
      gameScore += 10;
    }
  }

  if (ball1.y > height){
    ball1.reset();
    lives -= 1;
  }
  textFont(font,32);
  text(gameScore, 10, 30);
  textSize(18);
  text("LIVES: ", 10, 570);
  text(lives, 70, 570); 
  if ((score == total || lives <= 0) && mousePressed){
    resetGame();
  } 
  // make so on.click game start takes 1 life away so you start at 3
  if((lives ==4)&& mousePressed){
    gameStart();  
  }
  
  if (score == total){
    gameWin();
  }

  //if lives = 0 game ends.
  if (lives <= 0){
    gameOver();
  }
}

void gameStart(){
  background(0);
  textSize(32);
  lives -= 1;
  text("Welcome to Kayne Ball", 100,200);
  text("click to start", 100,300);
  }

//Function that displays the game screen after the player loses.
void gameOver(){
  background(0);
  textFont(font2,32);
  text("You let Kanye in his Zone", 100, 200);
  text("SWAG Score: ", 100, 300);
  text(gameScore, 300, 300);
  text("Click mouse to prove yourself!", 25, 500);

  ball1.x = -10;
  ball1.y = -10;
  ball1.vx = 0;
  ball1.vy = 0;
}

void gameWin(){ 
  background(0);
  textSize(32);
  text("You are cooler than Kanye West!", 100, 200);
  text("SWAG Score: ", 100, 300);
  text(gameScore, 300, 300);
  text("Click mouse to swag out!", 100, 500);

  ball1.x = -10;
  ball1.y = -10;
  ball1.vx = 0;
  ball1.vy = 0;
}

void resetGame(){
  //Setup array of all bricks on screen
  for (int i = 0; i < rows; i++){
    for (int j = 0; j< columns; j++){
     box[i*rows + j] = new Brick((i+1) *width/(rows + 2), (j+1) * 50);
    }
    score = 0;
    gameScore = 0;
    lives = 4;
  }
  ball1.reset();
}
//sprite class
/*class Sprite {
  float x;
  float y;
  float dx;
  float dy;

  void update() {
    x += dx;
    y += dy;
  }
}*/

//PADDLE CLASS
class Paddle{
  float x; //paddle x
  float y; //padlle y
  float w; //paddle width
  float h; //paddle height
  float rpcolor; //paddle red val

  //Paddle constructor
  Paddle(){
    x = width/2;
    y = 500;
    w = 100;
    h = 10;
    rpcolor=255;
  }

  void update(){
    x = mouseX;    
    //diamraw paddle
    fill(rpcolor);
    rect(x, y, w, h);
  }
}


//BALL CLASS
//make kanyes head on ball 
class Ball{
  float x;  //ball x
  float y; //ball y
  float vx; //ball velocity in x
  float vy; //ball velocity in y 
  float diam; //ball diameter
  //Ball constructor
  Ball(){
    x = 300;
    y = 500;
    vx = 0; //Initially, ball just falls straight down
    vy = 4; 
    diam = 10;
  }

  //Update the ball
  void update(){
    noStroke();
    fill(255);
    ellipse(x, y, diam, diam);
    y += vy; //increment y
    x += vx; //increment x
  }
  //Ball goes left
  void goleft(){
    vx = -4; //decrement x
  }
  //Ball goes right
  void goright(){
    vx = 4; //increment x
  }
  //Ball changes in y direction
  void changeY(){
    vy *= -1; 
  }
  //If ball goes below paddle, reset
  void reset(){
    x = 300;
    y = 400;
    vx = 0;
    vy = 4;
  }
}
//BRICK CLASS
class Brick
{
  float x; //brick x
  float y; //brick y
  float w; //brick width
  float h; //brich height
  float rcolor;
  boolean hit;
    Brick(float x0, float y0){
    x = x0;
    y = y0;
    rcolor = 150;
    w = 50; 
    h = 25; 
    hit = false;
  }
void update(){
    noStroke();
    fill(rcolor,rcolor*(255),rcolor);
    rect(x, y, w, h);
  }

void gotHit(){
    hit = true; 
    rcolor = 0;
    rect(x, y, w, h);
  }
}
//PARTICLE CLASS
/*class Particle extends Sprite {
  float diam;
  color fillColor;

  void render() {
    pushMatrix();

    noStroke();
    fill(fillColor);

    ellipse(x,y,5,5);

    popMatrix();
  }
}*/