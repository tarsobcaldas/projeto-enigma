#include <LiquidCrystal.h>

// Define the connections to the LCD keypad shield
LiquidCrystal lcd(8, 9, 4, 5, 6, 7);

// Define the message to be scrolled
String message = "Hello, World!";
int xPosition = 0;
int yPosition = 0;
char c = '$';

void setup() {
  Serial.begin(9600);
  lcd.begin(16, 2); // Initialize the LCD
}

void loop() {
  if (Serial.available()){
    c = Serial.read();
    xPosition++;
    if(c == '\0'){
      c = '$';
      lcd.clear();
      xPosition = 0;
      yPosition = 0;
    }
    if (xPosition >= 16 && yPosition == 0){
      yPosition = 1;
      xPosition = 0;
    }
    if (xPosition >= 16 && yPosition == 1){
      yPosition = 0;
      xPosition = 0;
      lcd.clear();
    }
  }

  // Display the scrolled message on the LCD
  lcd.setCursor(xPosition, yPosition);
  lcd.print(c);

  delay(500); // Delay for stability
}
