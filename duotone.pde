
// duotone [with alpha values] - image processing
// david medina, 2015



color c1, c2;
int colorRange=256;
float[] alpha = new float[colorRange];


void setup() {  
  size(800, 600, P2D);
  colorMode(RGB, 255);
  background(255,255,255);

  c1 = color(50, 0, 0, 255); //main
  c2 = color(0, 0, 0, 10);  //transparent  
  
  PImage pic= loadImage("http://grama.co/wp-content/uploads/2017/01/PP03-1024x768.jpg");
  PImage bck=loadImage("http://grama.co/wp-content/uploads/2017/01/P1050132-768x512.jpg");
  
  bck = duotone(bck, c1, c2);
  image(bck, 0, 50);

  c1 = color(0, 50, 0, 255); //main
  c2 = color(0, 0, 0, 10);  //transparent  
  
  pic = duotone(pic, c1, c2);
  image(pic, 0, 0);
}


PImage duotone(PImage img, color color1, color color2) {

  img.resize(width, 0);
  img.filter(GRAY);

  float a = (alpha(color2)-alpha(color1))/colorRange;
  color gradient[] = new color[colorRange];

  // Creates a gradient of 255 colors between color1 and color2 and alpha gradient
  for (int d=0; d < colorRange-1; d++) {    
    float ratio= float(d)*1.0/colorRange;
    gradient[d]=lerpColor(color1, color2, ratio);
    alpha[d]=alpha(color1) + int(d*a);
  }
  color tc=0;
  float br=0;

  //auxiliar image for alpha pixels - mode ARGB
  PImage aux2=createImage(img.width, img.height, ARGB);  
  aux2.loadPixels();
  
  img.loadPixels();
  
  for (int y = 0; y < img.height; y++) {
    for (int x = 0; x < img.width; x++) {
      int loc = x + y*img.width;

      // get the brightness
      br = constrain(brightness(img.pixels[loc]),0,colorRange-1);

      tc=gradient[int(br)];
      color pix= color(red(tc), green(tc), blue(tc), alpha[int(br)]);
      
      // Set the pixel to a gradient with the level of brightness
      aux2.pixels[loc]  =  img.pixels[loc]  =   pix;
      
    }
  }

  img.updatePixels();
  aux2.updatePixels(); 
  return(aux2);
}