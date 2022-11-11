class Node {
  float x;
  float y;
  
  public Node(float x, float y) {
    this.x = x;
    this.y = y;
  }
  
  void show() {
    push();
    stroke(3, 132, 252);
    ellipse(x, y, 20, 20);
    pop();
  }
  
  void show(float amp) {
    push();
    if (amp > 0.165) {
      stroke(255, 0, 0);
    } else {
      stroke(3, 132, 252);
    }
    ellipse(x, y, 20, 20);
    pop();
  }
}
