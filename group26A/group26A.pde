import processing.video.*;
Movie movie;

void setup(){
  size(320,240);
  movie = new Movie(this, "PCMLab9.mov");
  movie.loop();
}

void draw(){
  tint(255,20);
  image(movie, mouseX, mouseY);
}

//called every time a new frame is available to read
void movieEvent(Movie m){
  m.read();
}