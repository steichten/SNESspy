#define CHECK_BIT(var,pos) ((var) & (1<<(pos)))
static int dataPin = 2;//red
static int latchPin = 3;//yellow
static int clockPin = 4;//blue
boolean list[12]; //setup a TRUE/FALSE bool of 12 values called 'list'
int bytecount = 0;
byte incomingByte = 0;
void setup() {
   Serial.begin(57600);
   while(!Serial.available()){}
   pinMode(dataPin, OUTPUT);
   pinMode(latchPin, INPUT);
   pinMode(clockPin, INPUT);
   list[0] = false; //start by wiping the list to send
    list[1] = false;
    list[2] = false;
    list[3] = false;
    list[4] = false;
    list[5] = false;
    list[6] = false;
    list[7] = false;
    list[8] = false;
    list[9] = false;
    list[10] = false;
    list[11] = false;
}

void loop(){
    Serial.flush();
    while(digitalReadFast(latchPin) == LOW){} //wait until the latch goes high
    Serial.flush();
    bytecount = 0;
    while(bytecount < 2) //loop 1 - read in the serial bytes to get your controller status
    { 
      //Serial.println("stuck");
      if(Serial.available()){ //if there is something to read in the incoming serial buffer...
        incomingByte = Serial.read(); //here you are reading one of the bytes coming from C# button_list[bytecount]
        if(bytecount == 0) //if you are reading the first byte, expect it to contain 8 values
        {
          list[0] = CHECK_BIT(incomingByte,0);
          list[1] = CHECK_BIT(incomingByte,1);
          list[2] = CHECK_BIT(incomingByte,2);
          list[3] = CHECK_BIT(incomingByte,3);
          list[4] = CHECK_BIT(incomingByte,4);
          list[5] = CHECK_BIT(incomingByte,5);
          list[6] = CHECK_BIT(incomingByte,6);
          list[7] = CHECK_BIT(incomingByte,7);
        }
        else //if not the first byte reading, it must be the second. Expect 4 values
        {
          list[8] = CHECK_BIT(incomingByte,0);
          list[9] = CHECK_BIT(incomingByte,1);
          list[10] = CHECK_BIT(incomingByte,2);
          list[11] = CHECK_BIT(incomingByte,3);
        }
        bytecount++; //run up the bytecount
        
      }
      
    }
    //write back to the python script to let it know that it received the last set of updated inputs
    Serial.write(1);
    //now, once you have the latest controller status, pump it out on the correct clock cycles to the SNES
    while(digitalReadFast(latchPin) == HIGH){}
    digitalWriteFast(dataPin, list[0]);
    while(digitalReadFast(clockPin) == HIGH){}
    while(digitalReadFast(clockPin) == LOW){}
    digitalWriteFast(dataPin, list[1]);
    while(digitalReadFast(clockPin) == HIGH){}
    while(digitalReadFast(clockPin) == LOW){}
    digitalWriteFast(dataPin, list[2]);
    while(digitalReadFast(clockPin) == HIGH){}
    while(digitalReadFast(clockPin) == LOW){}
    digitalWriteFast(dataPin, list[3]);
    while(digitalReadFast(clockPin) == HIGH){}
    while(digitalReadFast(clockPin) == LOW){}
    digitalWriteFast(dataPin, list[4]);
    while(digitalReadFast(clockPin) == HIGH){}
    while(digitalReadFast(clockPin) == LOW){}
    digitalWriteFast(dataPin, list[5]);
    while(digitalReadFast(clockPin) == HIGH){}
    while(digitalReadFast(clockPin) == LOW){}
    digitalWriteFast(dataPin, list[6]);
    while(digitalReadFast(clockPin) == HIGH){}
    while(digitalReadFast(clockPin) == LOW){}
    digitalWriteFast(dataPin, list[7]);
    while(digitalReadFast(clockPin) == HIGH){}
    while(digitalReadFast(clockPin) == LOW){}
    digitalWriteFast(dataPin, list[8]);
    while(digitalReadFast(clockPin) == HIGH){}
    while(digitalReadFast(clockPin) == LOW){}
    digitalWriteFast(dataPin, list[9]);
    while(digitalReadFast(clockPin) == HIGH){}
    while(digitalReadFast(clockPin) == LOW){}
    digitalWriteFast(dataPin, list[10]);
    while(digitalReadFast(clockPin) == HIGH){}
    while(digitalReadFast(clockPin) == LOW){}
    digitalWriteFast(dataPin, list[11]);
    while(digitalReadFast(clockPin) == HIGH){}
    while(digitalReadFast(clockPin) == LOW){}
    digitalWriteFast(dataPin, HIGH);  
    while(digitalReadFast(clockPin) == HIGH){}
    while(digitalReadFast(clockPin) == LOW){}
    digitalWriteFast(dataPin, HIGH);
    while(digitalReadFast(clockPin) == HIGH){}
    while(digitalReadFast(clockPin) == LOW){}
    digitalWriteFast(dataPin, HIGH);  
    while(digitalReadFast(clockPin) == HIGH){}
    while(digitalReadFast(clockPin) == LOW){}
    digitalWriteFast(dataPin, HIGH);
}
