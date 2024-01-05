class Firefly {
  int flyradius;
  color flycolor;
  int blinking;
  int phase;
  int perception_radius;
  color perception_color;
  PVector position;
  PVector velocity;
  ArrayList<Firefly> others;
  int framewidth;
  int frameheight;
  Firefly(ArrayList<Firefly> otherflies, int fwidth, int fheight) {
    framewidth = fwidth;
    frameheight = fheight;

    flyradius = floor(random(5, 30));
    // flyradius = 10
    // flyradius = 100;
    flycolor = color(0, 0, 255);
    others = otherflies;
    blinking = 0;
    //flyradius = 10;
    // Assuming that the firefly blinks at a constant frequencey of 1 blink every 2 seconds. But with a possible phase delay of an integer multiple of 0.1 seconds.
    // Insted of using decimals we just count 10 frames to be a second so phase delay can be an integer
    phase = floor(random(10));
    // phase = phase;
    // phase = 0
    perception_radius =3  * flyradius;
    perception_color = color(0, 255, 0, 15);
    position = new PVector(
      floor(random(flyradius, framewidth - flyradius)),
      floor(random(flyradius, frameheight - flyradius))
      );
    velocity =PVector.random2D();
    velocity.setMag(floor(random(10, 30)));
    // position = position;
  }

  void display(int show_perception) {
    fill(flycolor);
    ellipse(
      position.x,
      position.y,
      2 * flyradius,
      2 * flyradius
      );
    if (show_perception == 1) {
      fill(perception_color);
      strokeWeight(0);
      ellipse(
        position.x,
        position.y,
        2 * perception_radius,
        2 * perception_radius
        );
      strokeWeight(1);
    }
  }


  void blink(int t) {
    if (phase == t) {
      //flycolor = color(255, 0, 255);      
      flycolor = color(0,255,255);
      blinking = 1;
    } else {
      flycolor = color(0, 0, 255);
      blinking = 0;
    }
  }

  void sync(int min, int t) {
    int blinkers = 0;
    for (int i = 0; i<others.size(); i++) {
      Firefly other = others.get(i);
      if (other != this) {
        float d = dist(
          other.position.x,
          other.position.y,
          position.x,
          position.y
          );
        if (d <= perception_radius) {
          // We can determine if it is blinking simply based on its blinking state. No need to complicate it using the pase and the time and all.
          if (other.blinking == 1) {
            blinkers += 1;
          }
        }
      }
    }
    // Instead of changing the phase to this time directly we use a tendency to move towards this time.
    // a weight factor is also used to increase the chances of accepting the new phase
    // The initial tendency is set to be 1/3. i.e even if just one fly is lit it will tend to move toward that.


    // // The more the flies lit, the more the tendency to move towords it.
    // let phase_change = t - phase;
    // // for now let us say 5 is the min no. of lit neighbours needed for maximum change.
    // // so 1 maps to 1/3 and 5 maps to 1
    // let tendency = phase_change;
    // if (max <= blinkers <= min) {
    //   tendency = phase_change*(
    //     1 / 3 + (2 / 3) * ((blinkers - min) / (max - min))
    //   );
    //   tendency = floor(phase_change);
    // }
    if (blinkers >= min) {
      // phase += tendency;
      phase = t;
    }
  }

  void move() {
    //as we are considering the frame rate to be 10 and the counter to work in integers. the equation of motion will be x1 = x0 + v*1/10

    position.x += velocity.x/10;
    position.y += velocity.y/10;
  }

  void wraparound() {
    if (position.x <= 0) {
      position.x = framewidth;
    }
    if (position.y <= 0) {
      print(position.y,"---");
      position.y = frameheight;
      println(position.y);
    }
    if (position.x > framewidth) {
      position.x = 0;
    }
    if (position.y > frameheight) {
      position.y = 0;
    }
  }

  void wallcollide() {
    if (position.x-flyradius<=0 || position.x+flyradius >= framewidth) {
      velocity.x = -velocity.x;
    }
    if (position.y-flyradius<=0 || position.y+flyradius >= frameheight) {
      velocity.y = -velocity.y;
    }
  }
  void flycollide() {
    PVector new_velocity = new PVector(0, 0);
    int collided = 0;
    for (int i = 0; i<others.size(); i++) {
      Firefly other = others.get(i);
      if (other != this) {
        float d = dist(this.position.x, this.position.y, other.position.x, other.position.y);
        if (d <=(this.flyradius+other.flyradius)) {
          new_velocity.add( PVector.sub(this.position, other.position));
          collided = 1;
        }
      }
    }
    new_velocity.setMag(floor(random(10, 30)));
    if (collided==1) {
      velocity = new_velocity;
    }
  }
}
