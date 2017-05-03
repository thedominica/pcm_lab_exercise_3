import processing.video.*;
Movie movie;
//low pass filters
final float[][] average = {    {1/9f,1/9f,1/9f},
                               {1/9f,1/9f,1/9f},
                               {1/9f,1/9f,1/9f}  };
final float[][] gaussian = {   {1/16f,2/16f,1/16f}, 
                               {2/16f,4/16f,2/16f},
                               {1/16f,2/16f,1/16f}  };
final float[][] bigGaussian = {  {1/256f, 4/256f,  6/256f,  4/256f,  1/256f},
                                 {4/256f, 16/256f, 24/256f, 16/256f, 4/256f},
                                 {6/256f, 24/256f, 36/256f, 24/256f, 6/256f},
                                 {4/256f, 16/256f, 24/256f, 16/256f, 4/256f},
                                 {1/256f, 4/256f,  6/256f,  4/256f,  1/256f}  };

void setup(){
  size(320,240);
  movie = new Movie(this, "PCMLab9.mov");
  movie.loop();
}

void draw(){
  tint(255,20);
  image(movie, 10, 10);
  
}

//called every time a new frame is available to read
void movieEvent(Movie m){
  m.read();
  PImage p = createImage(m.width, m.height, RGB);
  p.copy(m, 0, 0, m.width, m.height, 0, 0, m.width, m.height);
  println("copy pixels[]: " + p.pixels[0]);
  color c = p.get(10,10);
  println("copy getPixels: " + red(c) + " g: " + green(c) + " ,b: " + blue(c));
  p.set(10,10,color(100,100,100));
  color c1 = p.get(10,10);
  println("copy after: " + red(c1) + " g: " + green(c1) + " b: " + blue(c1));
  fold3by3(gaussian);
}

/*TODO folding:
1. make copy of the current frame
2. mess in the copy of the frame
3. iterate over the copy of the frame(2dim)
4. calculate current pixel with the current filter and the original frame
5. care for borders (copy most outer value thats accessible)
6. do it for every channel (or find a way how to do it in once)
7. choose to show the copy instead of the original

8. opt: do it also for 5x5
*/
float[][] fold3by3(float[][] filter){
  movie.loadPixels();
  //println("pixels[]: " + movie.pixels[0]);
  color c = movie.get(10,10);
  println("getPixels: " + red(c) + " g: " + green(c) + " ,b: " + blue(c));

  return null;
}

float[][] fold5by5(float[][] filter){
 return null; 
}