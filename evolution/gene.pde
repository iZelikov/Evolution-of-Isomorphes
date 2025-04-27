class Gene { //<>//
  int formType; //тип фигуры (ELLIPSE, RECTANGLE или TRIANGLE)
  float xCenter, yCenter; //координата центра от (0 до 1)
  float rw, rh; //расстояния от центра до сторон круга/квадрата (от 0 до 1) (ширина и высота)
  float x1, y1, x2, y2, x3, y3; // координаты вершин треугольника (от 0 до 1)
  float a1, a2, a3; // значение угла - положение вершин треугольника на описанном эллипсе
  float red, green, blue, alpha; //цвет и прозрачность (от 0 до 1)
  float position; //позиция относительно других фигур (от 0 до 1)
  boolean visible = true; //является ли ген видимым

  /* создает полноценный ген */
  Gene(int _f, 
    float _x, float _y, 
    float _rw, float _rh, 
    float _a1, float _a2, float _a3, 
    float _r, float _g, float _b, float _a, 
    float _p, 
    boolean _v) {
    formType = _f;
    xCenter = _x;
    yCenter = _y;
    rw = _rw;
    rh = _rh;
    a1 = _a1;
    a2 = _a2;
    a3 = _a3;
    red = _r;
    green = _g;
    blue = _b;
    alpha = _a;
    position = _p;
    //обрезаем position под размер фигуры (т.е. если у нас есть большая фигура, то она не сможет вылезти наверх)
    position = constrain(position,0,(1-max(rw,rh))); 
    visible = _v;
    setTriangleCoordinate();
  };

  /* создает рандомный ген */
  Gene() {
    formType = randomType();
    xCenter = random(1);
    yCenter = random(1);
    position = random(1);
    //генерируем размеры фигуры под ее позицию (т.е. если фигура находится сверху, то ее размер может быть только маленьким)
    rw = random(1-position);
    rh = random(1-position);
    a1 = random(1);
    a2 = random(1);
    a3 = random(1);
    red = random(1);
    green = random(1);
    blue = random(1);
    alpha = random(1);    
    setTriangleCoordinate();
  };

  /* создает рандомный ген определенного типа */
  Gene(int _f) {
    this();
    if (_f != RANDOM) {
      formType = _f;
    }
  };

  /* создает ген - полную копию гена _g */
  Gene(Gene _g) {
    this(_g.formType, 
      _g.xCenter, _g.yCenter, 
      _g.rw, _g.rh, _g.a1, _g.a2, _g.a3, 
      _g.red, _g.green, _g.blue, _g.alpha, 
      _g.position, 
      _g.visible);
  };

  Gene copy() {
    return new Gene(this);
  }

  void draw(PGraphics pg) {
    /* cоздаем цветовые каналы rgb, alpha */
    float r = red*255;
    float g = green*255;
    float b = blue*255;
    float a = alpha*255;

    /* в зависимости от типа рисуем разную фигуру "за экраном" (на pg) */
    if (visible) {         
      switch(formType) {    
      case ELLIPSE:
        pg.fill(r, g, b, a);
        pg.ellipse(pg.width*xCenter, pg.height*yCenter, pg.width*rw, pg.height*rh);
        break;
      case RECTANGLE:
        pg.fill(r, g, b, a);
        pg.rect(pg.width*xCenter, pg.height*yCenter, pg.width*rw, pg.height*rh);
        break;
      case TRIANGLE:
        pg.fill(r, g, b, a);
        pg.triangle(pg.width*(x1), pg.height*(y1), 
          pg.width*(x2), pg.height*(y2), 
          pg.width*(x3), pg.height*(y3));
        break;
      default:
        pg.fill(r, g, b, a);
        pg.ellipse(pg.width*xCenter, pg.height*yCenter, pg.width*rw, pg.height*rh);
        break;
      }
    }
  };

  /* функция мутации гена */
  void mutate(float maxDispersion) {
    if (formTypeSettings == RANDOM) {
      if (random(1)<formTypeChanceToMutate) {       
        formType = randomType();
      }
    }
    /* объединяем параметры по группам и кидаем "кости", какие из них мутируют */
    float chanceToMutatePartOfGene = 0.2;
    if (random(1)<chanceToMutatePartOfGene) {
      mutateCoordinate(random(maxDispersion));
    }

    if (random(1)<chanceToMutatePartOfGene) {
      mutateSize(random(maxDispersion));
    }

    if (random(1)<chanceToMutatePartOfGene) {
      mutateTriangle(random(maxDispersion));
    }

    if (random(1)<chanceToMutatePartOfGene) {
      mutateColor(random(maxDispersion));
    }

    if (random(1)<chanceToMutatePartOfGene) {
      position = mutateMe(position, random(maxDispersion));         
    }
    /* включает/выключает отображение гена */
    if (random(1)<visiabilityChanceToMutate) {
      visible = !visible;
    }
    setTriangleCoordinate();
    //обрезаем position под размер фигуры (т.е. если у нас есть большая фигура, то она не сможет вылезти наверх)
    position = constrain(position,0,(1-max(rw,rh)));
  };

  /* функция выбора рандомного типа для фигуры */
  int randomType() {
    return floor(random(3));
  };

  /* функция мутации переменной в диапазоне от 0 до 1 */
  float mutateMe(float x, float dispersion) {
    x += random(-dispersion, dispersion);
    x = constrain(x, 0, 1);
    return x;
  };

  /* функция мутации координат центра */
  void mutateCoordinate(float dispersion) {
    if (random(1)<0.5) {
      xCenter = mutateMe(xCenter, dispersion);
    };
    if (random(1)<0.5) {
      yCenter = mutateMe(yCenter, dispersion);
    };
  };
  /* функция мутации размера фигуры */
  void mutateSize(float dispersion) {
    if (random(1)<0.5) {
      rw = mutateMe(rw, dispersion);
    };
    if (random(1)<0.5) {
      rh = mutateMe(rh, dispersion);
    };
  };
  /* функция мутации треугольника */
  void mutateTriangle(float dispersion) {
    if (random(1)<0.33) {
      a1 = mutateMe(a1, dispersion);
    };
    if (random(1)<0.33) {
      a2 = mutateMe(a2, dispersion);
    };
    if (random(1)<0.33) {
      a3 = mutateMe(a3, dispersion);
    };
  }
  /* функция мутации цвета и прозрачности */
  void mutateColor(float dispersion) {
    if (random(1)<0.25) {
      red = mutateMe(red, dispersion);
    };
    if (random(1)<0.25) {
      green = mutateMe(green, dispersion);
    };  
    if (random(1)<0.25) {
      blue = mutateMe(blue, dispersion);
    };
    if (random(1)<0.25) {
      alpha = mutateMe(alpha, dispersion);
    };
  };

  /* функция рассчета кординат вершин треугольника */
  void setTriangleCoordinate() {
    x1 = rw/2*cos(a1*2*PI)+xCenter;
    x2 = rw/2*cos(a2*2*PI)+xCenter;
    x3 = rw/2*cos(a3*2*PI)+xCenter;
    y1 = rh/2*sin(a1*2*PI)+yCenter;
    y2 = rh/2*sin(a2*2*PI)+yCenter;
    y3 = rh/2*sin(a3*2*PI)+yCenter;
  }
}

/* компаратор, который умеет сортировать гены по позиции */
class PositionComparator implements Comparator<Gene> {
  int compare(Gene g1, Gene g2) {
    if (g1.position>g2.position) 
      return 1;
    else if (g1.position<g2.position) 
      return -1;
    else
      return 0;
  }
}
