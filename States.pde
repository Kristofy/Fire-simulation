color[][] Colors = {
  {#000000, #000000}, // base
  {#00d2ff, #3a7bd5}, // water
  {#f1e767, #feb645}, // sand
  {#b37828, #a4581e}, // ground
  {#add100, #7b920a}, // grass
  {#26990d, #119509}, // wood
  {#ffbc00, #ba0000}, // fire
  {#633914, #771a0f}  // burned
};

int FindStateIndexByHeight(int h){
 for(int i = 1; i < States.FIRE; i++){
   if(h < Heights[i]){
    return i; 
   }
 }
 return States.BURNED;
}

class States{
  static final int BASE = 0;
  static final int WATER = 1;
  static final int SAND = 2;
  static final int GROUND = 3;
  static final int GRASS = 4;
  static final int WOOD = 5;
  
  static final int FIRE = 6;
  static final int BURNED = 7;
  
}

float[] Inflammability = new float[]{
  0, // base
  0, // water
  0.05, // sand
  0.15, // ground
  0.3, // grass
  0.5, // tree
  0, // fire
  0.1 // burned
};

float FireTime = 0.6;

int[] Heights = new int[]{
  0,
  250, // water
  290, // sand
  340, // ground
  380, // grass
  1000, // wood
};

int[] ExactFrequencies = new int[]{
 0,0,0,0,0,0, // filling gaps
 2000, // fire
 3000, // burned soil
};

int[] dx = new int[]{0, 1, 0, -1};
int[] dy = new int[]{-1, 0, 1, 0};
