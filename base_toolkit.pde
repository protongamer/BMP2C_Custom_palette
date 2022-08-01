int Y_level[] = new int[100];
int X_level[] = new int[100];
int MY_level[] = new int[100];
int MX_level[] = new int[100];
int button[] = new int[100];
int switches[] = new int[100];
int choiceSW[] = new int[100];
int menuBT[] = new int[100];


void init_toolkit(){
 //set all var to 0
  for(int i = 0; i < 100; i++){
   Y_level[i] = 0; 
   X_level[i] = 0;
   MX_level[i] = 0;
   MY_level[i] = 0;
   button[i] = 0;
   switches[i] = 0;
   choiceSW[i] = 0;
   menuBT[i] = 0;
  }
  
}


int sliderY(int x, int y, int number){
  
  fill(255);
  rect(x,y,20,100);
  fill(0);
  rect(x,y+100,20,-Y_level[number]);
  if(mousePressed){
    if(mouseX >= x && mouseX <= x+20 && mouseY >= y && mouseY <= y+100){
     //println(100 - (mouseY-y));
     Y_level[number] = 100 - (mouseY-y);
    }
  }
  return Y_level[number];
}

int middleSliderY(int x, int y, int number){
  
  fill(255);
  rect(x,y,20,100);
  fill(0);
  rect(x,y+50,20,-MY_level[number]);
  if(mousePressed){
    if(mouseX >= x && mouseX <= x+20 && mouseY >= y && mouseY <= y+100){
     //println(100 - (mouseY-y));
     MY_level[number] = 50 - (mouseY-y);
    }
  }
  return MY_level[number];
}

int sliderX(int x, int y, int number){
  
  fill(255);
  rect(x,y,100,20);
  fill(0);
  rect(x,y,X_level[number],20);
  if(mousePressed){
    if(mouseX >= x && mouseX <= x+100 && mouseY >= y && mouseY <= y+20){
     //println((mouseX-x));
     X_level[number] = (mouseX-x);
    }
  }
  return X_level[number];
}

int middleSliderX(int x, int y, int number){
  
  fill(255);
  rect(x,y,100,20);
  fill(0);
  rect(x,y,MX_level[number]+50,20);
  if(mousePressed){
    if(mouseX >= x && mouseX <= x+100 && mouseY >= y && mouseY <= y+20){
     //println((mouseX-x));
     MX_level[number] = (mouseX-x)-50;
    }
  }
  return MX_level[number];
}


byte pushButton(int x, int y, int number){
  
  int c = 0;
  
  if(mousePressed){
    if(mouseX >= x && mouseX <= x+20 && mouseY >= y && mouseY <= y+20){
      c = 32;
      button[number] = 1;
    }
  }
  if(!mousePressed){
    c = 255;
    button[number] = 0;
  }
  
  if(mouseX < x || mouseX > x+20 || mouseY < y || mouseY > y+20){
    c = 255;
    button[number] = 0;
  }
  
  fill(c);
  rect(x,y,20,20);
  
  
  
  return (byte)button[number];
}


int alreadySW = 0;

byte Switch(int x, int y, int number){
  
  int c = 255;
  
  if(mousePressed && alreadySW == 0){
    if(mouseX >= x && mouseX <= x+20 && mouseY >= y && mouseY <= y+20){
    if(switches[number] == 0){
     switches[number] = 1; 
     c = 32;
    }
    else if(switches[number] == 1){
     switches[number] = 0;
     c = 255;
    }
    }
    alreadySW = 1;
  }
  
  if(!mousePressed && alreadySW == 1){
  alreadySW = 0;
  }
  
  
  if(switches[number] == 0){
     c = 255;
    }
    else if(switches[number] == 1){
     c = 32;
    }
    
  
  fill(200);
  rect(x-5,y-5,30,30);
  fill(c);
  rect(x,y,20,20);
  
  return (byte)switches[number];
}

int alreadyMB = 0;

byte menuButton(int x, int y, String inputText, int number){
  
  if(menuBT[number] == 0){
  fill(255);  
  }
  else if(menuBT[number] == 1){
  fill(128);
  }
  
  rect(x, y, (inputText.length()*12),20);
  textSize(12);
  stroke(0);
  fill(0);
  text(inputText, x+inputText.length()*2.25, y+15);
 if(mousePressed && alreadyMB == 0){
   
   if(mouseX >= x && mouseX <= x+(inputText.length()*12) && mouseY >= y && mouseY <= y+20){
     for(int i = 0; i < 100; i++){
     menuBT[i] = 0;
     }
     menuBT[number] = 1;
   }
   
   
  alreadyMB = 1; 
 }
 if(mousePressed && alreadyMB == 1){
 alreadyMB = 0;
 }
 
 return (byte)menuBT[number];
  
}


int alreadyCS = 0;

byte choiceSwitch(int x, int y, int number){
  
  fill(200);
  rect(x-5,y-5,30,30);
  
  if(choiceSW[number] == 0){
  fill(255);  
  }
  else if(choiceSW[number] == 1){
  fill(32);
  }
  
  rect(x, y, 20,20,16);
 if(mousePressed && alreadyMB == 0){
   
   if(mouseX >= x && mouseX <= x+20 && mouseY >= y && mouseY <= y+20){
     for(int i = 0; i < 100; i++){
     choiceSW[i] = 0;
     }
     choiceSW[number] = 1;
   }
   
   
  alreadyMB = 1; 
 }
 if(mousePressed && alreadyMB == 1){
 alreadyMB = 0;
 }
 
 return (byte)choiceSW[number];
  
}
