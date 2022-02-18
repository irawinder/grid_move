//Global Grid Parameters
boolean[][] blocker;
int GRID_WIDTH = 8;
int GRID_HEIGHT = 8;
float BLOCKER_CHANCE = 0.25; // chance of tile being blocked
float tileWidth, tileHeight;

//Global Position Parameters
int START_U = 1;
int START_V = 1;
int positionU, positionV;

void setup() {
  
  size(800, 800);
  tileWidth = (float) width / GRID_WIDTH;
  tileHeight = (float) height / GRID_HEIGHT;
  
  // Initialize Piece Location
  positionU = START_U;
  positionV = START_V;
  
  // Initialize a random grid of blockers
  blocker = new boolean[GRID_WIDTH][GRID_HEIGHT];
  for (int u=0; u<GRID_WIDTH; u++) {
    for (int v=0; v<GRID_HEIGHT; v++) {
      if (u==START_U && v==START_V) { // Never block starting position
        blocker[u][v] = false;
      } else if (random(1) < BLOCKER_CHANCE) {
        blocker[u][v] = true;  
      } else {
        blocker[u][v] = false;
      }
    }
  }
  
  strokeWeight(5);
}

void draw() {
  
  // draw grid
  background(50);
  fill(200);
  noStroke();
  for (int u=0; u<GRID_WIDTH; u++) {
    for (int v=0; v<GRID_HEIGHT; v++) {
      if (!blocker[u][v]) {
        rect(u * tileWidth, v * tileWidth, tileWidth, tileHeight, 0.25 * tileWidth);
      }
    }
  }
  
  // Draw Move Direction
  if (keyPressed) {
    switch(key) {
      case 'a':
        drawMove(-1, 0);
        break;
      case 'd':
        drawMove(+1, 0);
        break;
      case 'w':
        drawMove(0, -1);
        break;
      case 's':
        drawMove(0, +1);
        break;
    }
  }
  
  // Draw Position Marker
  fill(255);
  stroke(50);
  circle((positionU + 0.5) * tileWidth, (positionV + 0.5) * tileHeight, 0.4 * tileWidth);
}

// draws a colored arrow in the direction of the key you are pressing
// red if trying to move into a blocked tile, otherwise green
void drawMove(int dU, int dV) {
  int intendedU = positionU + dU;
  int intendedV = positionV + dV;
  pushMatrix();
  translate(0.5 * tileWidth, 0.5 * tileHeight);
  if (inBounds(intendedU, intendedV)) {
    if (!blocker[positionU + dU][positionV + dV]) {
      stroke(#00FF00, 100);
    } else {
      stroke(#FF0000, 100);
    }
    line(positionU * tileWidth, positionV * tileWidth, intendedU * tileWidth, intendedV * tileWidth);
  }
  popMatrix();
}

// returns true if a particular coordinate is in bounds
boolean inBounds(int u, int v) {
  boolean inBoundsU = u >= 0 && u <= GRID_WIDTH - 1;
  boolean inBoundsV = v >= 0 && v <= GRID_HEIGHT - 1;
  return inBoundsU && inBoundsV;
}

void keyReleased() {
  switch(key) {
    case 'a':
      tryMove(-1, 0);
      break;
    case 'd':
      tryMove(+1, 0);
      break;
    case 'w':
      tryMove(0, -1);
      break;
    case 's':
      tryMove(0, +1);
      break;
  }
}

// attempt to move in the specified direction
// if told to move into a blocked tile, position is not changed
void tryMove(int dU, int dV) {
  int intendedU = positionU + dU;
  int intendedV = positionV + dV;
  if (inBounds(intendedU, intendedV)) {
    if (!blocker[intendedU][intendedV]) {
      positionU = intendedU;
      positionV = intendedV;
    }  
  }
}
