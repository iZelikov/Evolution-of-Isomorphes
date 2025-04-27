class Criticus { 
  PImage originalImg; //картинка, с которой критикус сравнивает организмы
  PImage imageToCompare; //картинка измененного размера, с которой критикус сравнивает организмы
  int size; //измененный размер оригинальной картинки (criticusImageSize)
  float multiplicator = 1;
  PGraphics pg;
  boolean resizeMe = false;
  int id;

  Criticus(PImage _img, int _size) { 
    size = _size;
    if (_img != null) {
      originalImg = _img;
      imageToCompare = originalImg.get();
      imageToCompare.resize(size, size);
    }
    pg = createGraphics(size, size);
    id = nextCriticusID;
    nextCriticusID++;
  }
  /* выбор из двух организмусов менее похожего на оригинал */
  Organizmus chooseToEat(Organizmus org1, Organizmus org2) {
    long dif1 = getDifference(org1);
    long dif2 = getDifference(org2);
    if (dif1>dif2) return org1;
    else return org2;
  }
  long getDifference(Organizmus org) {
    long dif;
    if (org.rate.containsKey(id)) {
      dif = org.rate.get(id);
    } else {
      PImage food = org.draw(pg);
      dif = calculateDifference(food);
      org.rate.put(id, dif);
    }    
    return dif;
  }

  /* высчитывание квадратичного отклонения цветов картинки (организмуса) и оригинала */
  long calculateDifference(PImage img) {
    float r, g, b;
    long result = 0;
    if (imageToCompare != null) {
      for (int i=0; i < img.pixels.length; i++) {
        r=red(img.pixels[i])-red(imageToCompare.pixels[i]);
        g=green(img.pixels[i])-green(imageToCompare.pixels[i]);
        b=blue(img.pixels[i])-blue(imageToCompare.pixels[i]);
        result += r*r + g*g + b*b;
      }
    } else throw new NullPointerException("Criticus has no original image");
    if (result/img.pixels.length < criticusThreshold/multiplicator) { 
      resizeMe = true;
    }
    return result;
  }

  void resize(int newSize) {
    if (newSize<=topCriticusImageSize) {
      size = newSize;
      imageToCompare = originalImg.get();
      imageToCompare.resize(size, size);    
      pg = createGraphics(size, size);
      resizeMe = false;
      id = nextCriticusID;
      nextCriticusID++;
      multiplicator*=criticusThresMultiplicator;
    }
  }
}
