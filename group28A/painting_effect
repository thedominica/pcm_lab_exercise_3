import processing.video.*;

Movie movie;
int rectangle = 3; // size of rectangle
int columns, rows;

void setup() {
  size(320,240);
  movie = new Movie(this, "PCMLab9.mov");
  movie.play();
  columns = width / rectangle;
  rows = height / rectangle;
  colorMode(RGB, 255, 255, 255, 50); //last one / softness of effect
}


void draw() { 
  if (movie.available()) {
      movie.read();
      movie.loadPixels();
  
    for (int i = 0; i < columns; i++) {
      for (int j = 0; j < rows; j++) {   
        // FOR EACH AREA OF SIZE OF RECTANGLE WE CHOSE
        int x = i*rectangle;
        int y = j*rectangle;
        int position = (movie.width - x - 1) + y*movie.width; // MIRRORING IMAGE
      
        //GETTING COLOR VALUES OF PIXELS ON REVERSED POSITIONS
        float r = red(movie.pixels[position]);
        float g = green(movie.pixels[position]);
        float b = blue(movie.pixels[position]);
        color c = color(r, g, b, 75);
      
        // DRAWING 1 RECTANGLE
        pushMatrix();
        translate(x+rectangle/2, y+rectangle/2); 
        rotate((2 * PI * brightness(c) / 255.0)); // ROTATION BASED ON BRIGHTNESS
        rectMode(CENTER);
        fill(c);
        noStroke();
        rect(0, 0, rectangle+6, rectangle+6);
        popMatrix();        
      }
    }
  }
}
