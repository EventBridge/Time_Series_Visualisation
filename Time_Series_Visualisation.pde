import processing.sound.*;
import controlP5.*;

ControlP5 cp5;
Amplitude amp;
AudioIn in;

static final int AMP_LENGTH = 120;
float[] ampArr = new float[AMP_LENGTH];
int index = 0;
boolean isRecording = false;

int rectSize = 5;
int lineStrokeWeight = 2;

void setup() {
  size(640, 360);
  background(255);
  frameRate(60);
  cp5 = new ControlP5(this);
  // Start recording toggle
  cp5.addToggle("isRecording").setPosition(width - width*0.98, height-height/7).setSize(50,50)
     .setCaptionLabel("Night")
     .setColorCaptionLabel(color(20,20,20));
  // Create an Input stream which is routed into the Amplitude analyzer
  amp = new Amplitude(this);
  in = new AudioIn(this, 0);
  in.start();
  amp.input(in);
}

void draw() {
  background(255);
  if (isRecording) {
    // Input 100 frames of data to array
    if (index < AMP_LENGTH) {
      println(amp.analyze());
      ampArr[index] = amp.analyze();
      index++;
    } else {
      //in.stop();
    }
  } else {
    index = 0;
  }

  push();
  // Baseline
  stroke(0,255,0);
  strokeWeight(lineStrokeWeight);
  line(width-rectSize*3, height/2, rectSize*3, height/2);
  pop();
  push();
  // Threshold
  stroke(255,0,0);
  strokeWeight(lineStrokeWeight);
  line(width-rectSize*3, height/3, rectSize*3, height/3);
  pop();
  // Draw Amplitude Array
  push();
  noStroke();
  fill(51);
  for (int i = 0; i < index; i++) {
    // Shift x position by index*rectWidth
    // Shift y position by amp
    ellipse((width-(i*rectSize))-(rectSize*4), height/2-(height*ampArr[i]), rectSize, rectSize);
  }
  pop();
}
