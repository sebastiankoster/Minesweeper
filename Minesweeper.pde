Button [] [] minefield = new Button [10] [10];
ArrayList <Integer> mineList  = new ArrayList <Integer> ();
boolean gameOn = true;
boolean gameStarted = false;
boolean finalMessageDisplayed = false;
int flagCount = 0;
int shownCount ;
int hasWon = 0;   //0 means game is on, 1 means true, -1 means false

void setup(){
size(800,900);
init();}


void init(){
textSize(46);
loop();
textAlign(CENTER);
mineList.clear();
gameOn = true;
gameStarted = false;
flagCount = 0; shownCount =0;
//add "buttons" to minefield. Activate mines from mineList
for(int j = 0; j<10; j++){
  for(int k = 0; k<10; k++){
    minefield[j][k] = new Button(k*80,j*80);
  }
 }
}


class Button{
public  boolean isShown;
private boolean isMine;
private boolean isFlagged;
private int neighbors;
private int x;
private int y;
public Button(int xp, int yp){
  isMine = false;
  isFlagged = false;
  isShown = false;
  x = xp;
  y = yp;
 }
public void activateMine(){
  isMine = true;  
 }
public void flagMine(){
  if(!isFlagged && !isShown){ isFlagged = true; flagCount++;}
  else if(isFlagged){ isFlagged = false; flagCount--;}
 }
public void showMine(){
  if (isShown && isMine){
    fill(234,38,38);
    rect(x+2,y+2,76,76,4); 
   }
  else if (isShown ){
    fill(240,209,87);  
    rect(x+2,y+2,76,76,4);
    fill(81,179,81);
   }
  else{
    rect(x+2,y+2,76,76,4);
    if(isFlagged){
      strokeWeight(20);
      stroke(234,38,38);
      line(x+15,y+15,x+65,y+65);
      line(x+15,y+65,x+65,y+15);
      strokeWeight(1);
      stroke(0,0,0);
    }
    fill(81,179,81);
   }
  
 }
 
public void clickMine(){
  if(isFlagged) {isFlagged = false; flagCount--;}
  if (neighbors == 0){
    isShown = true;
    int row = y/80;
    int col = x/80;
    boolean lShift = (col>0);
    boolean rShift = (col<9);
    boolean uShift = (row>0);
    boolean dShift = (row<9);
  
  if (lShift && uShift){
    if(!minefield[row-1][col-1].isShown)
      minefield[row-1][col-1].clickMine();
  }
  if (uShift){
    if(!minefield[row-1][col].isShown)
      minefield[row-1][col].clickMine();
  }
  if (rShift && uShift){
    if(!minefield[row-1][col+1].isShown)
      minefield[row-1][col+1].clickMine();
  }
  if (lShift){
    if(!minefield[row][col-1].isShown)
      minefield[row][col-1].clickMine();
  }
  if (rShift){
    if(!minefield[row][col+1].isShown)
    minefield[row][col+1].clickMine();
  } 
  if (lShift && dShift){
    if(!minefield[row+1][col-1].isShown)
      minefield[row+1][col-1].clickMine();
  }
  if (dShift){
    if(!minefield[row+1][col].isShown)
      minefield[row+1][col].clickMine();
  }
  if (rShift && dShift){
    if(!minefield[row+1][col+1].isShown)
      minefield[row+1][col+1].clickMine();
  }
 }
  isShown  =true;
  shownCount++;
  if(isMine && gameOn)
    explode();
 }
 
public int countNeighborMines(int row, int col){
  int sum =0;
  boolean lShift = (col>0);
  boolean rShift = (col<9);
  boolean uShift = (row>0);
  boolean dShift = (row<9);
  
  if (lShift && uShift)
    if (minefield[row-1][col-1].isMine) sum++;
  
  if (uShift)
    if (minefield[row-1][col].isMine) sum++;
    
  if (rShift && uShift)
    if (minefield[row-1][col+1].isMine) sum++;
  
  if (lShift)
    if (minefield[row][col-1].isMine) sum++;
    
  if (rShift)
    if (minefield[row][col+1].isMine) sum++;
    
  if (lShift && dShift)
    if (minefield[row+1][col-1].isMine) sum++;
    
  if (dShift)
    if (minefield[row+1][col].isMine) sum++;
    
  if (rShift && dShift)
    if (minefield[row+1][col+1].isMine) sum++;
  return sum;
 }
}

void draw(){
background(209,250,233);
for(int j = 0; j<10; j++){
  for(int k = 0; k<10; k++){
    minefield[j][k].showMine();
    
    if(minefield[j][k].isShown && !minefield[j][k].isMine && !(minefield[j][k].neighbors==0)){
      fill(0,0,0);
      textSize(60);
      text( minefield[j][k].neighbors, k*80+40,j*80+60);
      fill(81,179,81);
    }
  }
 }
 
textAlign(LEFT);
textSize(34);
fill(0,0,0);
text("There are " + mineList.size() + " mines and you flagged " + flagCount + " in " + (float)frameCount/60 + " seconds", 20, 850);
textAlign(CENTER);
if(finalMessageDisplayed){
  fill(209,250,233,200);
  rect(200,700,400,100);
  fill(50,50,150);
  textSize(60);
  if (hasWon==-1)
    text("YOU LOST", 400,770);
  if (hasWon == 1)
    text("YOU WON", 400,770);
 }
fill(81,179,81);
if(gameOn) checkWin();
}


void mousePressed(){
if (gameOn && !gameStarted){
setMines((int)(mouseY/80),(int)(mouseX/80));}
if(finalMessageDisplayed)
  finalMessageDisplayed = false;  
if(mouseButton == LEFT && mouseY<800)
  minefield[mouseY/80][mouseX/80].clickMine();
if(mouseButton == RIGHT && mouseY<800)
  minefield[mouseY/80][mouseX/80].flagMine();  
if(!gameOn && !finalMessageDisplayed){
  gameOn = true;
  init();
 }
}

void explode(){
gameOn = false;
for(int j = 0; j<10; j++){
  for(int k = 0; k<10; k++){
    minefield[j][k].clickMine();
  }
 }
 noLoop();
 finalMessageDisplayed = true;
 hasWon = -1;
 draw();
}

void checkWin (){
if (shownCount + mineList.size() >= 100){
 noLoop();
 finalMessageDisplayed = true;
 hasWon = 1;
 gameOn = false;
 draw();
 }
}


void setMines (int row, int col){
//add values to  mineList - should be around 17-23 mines
gameStarted = true;
for(int i =0; i< 100; i++){
  if(Math.random()>0.67){
  mineList.add(i);};
 }

for(int i = 0; i < mineList.size(); i++){
int val = mineList.get(i);
if ((val%10-col)<3 && (val%10-col)>-3 && (val/10-row)<3 && (val%10-row)>-3){
mineList.remove(i);
i--;}}
 
//activate all mines 
for(int i=0; i<mineList.size(); i++){
  minefield[mineList.get(i)/10][mineList.get(i)%10].activateMine();
 }

//count neightbors
for(int j = 0; j<10; j++){
  for(int k = 0; k<10; k++){
    if(!minefield[j][k].isMine)
      minefield[j][k].neighbors = minefield[j][k].countNeighborMines(j,k);
    else
      minefield[j][k].neighbors = 9;
  }
 }
}
