class Circle {

  PVector loc;
  float rwidth, rheight;
  String s;
  int cr;
  float duration = 20; 
  int tfont;
  boolean colorRandom;
  boolean rot;

  Circle(PVector _loc, float _rwidth, float _rheight, String _s, int _tfont, boolean _colorRandom, boolean _rot) {
    loc = _loc;
    rwidth = _rwidth;
    rheight = _rheight;
    s = _s;
    tfont = _tfont;
    colorRandom = _colorRandom;
    rot = _rot;

    cr = (int)random(colors.length);
  }

  void display() {
    //easing
    float r;
    if (time > duration) {
      r = rheight;
    } else {
      r = easing(time, 0, rheight, duration);
    }

    if (tfont == 0) {
      textFont(font0);
    } else if (tfont == 1) {
      textFont(font1);
    } else if (tfont == 2) {
      textFont(font2);
    }
    textSize(r);
    pushMatrix();
    translate(loc.x, loc.y);
    if (rot) {
      rotate(-QUARTER_PI/15);
    }
    float tx = 0;
    for (int i = 0; i < s.length(); i++) {
      if (colorRandom) {
        int cc = (cr+i)%colors.length;
        fill(colors[cc]);
      } else {
        fill(colors[cr]);
      }
      char ci = s.charAt(i); //i番目の文字を取得
      float charWidth = textWidth(ci); //文字の横幅
      text(ci, 0-rwidth/2+charWidth/2+tx, 0);
      tx += charWidth;
    }
    popMatrix();
  }

  float easing(float t, float b, float c, float d) {
    //easeOutBack
    float s = 1.0;
    t /= d;
    t--;
    return c * (t * t * ((s + 1) * t + s) + 1) + b;
  }
}
