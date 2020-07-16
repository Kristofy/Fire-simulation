class GridController{
  int H, W;
  int[][] frequencies;
  int[][] saveMap;
  float[][] rng;
  
  GridController(){
    noiseSeed(0);
    H = height;
    W = width;
    frequencies = new int[H][W];
    saveMap = new int[H][W];
    rng = new float[H][W];

    // grid generation //
    
    float[][] height_map = _GenerateHeightMap(TEST_LAYERS);
  //  float[][] height_map = new float[H][W];
    for(int i = 0; i < H; i++) for(int j = 0; j < W; j++) rng[i][j] = random(100);
    
    _AddIslandMask(height_map);

    int steps = 65;
    float self = 55;
    _ApplySmoothing(height_map, steps, self);
   
    _SaveMap(height_map, frequencies);
   
    
    println("initialised");
    println("Layers: " + str(TEST_LAYERS));
  }
  
  float[][] _GenerateHeightMap(int layers){
    // adding multiple noise layers
    float amplitude = 1;
    float[][] height_map = new float[H][W];
    for(int i = 0; i < layers; i++){
      float noise_offsetx = random(100), noise_offsety = random(100);
      float noise_increment = 0.02;
      for(int y = 0; y < H; y++){
        for(int x = 0; x < W; x++){
          float h = int(map(noise(noise_offsetx, noise_offsety), 0, 1, -150, 1000));
          height_map[y][x] += h * amplitude;
          noise_offsetx += noise_increment;
        }
        noise_offsetx = 0;
        noise_offsety += noise_increment;
      }
      amplitude/=2;
    }
    
    // normalizing the height map to 0 - 1000
    float normalize = pow(2, layers-1) / (pow(2, layers)-1);
    for(int y = 0; y < H; y++){
        for(int x = 0; x < W; x++){
          height_map[y][x] = max(height_map[y][x]*normalize, 0);
      }
    }
    
    return height_map;
  }
  
  void _AddIslandMask(float[][] height_map){
    float dist_max = W/2; //dist(0, 0, W/2, H/2);
     for(int y = 0; y < H; y++){
        for(int x = 0; x < W; x++){
          float d = dist(x, y, W/2, H/2);
          height_map[y][x] *= (d < W/4 ? 1 : (1-d/dist_max)*2);
      }
    }
    
  }
  
  void _ApplySmoothing(float[][] height_map, int steps, float self){
    
    for(int i = 0; i < steps; i++){
     float[][] new_map = new float[H][W];
     for(int y = 1; y < H - 1; y++){
      for(int x = 1; x < W - 1; x++){
        
        float sum = 0;
        for(int ver = -1; ver <= 1; ver++){
         for(int hor = -1; hor <= 1; hor++){
          sum+=height_map[y+ver][x+hor]; 
         }
        }
        float avg = (sum+height_map[y][x]*self)/(9+self);
        new_map[y][x] = avg;
      }
     }
     arrayCopy(new_map, height_map);
    }
 
  }
  
  void _SaveMap(float[][] height_map, int[][] map_to_save){
    for(int y = 0; y < H; y++){
        for(int x = 0; x < W; x++){
          int h = int(height_map[y][x]);
          map_to_save[y][x] = h;
        }
      } 
  }
  
   void _SaveMask(float[][] height_map, int[][] map_to_save){
    for(int y = 0; y < H; y++){
        for(int x = 0; x < W; x++){
          int h = int(height_map[y][x]);
          map_to_save[y][x] = h;
        }
      } 
  }
  
  void SetOnFire(int x, int y){
    if(Inflammability[FindStateIndexByHeight(frequencies[y][x])] > 0){
      frequencies[y][x] = ExactFrequencies[States.FIRE]; 
    }
  }
  
  void Update(){
     int[][] new_frequencies = new int[H][W];
     for(int y = 1; y < H - 1; y++){
        for(int x = 1; x < W - 1; x++){
          int h = frequencies[y][x];
          if(h == ExactFrequencies[States.FIRE]){
            for(int dir = 0; dir < 4; dir++){
              if(Inflammability[FindStateIndexByHeight(frequencies[y+dy[dir]][x+dx[dir]])] > random(1)){
                new_frequencies[y+dy[dir]][x+dx[dir]] = h;
              }
            }
            if(FireTime <= random(1)){
              new_frequencies[y][x] = ExactFrequencies[States.BURNED];
            }else{
              new_frequencies[y][x] = h;
            }
          }else if(new_frequencies[y][x] != ExactFrequencies[States.FIRE]){
           new_frequencies[y][x] = frequencies[y][x]; 
          }
        }
      }
      frequencies = new_frequencies;
      //arrayCopy(new_frequencies, frequencies);
      // arrayCopy(frequencies, saveMap);
  }
  
  void Render(){
    loadPixels();
    
     for(int y = 0; y < H; y++){
      for(int x = 0; x < W; x++){
        color c = color(0,0,0);
        int h = frequencies[y][x];
        for(int i = 1; i <= States.WOOD; i++){
          
          if(h < Heights[i]){
            c = lerpColor(Colors[i][0], Colors[i][1], map(h, Heights[i-1], Heights[i], 0, 1));
            break;
          }
        }
       
       if(h == ExactFrequencies[States.FIRE]){
          c = lerpColor(Colors[States.FIRE][0], Colors[States.FIRE][1], random(1)); 
        } else if(h == ExactFrequencies[States.BURNED]){
          c = lerpColor(Colors[States.BURNED][0], Colors[States.BURNED][1], rng[y][x]); 
        }
          
        pixels[y * width + x] = c;
        }
      }
    
   /* 
    for(int y = 0; y < H; y++){
      for(int x = 0; x < W; x++){
        
     //   pixels[y * width + x + W] = Colors[saveMap[y][x]];
        if(saveMap[y][x] == 2000){
          pixels[y * width + x + W] = color(255,255,255);
        }else if(saveMap[y][x] == 3000){
          pixels[y * width + x + W] = color(0,0,0);
        }else{
          int b = int(map(saveMap[y][x],0,1000,0,255));
          pixels[y * width + x + W] = color(b,b,b);
        }
      }
    }
    */
    updatePixels();
  }
  
  
  
}
