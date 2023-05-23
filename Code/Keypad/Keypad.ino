#include <Keypad.h>
#include <SoftwareSerial.h>
#define MAX_SIZE 256
#define rxPin 0
#define txPin 1
//#define DEBUG

const byte ROWS = 4; 
const byte COLS = 4; 

char hexaKeys[ROWS][COLS] = {
  {'1', '2', '3','A'},
  {'4', '5', '6','B'},
  {'7', '8', '9','C'},
  {'*', '0', '#','D'}
};

char curChar;
unsigned long curTime;
char prevChar = 'x';
unsigned long prevTime;
int count = 0;
int maxCnt[] = {1,3,3,3,3,3,3,4,3,4};
char dispChar[10][5] = {" ", "/.@", "ABC", "DEF", "GHI", "JKL", "MNO", "PQRS",
                "TUV", "WXYZ"};

byte rowPins[ROWS] = {2,3,4,5}; 
byte colPins[COLS] = {6,7,8,9}; 

int counter = 0;
const int analogPin = A0;
char message[MAX_SIZE] = {0};


Keypad customKeypad = Keypad(makeKeymap(hexaKeys), rowPins, colPins, ROWS, COLS); 
void sendMessage(char* message, int tam){
  Serial.println(message);
}


void setup(){
  pinMode(rxPin, INPUT);
  pinMode(txPin, OUTPUT);
  Serial.begin(9600);
}

void loop(){
#ifdef DEBUG
curChar = customKeypad.getKey();
Serial.print(curChar);

#endif

  #ifndef DEBUG
  bool read = false;
  char c;
  curChar = customKeypad.getKey();
  read = (curChar == NO_KEY ? false : true);

  curTime = millis();
  int pivot = prevChar - '0';
  if(read) // Lido
  {
    if(curChar == 'A'){
    Serial.println();
    sendMessage(message, counter);
    
    memset(message, '\0', counter);
    counter = 0;
    }
    else if(curChar == prevChar) {
      count++;
    } 
    else if (count == 0){
      count++;
      prevChar = curChar;
      prevTime = curTime;
    }
    else {
      pivot = prevChar - '0';
      c = dispChar[pivot][(count-1) % maxCnt[pivot]];
      Serial.print(c);
      message[counter] = c;
      counter++;
      count = 1;
      prevChar = curChar;
      prevTime = curTime;
    }
  } 
  else // Nao lido
  {
    if(curTime - prevTime <= 1000) return;
    if(count == 0) {
      prevTime = curTime; 
      return; 
    }
    c = dispChar[pivot][(count-1) % maxCnt[pivot]];
    Serial.print(c);
    message[counter] = c;
    counter++;
    count = 0;
    prevChar = 'x';
    prevTime = curTime;
  }
#endif
}