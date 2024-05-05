import de.bezier.guido.*;
int numRows = 10;
int numCols = 10;
int numMines = 15;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines =new ArrayList<MSButton>(); //ArrayList of just the minesweeper buttons that are mined
void setup ()
{
  
 
  size(800, 1000);
  textAlign(CENTER, CENTER);

  // make the manager
  Interactive.make( this );
  buttons = new MSButton[numRows][numCols];
  //your code to initialize buttons goes here

  for (int r = 0; r< numRows; r++) {
    for (int c = 0; c<numCols; c++) {
      buttons[r][c] =new MSButton(r, c);
    }
  }

  setMines();
}

public void setMines()
{

while (mines.size()< numMines) { 
   int r = (int)(Math.random()*numRows);
   int c = (int)(Math.random()*numCols);
  if (!mines.contains(buttons[r][c])){
  mines.add(buttons[r][c]);
  }
}
}

public void draw ()
{
  background( 0 );
  if (checkWin() == true){
    displayWinningMessage();
    noLoop();
}
fill(124, 252, 0);
rect(0,800,900,200);
text("There are " + mines.size() + " mines      " + frameCount/60 + "sec", 400,850);

}
public boolean checkWin()
{
  //your code here
  for(int i = 0; i < mines.size(); i++){
      if(mines.get(i).isFlagged() == false){
        return false;
      }
     }
    return true;

}
public void displayLosingMessage()
{
  //your code here
  fill(255,255,255);
  rect(250,350,300,100);
  fill(0);
  text("You're a bum", 400,400 )
noLoop();
}

public void displayLosingMessage()
{
  //your code here
  fill(255,255,255);
  rect(250,350,300,100);
  fill(0);
  text("You Won. Good Job", 400,400 )
noLoop();
}


public boolean isValid(int r, int c)
{
  if (r>=0 && r<10 && c>=0 && c<10)
    return true;
  else
    return false;
}
public int countMines(int row, int col)
{
  int numMines = 0;
  //your code here
  for(int r = row -1; r <=row+1;r++){
   for (int c = col -1;c<= col+1;c++){
     if (isValid(r,c)== true && mines.contains(buttons[r][c])){
       numMines++;
   }
  }
  }
  return numMines;

}
public class MSButton
{
  private int myRow, myCol;
  private float x, y, width, height;
  private boolean clicked, flagged;
  private String myLabel;

  public MSButton ( int row, int col )
  {
    width = 800/numCols;
    height = 800/numRows;
    myRow = row;
    myCol = col; 
    x = myCol*width;
    y = myRow*height;
    myLabel = "";
    flagged = clicked = false;
    Interactive.add( this ); // register it with the manager
  }

  // called by manager
  public void mousePressed () 
  {
    clicked = true;
    //your code here
    if (flagged == true){
     clicked = false; 
    }
    if(mouseButton == RIGHT){
       if(flagged == false){
          flagged = true;
          clicked = false;
       }
    }else if (flagged == true){
       flagged = false;
       clicked = false;
    }else if (mines.contains(this)){
       displayLosingMessage(); 
       
    }else if(countMines(myRow,myCol)>0){
      setLabel(countMines(myRow,myCol));
    }else {
     for(int r = myRow-1;r<myRow+2;r++){
      for (int c = myCol-1;c<myCol+2;c++){
        if(isValid(r,c)&&buttons[r][c].clicked == false){
           buttons[r][c].mousePressed(); 
        }
      }
     }
      
    }
  }  
  public void draw () 
  {    
    if (flagged)
      fill(0);
     else if( clicked && mines.contains(this) ) 
      fill(234,38,38);
    else if (clicked)
      fill(240,209,87);
    else 
    fill(81,179,81);

    rect(x, y, width, height);
    fill(0);
    text(myLabel, x+width/2, y+height/2);
  }
  public void setLabel(String newLabel)
  {
    myLabel = newLabel;
  }
  public void setLabel(int newLabel)
  {
    myLabel = ""+ newLabel;
  }
  public boolean isFlagged()
  {
    return flagged;
  }
}

