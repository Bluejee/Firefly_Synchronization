//import processing.sound.*;
//Pulse pulse;

ArrayList<Firefly>fireflies;
ArrayList<Float> average_history;

int max_tries =500;
int t = 0;

void setup() {
  // noLoop();
  frameRate(10);
  //size(1600, 900);
  fullScreen();
  //pulse = new Pulse(this);


  average_history = new ArrayList<Float>();

  //Adding the first fly.
  fireflies =  new ArrayList<Firefly>();
  fireflies.add(new Firefly(fireflies, width*3/4, height*3/4));


  for (int  i = 0; i < max_tries; i++) {
    Firefly tempfly = new Firefly(fireflies, width*3/4, height*3/4);
    int isvalidfly = 1;
    for (int j = 0; j<fireflies.size(); j++) {
      Firefly other = fireflies.get(j);
      float d = dist(
        other.position.x,
        other.position.y,
        tempfly.position.x,
        tempfly.position.y
        );

      if (d <= tempfly.flyradius + other.flyradius) {
        isvalidfly = 0;
      }
    }

    if (isvalidfly == 1) {
      fireflies.add(tempfly);
    }
  }

  //print(fireflies.size());
}

void draw() {
  background(255);
  fill(0);
  rect(0, 0, width*3/4, height*3/4);
  fill(0, 180, 220);
  rect(width*3/4, 0, width*1/4, height*3/4);

  for (int i = 0; i < fireflies.size(); i++) {
    fireflies.get(i).blink(t);
    //blink is called first to make sure the flies change color
  }
  for (int i = 0; i < fireflies.size(); i++) {
    fireflies.get(i).display(0);
  }
  for (int i = 0; i < fireflies.size(); i++) {
    // print(t,bug.phase)
    //sync happens only after the blinking is seen by the fly so we display them first. The arguments passed is the minimum number of neighbours in the perception region that must be active for it to change its phase.
    fireflies.get(i).sync(1, t);
  }

  for (int i = 0; i < fireflies.size(); i++) {
    fireflies.get(i).move();
    //fireflies.get(i).wraparound();
    fireflies.get(i).flycollide();
    fireflies.get(i).wallcollide();

    // We can also calculate the percentage of blinkers.
  }

  float average_phase = 0;
  int[] phase_count = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0};// new int[9];
  //phase_count =
  for (int i = 0; i < fireflies.size(); i++) {
    // We can also calculate the percentage of blinkers.
    average_phase += fireflies.get(i).phase;
    phase_count[fireflies.get(i).phase] += 1;
  }
  average_phase /= fireflies.size();
  average_history.add(average_phase);
  if (average_history.size() >= width*7/8) {
    average_history.remove(0);
  }
  float bar_width = width*1/4/10;
  for (int i = 0; i<10; i++) {
    fill(255, 0, 0);
    float startx = (width*3/4 + i*bar_width);
    float starty = (height*3/4 - (float(phase_count[i])/fireflies.size()*3/4*height));
    float bar_height = (float(phase_count[i])/fireflies.size()*3/4*height);
    rect(startx, starty, bar_width, bar_height);
    fill(0, 255, 0);
    textAlign(CENTER, CENTER);
    textSize(20);
    text(str(phase_count[i]),(startx + bar_width/2), (height*3/4 - bar_width));
    text(('('+str(i)+')'),(startx + bar_width/2), (height*3/4 - bar_width/2));
  }
  noFill();
  stroke(255,0,0);
  beginShape();
  for(int i = 0; i<average_history.size();i++){
    //ellipse(i,(height-average_history.get(i)*height/9/4),1,1);
    vertex(i,(height - average_history.get(i)*height/9/4));   
  }
  endShape();
  stroke(0);

  //println(average_phase);
  //println(phase_count);
  t += 1;  
  t = t % 10;
  fill(0, 255, 0);
  rect(average_history.size()-10, (height-average_phase*height/9/4), 20, average_phase*height/9/4);
  fill(255, 0, 0);
  textAlign(CORNER, CENTER);
  textSize(20);
  text(str(average_phase)+", FR  = " + str(frameRate), 4, height-12);
  // saveFrame("Output/Frame_####.png");
}

// function keyPressed(){
//   if (isLooping()){
//     noLoop();
//   }else{
//     loop();
//     noLoop();
//   }
// }

 //void mousePressed(){
 //  if(frameRate > 10){
 //    frameRate(10);
 //  } else{
 //    frameRate(60);
 //  }
 //}
