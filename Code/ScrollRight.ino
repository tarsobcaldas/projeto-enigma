#include <LiquidCrystal.h>

// Define the connections to the LCD keypad shield
LiquidCrystal lcd(8, 9, 4, 5, 6, 7);

// Define the message to be scrolled
String message = "Hello, World!";
int scrollPosition = 0;

void setup() {
  lcd.begin(16, 2); // Initialize the LCD
  lcd.setCursor(0, 0);
  lcd.print("Scroll Message:");
}

void loop() {
  int adc_key_in = analogRead(0); // Read the analog value from the button inputs

  // Check for button presses based on the analog value ranges
  if (adc_key_in < 50) { // Right button
    scrollPosition++;
    if (scrollPosition >= message.length())
      scrollPosition = 0;
  }

  // Display the scrolled message on the LCD
  lcd.setCursor(0, 1);
  lcd.print(message.substring(scrollPosition) + message.substring(0, scrollPosition));
  
  delay(500); // Delay for stability
}
