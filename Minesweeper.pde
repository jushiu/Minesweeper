import de.bezier.guido.*;
public final static int NUM_ROWS = 25;
public final static int NUM_COLS = 25;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    //your code to initialize buttons goes here
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for(int i = 0; i < NUM_ROWS; i++) {
      for(int j = 0; j < NUM_COLS; j++) {
        buttons[i][j] = new MSButton(i, j);
      }
    }
    
    for(int i = 0; i < 80; i++) {
      setMines();
    }
}
public void setMines()
{
    int row = (int)(Math.random()*NUM_ROWS);
    int col = (int)(Math.random()*NUM_COLS);
    if(!mines.contains(buttons[row][col]) ){
      mines.add(buttons[row][col]);
    }
}

public void draw ()
{
    background( 0 );
    if(isWon() == true) {
        displayWinningMessage();
        noLoop();
    }
}
public boolean isWon()
{
  for(int i = 0; i < NUM_ROWS; i++) {
    for(int j = 0; j < NUM_COLS; j++) {
      if(!mines.contains(buttons[i][j]) && buttons[i][j].clicked == false) {
        return false;
      }
    }
  }
  return true;
}
public void displayLosingMessage()
{
  buttons[10][7].setLabel("Y");
  buttons[10][8].setLabel("O");
  buttons[10][9].setLabel("U");
  buttons[10][11].setLabel("L");
  buttons[10][12].setLabel("O");
  buttons[10][13].setLabel("S");
  buttons[10][14].setLabel("E");
  for(int i = 0; i < mines.size(); i++) {
    mines.get(i).clicked = true;
  }
}
public void displayWinningMessage()
{
  buttons[10][7].setLabel("Y");
  buttons[10][8].setLabel("O");
  buttons[10][9].setLabel("U");
  buttons[10][11].setLabel("W");
  buttons[10][12].setLabel("I");
  buttons[10][13].setLabel("N");
}
public boolean isValid(int r, int c)
{
   if((r >= 0 && r < NUM_ROWS) && (c >= 0 && c < NUM_COLS) ){
     return true;
   } else {
    return false;
   }
}
public int countMines(int row, int col)
{
    int numMines = 0;
    for(int i = row - 1; i <= row+1; i++) {
      for(int j = col - 1; j <= col+1; j++) {
        if(isValid(i,j) && mines.contains(buttons[i][j]))
         if(i != row || j != col)
          numMines++;
      }
    }
    return numMines;
}
public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
    
    public MSButton ( int row, int col )
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
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
        if(mouseButton == RIGHT) {
          flagged = !flagged;
          if(flagged == false) 
           clicked = false;
        }
        else if(mines.contains(this)) {
          displayLosingMessage();
          noLoop();
        }
        else if(countMines(myRow, myCol) > 0) {
          myLabel = "" + countMines(myRow, myCol);
        }
        else {
          for(int i = myRow - 1; i <= myRow+1; i++) {
            for(int j = myCol - 1; j <= myCol+1; j++) {
              if(isValid(i,j) && buttons[i][j].clicked == false) {
                //if(i != myRow || j != myCol) {
                  buttons[i][j].mousePressed();
                //}
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
            fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        text(myLabel,x+width/2,y+height/2);
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
