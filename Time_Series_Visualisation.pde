import processing.sound.*;
import controlP5.*;

ControlP5 cp5;
controlP5.Button audioButton;
controlP5.Button recordButton;
controlP5.Button recordNodeButton;
controlP5.Button backButton;
controlP5.Button kmButton;
controlP5.Button visualiseButton;

Amplitude amp;
AudioIn in;

static final int AMP_LENGTH = 320;
float[] ampArr = new float[AMP_LENGTH];
int index = 0;
boolean isRecording = false;

int rectSize = 3;
int lineStrokeWeight = 2;

Node[] nodes = new Node[AMP_LENGTH];
int nodeIndex = 0;
boolean isRecordNode = false;

boolean nodeMenu = false;
boolean audioMenu = false;
boolean visualiseMenu = false;

void setup() {
  size(1000, 600);
  background(255);
  frameRate(60);
  cp5 = new ControlP5(this);
  
  // K/M button
  kmButton = cp5.addButton("kmButton").setPosition(width/2-100, height/2-100).setSize(200,50)
     .setCaptionLabel("Keyboard/Mouse")
     .setColorCaptionLabel(color(20,20,20))
     .setColorBackground(color(255, 255, 0))
     .setColorForeground(color(255, 0, 0))
     .setColorActive(color(0, 255, 255));
  // Audio button
  audioButton = cp5.addButton("displayAudio").setPosition(width/2-100, height/2).setSize(200,50)
     .setCaptionLabel("Audio")
     .setColorCaptionLabel(color(20,20,20))
     .setColorBackground(color(255, 255, 0))
     .setColorForeground(color(255, 0, 0))
     .setColorActive(color(0, 255, 255));
  // Visualise button
  visualiseButton = cp5.addButton("startVisualisation").setPosition(width/2-100, height/2+100).setSize(200,50)
     .setCaptionLabel("Visualise")
     .setColorCaptionLabel(color(20,20,20))
     .setColorBackground(color(255, 255, 0))
     .setColorForeground(color(0, 255, 0))
     .setColorActive(color(0, 255, 255));
  // Start recording button
  recordButton = cp5.addButton("startRecording").setPosition(width - width*0.98, height-height/4).setSize(50,50)
     .setCaptionLabel("Record")
     .setColorCaptionLabel(color(20,20,20))
     .setColorBackground(color(255, 255, 0))
     .setColorForeground(color(255, 0, 0))
     .setColorActive(color(0, 255, 255));
  // Start recording nodes button
  recordNodeButton = cp5.addButton("startNodeRecording").setPosition(width - width*0.98, height-height/4).setSize(50,50)
     .setCaptionLabel("Record")
     .setColorCaptionLabel(color(20,20,20))
     .setColorBackground(color(255, 255, 0))
     .setColorForeground(color(255, 0, 0))
     .setColorActive(color(0, 255, 255));
  // Back button
  backButton = cp5.addButton("returnHome").setPosition(width - width*0.2, height-height/4).setSize(50,50)
     .setCaptionLabel("Back")
     .setColorCaptionLabel(color(20,20,20))
     .setColorBackground(color(255, 255, 0))
     .setColorForeground(color(255, 0, 0))
     .setColorActive(color(0, 255, 255));
  // Create an Input stream which is routed into the Amplitude analyzer
  amp = new Amplitude(this);
  in = new AudioIn(this, 0);
  in.start();
  amp.input(in);
}

void draw() {
  background(255);
  
  if (isRecording) {
    // Input AMP_LENGTH frames of data to array
    if (index < AMP_LENGTH) {
      println(amp.analyze());
      ampArr[index] = amp.analyze();
      index++;
    } else {
      //in.stop();
      isRecording = false;
    }
  }
  
  if (isRecordNode) {
    // Input AMP_LENGTH frames of data to array
    if (nodeIndex < AMP_LENGTH) {
      nodes[nodeIndex] = new Node(mouseX, mouseY);
      nodeIndex++;
    } else {
      isRecordNode = false;
    }
  }
  
  if (nodeMenu) {
    for (int i = 0; i < nodes.length; i++) {
      // Display node if exists
      try {
        nodes[i].show();
      }
      catch (Exception e) {
        // nothing
      }
    }
  }
  else if (audioMenu) {
    // Draw threshold
    drawThreshold();
    // Draw Amplitude Array
    drawAmplitude();
  } else if (visualiseMenu) {
    background(0);
    // Combine node and audio data
    for (int i = 0; i < nodes.length; i++) {
      try {
        nodes[i].show(ampArr[i]);
      }
      catch (Exception e) {
        // nothing
      }
      push();
      colorMode(HSB);
      float gradient = (float) i/ (float) nodes.length;
      stroke(gradient*125, 255, 255);
      try {
        line(nodes[i].x, nodes[i].y, nodes[i+1].x, nodes[i+1].y);
      }
      catch (Exception e) {
        // nothing
      }
      pop();
    }
  } else {
    push();
    // Display main menu items
    textSize(32);
    textAlign(CENTER);
    fill(0);
    text("Time Series Visualisation", width/2, 100);
    pop();
    recordButton.hide();
    recordNodeButton.hide();
    backButton.hide();
  }
}

void startRecording() {
  // TODO: reset Amplitude Array to 0.0 values
  index = 0;
  isRecording = true;
}

void startNodeRecording() {
  nodes = new Node[AMP_LENGTH];
  nodeIndex = 0;
  isRecordNode = true;
}

void kmButton() {
  recordNodeButton.show();
  audioButton.hide();
  kmButton.hide();
  visualiseButton.hide();
  backButton.show();
  nodeMenu = true;
}

void displayAudio() {
  recordButton.show();
  audioButton.hide();
  kmButton.hide();
  visualiseButton.hide();
  backButton.show();
  audioMenu = true;
}

void startVisualisation() {
  audioButton.hide();
  kmButton.hide();
  visualiseButton.hide();
  backButton.show();
  visualiseMenu = true;
}

void returnHome() {
  recordButton.hide();
  audioButton.show();
  kmButton.show();
  visualiseButton.show();
  backButton.hide();
  audioMenu = false;
  visualiseMenu = false;
  nodeMenu = false;
}

void drawAmplitude() {
  push();
  noStroke();
  for (int i = 0; i < index; i++) {
    if (ampArr[i] > 0.165) {
      fill(255,0,0);
    } else {
      fill(51);
    }
    // Shift x position by index*rectWidth
    // Shift y position by amp
    ellipse((width-(i*rectSize))-(rectSize*4), height/2-(height*ampArr[i]), rectSize, rectSize);
  }
  pop();
}

void drawThreshold() {
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
}
