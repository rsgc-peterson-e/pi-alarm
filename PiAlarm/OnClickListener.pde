class OnClickListener {

private Util u = new Util(); // gives access to util functions in case they are needed
private Resource r = new Resource(); // gives class access to variables stored in Resource class

color highColor;

void OnClickListener(color highlight) { // takes color the button should be when the user is hovering over it
  highlight = this.highColor; // will change depending on the instance of the class by using this
  // each instance of OnClickListner can have a unique value as oppose to other objects of the same type inheriting it
}

  void tri(float x1, float y1, float x2, float y2, float x3, float y3) {

  }

  void rect(float x, float y, float width, float height) {

  }

  void circle(float x, float y, float diameter) {

  }
}
