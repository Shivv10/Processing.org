/*
Processing, is a programming language based on Java, 
which allows its users to code within the context of visual 
arts and has been designed from the ground up to provide 
instant visual feedback.


Infinit Halls Game
*/

final int NUM_ROWS = 9;
final int NUM_COLS = 9;
final int SPACING = 80;
final int HALL_LEFT = 0;
final int HALL_TOP = 100;
final int DOOR_HEIGHT = 20;
final int DOOR_WIDTH = 200;
final int CARLIN_SIZE = 50;
final int SPIDER_WIDTH = 30;
final int SPIDER_HEIGHT = 50;
final int CARLIN_SPEED = SPACING;
final int LEVEL_TEXT_X = (NUM_COLS/2)*SPACING;
final int LEVEL_TEXT_Y = HALL_TOP/2;
final int SPIDER_SPEED_TEXT_X = (NUM_COLS/4)*SPACING;
final int SPIDER_SPEED_TEXT_Y = (SPACING*NUM_ROWS)+HALL_TOP+(SPACING/2);


final color BROWN = #8B4513;
final color GRAY = #C0C0C0  ;
final color WHITE = #FFFFFF;
final color YELLOW = #F5EF74;
final color RED = #D12020;
final color LIGHT_BLUE = #6FDCDC;



int frozenCol;
int frozenRow;
int remainedMagic;
int doorX;
int carlinX;
int carlinY;
int spiderX;
int spiderY;
int spiderSpeed;
int level;
boolean death;

void setup() {
  size(720, 900); 
  background(0);
  textSize(24);
  doorX = -1;
  carlinX = -1;
  spiderX = -1;
  spiderSpeed = 10; //pixels per frame
  level = 1;
  death = false;
  frozenCol = -1;
  remainedMagic = 3;
  
}

void draw() {
  if (!death) {
    drawHall();
    doorX = drawDoor(doorX);
    carlinX = drawCarlin(carlinX);
    spiderX = drawSpider(spiderX);
    moveSpider();
    drawScore();
    carlinAtTheDoor();
    spiderCatchedCarlin();
    frozedSpider();
    drawSpiderSpeed();
  } else {
    drawFinalLevel();
  }
}


//Draw the hall.
void drawHall() {

  for (int i = 0; i < NUM_COLS; i++) {
    for (int j = 0; j < NUM_ROWS; j++) {
      if (i%2 != 0 & j%2 != 0) {
        fill(BROWN);
        stroke(0);
        strokeWeight(1);      
      } else {
        fill(GRAY);
        noStroke();
      }
      if (frozenCol != -1 && i == frozenCol && j == frozenRow) { //Q4
        fill(LIGHT_BLUE);
        noStroke();
      }
      rect(HALL_LEFT + i*SPACING, HALL_TOP + j*SPACING, SPACING, SPACING);
    }
  }
}


//Draw the door
int drawDoor(int doorX) {
  if (doorX == -1) {
    doorX = (int)random(0, width-DOOR_WIDTH);
  }
  fill(YELLOW);
  rect(doorX, HALL_TOP - DOOR_HEIGHT, DOOR_WIDTH, DOOR_HEIGHT);
  
  return doorX;
}


//Draw Carlin
int drawCarlin(int carlinX){
  if (carlinX == -1) {
    carlinX = initialX();
    carlinY = HALL_TOP + (SPACING*NUM_ROWS) - (SPACING/2);
  }
  // draw body
  fill(WHITE);
  stroke(0);
  strokeWeight(2);
  ellipse(carlinX, carlinY, CARLIN_SIZE, CARLIN_SIZE);
  // draw eye
  strokeWeight(6);
  point(carlinX-(CARLIN_SIZE/4), carlinY-(CARLIN_SIZE/4));
  point(carlinX+(CARLIN_SIZE/4), carlinY-(CARLIN_SIZE/4));
  // draw feet
  strokeWeight(2);
  arc(carlinX-(SPACING/4), carlinY+(SPACING/3), SPACING/3, SPACING/3, PI, TWO_PI);
  arc(carlinX+(SPACING/4), carlinY+(SPACING/3), SPACING/3, SPACING/3, PI, TWO_PI);
  
  return carlinX;
}


//Draw spider
int drawSpider(int spiderX) {
  if (spiderX == -1) {
    spiderX = initialX();
    spiderY = HALL_TOP + (SPACING/2);
  }
  fill(RED);
  stroke(0);
  strokeWeight(2);
  // draw body
  ellipse(spiderX, spiderY, SPIDER_WIDTH, SPIDER_HEIGHT);
  //draw legs
  stroke(RED);
  line(spiderX-(SPIDER_WIDTH/2), spiderY, spiderX-SPIDER_WIDTH, spiderY-(SPIDER_HEIGHT/2));
  line(spiderX-(SPIDER_WIDTH/2), spiderY, spiderX-SPIDER_WIDTH, spiderY-(SPIDER_HEIGHT/4));
  line(spiderX-(SPIDER_WIDTH/2), spiderY, spiderX-SPIDER_WIDTH, spiderY+(SPIDER_HEIGHT/4));
  line(spiderX-(SPIDER_WIDTH/2), spiderY, spiderX-SPIDER_WIDTH, spiderY+(SPIDER_HEIGHT/2));
  line(spiderX+(SPIDER_WIDTH/2), spiderY, spiderX+SPIDER_WIDTH, spiderY-(SPIDER_HEIGHT/2));
  line(spiderX+(SPIDER_WIDTH/2), spiderY, spiderX+SPIDER_WIDTH, spiderY-(SPIDER_HEIGHT/4));
  line(spiderX+(SPIDER_WIDTH/2), spiderY, spiderX+SPIDER_WIDTH, spiderY+(SPIDER_HEIGHT/2));
  line(spiderX+(SPIDER_WIDTH/2), spiderY, spiderX+SPIDER_WIDTH, spiderY+(SPIDER_HEIGHT/4));
  return spiderX;
  
}


// Randomly select an initial X position for either Carlin or Spider
int initialX() {
  int col = (int)random(1, NUM_COLS);
  int center = (SPACING*col)-(SPACING/2);

  return center;
}


//Randomly move the Spider
void moveSpider() {
  int directionNum = (int)random(4);
  if (directionNum == 0){
    spiderX = nextX(spiderX, spiderY, "left", spiderSpeed);
  } else if (directionNum == 1) {
    spiderX = nextX(spiderX, spiderY, "right", spiderSpeed);
  } else if (directionNum == 2) {
    spiderY = nextY(spiderX, spiderY, "up", spiderSpeed);
  } else if (directionNum == 3) {
    spiderY = nextY(spiderX, spiderY, "down",spiderSpeed);
  }
}


// Move Carlin by arrow keys
void keyPressed() {
  if (keyCode == LEFT){
    carlinX = nextX(carlinX, carlinY, "left", CARLIN_SPEED);
  } else if (keyCode == RIGHT) {
    carlinX = nextX(carlinX, carlinY, "right", CARLIN_SPEED);
  } else if (keyCode == UP) {
    carlinY = nextY(carlinX, carlinY, "up",CARLIN_SPEED);
  } else if (keyCode == DOWN) {
    carlinY = nextY(carlinX, carlinY, "down", CARLIN_SPEED);
  } else if (key == '\n' && frozenCol == -1 && remainedMagic > 0) { //Q4
    frozenCol = carlinX/SPACING;
    frozenRow = (carlinY-HALL_TOP)/SPACING;
    remainedMagic --;
    background(0);
  }
}


//Determine the next X position of either Carlin or Spider
int nextX(int currentX, int currentY, String direction, int speed){
  if (direction == "left" && currentX> SPACING) {
    if (!checkObstacle(currentX-SPACING, currentY)){
      currentX -= speed;
    }
  } else if (direction == "right" && currentX<width-SPACING) {
    if (!checkObstacle(currentX+SPACING, currentY)) {
      currentX += speed;
    }
  }
  return currentX;
}


//Determine the next Y position of either Carlin or Spider
int nextY(int currentX, int currentY, String direction, int speed){
  if (direction == "up" && currentY > SPACING+HALL_TOP) {
    if (!checkObstacle(currentX, currentY-SPACING)){
      currentY -= speed;
    }
  } else if (direction == "down" && currentY < HALL_TOP+(NUM_ROWS-1)*SPACING) {
    if (!checkObstacle(currentX, currentY+SPACING)) {
      currentY += speed;
    }
  }
  return currentY;
}


//To see if it's an obstacle/column in the hall with brown cell
boolean checkObstacle(int positionX, int positionY) {
  return ((int)(positionX/SPACING))%2!=0 && ((int)((positionY-HALL_TOP)/SPACING)%2!=0);
}


// Display the level
void drawScore(){
  textSize(20);
  fill(WHITE); 
  String toPrint = "Level: " + level;
  text(toPrint, LEVEL_TEXT_X, LEVEL_TEXT_Y);
}


//Check if Carlin arrived at the door
void carlinAtTheDoor() {
  if (carlinY == HALL_TOP+SPACING/2) {
    if (carlinX >= doorX &&  carlinX <= doorX + DOOR_WIDTH) {
      levelUp();
    }
  }
}


void levelUp() {
  level ++;
  spiderSpeed *= 1.1;
  doorX = -1;
  carlinX = -1;
  spiderX = -1;
  carlinY= -1; //to avoid ending the game after restarting Carline and Spider X positions if they have the same Y
  frozenCol= -1; //Q4
  if (spiderSpeed < 10) {
    spiderSpeed = 10;
  }
  background(0);
}


// Check if the Spider catched Carlin
void spiderCatchedCarlin() {
  int spiderCol = (int)(spiderX/SPACING);
  int spiderRow = (int)((spiderY-HALL_TOP)/SPACING);
  int carlinCol = carlinX/SPACING;
  int carlinRow = (carlinY-HALL_TOP)/SPACING;
  if (spiderCol == carlinCol && spiderRow == carlinRow) {
    death = true;
  }
}


void drawFinalLevel() {
  background(0);
  textSize(50);
  fill(WHITE); 
  String toPrint = "Level: " + level;
  textAlign(CENTER);
  text(toPrint, width/2, height/2);
}


// check if spider entered the icy area
void frozedSpider(){
  if( frozenCol == (int)(spiderX/SPACING) && frozenRow == (int)((spiderY-HALL_TOP)/SPACING)) {
    spiderSpeed /= 4;
    frozenCol = -1;
    background(0);
  }
}


void drawSpiderSpeed(){
  textSize(20);
  fill(WHITE); 
  String toPrint = "Spider Speed: " + spiderSpeed + "   Remained Magic: " + remainedMagic;
  text(toPrint, SPIDER_SPEED_TEXT_X, SPIDER_SPEED_TEXT_Y);
}
