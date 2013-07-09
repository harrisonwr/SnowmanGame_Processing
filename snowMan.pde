Game game = new Game();
Rain[] rain = new Rain[20];

import ddf.minim.*;
Minim minim;
AudioPlayer gameover;
AudioPlayer backgroundMusic;
AudioPlayer ding;
AudioPlayer bomb;
AudioPlayer heartBeat;
AudioInput input;

int points;
int life;
int recoverLife;
float level;
int levelBreak;
boolean dead;

//boolean delay= false;

void setup()
{
  size(700, 500);
  smooth();
  //music setup
  minim = new Minim(this);
  gameover = minim.loadFile("./Music/JollyLaugth.mp3");
  backgroundMusic = minim.loadFile("./Music/JingleBellRock.mp3");
  ding = minim.loadFile("./Music/ding.mp3");
  bomb = minim.loadFile("./Music/Crunch.mp3");
  heartBeat = minim.loadFile("./Music/Heartbeat.mp3");
  //initial setting game
  points = 0;
  life = 10;
  recoverLife = 0;
  level = 1;
  levelBreak = 100;
  dead = false;
  
  for(int i=0;i<rain.length;i++)
  {
    rain[i] = new Rain();
  }
  //frameRate(100);
}

void draw()
{
   if(!dead)
   {
     background(0,200,255);
     backgroundMusic.play();
     strokeWeight(5);
     for(int i=0;i<9;i++)
     {
       rain[i].snow();
     }
     for(int i=9;i<rain.length;i++)
     {
       rain[i].bomb();
     }
     //System.out.println(level);
     game.heart();
     game.score();
     game.life();
     game.snowMan();
     game.recover();
     game.level();
     //game.levelUpWord();
   }
   else
   {
     try
     {
       backgroundMusic.close();
       gameover.play();
       delay(2000);
       game.Musicstop();
     }
     catch(Exception e)
     {
       //System.out.println("");
     }

   }
   
}

void keyPressed()
{
  if(key == CODED)
  {
    if(keyCode == LEFT)
    {
      game.moveLeft();
    }
    if(keyCode == RIGHT)
    {
      game.moveRight();
    }
    if(keyCode == UP)
    {
      gameover.play();
      gameover.rewind();
    }
  }
}

class Game
{
  int xpos, time=0;
  float speed = 50;
  int finalScore;
  Game()
  {
    //snowMan();
  }
  
  void snowMan()
  {
    pushMatrix();
    smooth();
    translate(xpos+width/2,430);
    noStroke();
    fill(255);
    ellipse(0,0,60,60);
    ellipse(0,50,90,90);
    fill(0);
    ellipse(-20,-10,8,8);
    ellipse(20,-10,8,8);
    fill(200,0,0);
    ellipse(0,0,7,7);
    noStroke();
    fill(200,0,0);
    arc(0,10,20,20,0,PI);
    fill(255,0,0);
    rect(-43,-50,86,20);
    strokeWeight(5);
    stroke(10);
    line(-40,-30,-38,30);
    line(40,-30,38,30);
    strokeWeight(3.5);
    line(-50,-20,-39.5,0);
    line(50,-20,39.5,0);
    strokeWeight(3);
    line(-30,-25,-38,-15);
    line(30,-25,38,-10);
    popMatrix();
  }
  
  void heart()
  {
    //draw a heart
    smooth();
    noStroke();
    fill(255,0,0);
    beginShape();
    vertex(30, 15); 
    bezierVertex(30, -5, 75, 5, 30, 40); 
    vertex(30, 15); 
    bezierVertex(30, -5, -15, 5, 30, 40); 
    endShape();
  }
  
  void score()
  {
    textSize(32);
    fill(0);
    text(""+points+"",600,30);
  }
  
  void level()
  {
     if(points>=levelBreak)
     {
       level+=1;
       levelBreak+=100;
       textSize(40);
       //delay = true;
       //System.out.println(delay);
       //fill(0,0,0,100);
       //text("LEVEL UP!",width/2-170,250);
     }
  }
  
  /*void levelUpWord()
  {
    System.out.println(delay+" "+time);
    if(delay&&time<100)
    {
      textSize(40);
      fill(0,0,0,100);
      text("LEVEL UP!",width/2-170,250);
      System.out.println("hi");
      time++;
    }
    else
    {
      delay = false;
    }
  }*/
  
  void life()
  {
    //show lifes
    textSize(32);
    fill(0);
    text(""+life,90,30);
    if(life<=0)
    {
      dead = true;
      fill(255,0,0,130);
      rect(0,0,width,height);
      textSize(60);
      text("GAME OVER!",width/2-200,220);
      text("SCORE "+points,width/2-200,280);
    }
  }
  
  void recover()
  {
    //show recovery bar
    fill(255,0,0,150);
    strokeWeight(1);
    stroke(0);
    rect(20,50,10,30);
    if(recoverLife<0)
    {
      heartBeat.play();
      heartBeat.rewind();
      life--;
      recoverLife=0;
    }
    if(recoverLife >= 1)
    {
      rect(30,50,10,30);
    }
    if(recoverLife >= 2)
    {
      rect(40,50,10,30);
    }
    if(recoverLife >= 3)
    {
      rect(50,50,10,30);
    }
    if(recoverLife >= 4)
    {
      rect(60,50,10,30);
    }
    if(recoverLife >= 5)
    {
      //textSize(30);
      //text("+1 Life!",40,50);
      life++;
      recoverLife=0;
    }
  }
  
  void Musicstop()
  {
    minim.stop();
    //backgroundMusic.close();
    ding.close();
    bomb.close();
    heartBeat.close();
    //gameover.close();
  }
  
  void moveLeft()
  {
    if(xpos > 40-width/2)
    {
      xpos-=speed;
    }
  }
  void moveRight()
  {
    if(xpos < width/2-40)
    {
      xpos+=speed;
    }
  }
  int getXpos()
  {
    return xpos+width/2;
  } 
}

class Rain
{
  float ypos=(int)random(-2000,0);
  //int speed = 1;
  int xpos=0;
  boolean change = true;
  
  Rain()
  {
    Game game = new Game();
  }
  void bomb()
  {
    if(change)
    {
      xpos = (int)random(20,width-20);
    }
    change = false;
    fill(255,150,0);
    noStroke();
    //main part
    ellipse(xpos,ypos,40,40);
    triangle(xpos,ypos-26,xpos+5*pow(3,0.5),ypos-21,xpos-5*pow(3,0.5),ypos-21);
    triangle(xpos,ypos+26,xpos+5*pow(3,0.5),ypos+21,xpos-5*pow(3,0.5),ypos+21);
    
    fill(0);
    //eyes
    ellipse(xpos-10,ypos-10,7,7);
    ellipse(xpos+10,ypos-10,7,7);
    stroke(0);
    //mouth
    line(xpos-10,ypos+10,xpos+10,ypos+10);
    line(xpos-7,ypos+5,xpos-7,ypos+15);
    line(xpos+7,ypos+5,xpos+7,ypos+15);
    //line(xpos,ypos+5,xpos,ypos+15);
    if(ypos>height+40)
    {
      ypos = (int)random(-1000,0);
      change = true;
    }
    else if(((xpos+20>=game.getXpos()-43 && xpos+20<=game.getXpos()+83) || (xpos-20<=game.getXpos()+43 && xpos-20>=game.getXpos()-83)) && (ypos>380 && ypos<410))
    {
      ypos = (int)random(-1000,0);
      change = true;
      bomb.play();
      bomb.rewind();
      //lost 2 life
      life-=2;
      recoverLife=0;
    }
    ypos+=level;
  }
  void snow()
  {
    if(change)
    {
      xpos = (int)random(20,width-20);
    }
    change = false;
    smooth();
    //color of snow
    stroke(0,100,255);
    //main part
    line(xpos, ypos-20, xpos, ypos+20);
    line(xpos-10*pow(3,0.5),ypos-10,xpos+10*pow(3,0.5),ypos+10);
    line(xpos-10*pow(3,0.5),ypos+10,xpos+10*pow(3,0.5),ypos-10);
    //right part
    line(xpos+5*pow(3,0.5),ypos-5,xpos+10*pow(3,0.5),ypos-1);
    line(xpos+5*pow(3,0.5),ypos+5,xpos+10*pow(3,0.5),ypos+1);
    //left part
    line(xpos-5*pow(3,0.5),ypos-5,xpos-10*pow(3,0.5),ypos-1);
    line(xpos-5*pow(3,0.5),ypos+5,xpos-10*pow(3,0.5),ypos+1);
    //top part
    line(xpos, ypos-8, xpos+7.5, ypos-10*pow(3,0.5));
    line(xpos, ypos-8, xpos-7.5, ypos-10*pow(3,0.5));
    //down part
    line(xpos, ypos+8, xpos+7.5, ypos+10*pow(3,0.5));
    line(xpos, ypos+8, xpos-7.5, ypos+10*pow(3,0.5));
    //change y position
    if(ypos>height+40)
    {
      ypos = (int)random(-1000,0);
      change = true;
      recoverLife--;
    }
    else if(((xpos+20>=game.getXpos()-43 && xpos+20<=game.getXpos()+83) || (xpos-20<=game.getXpos()+43 && xpos-20>=game.getXpos()-83)) && (ypos>375 && ypos<410))
    {
      ypos = (int)random(-1000,0);
      change = true;
      ding.play();
      ding.rewind();
      //add points
      points+=10;
      if(recoverLife<5)
      {
        recoverLife++;
        //ding.rewind();
      }
      else
      {
        recoverLife = 0;
      }
    }
    ypos+=level;
  }
}
