#include <AccelStepper.h>
#include <MultiStepper.h>



#define STEPPER_PIN_PWM 6
#define STEPPER_PIN_DIR 7

AccelStepper stepper(1, STEPPER_PIN_PWM, STEPPER_PIN_DIR);

void setup() {
  // put your setup code here, to run once:
  Serial.begin(115200);
  Serial.println("Init...");

  stepper.setMaxSpeed(10000);
  stepper.setSpeed(100);	
  stepper.setMinPulseWidth(10);


  // pinMode(STEPPER_PIN_PWM, OUTPUT);
  // pinMode(STEPPER_PIN_DIR, OUTPUT);
  // pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  // put your main code here, to run repeatedly:
  // Serial.println("Go...");
  digitalWrite(LED_BUILTIN, HIGH);
  stepper.runSpeed();
}
