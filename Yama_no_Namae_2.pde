import java.util.Calendar;

float time = 1;
ArrayList<Circle> circles;
String[] lines, mountains;
String letters = "Encouragement of";
String letters2 = "Climb";
String letters3 = "GHIKLcdef";
PFont font0, font1, font2;
PImage img;
int dimborder = 100; //縁の太さ

color bgColor = #887289;
color[] colors = {#f88c08, #99cfd8, #ffb2c5, #eee6cf, #ffc55f};

void setup() {
  size(1024, 768);
  circles = new ArrayList<Circle>();

  //テキストデータ読み込み
  lines = loadStrings("mountains.txt");
  mountains = new String[lines.length];
  for (int i = 0; i < lines.length; i++) {
    String[] pieces = split(lines[i], '\t');
    mountains[i] = pieces[1];
  }

  //フォント情報
  font0 = createFont("MellowMorningSmallCaps.ttf", 30);
  font1 = createFont("MellowMorningScriptAlt.ttf", 30);
  font2 = createFont("MellowMorningDoodles.ttf", 30);
  textAlign(CENTER, CENTER);

  //画像読み込み
  img = loadImage("kokona.png");
  imageMode(CENTER);
}

void draw() {
  background(bgColor);

  for (Circle c : circles) {
    c.display();
  }

  image(img, width/2, height-img.height/2, img.width, img.height);
  time += 1;
}

void mousePressed() {
  makeCircles();
}

void makeCircles() {
  circles = new ArrayList<Circle>();

  for (int i = 0; i < 100; i++) {
    boolean isOverlapped = false;

    float rwidth, rheight;
    PVector loc;
    String s;
    int tfont;
    boolean colorRandom; //一文字ずつ色を変えるかどうか　true:一文字ずつ色を変える　false:変えない
    boolean rot; //傾き（回転）を加えるか　true:傾ける　false:なし

    if (i == 0) { //Encouragement of

      textFont(font0);
      tfont = 0;
      s = letters;
      int tsize = int(random(40, 50)); //文字の大きさ
      textSize(tsize);
      rwidth = textWidth(s); //文字の横幅
      rheight = tsize; //文字の高さ
      //文字の位置
      float locSize_x = map(sqrt(random(1)), 0, 1, 0, (height-dimborder*2)/2);
      float locSize_y = map(sqrt(random(1)), 0, 1, (height)/2*0.5, (height)/2*0.8);
      float locAng = radians(random(210, 330));
      loc = new PVector(width/2 + locSize_x * cos(locAng), height/2 + locSize_y * sin(locAng));
      colorRandom = true;
      rot = true;
    } else if (i == 1) { //Climb

      textFont(font1);
      tfont = 1;
      s = letters2;
      float tsize = circles.get(0).rheight * 2.0; //文字の大きさ（↑Encouragement ofの大きさの２倍）
      textSize(tsize);
      rwidth = textWidth(s); //文字の横幅
      rheight = tsize; //文字の高さ
      loc = new PVector(circles.get(0).loc.x, circles.get(0).loc.y+circles.get(0).rheight/2+rheight/2); //文字の位置
      colorRandom = true;
      rot = true;
    } else { //絵文字、山の名前

      int tsize;

      int tr = (int)random(4);
      if (tr == 0) { //絵文字  ↑4ぶんの1の確率で絵文字
        textFont(font2);
        tfont = 2;
        int tRandom = int(random(letters3.length())); //letters3の文字列からランダムに一文字とりだす
        s = letters3.substring(tRandom, tRandom+1);
        tsize = 65; //文字の大きさ
        textSize(tsize);
        rwidth = textWidth(s); //文字の横幅
        rheight = tsize; //文字の高さ
        //文字の位置
        float locSize = map(sqrt(random(1)), 0, 1, (height-dimborder*2)/2, (height-dimborder*2)/2*1.2);
        float locAng = random(TWO_PI);
        loc = new PVector(width/2 + locSize * cos(locAng), height/2 + locSize * sin(locAng));
        colorRandom = true;
        rot = false;
      } else { //山の名前
        textFont(font0);
        tfont = 0;
        int tRandom = int(random(mountains.length)); //文字のランダム値
        s = mountains[tRandom];
        tsize = int(random(20, 40)); //文字の大きさ 
        textSize(tsize);
        rwidth = textWidth(s); //文字の横幅
        rheight = tsize; //文字の高さ
        //文字の位置
        float locSize = map(sqrt(random(1)), 0, 1, 0, (height-dimborder*2)/2);
        float locAng = random(TWO_PI);
        loc = new PVector(width/2 + locSize * cos(locAng), height/2 + locSize * sin(locAng));
        colorRandom = true;
        rot = true;
      }

      //画面の外に文字がはみ出ないようにする
      if ((loc.x - rwidth/2 < 0) ||
        (loc.x + rwidth/2 > width) ||
        (loc.y - rheight/2 < 0) ||
        (loc.y + rheight/2 > height) 
        ) {
        isOverlapped = true;
      }

      //文字と文字の重なり判定
      if (!isOverlapped) {
        for (Circle other : circles) {
          if ((abs(loc.x - other.loc.x) < rwidth/2 + other.rwidth/2 + 10) &&
            (abs(loc.y - other.loc.y) < rheight/2 + other.rheight/2 + 10)) {
            isOverlapped = true;
          }
        }
      }
    }

    if (!isOverlapped) {
      circles.add(new Circle(loc, rwidth, rheight, s, tfont, colorRandom, rot));
    }
  }
  time = 1;
}

void keyReleased() {
  if (key == 's' || key == 'S')saveFrame(timestamp()+"_####.png");
  if (keyCode == BACKSPACE) makeCircles();
}


String timestamp() {
  Calendar now = Calendar.getInstance();
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", now);
}
