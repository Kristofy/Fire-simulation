GridController controller;
int TEST_LAYERS = 8;

void setup(){
  size(800, 800);
  controller = new GridController();

}

void draw(){
  controller.Render();
  controller.Update();

}


void keyPressed(){
  if(key == 'r'){
     setup(); 
  }
}

void mousePressed(){
  controller.SetOnFire(mouseX, mouseY); 
}

void mouseDragged(){
  controller.SetOnFire(mouseX, mouseY); 
}
