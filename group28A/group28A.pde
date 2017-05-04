import processing.video.*;
Movie movie;
PImage filtered;

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
   
//high pass filters
final float[][] sharpen1 = {  {-1, -1, -1},
                             {-1, 9, -1},
                             {-1, -1, -1}};
                             
final float[][] sharpen2 = {  {0,-1,0}, 
                              {-1,5,-1},
                              {0,-1,0}};
//edge detection                              
final float[][] laplacian1 = {  {-1,-1,-1}, 
                               {-1,8,-1},
                               {-1,-1,-1}};
                               
final float[][] laplacian2 = {  {0,-1,0},
                                {-1,4,-1}, 
                                {0,-1,0}};
                                
final float[][] sobelVertical = {   {-1,0,1},
                                    {-2,0,2}, 
                                    {-1,0,1}};
                                    
final float[][] sobelHorizontal = { {-1,-2,-1},
                                    {0,0,0},
                                    {1,2,1}};
          
                             

void setup(){
  size(320,240);
  movie = new Movie(this, "PCMLab9.mov");
  movie.play();
}

void draw(){
  if(filtered == null){
    image(movie,0,0);
  }
  else{
    image(filtered,0,0);
  }
  
}

//called every time a new frame is available to read
void movieEvent(Movie m){
  m.read();
  filtered = fold3by3(sobelHorizontal, m);
}

/* folding step by step:
1. make copy of the current frame
2. mess in the copy of the frame
3. iterate over the copy of the frame(2dim)
4. calculate current pixel with the current filter and the original frame
5. care for borders (copy most outer value thats accessible)
6. do it for every channel (or find a way how to do it in once)
7. choose to show the copy instead of the original
*/
PImage fold3by3(float[][] filter, PImage originalFrame){
  
  PImage result = createImage(originalFrame.width, originalFrame.height, RGB);
  result.copy(originalFrame, 0, 0, originalFrame.width, originalFrame.height, 0, 0, originalFrame.width, originalFrame.height);


  for(int x = 0; x < result.width; x++){
      for(int y = 0; y < result.height; y++){
         color pixelResult = calculatePixelFolding(filter, originalFrame, result, x, y);
         result.set(x,y,pixelResult);
    }
  }
  
  return result;

}

color calculatePixelFolding(float[][] filter, PImage originalFrame, PImage result, int positionX, int positionY){
  
  int sumRed = 0;
  int sumGreen = 0;
  int sumBlue = 0;
  for(int i = -1; i <= 1; i++){
    for(int j = -1; j <= 1; j++){
      
      int currentX;
      int currentY;
      //get position in the original image
      //take the borders into account, copy the most outer value if it is outside the image
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
      //apply the actual filter, +1 to get the actual position in the array since we start with i= -1
      sumRed += red(current)*filter[i+1][j+1];
      sumGreen += green(current)*filter[i+1][j+1];
      sumBlue += blue(current)*filter[i+1][j+1];
      
    }
  }
  
  return color(sumRed, sumGreen, sumBlue);
}