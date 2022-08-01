
PImage img;

long px = 0, py = 0;
long palette[] = new long[0xFFFFFF];
long buffer[] = new long[0xFFFFFF];
int cnt = 0;
int match = 0;
int display = 0;
int colorGet;
int colorGet2;

long r, g, b, c;
int i = 0;

int choice1, choice2;

String filename;

PrintWriter textFile;
int error = 0;


void readFile(File selection)
{
  if (selection == null)
  {
    filename = "null";
    println("No file selected");
  } else
    filename = selection.getAbsolutePath();
}


void setup()
{
  size(640, 240);


  init_toolkit();
  
  //set a default choice
  choiceSW[0] = 1;
  menuBT[0] = 1;

  for (int i = 0; i < 0xFFFFFF; i++) //set default value
  {
    palette[i] = 0x7FFFFFFF;
  }
}


void draw()
{
  //Main display
  background(190);
  textSize(32);
  fill(0);
  stroke(0);
  text("RGB565", 100, 70);
  text("RGB888", 100, 120);
  text("Start conversion", 100, 170);


  choice1 = choiceSwitch(50, 50, 0);
  choiceSwitch(50, 100, 1);

  choice2 = menuButton(300, 50, "16-Colors format", 0);
  menuButton(300, 100, "256-Colors format", 1);

  if (pushButton(50, 150, 0) == 1)
    startConv();


}




//////////////////////////////////



void startConv()
{

  int nbit = 0, clrPal = 0;
  int hibyte, lobyte;
  int px_counter = 0; // might be useful...


  selectInput("Select a file", "readFile"); //select a bmp file

  while (filename == null)
  {
    println(filename);
    delay(250);
  }

  if (filename != "null")
  {

    img = loadImage(filename);

    println("W : " + img.width);
    println("H : " + img.height);


    textFile = createWriter("output.c"); //create an output file that store arrays

    if (choice1 == 1) //16 (RGB565) or 32 bits (RGB888) ?
      nbit = 16;
    else
      nbit = 32;


    if (choice2 == 1) // 16 colors (2 px per byte) or 256 colors (1 px per byte) ?
      clrPal = 16;
    else
      clrPal = 256;


    ///////////////////////////////////////////////////////////////////////
    //Palette calculate method

    textFile.println("const uint" + (nbit) +"_t colorPalette[] = {");
    i = 0;
    for (px = 0; px < img.width; px++)
    {
      for (py = 0; py < img.height; py++)
      {
        colorGet = img.pixels[i]; //read actual pixel color

        for (int k = 0; k < cnt; k++)
        {
          //let's compare now this color to every colors found
          if (palette[k] == colorGet) // 2 colors match ?
          {
            match = 1; //say don't store this color read
          }
        }
        if (match == 0) //we get a new color ?
        {
          palette[cnt] = colorGet; //store this new color !
          cnt++; //next...
        }
        match = 0; //reset flag !
        i++; //next pixel
      }
    }

    for (int i = 1; i <= cnt; i++) //display every colors found
    {
      c = (palette[i-1] & 0xff000000) >> 24;
      r = (palette[i-1] & 0xff0000) >> 16;
      g = (palette[i-1] & 0xff00) >> 8;
      b = palette[i-1] & 0xff;

      if (choice1 == 1)
      {
        r = (int)map(r, 0, 255, 0, 31);
        g = (int)map(g, 0, 255, 0, 63);
        b = (int)map(b, 0, 255, 0, 31);
        hibyte = ((int)r << 3) | ((int)g >> 3);
        lobyte = (((int)g & 7) << 5) | (int)b;
        textFile.print("0x" + hex(byte(hibyte)) + hex(byte(lobyte)) + ", ");
      } else
      {
        textFile.print("0x" + hex(byte(r)) + hex(byte(g)) + hex(byte(b)) + ", ");
      }


      if (cnt % 8 == 0)
        textFile.println();

      //println("[" + i + "] : " + hex(byte(c)) + " " + hex(byte(r)) + " " + hex(byte(g)) + " " + hex(byte(b)) + " " + palette[i] );
    }
    textFile.println("\n};");



    println("\npalette done");

    //////////////////////////////////////////////////////////////////////
    //bmp calculate

    int addr1 = 0, addr2 = 0;

    if (clrPal == 256)
    {

      for (i = 0; i < img.width * img.height; i++)
      {
        colorGet = img.pixels[i]; //read actual pixel color

        for (int k = 0; k < cnt; k++)
        {
          //let's compare now this color to every colors found
          if (palette[k] == colorGet) // 2 colors match ?
          {
            addr1 = k;
          }
        }
        buffer[i] = addr1; //write palette adress to the buffer
      }
      px_counter = i;
    } else //clrPal == 16 ?
    {

      int j = 0; //What the hell are you doing here ? return learn how coding like a boss in 2 minutes...
      for (i = 0; i < img.width * img.height; i+=2)
      {
        colorGet = img.pixels[i]; //read actual pixel color
        colorGet2 = img.pixels[i+1]; //read actual pixel color

        for (int k = 0; k < cnt; k++)
        {
          //let's compare now this color to every colors found
          if (palette[k] == colorGet) // 2 colors match ?
          {
            addr1 = k; //write palette adress to the buffer
          }
          if (palette[k] == colorGet2) // 2 colors match ?
          {
            addr2 = k; //write palette adress to the buffer
          }
        }
        buffer[j] = (addr1 << 4) | addr2;
        j++; //very bad boy...
      }
      px_counter = j;
    }

    textFile.println("\n\n\nconst uint8_t bmp[] = {\n"); //let's put some backspace

    for (i = 1; i <= px_counter; i++)
    {

      textFile.print("0x" + hex(byte(buffer[i-1])) + ", ");

      if (i % 16 == 0)
        textFile.println();
    }

    textFile.println("};");
    textFile.close();

    //make a log file to store results
    textFile = createWriter("log.txt");
    textFile.println("Color palette method used : " + clrPal);
    textFile.println("Number of bits per pixels : " + nbit);
    textFile.println("Number of colors found : " + cnt);
    if (cnt > clrPal)
    {
      textFile.println("\nERROR : Too many colors according color definition");
      error = 1;
    }
    textFile.close();
  }


  exit();
}
