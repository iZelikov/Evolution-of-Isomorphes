class Button implements Control {
  String name;
  float x, y, cx, cy; //координаты x,y левого верхнего угла и центра кнопки
  float w, h; //ширина и высота кнопки
  float borderWidth; //толщина границы
  float textSize; //размер шрифта
  String text; //текст на кнопке
  //цвет заливки и границы в спокойном состоянии, когда мышь "над кнопкой" и когда кнопка нажата
  color bgColor, borderColor, hoverBg, hoverBorder, pressedBg, pressedBorder, activeBg, activeBorder, disabledBg; 
  //цвет текста
  color  textColor, enabledTextColor, disabledTextColor;
  boolean enabled, visible, hover, pressedInside, pressedOutside, active;
  OnClickListener onClickListener;

  /*конструктор создания дефолтной кнопки */
  Button() {
    name = "";
    x = 100;
    y = 100;
    w = 100;
    h = 50;
    borderWidth = 1;
    textSize = 20;
    text = "Click me";
    bgColor = color(100);
    disabledBg = bgColor;
    borderColor = color(0);
    hoverBg = color(80);
    hoverBorder = color(0);
    pressedBg = color(50);
    pressedBorder = color(0);
    activeBg = color(0, 150, 0);
    activeBorder = color(0);
    textColor = color(255);
    enabledTextColor = color(255);
    disabledTextColor = color(50);
    enabled = true;
    visible = true;
    hover = false;
    pressedInside = false;
    pressedOutside = false;
    active = false;
  }

  Button(String _text, float _x, float _y) {
    this();
    x = _x;
    y = _y;
    text = _text;
  }

  Button(String _text, float _x, float _y, Button b) {
    this();
    x = _x;
    y = _y;
    text = _text;
    w = b.w;
    h = b.h;
    borderWidth = b.borderWidth;
    textSize = b.textSize;
    bgColor = b.bgColor;
    borderColor = b.borderColor;
    hoverBg = b.hoverBg;
    hoverBorder = b.hoverBorder;
    pressedBg = b.pressedBg;
    pressedBorder = b.pressedBorder;
    activeBg = b.activeBg;
    activeBorder = b.activeBorder;
    enabledTextColor = b.enabledTextColor;
    disabledTextColor = b.disabledTextColor;
  }

  void setOnClickListener(OnClickListener x) {
    onClickListener = x;
  }

  /* функция проверки, в каком состоянии кнопка и выполнение нужных действий */
  void check() {
    cx = x + w/2;
    cy = y + h/2;
    if (!mousePressed) { //если мышь не "нажата" 
      pressedOutside = false; //то она не "нажата снаружи"
    }
    if (mouseIsInside() && visible) { //если мышь "внутри" кнопки и кнопка "видна"
      hover = true; //то мышь "над кнопкой"
    } else {
      if (mousePressed) { //если мышь не "внутри" и "нажата" 
        pressedOutside = true; //то мышь "нажата снаружи"
      }
      hover = false; //мышь не "над кнопкой"
      pressedInside = false; //мышь не "нажата внутри"
    }
    if (hover && mousePressed && enabled && !pressedOutside) { //если мышь "над кнопкой", и "нажата", и "активна" и мышь не была "нажата снаружи"
      pressedInside = true; //то мышь "нажата внутри"
    }
    if (pressedInside && !mousePressed && enabled) { //если мышь в состоянии "нажата внутри" и уже не "нажата" и "активна"
      if (onClickListener != null) {
        onClickListener.onClick(this); //то кликнуть
      }
      pressedInside = false; //присвоить значение мышь не "нажата внутри"
    }
    if (enabled) {
      textColor = enabledTextColor;
    } else {
      textColor = disabledTextColor;
    }
  }

  /* функция проверки, находится ли мышь внутри кнопки */
  boolean mouseIsInside() {
    float rx=abs(cx-mouseX);
    float ry=abs(cy-mouseY);
    if ((rx<w/2) && (ry<h/2)) {
      return true;
    } else return false;
  }

  ///* функция клика мышкой по кнопке */
  //  public void click() {
  //    bgColor = color(random(255));
  //    //bg = color(random(255));
  //  }

  /* функция рисования кнопки на экране */
  void show() {
    if (visible) {
      strokeWeight(borderWidth);
      if (pressedInside && enabled) {
        fill(pressedBg);
        stroke(pressedBorder);
      } else if (hover && enabled) {
        fill(hoverBg);
        stroke(hoverBorder);
      } else {
        fill(bgColor);
        stroke(borderColor);
      }
      if (active) {
        fill(activeBg);
        stroke(activeBorder);
      }
      if(!enabled){
        fill(disabledBg);
      }
      rect(x, y, w, h);
      fill(textColor);
      textAlign(CENTER, CENTER);
      textSize(textSize);
      text(text, x, y, w, h);
    }
  }
}

class ImageButton extends Button {
  PImage image;

  ImageButton() {
    super();
    w = 100;
    h = 50;
    borderWidth = 5;
    PGraphics pg;
    pg = createGraphics(int(w+borderWidth*2), int(h+borderWidth*2));
    pg.beginDraw();
    pg.fill(100);
    pg.stroke(50);
    pg.strokeWeight(borderWidth);
    pg.ellipse(w/2+borderWidth, h/2+borderWidth, w, h);
    image = pg.get();
    bgColor = color(255);
    hoverBg = color(200);
    pressedBg = color(100);
  }

  ImageButton(PImage _img, float _x, float _y) {
    this();
    image = _img;
    x = _x;
    y = _y;
    w = image.width;
    h = image.height;
  }

  ImageButton(PImage _img, float _x, float _y, float _w, float _h) {
    this();
    image = _img;
    x = _x;
    y = _y;
    w = _w;
    h = _h;
    image.resize(int(w), int(h));
  }

  void show() {
    if (visible) {
      strokeWeight(borderWidth);
      if (pressedInside && enabled) {
        fill(pressedBg);
        tint(pressedBg);
        stroke(pressedBorder);
      } else if (hover && enabled) {
        fill(hoverBg);
        tint(hoverBg);
        stroke(hoverBorder);
      } else {
        fill(bgColor);
        tint(bgColor);
        stroke(borderColor);
      }
      if (active) {
        fill(activeBg);
        tint(activeBg);
        stroke(activeBorder);
      }
      //rect(x, y, w, h);
      image(image, x, y);
      noTint();
    }
  }

  void resizeToFit() {
    if (image.width*h<image.height*w) {
      image.resize(int(image.width*h/image.height), int(h));
    } else {
      image.resize(int(w), int(image.height*w/image.width));
    }
  }

  boolean mouseIsInside() {
    if (super.mouseIsInside()) {
      color c;
      c = image.get(int(mouseX-(cx-image.width/2)), int(mouseY-(cy-image.height/2)));
      if (alpha(c) != 0) return true;
      else return false;
    } else return false;
  }
}

class Slider extends Button {
  float position=0;
  float value;
  float max, min;
  int numberOfDivisions; //количество делений
  boolean stickToDivisions = false; //прилипать к делениям?
  float divisionH;
  int digits; //количество знаков после запятой для value
  boolean expDependence = false; //тип зависимости (true - экспоненциальная, false - линейная)
  boolean zeroStart = false; //начинаем с 0


  boolean mouseDrag = false;

  Slider() {
    super();
    min = 0;
    max = 1;
    numberOfDivisions = 10;
    position = 0;
    w = 300;
    h = 20;
    text = "Value";
    borderWidth = 3;
    digits = 2;
    divisionH = h/2;

    bgColor = color(128);
    borderColor = color(255);
    hoverBg = color(100,200);
    hoverBorder = color(255);
    pressedBg = color(0,100,0,170);
    pressedBorder = color(255);
    textColor = color(255);
    textSize = 20;
    enabledTextColor = color(255);
    disabledTextColor = color(128);
  }
  
  Slider(String _text, float _x, float _y){
    this();
    x = _x;
    y = _y;
    text = _text;
  }
  
  Slider(String _text, float _x, float _y, Slider s){
    this();
    x = _x;
    y = _y;
    text = _text;
    w = s.w;
    h = s.h;
    max = s.max;
    min = s.min;
    digits = s.digits;    
    numberOfDivisions = s.numberOfDivisions;
    position = s.position;
    borderWidth = s.borderWidth;
    divisionH = s.divisionH;
    stickToDivisions = s.stickToDivisions;
    expDependence = s.expDependence;
    
    bgColor = s.bgColor;
    borderColor = s.borderColor;
    hoverBg = s.hoverBg;
    hoverBorder = s.hoverBorder;
    pressedBg = s.pressedBg;
    pressedBorder = s.pressedBorder;
    textColor = s.textColor;
    textSize = s.textSize;
    enabledTextColor = s.enabledTextColor;
    disabledTextColor = s.disabledTextColor;
  }

  void check() {
    super.check();
    if (pressedInside) {
      mouseDrag = true;
    }
    if (!mousePressed) {
      mouseDrag = false;
    }
    if (mouseDrag) {
      position = map(mouseX-x, 0, w, 0, 1); 
      position = constrain(position, 0, 1);
      if (stickToDivisions) {
        position = round(position*numberOfDivisions)/(float)numberOfDivisions;
      }
    }
    if (expDependence) {
      if (zeroStart&&position==0) value = 0; 
      else value = min*pow(max/min, position);
    } else {
      value = (max-min)*position+min;
    }
    if (digits == 0){
      value = round(value);
    }
  }

  boolean mouseIsInside() {
    float rx=abs(x+position*w-mouseX);
    float ry=abs(y+h/2-mouseY);
    if ((rx<h/2) && (ry<h/2)) {
      return true;
    } else return super.mouseIsInside();
  }

  void show() {
    stroke(borderColor);
    strokeWeight(borderWidth);
    line(x, y+h/2, x+w, y+h/2);
    for (int i=0; i<=numberOfDivisions; i++) {
      line(x+w*i/numberOfDivisions, cy-divisionH/2, x+w*i/numberOfDivisions, cy+divisionH/2);
    }
    if (mouseDrag && enabled) {
      fill(pressedBg);
      stroke(pressedBorder);
    } else if (hover && enabled) {
      fill(hoverBg);
      stroke(hoverBorder);
    } else {
      fill(bgColor);
      stroke(borderColor);
    }
    ellipse(x+position*w, y+h/2, h, h);
    fill(textColor);
    textAlign(LEFT);
    textSize(textSize);
    text(text+" "+nf(value, 0, digits), x, y-textSize);
  }
  
  void setValue (float v){
    value = v;
    if (expDependence) {
      if (zeroStart&&value==0) position = 0;
      else position = log(value/min)/log(max/min);
    } else {
      position = (value-min)/(max-min);
    }    
  }
}

class ButtonsGroup implements Control {
  ArrayList<Button> buttons;
  int activeButton=0;
  String text;
  float textSize;
  color textColor;
  OnClickListener listener;

  ButtonsGroup() {    
    text = "Buttons group";
    textSize = 20;
    textColor = color(255);
    buttons = new ArrayList<Button>();
    listener = new OnClickListener() {
      public void onClick(Control c) {
        Button b = (Button)c;
        b.active = true;
      }
    };
  }

  void check() {
    if(buttons.size()>activeButton) buttons.get(activeButton).active = true;
    for (int i=0; i < buttons.size(); i++) {
      buttons.get(i).check();
      if (buttons.get(i).active&&i!=activeButton) {
        buttons.get(activeButton).active = false;
        activeButton = i;
      }
    }
  }

  void show() {
    for (int i=0; i < buttons.size(); i++) {
      buttons.get(i).show();
    }
    if (buttons.size()>0) {
      textAlign(LEFT);
      fill(textColor);
      textSize(textSize);
      text(text, buttons.get(0).x, buttons.get(0).y-textSize);      
    }
  }

  void add(Button b) {
    buttons.add(b);
    b.setOnClickListener(listener);
  }
}

interface Control { //создаем интерфейс controls, который будет реализовывать все кнопочки и другие контроллеры
  void check();
  void show();
}

interface OnClickListener { //создаем интерфейс слушателя, который требует реализации метода onClick()
  public void onClick(Control b);
}
