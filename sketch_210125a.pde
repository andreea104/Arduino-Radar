import processing.serial.*; // imports library for serial communication
import java.awt.event.KeyEvent; // imports library for reading the data from the serial port
import java.io.IOException;
Serial myPort; // pt serial communication

String angle = "";
String distance = "";
String data = "";
String noObject;
float pixsDistance;
int iAngle, iDistance;
int index1 = 0;
int index2 = 0;

public class Utils
{
  public void drawRadar()
  {
    pushMatrix();
    translate(width/2, height-height * 0.074); // muta coordonatele de start in josul paginii
    noFill();
    strokeWeight(3);
    stroke(98, 245, 31);

    // desenez arcurile de cerc de la pi la 2pi
    arc(0, 0, (width-width * 0.0625), (width-width * 0.0625), PI, TWO_PI);
    arc(0, 0, (width-width * 0.2700), (width-width * 0.2700), PI, TWO_PI);
    arc(0, 0, (width-width * 0.4790), (width-width * 0.4790), PI, TWO_PI);
    arc(0, 0, (width-width * 0.6870), (width-width * 0.687), PI, TWO_PI);
    // desenez cate o linie ca reper din 30 in 30 de grade 
    line(-width/2, 0, width/2, 0);
    line(0, 0, (-width/2) * cos(radians(30)), (-width/2) * sin(radians(30)));
    line(0, 0, (-width/2) * cos(radians(60)), (-width/2) * sin(radians(60)));
    line(0, 0, (-width/2) * cos(radians(90)), (-width/2) * sin(radians(90)));
    line(0, 0, (-width/2) * cos(radians(120)), (-width/2) * sin(radians(120)));
    line(0, 0, (-width/2) * cos(radians(150)), (-width/2) * sin(radians(150)));
    line((-width/2) * cos(radians(30)), 0, width/2,0);
    popMatrix();
  }
  
  public void drawObject() //cu rosu pt cazul in care se detecteaza un obiect
  {
    pushMatrix();
    translate(width/2, height-height * 0.074); // fixez coordonatele de inceput in coltul din dreapta jos
    strokeWeight(10);
    stroke(255, 10, 10); //rosu
    pixsDistance = iDistance * ((height-height * 0.1666) * 0.025); // transforma distanta fata de senzor masurata in cm in pixeli
    
    // limitez distanta pana la care sa fie detectate obiectele la 40cm
    if(iDistance < 40)
    {
      // se figureaza obiectul detectat in functie de unghi si distanta
      line(pixsDistance * cos(radians(iAngle)), pixsDistance * -sin(radians(iAngle)), 
      (width-width * 0.505) * cos(radians(iAngle)), -(width-width * 0.505) * sin(radians(iAngle)));
    }
    popMatrix();
  }
  
  public void drawLine()  //verde in cazul in care nu se afla niciun obiect  
  {
    pushMatrix();
    strokeWeight(10);
    stroke(98, 245, 31); //verde
    translate(width/2,height-height*0.074); // fixez coordonatele de inceput in coltul din dreapta jos
    line(0,0,(height-height * 0.12) * cos(radians(iAngle)), -(height-height * 0.12) * sin(radians(iAngle))); // figureaza o linie verde in functie de unghi
    popMatrix();
  }

  public void drawText() // printeaza textul pe ecran
  { 
    pushMatrix();
    if(iDistance > 40) 
    {
      noObject = "Out of Range";
    }
    else 
    {
      noObject = "In Range";
    }
    fill(0,0,0);
    noStroke();
    rect(0, height-height * 0.0648, width, height);
    fill(98, 245, 31);
  
    textSize(20);
    text("10cm", width-width * 0.3854, height-height * 0.0833);
    text("20cm", width-width * 0.2810, height-height * 0.0833);
    text("30cm", width-width * 0.1770, height-height * 0.0833);
    text("40cm", width-width * 0.0729, height-height * 0.0833);
  
    textSize(25);
    text("Object: " + noObject, width-width * 0.875, height-height*0.0277);
    text("Angle: " + iAngle +" °", width-width*0.48, height-height*0.0277);
    text("Distance: ", width-width * 0.26, height-height * 0.0277);
   
    if(iDistance > 40)
      text("No distance", width-width * 0.17, height-height * 0.0277);
    
    if(iDistance <= 40) 
    {
      text("        " + iDistance +" cm", width-width * 0.225, height-height * 0.0277);
    }
  
    textSize(25);
    fill(98, 245, 60);
  
    translate((width-width * 0.4994) + width/2 * cos(radians(30)), (height-height * 0.0907)-width/2 * sin(radians(30))); //30 grade
    rotate(-radians(-60));
    text("30°", 0, 0);
    resetMatrix();
  
    translate((width-width * 0.503) + width/2 * cos(radians(60)), (height-height * 0.0888)-width/2 * sin(radians(60))); //60
    rotate(-radians(-30));
    text("60°", 0, 0);
    resetMatrix();
  
    translate((width-width * 0.507) + width/2 * cos(radians(90)), (height-height * 0.0833)-width/2 * sin(radians(90))); //90
    rotate(radians(0));
    text("90°", 0, 0);
    resetMatrix();
  
    translate((width-width * 0.513) + width/2 * cos(radians(120)), (height-height * 0.07129)-width/2 * sin(radians(120))); //120
    rotate(radians(-30));
    text("120°", 0, 0);
    resetMatrix();
  
    translate((width-width * 0.5104) + width/2 * cos(radians(150)), (height-height * 0.0574)-width/2 * sin(radians(150))); //150
    rotate(radians(-60));
    text("150°", 0, 0);
    resetMatrix();
  
    popMatrix(); 
  }
}

void serialEvent (Serial myPort) 
{ // citeste date de la serial port
  // pe care le stocheaza in variabila data
  data = myPort.readStringUntil('.');
  data = data.substring(0, data.length() - 1);
  
  index1 = data.indexOf(","); // gaseste caracterul ',' si il stocheaza in index1
  angle= data.substring(0, index1); // citeste datele incepand cu prima pozitie si pana la index1(valoarea unghiului care se gaseste in serial port)
  distance= data.substring(index1 + 1, data.length()); // citeste datele de la index1 si pana la sfarsit
  
  // converteste variabilele la tipul de date int
  iAngle = int(angle);
  iDistance = int(distance);
}

void setup() 
{  
  fullScreen();
  //size (1000, 540);
  //smooth();
  myPort = new Serial(this,"COM4", 9600); // serial communication
  myPort.bufferUntil('.'); // citeste datele (angle si distance)
}


void draw() 
{
  Utils obj = new Utils();  //obiect de tip clasa
  
  fill(98, 245, 31);
  noStroke();
  fill(0, 4); 
  rect(0, 0, width, height-height * 0.065); 
  
  fill(98, 245, 31); 
  // apeleaza functiile necesare pt interfata grafica
  obj.drawRadar(); 
  obj.drawLine();
  obj.drawObject();
  obj.drawText();
}
