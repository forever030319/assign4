final int GAME_START = 0;
final int GAME_RUN = 1;
final int GAME_LOSE = 2;
int gameState;
float speed = 5;

PImage start2, start1, end2, end1;
int hp_initial=20;
int hp;

int x,y;

boolean upPressed = false;
boolean downPressed = false;
boolean leftPressed = false;
boolean rightPressed = false;

PImage hpImg,treasureImg,fighterImg,enermyImg;
PImage bg1,bg2;
int width=640, height=480;
int treasure_width=41, treasure_height=41; //treasure's size
int treasure_x,treasure_y; //treasure's position
int enermy_height=61, enermy_width=61; //enermy's size
float enermy_x,enermy_y; //enermy's position
int x_flood, rand_flood;
int bg1_x,bg1_y;
int bg2_x,bg2_y;
int flighter_x,flighter_y;
int flighter_width=51, flighter_height=51;

PImage[] flame = new PImage[5];

int [] enermy_wave1_lived = { 0,0,0,0,0 };
int [] enermy_wave2_lived = { 0,0,0,0,0 };
int [] enermy_wave3_lived = { 0,0,0,0,0,0,0,0 };

float [][] enermy_wave1 = {
  {0, 0},
  {0, 0},
  {0, 0},
  {0, 0},
  {0, 0}
};

float [][] enermy_wave2 = {
  {0, 0},
  {0, 0},
  {0, 0},
  {0, 0},
  {0, 0}
};

float [][] enermy_wave3 = {
  {0, 0},
  {0, 0},
  {0, 0},
  {0, 0},
  {0, 0},
  {0, 0},
  {0, 0},
  {0, 0}
};

int EnermyToFlighter;
int enermy_count;

int currentFlame=0;
int FrameRate = 100;

void setup () {
  size(640, 480) ;
  background(0);
  
  start2 = loadImage("img/start2.png");//default
  start1 = loadImage("img/start1.png");//cursor
  
  end2 = loadImage("img/end2.png");
  end1 = loadImage("img/end1.png");
  
  hpImg = loadImage("img/hp.png");
  treasureImg = loadImage("img/treasure.png");
  fighterImg = loadImage("img/fighter.png");
  enermyImg = loadImage("img/enemy.png");
  bg1 = loadImage("img/bg1.png");
  bg2 = loadImage("img/bg2.png");
  
  flighter_x=580;
  flighter_y=240;

  treasure_x = floor(random(width-treasure_width/2));
  treasure_y = floor(random(height-treasure_height/2));
  
  enermy_x = 0;
  enermy_y = floor(random(height-enermy_height));
  
  x_flood = 200;
  
  for(int i=0;i<5;i++){
    flame[i] = loadImage("img/flame"+(i+1)+".png");
  }

  bg1_x = -640;
  bg1_y = 0;
  bg2_x = 0;
  bg2_y = 0;
  
  gameState = GAME_START;
  
  enermy_count = 0;
 frameRate(60);
}

void draw() {

background(0); // clear scene

  switch(gameState){
    case GAME_START:
      image(start2,0,0);
      if( mouseY<410 && mouseY>375 && mouseX>200 && mouseX<450){
        image(start1,0,0);
        if (mousePressed){
          gameState = GAME_RUN;
        }
      }
      break;
    
    case GAME_RUN:
      image(bg1,bg1_x,0); 
      image(bg2,bg2_x,0);
      
      hp = (x_flood/100)*hp_initial;
      if(hp>=200){
        hp_initial = 100;
        hp = 200;
      }
      if(hp<=0){
        hp_initial = 0;
        hp = 0;
        gameState = GAME_LOSE;
      }
      
      //HP
      stroke(0);
      fill(255,0,0);
      rect(5,4,hp,20);
      
      image(hpImg,0,0);
      
      image(fighterImg,flighter_x,flighter_y);
      image(treasureImg,treasure_x,treasure_y);
      
    
      //enermy
      switch(enermy_count%3){
        //enermy_wave1[0][0] => 第0台-x軸
        //enermy_wave1[0][1] => 第0台-y軸

        //enermy_wave1[1][0] => 第1台-x軸
        //enermy_wave1[1][1] => 第1台-y軸
        case 0:
          if(enermy_x == 0 && enermy_count%3==0){
            enermy_x = -5*enermy_width;
            for(int i=0;i<5;i++){
              enermy_wave1_lived[i] = 1;
            }
          }
          for(int i=0;i<5;i++){
            int x = i*enermy_width;
            enermy_wave1[i][0] = enermy_x+x;
            enermy_wave1[i][1] = enermy_y;
            if(enermy_wave1_lived[i]==0)
              enermy_wave1[i][0]=-enermy_width;
            image(enermyImg,enermy_wave1[i][0],enermy_wave1[i][1]);
          }
          break;
        
        case 1:
          if(enermy_x == 0 && enermy_count%3==1){
            enermy_x = -5*enermy_width;
            for(int i=0;i<5;i++){
              enermy_wave2_lived[i] = 1;
            }
          }
          while(enermy_y < enermy_height*4){
            enermy_y = enermy_height*4 +  floor(random(height-enermy_height - enermy_height*4));
          }
       
          for(int i=0;i<5;i++){
            int x = i*enermy_width;
            int y = i*enermy_height;
            enermy_wave2[i][0] = enermy_x+x;
            enermy_wave2[i][1] = enermy_y-y;
            if(enermy_wave2_lived[i]==0)
              enermy_wave2[i][0]=-enermy_width;
            image(enermyImg,enermy_wave2[i][0],enermy_wave2[i][1]);
          }
          break;
        
        case 2:
         
          if(enermy_x == 0 && enermy_count%3==2){
            enermy_x = -4*enermy_width;
            for(int i=0;i<8;i++){
              enermy_wave3_lived[i] = 1;
            }
          }
          while(enermy_y < enermy_height*2 || enermy_y > height-enermy_height*3){
            enermy_y = enermy_height*2 +  floor(random(height-enermy_height*3 - enermy_height*2));  
          }

          int enermy_index = 0;
          enermy_wave3[enermy_index][0] = enermy_x;
          enermy_wave3[enermy_index][1] = enermy_y;
          enermy_index++;
          for(int j=1;j<3;j++){
            x = j*enermy_width;
            y = j*enermy_height;
            enermy_wave3[enermy_index][0] = enermy_x+x;
            enermy_wave3[enermy_index][1] = enermy_y-y;
            enermy_index++;
            enermy_wave3[enermy_index][0] = enermy_x+x;
            enermy_wave3[enermy_index][1] = enermy_y+y;
            enermy_index++;
          }

          for(int i=1;i<3;i++){
             x = (i+2)*enermy_width;
             y = i*enermy_height;
             enermy_wave3[enermy_index][0] = enermy_x+x;
             enermy_wave3[enermy_index][1] = enermy_y+enermy_height*2-y;
             enermy_index++;
             if( i!=2 ){
               enermy_wave3[enermy_index][0] = enermy_x+x;
               enermy_wave3[enermy_index][1] = enermy_y-enermy_height*2+y;
               enermy_index++;
             }
           }

           for(int idx=0;idx<enermy_index;idx++){
               if(enermy_wave3_lived[idx]==0)
                enermy_wave3[idx][0]=-enermy_width;
               image(enermyImg,enermy_wave3[idx][0],enermy_wave3[idx][1]);
          }

          break;
        
        default:
        break;
      }
      
      
      
     
      //background image movement
      bg2_x++;
      bg1_x++;
    
      if(bg2_x==640){
        bg2_x = -640;
      }
      if(bg1_x == 640){
       bg1_x =-640; 
      }
   
      if (upPressed) {
        flighter_y -= speed;
      }
      if (downPressed) {
        flighter_y += speed;
      }
      if (leftPressed) {
        flighter_x -= speed;
      }
      if (rightPressed) {
        flighter_x += speed;
      }
      
      //boundary detection
      if(flighter_x >= width-flighter_width){
        flighter_x = width-flighter_width;
      }
      if( flighter_x<0 ){
        flighter_x = 0;
      }
      
      if(flighter_y> height-flighter_height){
        flighter_y=height-flighter_height;
      }
      if(flighter_y<0){
        flighter_y=0;
      }
       
      //flighter to treasure
      if(flighter_x+flighter_width >= treasure_x && flighter_x <= treasure_x+treasure_width && flighter_y+flighter_height >= treasure_y && flighter_y <= treasure_y+treasure_height){
        treasure_x = floor(random(width-treasure_width/2));
        treasure_y = floor(random(height-treasure_height/2));
        hp_initial = hp_initial+10;
      }
      
      //flighter to enermy_wave1
      switch(enermy_count%3){
        case 0:
          for(int i=0;i<5;i++){
            if(flighter_x+flighter_width >= enermy_wave1[i][0] && flighter_x <=  enermy_wave1[i][0]+enermy_width && flighter_y+flighter_height >=  enermy_wave1[i][1] && flighter_y <=  enermy_wave1[i][1]+enermy_height){
              enermy_wave1_lived[i] = 0;
              hp_initial = hp_initial-20;
              image(flame[currentFlame],enermy_wave1[i][0],enermy_wave1[i][1]);
              if(frameCount%(FrameRate/10)==0){
                currentFlame++;
                if(currentFlame>5){
                 currentFlame =0;
                 }     
              }
            }
          }
        break;

        case 1:
          for(int i=0;i<5;i++){
            if(flighter_x+flighter_width >= enermy_wave2[i][0] && flighter_x <=  enermy_wave2[i][0]+enermy_width && flighter_y+flighter_height >=  enermy_wave2[i][1] && flighter_y <=  enermy_wave2[i][1]+enermy_height){
              enermy_wave2_lived[i] = 0;
              hp_initial = hp_initial-20;
              image(flame[currentFlame],enermy_wave2[i][0],enermy_wave2[i][1]);
              if(frameCount%(FrameRate/10)==0){
                currentFlame++;
                if(currentFlame>5){
                 currentFlame =0;
                 }     
              }
            }
          }
        break;

        case 2:
          for(int i=0;i<8;i++){
            if(flighter_x+flighter_width >= enermy_wave3[i][0] && flighter_x <=  enermy_wave3[i][0]+enermy_width && flighter_y+flighter_height >=  enermy_wave3[i][1] && flighter_y <=  enermy_wave3[i][1]+enermy_height){
              enermy_wave3_lived[i] = 0;
              hp_initial = hp_initial-20;
              image(flame[currentFlame],enermy_wave3[i][0],enermy_wave3[i][1]);
              if(frameCount%(FrameRate/10)==0){
                currentFlame++;
                if(currentFlame>5){
                 currentFlame =0;
                 }     
              }
            }
          }
        break;

        default:
        break;
      }

      enermy_x = enermy_x +3;
      if(enermy_x>=640){
        enermy_count++;
        enermy_y = floor(random(height-enermy_height));
        enermy_x = 0;
      }
      enermy_x %= 640;

      break;
    
    case GAME_LOSE:
      image(end2,0,0);
      if( mouseY<350 && mouseY>300 && mouseX>200 && mouseX<430){
        image(end1,0,0);
        if (mousePressed){
          background(0);
          hp_initial = 20;
          flighter_x=580;
          flighter_y=240;
          
          enermy_count = 0;
          treasure_x = floor(random(width-treasure_width/2));
          treasure_y = floor(random(height-treasure_height/2));
          enermy_x = 0;
          enermy_y = floor(random(height-enermy_height));
          gameState = GAME_RUN;
        }
      }
      break;
  }
}
void keyPressed(){
  if (key == CODED) { // detect special keys 
    switch (keyCode) {
      case UP:
        upPressed = true;
        break;
      case DOWN:
        downPressed = true;
        break;
      case LEFT:
        leftPressed = true;
        break;
      case RIGHT:
        rightPressed = true;
        break;
    }
  }
}
void keyReleased(){
  if (key == CODED) { // detect special keys 
    switch (keyCode) {
      case UP:
        upPressed = false;
        break;
      case DOWN:
        downPressed = false;
        break;
      case LEFT:
        leftPressed = false;
        break;
      case RIGHT:
        rightPressed = false;
        break;
    }
  }
}
