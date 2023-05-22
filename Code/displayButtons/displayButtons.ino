#include <LiquidCrystal.h>

// Define the connections to the LCD keypad shield
LiquidCrystal lcd(8, 9, 4, 5, 6, 7);

void setup() {
  lcd.begin(16, 2); // Initialize the LCD
  
}

void loop() {
  int adc_key_in = analogRead(1); // Read the analog value from the button inputs
  // The analog values of =the buttons may vary, so you may need to adjust the threshold values accordingly
  lcd.setCursor(0, 0);
  lcd.print(adc_key_in);
  
   

  // Check the analog value and determine which button is pressed
   /*if (adc_key_in > 1000) {
    lcd.clear(); // Clear the LCD screen
    lcd.setCursor(0, 0);
    lcd.print(adc_key_in);
    lcd.setCursor(0, 1);
    lcd.print("WAITING");
    }
  
  else if (adc_key_in < 50) {
    lcd.clear(); // Clear the LCD screen
    lcd.setCursor(0, 0);
    lcd.print(adc_key_in);
    lcd.setCursor(0, 1);
    lcd.print("RIGHT");
  }
  else if (adc_key_in < 250) {
    lcd.clear(); // Clear the LCD screen
    lcd.setCursor(0, 0);
    lcd.print(adc_key_in);
    lcd.setCursor(0, 1);
    lcd.print("UP");
  }
  else if (adc_key_in < 450) {
    lcd.clear(); // Clear the LCD screen
    lcd.setCursor(0, 0);
    lcd.print(adc_key_in);
    lcd.setCursor(0, 1);
    lcd.print("DOWN");
  }
  else if (adc_key_in < 650) {
    lcd.clear(); // Clear the LCD screen
    lcd.setCursor(0, 0);
    lcd.print(adc_key_in);
    lcd.setCursor(0, 1);
    lcd.print("LEFT");
  }

  else if (adc_key_in < 850) {
    lcd.clear(); // Clear the LCD screen
    lcd.setCursor(0, 0);
    lcd.print(adc_key_in);
    lcd.setCursor(0, 1);
    lcd.print("SELECT");
  }*/
  delay(100); // Delay for stability
}
