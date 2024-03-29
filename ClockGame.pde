/*
  A fly (grey) can jump between dots (blue) using the arrow keys.
  Avoid the moving clock hands, or the fly is squished. The hands
  will speed up over time. How many jumps can you make?
*/

//length of clock hands
final int HOUR_HAND_LENGTH = 150;
final int MIN_HAND_LENGTH = 220;

//current angle of clock hands, in radians (0 to TWO_PI)
float hourAngle = 0.0;
float minAngle = 0.0;

//angular speed of hands, in radians per frame
float hourSpeed = 0.01;
float minSpeed = 0.02;
final float SPEED_STEP = 0.01;

//diameter of dots
final int DOT_SIZE = 20;
//spacing of dots
final int DOT_SPACING = 200;

int flyX, flyY, flyZ;
final int FLY_SIZE = 30;
final int MAX_Z = 50;

//together, these two identify one of the 4 dots
boolean atTop;
boolean atLeft;

//jump properties
boolean isJumping;
final int JUMP_DURATION = 20; //20 frames to jump between dots
int jumpTime = 0; //how many frames has the fly been jumping?
int jumpOffset = 0; //how far is the fly along the current jump?

//direction of current jump
boolean jumpUp = false, jumpDown = false, jumpLeft = false, jumpRight = false;

final float TOLERANCE = 0.1; //angle difference where fly considered hit, in radians
boolean gameOver = false;

int numJumps = 0; //the score - the number of completed jumps
final int JUMPS_PER_LEVEL = 10;

void setup(){
  size(500,500);
  
  //fly starts at upper left dot
  flyX = width/2 - DOT_SPACING/2;
  flyY = height/2 - DOT_SPACING/2;
  flyZ = 0;
  atTop = true;
  atLeft = true;
  isJumping = false;
  numJumps = 0;
}

void draw(){
  background(#1EC65A);
  if (!gameOver){
    moveHands();
    moveFly();
    checkForCollision();
  }
  drawDots();
  drawHands();
  drawFly();
  if (gameOver){
    printGameOver(); 
  }
  else{
    printScore(); 
  }
}

/* drawDots
   Draw the 4 dots on the clock face.
   Does not modify any global variables.
*/
void drawDots(){
  fill(#2B1EC6);
  strokeWeight(1);
  stroke(0);
  ellipse(width/2 - DOT_SPACING/2, height/2-DOT_SPACING/2, DOT_SIZE, DOT_SIZE); //top left dot
  ellipse(width/2 - DOT_SPACING/2, height/2+DOT_SPACING/2, DOT_SIZE, DOT_SIZE); //bottom left dot
  ellipse(width/2 + DOT_SPACING/2, height/2-DOT_SPACING/2, DOT_SIZE, DOT_SIZE); //top right dot
  ellipse(width/2 + DOT_SPACING/2, height/2+DOT_SPACING/2, DOT_SIZE, DOT_SIZE); //bottom right dot
}

/* drawHands
   Draw the clock hands.
   Does not modify any global variables.
*/
void drawHands(){
  strokeWeight(8);
  stroke(#AF7509);
  line(width/2, height/2, width/2+HOUR_HAND_LENGTH*cos(hourAngle), height/2+HOUR_HAND_LENGTH*sin(hourAngle));
  line(width/2, height/2, width/2+MIN_HAND_LENGTH*cos(minAngle), height/2+MIN_HAND_LENGTH*sin(minAngle));
}

/* moveHands
   Move the clock hands.
   Updates the global variables storing the angles of the hands.
*/
void moveHands(){
  hourAngle = (hourAngle+hourSpeed) % TWO_PI;
  minAngle = (minAngle+minSpeed) % TWO_PI;
}

/* drawFly
   Draw the fly.
   Does not modify any global variables.
*/
void drawFly(){
  stroke(0);
  strokeWeight(1);
  fill(#D1CABE);
  int currentSize = (int)(FLY_SIZE+0.3*FLY_SIZE*flyZ/MAX_Z);
  ellipse(flyX, flyY, currentSize, currentSize);
}

/* keyPressed
   Runs once when a key is pressed.
   If the fly is not mid-jump, initiate the jump.
   Sets the global variables that indicate which direction the fly is jumping.
*/
void keyPressed(){
  if (!gameOver && !isJumping){
    jumpTime = 0;
    if (keyCode == UP && !atTop){
      //jump up 
      jumpUp = true;
      isJumping = true;
    }
    else if (keyCode == DOWN && atTop){
      //jump down
      jumpDown = true;
      isJumping = true;
    }
    else if (keyCode == RIGHT && atLeft){
      //jump right 
      jumpRight = true;
      isJumping = true;
    }
    else if (keyCode == LEFT && !atLeft){
      //jump left 
      jumpLeft = true;
      isJumping = true;
    }
    //else wrong key pressed OR not allowed to make the move - do nothing
  }
  //else fly is already jumping - do nothing
}

/* setOffset
   Set the current distance of the fly from the last dot it sat on.
*/
void setOffset(){
  jumpOffset = jumpTime * DOT_SPACING/JUMP_DURATION; 
}

/* moveFly
   If the fly is jumping, update the fly coordinates.
   If the jump is finished, stop the jump and update the boolean
   variables that indicate which dot the fly is on.
*/
void moveFly(){
  if (isJumping){
    setOffset();
    
    if (jumpUp){
      flyY = height/2+DOT_SPACING/2 - jumpOffset;
      //x coordinate does not change
    }
    else if (jumpDown){
      flyY = height/2-DOT_SPACING/2 + jumpOffset;
      //x coordinate does not change
    }
    else if (jumpRight){
      flyX = width/2-DOT_SPACING/2 + jumpOffset;
      //y coordinate does not change
    }
    else if (jumpLeft){
      flyX = width/2+DOT_SPACING/2 -jumpOffset;
      //y coordinate does not change
    }
    
    if (jumpOffset < DOT_SPACING/2){
      flyZ = 2 * MAX_Z * jumpOffset / DOT_SPACING;
    }
    else{ //jumpOffset >= DOT_SPACING/2
      flyZ = (int)(2 * MAX_Z * (1 - (float)jumpOffset/DOT_SPACING));
    }
    
    jumpTime++;
    
    if (jumpTime >= JUMP_DURATION){
      numJumps++;
      if (numJumps%JUMPS_PER_LEVEL==0){
         //next level
         hourSpeed += 0.5*SPEED_STEP;
         minSpeed += SPEED_STEP; //minute hand speeds up faster
      }
      //jump is finished
      flyZ = 0;
      if (jumpUp){
        jumpUp = false;
        atTop = true;
        flyY = height/2-DOT_SPACING/2; //make sure exactly over dot
      }
      else if (jumpDown){
        jumpDown = false;
        atTop = false;
        flyY = height/2+DOT_SPACING/2;
      }
      else if (jumpRight){
        jumpRight = false;
        atLeft = false;
        flyX = width/2+DOT_SPACING/2;
      }
      else if (jumpLeft){
        jumpLeft = false;
        atLeft = true;
        flyX = width/2-DOT_SPACING/2;
      }
      
      isJumping = false; 
    }
  }
}

/* checkForCollision
   If the flyAngle lines up with a hand angle, look at the fly's
   z coordinate to determine if it has been hit by a hand. End the
   game if the fly is hit.
*/
void checkForCollision(){
  float flyAngle = atan2(flyY-height/2, flyX-width/2); //atan2 gives angle in -PI to PI

  //make sure angle is in 0..TWO_PI - need to add TWO_PI to flyAngle if in -PI to 0 range
  flyAngle = (flyAngle + TWO_PI) % TWO_PI;
  
  boolean angleMatch = abs(flyAngle-hourAngle) < TOLERANCE || abs(flyAngle-minAngle) < TOLERANCE;
  
  if (flyZ < MAX_Z/4 && angleMatch){
    gameOver = true; 
  }
}

/* printGameOver
   Print a game over message on the canvas.
*/
void printGameOver(){
  textSize(height/10);
  fill(0);
  String message = "GAME OVER!";
  text(message, (width-textWidth(message))/2, (height+textAscent()-textDescent())/2);
}

/* printScore
   Print the current score at the top of the canvas.
*/
void printScore(){
  textSize(height/20);
  fill(0);
  String message = "Number of jumps: " + numJumps;
  text(message, (width-textWidth(message))/2, textAscent()+10);
}
