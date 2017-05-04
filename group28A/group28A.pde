import processing.video.*;
Movie movie;
PImage filtered;
int counter = 0;
int counterEvent = 0;
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
                                 
final float[][] sharpen1 = {  {-1, -1, -1},
                             {-1, 9, -1},
                             {-1, -1, -1}};
                             
final float[][] sharpen2 = {  {0,-1,0}, 
                              {-1,5,-1},
                              {0,-1,0}};
                             

void setup(){
  size(320,240);
  movie = new Movie(this, "PCMLab9.mov");
  movie.play();
}

void draw(){
  //tint(255,20);
  image(movie, 0, 0);
  //image(filtered,0,0);
  if(filtered == null){
    println("filtered null");
    image(movie,0,0);
  }
  else{
    println("filtered");
    image(filtered,0,0);
  }
  println("counter draw: " + counter ++);
  
}

//called every time a new frame is available to read
void movieEvent(Movie m){
  //println("counterevent: " + counterEvent++);
  m.read();

  filtered = fold3by3(sharpen1, m);
  //movie.stop();

  println("counter event: " + counterEvent++);
  //PImage p = createImage(m.width, m.height, RGB);
  //p.copy(m, 0, 0, m.width, m.height, 0, 0, m.width, m.height);

  //fold3by3(gaussian);
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
PImage fold3by3(float[][] filter, PImage originalFrame){
  
  PImage result = createImage(originalFrame.width, originalFrame.height, RGB);
  result.copy(originalFrame, 0, 0, originalFrame.width, originalFrame.height, 0, 0, originalFrame.width, originalFrame.height);
  /*
  println("copy pixels[]: " + result.pixels[0]);
  color c = result.get(10,10);
  println("copy getPixels: " + red(c) + " g: " + green(c) + " ,b: " + blue(c));
  //result.set(10,10,color(100,100,100));
  color c1 = result.get(10,10);
  println("copy after: " + red(c1) + " g: " + green(c1) + " b: " + blue(c1));
  */
  //movie.loadPixels();
  //println("pixels[]: " + movie.pixels[0]);
  //color c = movie.get(10,10);
  //println("getPixels: " + red(c) + " g: " + green(c) + " ,b: " + blue(c));
 //println("widht: " + result.width + " height: " + result.height);

for(int x = 0; x < result.width; x++){
  
    for(int y = 0; y < result.height; y++){
       color pixelResult = calculatePixelFolding(filter, originalFrame, result, x, y);
       //println("color result pixel r: " + red(pixelResult) + " ,g: " + green(pixelResult) + " ,b: " + blue(pixelResult));
       result.set(x,y,pixelResult);
}

  
}
println("10,10: original: r: " + red(originalFrame.get(10,10)) + " , g: " + green(originalFrame.get(10,10)) + " b: " + blue(originalFrame.get(10,10)));
println("10,10: r: " + red(result.get(10,10)) + " ,g: " + green(result.get(10,10)) + " ,b: " + blue(result.get(10,10)));
//image(originalFrame,0,0);
return result;

/*for(int x = 0; x < result.width; x++){
    for(int y = 0; y < result.height; y++){

       println("something in the loop, x= " + x + " y= " + y);
    }
  }
  */

  //return null;
}

color calculatePixelFolding(float[][] filter, PImage originalFrame, PImage result, int positionX, int positionY){
  
  int sumRed = 0;
  int sumGreen = 0;
  int sumBlue = 0;
  for(int i = -1; i <= 1; i++){
    for(int j = -1; j <= 1; j++){
      
      int currentX;
      int currentY;
      if(positionX + i < 0 || positionX + i >= result.width){
        currentX = positionX;
      }
      else{
         currentX = positionX +i; 
      }
      if(positionY + j < 0 || positionY + i >= result.height){
        currentY = positionY;
      }
      else{
         currentY = positionY +j; 
      }
      //sumuptheposition
      color current = originalFrame.get(currentX,currentY);
      sumRed += red(current);
      sumGreen += green(current);
      sumBlue += blue(current);
      
    }
  }
  
  return color(sumRed, sumGreen, sumBlue);
  
  //return 0; 
}

float[][] fold5by5(float[][] filter){
 return null; 
}