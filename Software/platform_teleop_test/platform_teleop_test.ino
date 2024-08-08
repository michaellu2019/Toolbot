#include <AccelStepper.h>
#include <MultiStepper.h>

#define PLATFORM_STEPPER_PWM_PIN 2
#define PLATFORM_STEPPER_DIR_PIN 3
#define BASE_ROLL_STEPPER_PWM_PIN 4
#define BASE_ROLL_STEPPER_DIR_PIN 5
#define BASE_PITCH_STEPPER_PWM_PIN 6
#define BASE_PITCH_STEPPER_DIR_PIN 7

#define PLATFORM_STEPPER_BUTTON1_PIN 23
#define PLATFORM_STEPPER_BUTTON2_PIN 22
#define BASE_ROLL_STEPPER_BUTTON1_PIN 21
#define BASE_ROLL_STEPPER_BUTTON2_PIN 20
#define BASE_PITCH_STEPPER_BUTTON1_PIN 19
#define BASE_PITCH_STEPPER_BUTTON2_PIN 18

AccelStepper platform_stepper(1, PLATFORM_STEPPER_PWM_PIN, PLATFORM_STEPPER_DIR_PIN);
AccelStepper base_roll_stepper(1, BASE_ROLL_STEPPER_PWM_PIN, BASE_ROLL_STEPPER_DIR_PIN);
AccelStepper base_pitch_stepper(1, BASE_PITCH_STEPPER_PWM_PIN, BASE_PITCH_STEPPER_DIR_PIN);

enum Direction {
  FORWARD,
  BACKWARD,
  UP, 
  DOWN,
  LEFT,
  RIGHT,
  CLOCKWISE,
  COUNTERCLOCKWISE,
  OFF
};

void setup() {
  // put your setup code here, to run once:
  Serial.begin(115200);
  Serial.println("Init...");

  platform_stepper.setMaxSpeed(10000);
  platform_stepper.setMinPulseWidth(10);
  base_roll_stepper.setMaxSpeed(10000);
  base_roll_stepper.setMinPulseWidth(10);
  base_pitch_stepper.setMaxSpeed(10000);
  base_pitch_stepper.setMinPulseWidth(10);


  pinMode(PLATFORM_STEPPER_BUTTON1_PIN, INPUT_PULLUP);
  pinMode(PLATFORM_STEPPER_BUTTON2_PIN, INPUT_PULLUP);
  pinMode(BASE_ROLL_STEPPER_BUTTON1_PIN, INPUT_PULLUP);
  pinMode(BASE_ROLL_STEPPER_BUTTON2_PIN, INPUT_PULLUP);
  pinMode(BASE_PITCH_STEPPER_BUTTON1_PIN, INPUT_PULLUP);
  pinMode(BASE_PITCH_STEPPER_BUTTON2_PIN, INPUT_PULLUP);
}

void loop() {
  // put your main code here, to run repeatedly:
  if (digitalRead(PLATFORM_STEPPER_BUTTON1_PIN) && !digitalRead(PLATFORM_STEPPER_BUTTON2_PIN)) {
    platform_stepper.setSpeed(-100);	
    platform_stepper.runSpeed();
  } else if (!digitalRead(PLATFORM_STEPPER_BUTTON1_PIN) && digitalRead(PLATFORM_STEPPER_BUTTON2_PIN)) {
    platform_stepper.setSpeed(100);	
    platform_stepper.runSpeed();
  } else if (digitalRead(PLATFORM_STEPPER_BUTTON1_PIN) && digitalRead(PLATFORM_STEPPER_BUTTON2_PIN)) {
    platform_stepper.stop();
  }
  
  if (digitalRead(BASE_ROLL_STEPPER_BUTTON1_PIN) && !digitalRead(BASE_ROLL_STEPPER_BUTTON2_PIN)) {
    base_roll_stepper.setSpeed(-200);	
    base_roll_stepper.runSpeed();
  } else if (!digitalRead(BASE_ROLL_STEPPER_BUTTON1_PIN) && digitalRead(BASE_ROLL_STEPPER_BUTTON2_PIN)) {
    base_roll_stepper.setSpeed(200);	
    base_roll_stepper.runSpeed();
  } else if (digitalRead(BASE_ROLL_STEPPER_BUTTON1_PIN) && digitalRead(BASE_ROLL_STEPPER_BUTTON2_PIN)) {
    base_roll_stepper.stop();
  }
  
  if (digitalRead(BASE_PITCH_STEPPER_BUTTON1_PIN) && !digitalRead(BASE_PITCH_STEPPER_BUTTON2_PIN)) {
    base_pitch_stepper.setSpeed(-200);	
    base_pitch_stepper.runSpeed();
  } else if (!digitalRead(BASE_PITCH_STEPPER_BUTTON1_PIN) && digitalRead(BASE_PITCH_STEPPER_BUTTON2_PIN)) {
    base_pitch_stepper.setSpeed(200);	
    base_pitch_stepper.runSpeed();
  } else if (digitalRead(BASE_PITCH_STEPPER_BUTTON1_PIN) && digitalRead(BASE_PITCH_STEPPER_BUTTON2_PIN)) {
    base_pitch_stepper.stop();
  }
}
