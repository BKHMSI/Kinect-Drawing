import org.openkinect.freenect.*;
import org.openkinect.processing.*;

KinectTracker tracker;
Kinect kinect;
float angle = 0;
int pointsCounter = 0;
int pointsSize = 5;
boolean clear = false, colorDepth = true;
float[] points;


void setup() {
  size(1280, 520);
  kinect = new Kinect(this);
  kinect.initDepth();
  kinect.enableColorDepth(colorDepth);
  tracker = new KinectTracker();
  points = new float[pointsSize];
  background(0);
}

void draw() {

  if(isClear()){background(0); clear = false;}
  
  // Run the tracking analysis
  tracker.track();
  
  // Show the image
  tracker.display();

  PVector v1 = tracker.getPos();
  fill(50, 100, 250, 200);
  noStroke();
  ellipse(v1.x+640, v1.y, 40, 40);

  PVector v2 = tracker.getLerpedPos();
  fill(100, 250, 50, 200);
  noStroke();
  ellipse(v2.x+640, v2.y, 20, 20);
  
  points[pointsCounter] = v2.x;
  pointsCounter = pointsCounter == pointsSize-1 ? 0:pointsCounter+1;
  
  float radius = tracker.getThreshold()/2.5-tracker.getAvgDepth();
  noStroke();
  fill(random(255),random(255),random(255));
  ellipse(v2.x,v2.y,radius,radius);
}

boolean isClear(){
  float max = 0, min = 10000;
  for(int i = 0; i<pointsSize; i++){
    if(points[i] > max) max = points[i];
    if(points[i] < min) min = points[i];
  }
  return abs(max-min)>175;
}


// Adjust the threshold and tilt the kinect with key presses
void keyPressed() {
  if(key == CODED){
    if (keyCode == UP) {
        angle = kinect.getTilt();
        angle+=4;
        kinect.setTilt(angle);
    } else if (keyCode == DOWN) {
        angle = kinect.getTilt();
        angle-=4;
        kinect.setTilt(angle);
    }else if(keyCode == RIGHT){
      tracker.setThreshold(tracker.getThreshold()+1);
    }else if(keyCode == LEFT){
      tracker.setThreshold(tracker.getThreshold()-1);
    }
  }else if(key == ' '){
    clear = true;
    print(tracker.getThreshold()/4-tracker.getAvgDepth()+"\n");
  }else if(key == 'c'){
    colorDepth = !colorDepth;
    kinect.enableColorDepth(colorDepth);
  }
}
