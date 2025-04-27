Population generatePopulation() {
  Population p = new Population(numberOfOrganizmusInPopulation);
  p.addCriticus(criticus);
  return p;
}

void nextGeneration(Population p) {  
  p.growUp();
  p.reproduction();
  p.suddenDeath();
  p.oldAgeDeath();
  p.naturalSelection();
  p.getTop();
  if (criticus.resizeMe) {
    criticus.resize(criticus.size*2);
    currentCriticusSize = criticus.size;
  }
  generation++;
}

class Population {
  int maxSize;  // максималькое количество организмов в популяции
  ArrayList<Organizmus> victims = new ArrayList<Organizmus>();  // массив организмов в популяции
  //ArrayList<Criticus> predators= new ArrayList<Criticus>();  // массив хищников (критикусов)
  Criticus criticus;
  Organizmus topOrganizmus;
  ArrayList<Organizmus> topHistory = new ArrayList<Organizmus>();

  /* конструктор для создания новой популяции с заданным количеством организмусов */
  Population(int populationSize) {
    maxSize=populationSize;
    Organizmus org;
    for (int i=0; i < maxSize; i++) {
      org=new Organizmus();
      org.generate(numberOfGenesInOrganizmus);
      victims.add(org);
    }
    topOrganizmus = victims.get(0);
  };

  Population() {
  };

  /* размножение организмов */
  void reproduction() { 
    int n = victims.size();
    Organizmus mama, papa, child;    
    if (reproductionType == CLONE) { // бесполое размножение
      for (int i=0; i < n; i++) {
        for (int j=0; j < numberOfChildren; j++) {
          mama = victims.get(i);
          child = mama.copy();
          child.geneMutate(chanceToMutateGene, maxDispersion);
          child.chromosomeMutate(chanceToMutateChromosome, maxDispersion);
          victims.add(child);
        }
      }
    } else if (reproductionType==SEXUAL) { // половое размножение
      for (int i=0; i < numberOfChildren*n; i++) {
        mama = victims.get(floor(random(n)));
        papa = victims.get(floor(random(n))); 
        /* тут может получиться, что мама и папа - один организмус, но это ничего страшного
         + не понятно, хорошо ли, что берутся рандомные пары. 
         Ибо может получится, что хороший родитель вообще не оставит детей, а плохой наплодит кучу и все испортит */
        child = mama.sex(papa);
        child.geneMutate(chanceToMutateGene, maxDispersion);
        child.chromosomeMutate(chanceToMutateChromosome, maxDispersion);
        victims.add(child);
      }
    }
  }

  /* случайная смерть организмов */
  void suddenDeath() {     
    int n = victims.size();
    if (n>1) {
      for (int i=n-1; i >= 0; i--) {
        if (random(1)<chanceToDie) {
          victims.remove(i);
        }
      }
    }
  }

  /* смерть организмов от старости */
  /* to do можно доработать - чем старше, тем больше шанс умереть или же у каждого организмуса свой шанс (мб он даже мeтирует)*/
  void oldAgeDeath() {
    int n = victims.size();
    for (int i=n-1; i >= 0; i--) {
      if (victims.get(i).age > maxAge) {
        victims.remove(i);
      }
    }
  }

  /* естественный отбор организмов критикусами */
  void naturalSelection() { 
    if (victims.size()>0) {
      int toDie = victims.size()-maxSize;
      int n, m;
      for (int i=0; i < toDie; i++) {
        if (!evolutionStarted) break; //если эволюция остановлена, прекратить naturalSelection
        
        n = floor(random(victims.size()));
        m = floor(random(victims.size()));
        while (m == n) {
          m = floor(random(victims.size()));
        }
        Organizmus food1 = victims.get(n);
        Organizmus food2 = victims.get(m);

        /* to do сейчас обращаемся только к 1 критикусу, если будет много - перепишем! */
        /* to do критикус единожды выставляет рейтинг (difference) и в отборе всего лишь их сравнивает
         когда появляется ребенок - выставляем ему, а когда сам увеличивается - пересчитывает для всех */
        Organizmus looser = criticus.chooseToEat(food1, food2); 

        victims.remove(looser);
      }
    } else {
      gameOver = true;
      evolutionStarted = false;      
    }
  } 

  void getTop() {
    long min = Long.MAX_VALUE;
    for (int i=0; i < victims.size(); i++) {
      if (victims.get(i).rate.containsKey(criticus.id)) {
        if (victims.get(i).rate.get(criticus.id)<min) {
          min = victims.get(i).rate.get(criticus.id);
          topOrganizmus = victims.get(i);
          
        }
      }
    }
    topHistory.add(topOrganizmus);
  }

  /* старение на один год */
  void growUp() {
    for (Organizmus org : victims) { //цикл for each, дословно - пробегаем по каждому организму org в массиве victims
      org.age++;
    }
  }

  void addCriticus(Criticus cr) {
    criticus = cr;
    currentCriticusSize = cr.size;
  }
}
