PImage Im;
final int ZERO = 0, BN_MAX = 255, SOLAR_ALPHA_MAX = 16, RECT_MAX = 300, RECT_MIN = 20, RECT_GROW = 5;
final float RED_INFLUENCE = 0.3, GREEN_INFLUENCE = 0.6, BLUE_INFLUENCE = 0.1;
int type, rect_Dim, BN_Limit, solar_alpha;
float gam;
void settings() {
  Im = loadImage("lenna.png");
  size(Im.width, Im.height+100);
}
void setup() {
  rect_Dim = 40;
  type = 0;
  gam = 1;
  BN_Limit = 120;
  solar_alpha = 6;
}

void draw() {
  background(0);
  image(Im, 0, 0);
  rectMode(CENTER);
  noFill();
  stroke(0, 255, 0);
  strokeWeight(3);
  rect(mouseX, mouseY, rect_Dim, rect_Dim);
  textSize(20);
  text("Press 'c' to change mode or 'r' to reset the image.", 0, Im.height+25);
  text("rect: " + rect_Dim + "  [ + | - ]", 0, Im.height+50);
  String mode_status = "";
  if (type==0) {
    mode_status = "mode: Logarithm";
  } else if (type==1) {
    mode_status = "mode: Gamma (" + gam + ")" +  "  [ * | / ]";
  } else if (type==2) {
    mode_status = "mode: Negative";
  } else if (type==3) {
    mode_status = "mode: RGB to Gray scale";
  } else if (type==4) {
    mode_status = "mode: Binary Black&White (Limit = " + BN_Limit + ")" +  "  [ * | / ]";
  } else if (type==5) {
    mode_status = "mode: Solarization (Alpha = " + solar_alpha + ")" +  "  [ * | / ]";
  }
  text(mode_status, 0, Im.height+75);
}

PImage logarithm(PImage I) {
  PImage tmp = createImage(I.width, I.height, RGB);
  I.loadPixels();
  tmp.loadPixels();
  float r, g, b;
  float c = 255/log(256);
  for (int i = 0; i<tmp.pixels.length; i++) {
    r = c*log(1+red(I.pixels[i]));
    g = c*log(1+green(I.pixels[i]));
    b = c*log(1+blue(I.pixels[i]));
    tmp.pixels[i] = color(r, g, b);
  }
  tmp.updatePixels();
  return tmp;
}

PImage rgb2gray(PImage I) {
  PImage tmp = createImage(I.width, I.height, RGB);
  I.loadPixels();
  tmp.loadPixels();
  float r, g, b;
  for (int i = 0; i<tmp.pixels.length; i++) {
    r = red(I.pixels[i])*RED_INFLUENCE;
    g = green(I.pixels[i])*GREEN_INFLUENCE;
    b = blue(I.pixels[i])*BLUE_INFLUENCE;
    int gray = (int)(r+g+b);
    tmp.pixels[i] = color(gray);
  }
  tmp.updatePixels();
  return tmp;
}

PImage binaryBlackWhite(PImage I) {
  PImage tmp = createImage(I.width, I.height, RGB);
  I = rgb2gray(I);
  I.loadPixels();
  tmp.loadPixels();
  color c;
  for (int i = 0; i<tmp.pixels.length; i++) {
    if (red(I.pixels[i]) < BN_Limit)
      c = color(0);
    else
      c = color(255);
    tmp.pixels[i] = c;
  }
  tmp.updatePixels();
  return tmp;
}

PImage negative(PImage I) {
  PImage tmp = createImage(I.width, I.height, RGB);
  I.loadPixels();
  tmp.loadPixels();
  float r, g, b;
  for (int i = 0; i<tmp.pixels.length; i++) {
    r = 255-red(I.pixels[i]);
    g = 255-green(I.pixels[i]);
    b = 255-blue(I.pixels[i]);
    tmp.pixels[i] = color(r, g, b);
  }
  tmp.updatePixels();
  return tmp;
}

PImage gamma(PImage I, float G) {
  PImage tmp = createImage(I.width, I.height, RGB);
  I.loadPixels();
  tmp.loadPixels();
  float r, g, b;
  float c = 1/pow(255, G-1);
  for (int i = 0; i<tmp.pixels.length; i++) {
    r = c*pow(red(I.pixels[i]), G);
    g = c*pow(green(I.pixels[i]), G);
    b = c*pow(blue(I.pixels[i]), G);
    tmp.pixels[i] = color(r, g, b);
  }
  tmp.updatePixels();
  return tmp;
}

int solar_pol(int i) {
  float x = (float)i/255;
  float tmp = solar_alpha*pow(x,3)-((3/2)*solar_alpha*pow(x,2))+(1+solar_alpha/2)*x;
  return round(255*tmp);
}

PImage solar(PImage I) {
  PImage tmp = createImage(I.width, I.height, RGB);
  I.loadPixels();
  tmp.loadPixels();
  float r, g, b;
  for (int i = 0; i<tmp.pixels.length; i++) {
    r = solar_pol((int)red(I.pixels[i]));
    g = solar_pol((int)green(I.pixels[i]));
    b = solar_pol((int)blue(I.pixels[i]));
    tmp.pixels[i] = color(r, g, b);
  }
  tmp.updatePixels();
  return tmp;
}

void keyPressed() {
  if (key=='+' && rect_Dim <RECT_MAX) {
    rect_Dim+=RECT_GROW;
  } else if (key == '-' && rect_Dim >RECT_MIN) {
    rect_Dim-=RECT_GROW;
  }
  if ((key=='*' || key == '/') && type==1) {
    if (key=='*' && gam <30)
      gam+=0.2;
    else if (key=='/' && gam > 0.2)
      gam-=0.2;
  }
  if ((key=='*' || key == '/') && type==4) {
    if (key=='*' && BN_Limit <BN_MAX)
      BN_Limit+=1;
    else if (key=='/' &&  BN_Limit >ZERO)
      BN_Limit-=1;
  }
  if ((key=='*' || key == '/') && type==5) {
    if (key=='*' && solar_alpha <SOLAR_ALPHA_MAX)
      solar_alpha+=1;
    else if (key=='/' &&  solar_alpha > ZERO)
      solar_alpha-=1;
  } else if (key=='c' || key=='C') {
    type = (type+1)%6;
  } else if (key == 'r' || key=='R') {
    Im = loadImage("lenna.png");
    gam = 1;
    BN_Limit = 120;
    solar_alpha = 6;
  }
}

void mousePressed() {
  PImage raw = Im.get(mouseX-rect_Dim/2, mouseY-rect_Dim/2, rect_Dim, rect_Dim);
  PImage tmp = createImage(rect_Dim, rect_Dim, RGB);
  switch(type) {
  case 0:
    tmp = logarithm(raw);
    break;
  case 1:
    tmp = gamma(raw, gam);
    break;
  case 2:
    tmp = negative(raw);
    break;
  case 3:
    tmp = rgb2gray(raw);
    break;
  case 4:
    tmp = binaryBlackWhite(raw);
    break;
  case 5:
    tmp = solar(raw);
    break;
  }
  Im.set(mouseX-rect_Dim/2, mouseY-rect_Dim/2, tmp);
  Im.updatePixels();
}
