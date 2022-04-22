// Giovanni Olmos Salmones - 2172002785
// Gabriel Hurtado Aviles  - 2172000781

/***************************************************
  Codigo principal "Sistema de control de aforos en instituciones educativas basada en el internet de las cosas"

  Objetivo General :
  Desarrollar un sistema modular capaz de gestionar y almacenar la información de
  múltiples usuarios a través de Internet de las Cosas como un prototipo para el control de
  aforos en instituciones educativas.

 ****************************************************/
#include <WiFi.h>              // Conexion Wifi.
#include <PubSubClient.h>      // Conexion MQTT.
#include <ArduinoJson.h>       // Manipulacion de JSON.

const char* ssid = "GosCoop23";                  // SSID de la red a conectar la cerradura.
const char* password = "Olmedo21720027";         // Password de la red a conectar la cerradura.
//const char* mqtt_server = "189.211.115.183";   // IP donde esta instalado el servidor MQTT.
const char* mqtt_server = "192.168.100.203";     // Servidor MQTT Personal;

const String Lab_Aula = "Laboratorio de Diseño Logico"; // Laboratorio o aula equipada donde se encuentra la cerradura.

WiFiClient espClient;
PubSubClient client(espClient);
const int ledPin = 15;         // LED Pin (led para la señal de apertura de la chapa).

#include <Keypad.h>            // Libreria teclado.
#include <Adafruit_GFX.h>      // Liberia pantalla .
#include <Adafruit_SSD1306.h>  // Pantalla OLED 128x64.

#include <SPI.h>               //Sensor RFID-RC522.
#include <MFRC522.h>


#include <HardwareSerial.h>   // Sensor de huellas dactilares - Para Registrar.
#include <SoftwareSerial.h>   // 
uint8_t id;                   // Variable para registrar huellas.

#include <Adafruit_Fingerprint.h>                              // Sensor de huellas dactilares.
#define mySerial Serial2                                       // Puertdo TX0 y RX0 donde esta conectado.  
Adafruit_Fingerprint finger = Adafruit_Fingerprint(&mySerial); // Creamos el objeto del sensor de huellas.

#include <Wire.h>               //Sensor de temperatura.
#include <Adafruit_MLX90614.h> 

const int trigPin = 5;   // Ultrasonico DHT11.
const int echoPin = 35;  // pines uilizados por el sensor ultrasonico.

// Definimos la velocidad del sonido en cm / uS para el sensor ultrasonico.
#define SOUND_SPEED 0.034
#define CM_TO_INCH 0.393701
long duration;
int distanceCm;
int distanceInch;

//Variables Extra
int Espera1 = 500;        //Espera en el loop.
int Dist;                 //Distancia del ultrasonico.
int DistMin = 12;         //Distancia minima para detectar al sujeto (mm).
int Presente = 0;         //Si hay alguien frente al Termometro.
int Espera = 3000;        //Tiempo de espera para verificar sujeto.
unsigned long Tiempo = 0; //Tiempo que lleva detectado para Millis.
int Ahora = 0;            //Millis en el momento que se inicia.

//Temperatura
float TempObj;            //Temperatura del sujeto (Usuario).
float TempMax = 37.50;    //Temperatura maxima permitida.

//Inicializamos sensor de temperatura.
Adafruit_MLX90614 mlx = Adafruit_MLX90614();

//Definimos la pantalla OLED 128x64.
#define SCREEN_WIDTH 128 // OLED display ancho, en pixeles.
#define SCREEN_HEIGHT 64 // OLED display alto, en pixelss.
Adafruit_SSD1306 display(SCREEN_WIDTH, SCREEN_HEIGHT, &Wire, -1); // Creamos un objeto a la pantalla oled

//Definmos el sensor RFID
#define RST_PIN         2          // Pin RST.
#define SS_PIN          4          // Pin SDA.
MFRC522 mfrc522(SS_PIN, RST_PIN);  // Creamos un objeto al sensor MFRC522.

//Teclado
const byte filas = 4;     //Numero de filas del teclado.
const byte columnas = 4;  //Numero de columnas del teclado.

//Defino una matriz 4x4 con la posicion de las filas y columnas.
char matriz[filas][columnas] = {
  { '1', '2', '3', 'A'},
  { '4', '5', '6', 'B'},
  { '7', '8', '9', 'C'},
  { '*', '0', '#', 'D'},

};

byte pinesFilas[filas] = {13, 12, 14, 27};       //Pines donde van conectadas las filas del teclado.
byte pinesColumnas[columnas] = {26, 25, 33, 32}; //Pines donde van conectadas las columnas del teclado.

//Inicializo el teclado con el numero de filas, columnas, los pines del Arduino utilizados y la matriz.
Keypad teclado = Keypad( makeKeymap(matriz), pinesFilas, pinesColumnas, filas, columnas);
char num1[10] = ""; // Aqui se guardara la contrasena tecleada.
int y = 0;          // Iterador de la cadena tecleada.

// Sensor de apertura de la puerta
const int pinDoor = 34; // pin de entrada de la señal del electroiman.
int EstadoV = 0;        // Estados del sensor.
int EstadoN = 0;  
String doorState ;      // Estado de la puerta.


const int boton = 1;             // Botón asignado en el pin 1.
int   anterior;                  // Guardamos el estado anterior.
int   estado;                    // Estado del botón.
unsigned long temporizador;      // Temporizador del boton.
unsigned long tiemporebote = 50; //

// Logotipo 
static const uint8_t image[648] = {
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
    0x00, 0x00, 0x00, 0x01, 0xe0, 0x00, 0x00, 0x00, 
    0x00, 0x00, 0x00, 0x47, 0xc8, 0x80, 0x00, 0x00, 
    0x00, 0x00, 0x00, 0x18, 0x72, 0x60, 0x00, 0x00, 
    0x00, 0x00, 0x0f, 0xff, 0x5d, 0x90, 0x00, 0x00, 
    0x00, 0x00, 0x00, 0x18, 0xd4, 0x48, 0x00, 0x00, 
    0x00, 0x00, 0x0f, 0x38, 0xb1, 0xa4, 0x00, 0x00, 
    0x00, 0x00, 0x30, 0x71, 0xaa, 0xd2, 0x00, 0x00, 
    0x00, 0x00, 0x07, 0xf1, 0x64, 0x69, 0x00, 0x00, 
    0x00, 0x00, 0x10, 0x86, 0x5d, 0x34, 0x80, 0x00, 
    0x00, 0x00, 0x48, 0x00, 0xd6, 0x92, 0x00, 0x00, 
    0x00, 0x01, 0xb6, 0x0e, 0xa2, 0x59, 0x00, 0x00, 
    0x00, 0x00, 0xd1, 0x05, 0xab, 0x64, 0x80, 0x00, 
    0x00, 0x00, 0xac, 0x7c, 0x6d, 0xb3, 0x40, 0x00, 
    0x00, 0x01, 0x49, 0x01, 0x16, 0xd9, 0xc0, 0x00, 
    0x00, 0x02, 0x94, 0x38, 0x59, 0x64, 0x80, 0x00, 
    0x00, 0x05, 0x29, 0x83, 0x2c, 0xb2, 0x40, 0x00, 
    0x00, 0x01, 0x52, 0x00, 0x96, 0xd9, 0x20, 0x00, 
    0x00, 0x02, 0x84, 0x7c, 0x5b, 0x64, 0xa0, 0x00, 
    0x00, 0x04, 0xe9, 0xc3, 0x2d, 0xb3, 0x00, 0x00, 
    0x00, 0x09, 0xcb, 0x01, 0x92, 0x19, 0xc0, 0x00, 
    0x00, 0x01, 0x5c, 0x7c, 0x4b, 0x45, 0x60, 0x00, 
    0x00, 0x02, 0x95, 0x83, 0x25, 0x25, 0x80, 0x00, 
    0x00, 0x04, 0xbd, 0x38, 0xb4, 0xb2, 0xc0, 0x00, 
    0x00, 0x01, 0xba, 0x64, 0x52, 0x5b, 0x60, 0x00, 
    0x00, 0x0e, 0x56, 0x93, 0x49, 0x20, 0x80, 0x00, 
    0x00, 0x12, 0xf5, 0x45, 0x24, 0xb4, 0x40, 0x00, 
    0x00, 0x06, 0xa5, 0x12, 0x92, 0xda, 0x20, 0x00, 
    0x00, 0x09, 0x69, 0x85, 0x49, 0x4b, 0x00, 0x00, 
    0x00, 0x0a, 0x49, 0xb4, 0xa9, 0x24, 0x80, 0x00, 
    0x00, 0x02, 0xda, 0xaa, 0x14, 0x92, 0xc0, 0x00, 
    0x00, 0x04, 0x12, 0xa5, 0x52, 0x49, 0x60, 0x00, 
    0x00, 0x09, 0x3a, 0x90, 0xa9, 0x24, 0xc0, 0x00, 
    0x00, 0x02, 0x2a, 0x4a, 0x94, 0x92, 0x00, 0x00, 
    0x00, 0x06, 0x5a, 0x49, 0x4a, 0x49, 0x80, 0x00, 
    0x00, 0x0c, 0x94, 0x24, 0xa8, 0x24, 0x60, 0x00, 
    0x00, 0x01, 0xa4, 0x13, 0x95, 0x13, 0x00, 0x00, 
    0x00, 0x03, 0x28, 0x4c, 0xca, 0xcc, 0x40, 0x00, 
    0x00, 0x06, 0x48, 0x23, 0x35, 0xa3, 0x80, 0x00, 
    0x00, 0x00, 0x90, 0x98, 0x8b, 0x58, 0x00, 0x00, 
    0x00, 0x01, 0x23, 0x76, 0x66, 0x33, 0x00, 0x00, 
    0x00, 0x02, 0x48, 0x19, 0x99, 0xe0, 0x00, 0x00, 
    0x00, 0x00, 0x31, 0xa6, 0x67, 0x1e, 0x00, 0x00, 
    0x00, 0x00, 0x4e, 0x3d, 0x99, 0xe0, 0x80, 0x00, 
    0x00, 0x01, 0x30, 0x07, 0xe7, 0x1c, 0x00, 0x00, 
    0x00, 0x00, 0x47, 0xfc, 0xe1, 0xc0, 0x00, 0x00, 
    0x00, 0x00, 0x7c, 0x06, 0x1e, 0x00, 0x00, 0x00, 
    0x00, 0x01, 0x87, 0x38, 0xe3, 0x88, 0x00, 0x00, 
    0x00, 0x00, 0x3e, 0x7e, 0x6c, 0x0c, 0x00, 0x00, 
    0x00, 0x00, 0x02, 0x00, 0x78, 0xd0, 0x00, 0x00, 
    0x00, 0x00, 0x1e, 0x3f, 0x19, 0xf8, 0x00, 0x00, 
    0x00, 0x00, 0x30, 0x18, 0xff, 0x80, 0x00, 0x00, 
    0x00, 0x00, 0x0e, 0x3e, 0x00, 0x10, 0x00, 0x00, 
    0x00, 0x00, 0x1f, 0x03, 0x00, 0x00, 0x00, 0x00, 
    0x00, 0x00, 0x00, 0x03, 0xc3, 0xe0, 0x00, 0x00, 
    0x00, 0x00, 0x03, 0xf9, 0x00, 0x00, 0x00, 0x00, 
    0x00, 0x00, 0x00, 0x01, 0xff, 0x00, 0x00, 0x00, 
    0x00, 0x00, 0x00, 0x3c, 0x00, 0x00, 0x00, 0x00, 
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
};


// Funcion del sensor RFID, nos devuelve el id en formato decimal.
unsigned long getID(){
  if ( ! mfrc522.PICC_ReadCardSerial()) { 
    return -1;
  }
  unsigned long hex_num;
  hex_num =  mfrc522.uid.uidByte[0] << 24;
  hex_num += mfrc522.uid.uidByte[1] << 16;
  hex_num += mfrc522.uid.uidByte[2] <<  8;
  hex_num += mfrc522.uid.uidByte[3];
  mfrc522.PICC_HaltA(); 
  return hex_num;
}

// Limpiar contrasena (tecleada).
void limpiar() {
  for (int i = 0; i <= 9; ++i){
    num1[i] = ' '; 
  }
} 

// Funcion para el rsgistro de nuevas huellas.
void Fun_Enroll() {
  while(true){
    display.clearDisplay();
    display.setTextColor(WHITE);
    display.setTextSize(1);
    display.setCursor(0,0);
    display.print("Huella a registrar : ");display.print(id);
    display.setCursor(0,20);
    display.print("Oprime A - Registrar ");
    display.setCursor(0,30);
    display.print("Oprime B - Cambiar #");
    display.setCursor(0,40);
    display.print("Oprime # - Salir ");
    display.display();
    
    char key = teclado.getKey();      // Se lee el caracter tecleado por el usuario.
      if(key){                          
        if(key == '#'){
          display.clearDisplay();
          display.setTextColor(WHITE);
          display.setTextSize(2);
          display.setCursor(0,0);
          display.print("Saliendo");
          display.setCursor(0,20);
          display.print("del modo");
          display.setCursor(0,40);
          display.print("registro");
          display.display();
          delay(2000); 
          return ;
        } else if (key == 'A'){
          getFingerprintEnroll() ; 
        } else if (key == 'B') {
          Fun_Huella_Registrar() ;
        }    
      }
  } 
}

// Funcion para captural y almacenar las huellas dactilares
uint8_t getFingerprintEnroll() {    
    int p = -1;
    while (p != FINGERPRINT_OK) {
      p = finger.getImage();
      switch (p) {
        case FINGERPRINT_OK:
        display.clearDisplay();
        display.setTextColor(WHITE);
        display.setTextSize(2);
        display.setCursor(0,0);
        display.setTextColor(WHITE);
        display.print("Imagen tomada");
        display.display();
        break;
        case FINGERPRINT_NOFINGER:

        display.clearDisplay();
        display.setTextColor(WHITE);
        display.setTextSize(2);
        display.setCursor(0,0);
        display.setTextColor(WHITE);
        display.print("...");
        display.display();
        break;
        case FINGERPRINT_PACKETRECIEVEERR:
        Serial.println("Communication error");
        display.clearDisplay();
        display.setTextColor(WHITE);
        display.setTextSize(2);
        display.setCursor(0,0);
        display.setTextColor(WHITE);
        display.print("Error de comunicacion");
        display.display();
        break;
        case FINGERPRINT_IMAGEFAIL:
        display.clearDisplay();
        display.setTextColor(WHITE);
        display.setTextSize(2);
        display.setCursor(0,0);
        display.setTextColor(WHITE);
        display.print("Error de imagen");
        display.display();

        break;
        default:
        display.clearDisplay();
        display.setTextColor(WHITE);
        display.setTextSize(2);
        display.setCursor(0,0);
        display.setTextColor(WHITE);
        display.print("Error desconocido");
        display.display();
        break;
      }
    }
    
   // OK success!
    
    p = finger.image2Tz(1);
    switch (p) {
      case FINGERPRINT_OK:
      display.clearDisplay();
      display.setTextColor(WHITE);
      display.setTextSize(2);
      display.setCursor(0,0);
      display.setTextColor(WHITE);
      display.print("Imagen convertida");
      display.display();
      break;
      case FINGERPRINT_IMAGEMESS:
      display.clearDisplay();
      display.setTextColor(WHITE);
      display.setTextSize(2);
      display.setCursor(0,0);
      display.setTextColor(WHITE);
      display.print("Imagen demasiado desordenada");
      display.display();
      return p;
      case FINGERPRINT_PACKETRECIEVEERR:
      display.clearDisplay();
      display.setTextColor(WHITE);
      display.setTextSize(2);
      display.setCursor(0,0);
      display.setTextColor(WHITE);
      display.print("Error de comunicacion");
      display.display();
      return p;
      case FINGERPRINT_FEATUREFAIL:
      display.clearDisplay();
      display.setTextColor(WHITE);
      display.setTextSize(2);
      display.setCursor(0,0);
      display.setTextColor(WHITE);
      display.print("No se pudieron encontrar las características");
      display.display();
      delay(1000);
      case FINGERPRINT_INVALIDIMAGE:
      display.clearDisplay();
      display.setTextColor(WHITE);
      display.setTextSize(2);
      display.setCursor(0,0);
      display.setTextColor(WHITE);
      display.print("No se pudieron encontrar las características");
      display.display();
      return p;
      default:
      display.clearDisplay();
      display.setTextColor(WHITE);
      display.setTextSize(2);
      display.setCursor(0,0);
      display.setTextColor(WHITE);
      display.print("Error desconocido");
      display.display();
      return p;
    }
    
    display.clearDisplay();
    display.setTextColor(WHITE);
    display.setTextSize(2);
    display.setCursor(0,0);
    display.setTextColor(WHITE);
    display.print("Remueve el dedo");
    display.display();
    delay(2000);
    p = 0;
    while (p != FINGERPRINT_NOFINGER) {
      p = finger.getImage();
    }
    display.clearDisplay();
    display.setTextColor(WHITE);
    display.setTextSize(2);
    display.setCursor(0,0);
    display.setTextColor(WHITE);
    display.print("# de Huella :" + id);
    display.display();
    p = -1;
    display.clearDisplay();
    display.setTextColor(WHITE);
    display.setTextSize(2);
    display.setCursor(0,0);
    display.setTextColor(WHITE);
    display.print("Vuelva a colocar el mismo dedo");
    display.display();
    delay(1000);
    while (p != FINGERPRINT_OK) {
      p = finger.getImage();
      switch (p) {
        case FINGERPRINT_OK:
        display.clearDisplay();
        display.setTextColor(WHITE);
        display.setTextSize(2);
        display.setCursor(0,0);
        display.setTextColor(WHITE);
        display.print("Imagen tomada");
        display.display();
        break;
        case FINGERPRINT_NOFINGER:
        display.clearDisplay();
        display.setTextColor(WHITE);
        display.setTextSize(2);
        display.setCursor(0,0);
        display.setTextColor(WHITE);
        display.print("...");
        display.display();
        break;
        case FINGERPRINT_PACKETRECIEVEERR:
        display.clearDisplay();
        display.setTextColor(WHITE);
        display.setTextSize(2);
        display.setCursor(0,0);
        display.setTextColor(WHITE);
        display.print("Imagen tomada");
        display.display();
        break;
        case FINGERPRINT_IMAGEFAIL:
        display.clearDisplay();
        display.setTextColor(WHITE);
        display.setTextSize(2);
        display.setCursor(0,0);
        display.setTextColor(WHITE);
        display.print("Error de imagen");
        display.display();
        break;
        default:
        display.clearDisplay();
        display.setTextColor(WHITE);
        display.setTextSize(2);
        display.setCursor(0,0);
        display.setTextColor(WHITE);
        display.print("Error desconocido");
        display.display();
        break;
      }
    }
    
    // OK success!
    
    p = finger.image2Tz(2);
    switch (p) {
      case FINGERPRINT_OK:
      display.clearDisplay();
      display.setTextColor(WHITE);
      display.setTextSize(2);
      display.setCursor(0,0);
      display.setTextColor(WHITE);
      display.print("Imagen convertidad");
      display.display();
      break;
      case FINGERPRINT_IMAGEMESS:
      display.clearDisplay();
      display.setTextColor(WHITE);
      display.setTextSize(2);
      display.setCursor(0,0);
      display.setTextColor(WHITE);
      display.print("Imagen demasiado desordenado");
      display.display();
      return p;
      case FINGERPRINT_PACKETRECIEVEERR:
      display.clearDisplay();
      display.setTextColor(WHITE);
      display.setTextSize(2);
      display.setCursor(0,0);
      display.setTextColor(WHITE);
      display.print("Error de comunicacion");
      display.display();
      return p;
      case FINGERPRINT_FEATUREFAIL:
      display.clearDisplay();
      display.setTextColor(WHITE);
      display.setTextSize(2);
      display.setCursor(0,0);
      display.setTextColor(WHITE);
      display.print("No se pudieron encontrar las características");
      display.display();
      return p;
      case FINGERPRINT_INVALIDIMAGE:
      display.clearDisplay();
      display.setTextColor(WHITE);
      display.setTextSize(2);
      display.setCursor(0,0);
      display.setTextColor(WHITE);
      display.print("No se pudieron encontrar las características");
      display.display();
      return p;
      default:
      display.clearDisplay();
      display.setTextColor(WHITE);
      display.setTextSize(2);
      display.setCursor(0,0);
      display.setTextColor(WHITE);
      display.print("Error desconocido");
      display.display();
      return p;
    }
    
    // OK converted!
    display.clearDisplay();
    display.setTextColor(WHITE);
    display.setTextSize(2);
    display.setCursor(0,0);
    display.setTextColor(WHITE);
    display.print("Creando modelo para # " + id);
    display.display();
    
    
    p = finger.createModel();
    if (p == FINGERPRINT_OK) {
      display.clearDisplay();
      display.setTextColor(WHITE);
      display.setTextSize(2);
      display.setCursor(0,0);
      display.setTextColor(WHITE);
      display.print("Huellas combinadas");
      display.display();
      
    } else if (p == FINGERPRINT_PACKETRECIEVEERR) {
      display.clearDisplay();
      display.setTextColor(WHITE);
      display.setTextSize(2);
      display.setCursor(0,0);
      display.setTextColor(WHITE);
      display.print("Error de comunicacion");
      display.display();
      
      return p;
    } else if (p == FINGERPRINT_ENROLLMISMATCH) {
      display.clearDisplay();
      display.setTextColor(WHITE);
      display.setTextSize(2);
      display.setCursor(0,0);
      display.setTextColor(WHITE);
      display.print("Las huellas dactilares no coinciden");
      display.display();
      delay(1000);
      
      return p;
    } else {
      display.clearDisplay();
      display.setTextColor(WHITE);
      display.setTextSize(2);
      display.setCursor(0,0);
      display.setTextColor(WHITE);
      display.print("Error desconocido");
      display.display();
      
      return p;
    }
    
    display.clearDisplay();
    display.setTextColor(WHITE);
    display.setTextSize(2);
    display.setCursor(0,0);
    display.setTextColor(WHITE);
    display.print("# ID : " + id);
    display.display();
   
    p = finger.storeModel(id);
    if (p == FINGERPRINT_OK) {
      display.clearDisplay();
      display.setTextColor(WHITE);
      display.setTextSize(2);
      display.setCursor(0,0);
      display.setTextColor(WHITE);
      display.print("Almacenda!");
      display.display();
      delay(3000);
      
      return p;
    } else if (p == FINGERPRINT_PACKETRECIEVEERR) {
      display.clearDisplay();
      display.setTextColor(WHITE);
      display.setTextSize(2);
      display.setCursor(0,0);
      display.setTextColor(WHITE);
      display.print("Error de comunicacion");
      display.display();
      
      return p;
    } else if (p == FINGERPRINT_BADLOCATION) {
      display.clearDisplay();
      display.setTextColor(WHITE);
      display.setTextSize(2);
      display.setCursor(0,0);
      display.setTextColor(WHITE);
      display.print("No se pudo almacenar en esa ubicación");
      display.display();
    
      return p;
    } else if (p == FINGERPRINT_FLASHERR) {
      display.clearDisplay();
      display.setTextColor(WHITE);
      display.setTextSize(2);
      display.setCursor(0,0);
      display.setTextColor(WHITE);
      display.print("Error al escribir en flash");
      display.display();
      
      return p;
    } else {
      display.clearDisplay();
      display.setTextColor(WHITE);
      display.setTextSize(2);
      display.setCursor(0,0);
      display.setTextColor(WHITE);
      display.print("Error desconocido");
      display.display();
      return p;
    }
}

uint8_t deleteFingerprint(uint8_t id) {
  uint8_t p = -1;

  p = finger.deleteModel(id);

  if (p == FINGERPRINT_OK) {
    display.clearDisplay();
    display.setTextColor(WHITE);
    display.setTextSize(2);
    display.setCursor(0,0);
    display.print("Borrada!");
    display.display();
    delay(2000);
  } else if (p == FINGERPRINT_PACKETRECIEVEERR) {
    display.clearDisplay();
    display.setTextColor(WHITE);
    display.setTextSize(2);
    display.setCursor(0,0);
    display.print("Error de comunicacion");
    display.display();
    delay(1000);
  } else if (p == FINGERPRINT_BADLOCATION) {
    display.clearDisplay();
    display.setTextColor(WHITE);
    display.setTextSize(2);
    display.setCursor(0,0);
    display.print("No se");
    display.setCursor(0,20);
    display.print("puede");
    display.setCursor(0,40);
    display.print("borra");
    display.display();
    delay(1000);
  } else if (p == FINGERPRINT_FLASHERR) {
    display.clearDisplay();
    display.setTextColor(WHITE);
    display.setTextSize(2);
    display.setCursor(0,0);
    display.print("Error almemoria flash");
    display.display();
    delay(1000);
  }

  return p;
}

void Fun_Huella_Borrar() {
  display.clearDisplay();
  display.setTextColor(WHITE);
  display.setTextSize(2);
  display.setCursor(0,0);
  display.print("Borrar");
  display.setCursor(0,20);
  display.print("Huellas");
  display.setCursor(0,40);
  display.print("dactilares");
  display.display();
  delay(1000);
  
  char numHuella[3] = "" ;
  int x =  0 ;
  while(true){
    display.clearDisplay();
    display.setTextColor(WHITE);
    display.setTextSize(1);
    display.setCursor(0,0);
    display.print("Escriba el # huella");
    display.setCursor(0,10);
    display.print("(del 1 al 127)");
    display.setCursor(0,20);
    display.print("Oprime A - Borrar");
    display.setCursor(0,30);
    display.print("Oprime B - limpiar #");
    display.setCursor(0,40);
    display.print("Oprime # - Salir");
    display.display();
  
    char key = teclado.getKey();      // Se lee el caracter tecleado por el usuario.
    if(key){                          
        if(key == '#'){
          display.clearDisplay();
          display.setTextColor(WHITE);
          display.setTextSize(2);
          display.setCursor(0,0);
          display.print("Saliendo");
          display.setCursor(0,20);
          display.print("del modo");
          display.setCursor(0,40);
          display.print("borrar");
          display.display();
          delay(2000);
          return ; 
        } else if (key == 'A') {
          String valueS = String(numHuella);
          int value = valueS.toInt(); // Convertimos la cadena de string a int
          display.clearDisplay();
          display.setTextColor(WHITE);
          display.setTextSize(2);
          display.setCursor(0,0);
          display.print("# Huella a");
          display.setCursor(0,20);
          display.print("Borrar :");
          display.setCursor(0,40);
          display.print(value);
          display.display();
          delay(2000);
          if( value >= 1 && value <= 127){
            id = value;
            deleteFingerprint(id);
            x = 0;     // Reinicimaos el iterador.
            numHuella[0] = ' ' ; 
            numHuella[1] = ' ' ; 
            numHuella[2] = ' ' ; 
          } else {
            display.clearDisplay();
            display.setTextColor(WHITE);
            display.setTextSize(2);
            display.setCursor(0,0);
            display.print("Numero");
            display.setCursor(0,20);
            display.print("incorrecto...");
            display.setCursor(0,40);
            display.print("...  :C");
            display.display();
            delay(1000);
            x = 0;     // Reinicimaos el iterador.
            numHuella[0] = ' ' ; 
            numHuella[1] = ' ' ; 
            numHuella[2] = ' ' ;  
          }
        } else if (key == 'B') {
          display.clearDisplay();
          display.setTextColor(WHITE);
          display.setTextSize(2);
          display.setCursor(0,0);
          display.print("limpiando");
          display.setCursor(0,20);
          display.print("...");
          display.display();
          delay(1000);
          x = 0;     // Reinicimaos el iterador.
          numHuella[0] = ' ' ; 
          numHuella[1] = ' ' ; 
          numHuella[2] = ' ' ; 

        } else {
          numHuella[x] = key; 
          x++;
        }
    }
  }  
}
    

void Fun_Huella_Registrar() {
  display.clearDisplay();
  display.setTextColor(WHITE);
  display.setTextSize(2);
  display.setCursor(0,0);
  display.print("Registro");
  display.setCursor(0,20);
  display.print("de Huellas");
  display.setCursor(0,40);
  display.print("dactilares");
  display.display();
  delay(1000);
  
  char numHuella[3] = "" ;
  int x =  0 ;
  while(true){
    display.clearDisplay();
    display.setTextColor(WHITE);
    display.setTextSize(1);
    display.setCursor(0,0);
    display.print("Escriba el # huella");
    display.setCursor(0,10);
    display.print("(del 1 al 127)");
    display.setCursor(0,20);
    display.print("Oprime A - Ir a registrar");
    display.setCursor(0,30);
    display.print("Oprime B - limpiar #");
    display.setCursor(0,40);
    display.print("Oprime # - Salir");
    display.display();
  
    char key = teclado.getKey();      // Se lee el caracter tecleado por el usuario.
    if(key){                          
        if(key == '#'){
          display.clearDisplay();
          display.setTextColor(WHITE);
          display.setTextSize(2);
          display.setCursor(0,0);
          display.print("Saliendo");
          display.setCursor(0,20);
          display.print("del modo");
          display.setCursor(0,40);
          display.print("registro");
          display.display();
          delay(2000);
          return ; 
        } else if (key == 'A') {
          String valueS = String(numHuella);
          int value = valueS.toInt(); // Convertimos la cadena de string a int
          display.clearDisplay();
          display.setTextColor(WHITE);
          display.setTextSize(2);
          display.setCursor(0,0);
          display.print("# Huella a");
          display.setCursor(0,20);
          display.print("Registar :");
          display.setCursor(0,40);
          display.print(value);
          display.display();
          delay(2000);
          if( value >= 1 && value <= 127){
            id = value;
            Fun_Enroll();
            x = 0;     // Reinicimaos el iterador.
            numHuella[0] = ' ' ; 
            numHuella[1] = ' ' ; 
            numHuella[2] = ' ' ;  
          } else {
            display.clearDisplay();
            display.setTextColor(WHITE);
            display.setTextSize(2);
            display.setCursor(0,0);
            display.print("Numero");
            display.setCursor(0,20);
            display.print("incorrecto...");
            display.setCursor(0,40);
            display.print("...  :C");
            display.display();
            delay(1000);
            x = 0;     // Reinicimaos el iterador.
            numHuella[0] = ' ' ; 
            numHuella[1] = ' ' ; 
            numHuella[2] = ' ' ;  
          }
        } else if (key == 'B') {
          display.clearDisplay();
          display.setTextColor(WHITE);
          display.setTextSize(2);
          display.setCursor(0,0);
          display.print("limpiando");
          display.setCursor(0,20);
          display.print("...");
          display.display();
          delay(1000);
          x = 0;     // Reinicimaos el iterador.
          numHuella[0] = ' ' ; 
          numHuella[1] = ' ' ; 
          numHuella[2] = ' ' ; 

        } else {
          numHuella[x] = key; 
          x++;
        }
    }
  }  
}

void Fun_Ver_RFID(){
  display.clearDisplay();
  display.setTextColor(WHITE);
  display.setCursor(0,0);
  display.print("Detector");
  display.setCursor(0,20);
  display.print("RFID");
  display.display();
  
  while(true){
  char key = teclado.getKey();    // Se lee el caracter tecleado por el usuario.
  if(key){                          
      if(key == '#'){
        display.clearDisplay();
        display.setTextSize(2);
        display.setTextColor(WHITE);
        display.setCursor(0,0);
        display.print("Saliendo");
        display.setCursor(0,20);
        display.print("del modo");
        display.setCursor(0,40);
        display.print("detector");
        display.display();
        delay(2000);
        return ; 
      }
    }
    if(mfrc522.PICC_IsNewCardPresent()) {
      unsigned long uid = getID();
        if(uid != -1){
          display.clearDisplay();
          display.setTextSize(1);
          display.setTextColor(WHITE);
          display.setCursor(0, 0);
          display.print("Tarjeta detectada : ");
          display.setTextSize(2);
          display.setCursor(0, 30);
          display.print(uid);
          display.display();
        }
     } 
  }
}

//Funcion teclado 
void Fun_teclado(char x) {
    num1[y] = x;                        // Char x es el primer caracter de la contrasena tecleada.
    y++;                                // Iterador de la cadena tecleada.
    while(true){                        // Ciclo infinito mmientras el usuario no deje de teclear.
      char key = teclado.getKey();      // Se lee el caracter tecleado por el usuario.
      if(key){                          
        if(key == '#'){                 // Si el usuario teclea "#", quiere decir que ya ah acabado de poner su contrasena.
          Serial.println(key);     
          String codigo = String(num1); //En num1 se guarda el codigo tecleado por el usuario, lo convertimos a string.

           /////// Verificar Tarjetas - RFID////////

           if(codigo == "1903152172"){
              Fun_Ver_RFID();               // Funcion que nos ayuda a detectar el numero RFID de las tarjetas.
              y = 0;                        // Reinicimaos el iterador.
              limpiar();                    // Limpiamos la cadena para el proximo usuario.        
              return ;
           } else if (codigo == "1903152173") {
              Fun_Huella_Registrar();       // Funcion que nos ayuda a registrar un huella dactilar.
              y = 0;                        // Reinicimaos el iterador.
              limpiar();                    // Limpiamos la cadena para el proximo usuario.        
              return ;

           } else if (codigo == "1903152174") {
              Fun_Huella_Borrar();          // Funcion que nos ayuda a borrar un huella dactilar.
              y = 0;                        // Reinicimaos el iterador.
              limpiar();                    // Limpiamos la cadena para el proximo usuario.        
              return ;
           } else {
            StaticJsonDocument<256> doc;  //Creamos un documento JSON, donde enviaremos el codigo tecleado para comprobar si esta registrado.
            doc["codigo"] = codigo;       //Solo mandamos el id del codigo tecleado.
            char out[128];
            int b = serializeJson(doc, out);  //Sereliarizamos el JSON para poderlo mandar por mqtt.
            
            client.publish("Gabanni/UAMazc/compararteclado/Profesor/1", out); //Publicamos en MQTT.
            
            y = 0;     // Reinicimaos el iterador.
            limpiar(); // Limpiamos la cadena para el proximo usuario.        
            return ;
           }

           /////////////////////////////////////////
  
        } else if (y <= 9) {
          num1[y] = key; 
          y++;
        }
      } 
    }
}

//Funcion RFID
void Fun_RFID() {
    unsigned long uid = getID();      // Numero de identificacion en formato decimal.
    Serial.println("ESTOY LEYENDO LA TARJETA");

    if(uid != -1){                    // Comprobamos que la lectura de la tarjeta sea correcta 
      char uidString[12];             // Variable que se usara para almacenar el id de la tarjeta RFID.
      dtostrf(uid, 1, 0, uidString);  // Convertimos la cadena de unsigned long a string
     
      StaticJsonDocument<256> doc;    // Creamos un documento JSON, donde enviaremos la infromacion de la tarjeta RFID para comprobar si esta registrada.
      doc["RFID"] = uidString;        // Solo mandamos el id de identifiacion de la tarjeta.
     
      char out[128];
      int b = serializeJson(doc, out);  //Sereliarizamos el JSON para poderlo mandar por mqtt.
      
      
      client.publish("Gabanni/UAMazc/compararRFID/Alumno/1", out); //Publicamos en MQTT.
    }
}

//Funcion para detectar huellas dactilares 
// Obtenemos la imagen de la huella presentada.
uint8_t getFingerprintID() {
  uint8_t p = finger.getImage();
  switch (p) {
    case FINGERPRINT_OK:
      //Serial.println("Image taken");
      break;
    case FINGERPRINT_NOFINGER:
      //Serial.println("No finger detected");
      return p;
    case FINGERPRINT_PACKETRECIEVEERR:
      //Serial.println("Communication error");
      return p;
    case FINGERPRINT_IMAGEFAIL:
      //Serial.println("Imaging error");
      return p;
    default:
      //Serial.println("Unknown error");
      return p;
  }

  // OK success!

// Convertimos la imagen de la huella presentada codigo para compararla.
  p = finger.image2Tz();
  switch (p) {
    case FINGERPRINT_OK:
      //Serial.println("Image converted");
      break;
    case FINGERPRINT_IMAGEMESS:
      //Serial.println("Image too messy");
      return p;
    case FINGERPRINT_PACKETRECIEVEERR:
      //Serial.println("Communication error");
      return p;
    case FINGERPRINT_FEATUREFAIL:
      //Serial.println("Could not find fingerprint features");
      return p;
    case FINGERPRINT_INVALIDIMAGE:
      //Serial.println("Could not find fingerprint features");
      return p;
    default:
     // Serial.println("Unknown error");
      return p;
  }

  // OK converted!
  p = finger.fingerSearch();
  if (p == FINGERPRINT_OK) {
    //Serial.println("Found a print match!");
  } else if (p == FINGERPRINT_PACKETRECIEVEERR) {
    //Serial.println("Communication error");
    return p;
  } else if (p == FINGERPRINT_NOTFOUND) {
    //Serial.println("Did not find a match");
    
    //Si la huella presentada no conincide con ninguna huella.
    display.clearDisplay();
    display.setCursor(0,0);
    display.setTextColor(WHITE);
    display.print("Huella no registrada");
    display.display();
    delay(3000);
    return p;
    
  } else {
    //Serial.println("Unknown error");
    return p;
  }
 
  //Si la huella presentada conincide con alguna huella resgitrada.
  char dactilarString[12];
  dtostrf(finger.fingerID, 1, 0, dactilarString);  //Almacenamos el id de la huella detectada
  
  StaticJsonDocument<256> doc;               //Creamos un documento JSON, donde enviaremos la informacion del id de la huella para comprobar si esta registrada.
  doc["dactilar"] = dactilarString;          //Solo mandamos el id de identifiacion de la huella.
  char out[128];
  int b = serializeJson(doc, out);           //Sereliarizamos el JSON para poderlo mandar por mqtt.
  
  client.publish("Gabanni/UAMazc/compararHuella/Profesor/1", out); //Publicamos en MQTT. 
  return finger.fingerID;
}

// devuelve -1 si falla, de lo contrario devuelve ID # de la huella
int getFingerprintIDez() {
    uint8_t p = finger.getImage();
    if (p != FINGERPRINT_OK)  return -1;
  
    p = finger.image2Tz();
    if (p != FINGERPRINT_OK)  return -1;
  
    p = finger.fingerFastSearch();
    if (p != FINGERPRINT_OK)  return -1;
  
    return finger.fingerID;
}

void EstadoPuerta() {
     EstadoV = EstadoN ;
     if(EstadoV == 0){
        doorState = "abierto";
    } else{ 
        doorState = "cerrado";
    }

    StaticJsonDocument<256> doc;              //Creamos un documento JSON, donde enviaremos la informacion del id de la huella para comprobar si esta registrada.
    doc["estado"] = doorState;              //Solo mandamos el eatado de la puerta.
    char out[128];
    int b = serializeJson(doc, out);           //Sereliarizamos el JSON para poderlo mandar por mqtt.  
    client.publish("Gabanni/UAMazc/EstadoPuerta/1", out); //Publicamos
}

void setup() {
    Serial.begin(115200); //Se inicia el monitor serie a 115200 baudios.
    
    //Se inicia la pantalla
    display.begin(SSD1306_SWITCHCAPVCC, 0x3C);
  
    setup_wifi();                         // Se inicia la conexion wifi.
    client.setServer(mqtt_server, 1883);  // Se inicia comunicacion con el servidor MQTT.
    client.setCallback(callback);         // Se inicia la funcion callback.

    pinMode(pinDoor, INPUT); // Se inicializa el sensor de puerta
    pinMode(ledPin, OUTPUT); // Se inicializa el LED Pin (led para la senal de apertura de la chapa).
    pinMode(2, OUTPUT);
    digitalWrite(2,LOW);

    //Iniciamos los leds indicadores 
    //pinMode(LedV,OUTPUT);
    //pinMode(LedR,OUTPUT);

    //Iniciamos sensor RFID
    SPI.begin();        // Iniciamos el bus SPI.
    mfrc522.PCD_Init(); // Iniciamos el objeto MFRC522.
    delay(4);           // Le damos tiempo para que se inicie. 
    mfrc522.PCD_DumpVersionToSerial(); //Opcional, mostramos detalles de las tarjetas MFRC522.

    //Iniciamos sensor de huellas 
    finger.begin(57600); //Establecemos la velocidad de datos para el puerto serie del sensor 
    delay(5);
  
    //Iniciando el sensor ultrasonico
    pinMode(trigPin, OUTPUT); 
    pinMode(echoPin, INPUT); 

    //Se inicia el sensor Temperatura
    mlx.begin(0x5A);  

    //Valores logicos del led 
    // LOW  - Apagado
    // HIGH - Prendido
    //digitalWrite(LedV,LOW);
    //digitalWrite(LedR,LOW);

    //Mesnaje de bienvenida
    display.clearDisplay();
    display.setTextColor(WHITE);
    display.setTextSize(2);
    display.setCursor(0, 0);
    display.print("Bienvenido");
    display.setCursor(0, 20);
    display.print(" GABANNI ");
    display.display();
    delay(2000);

    // Dibujamos el logo.
    display.clearDisplay();
    display.drawBitmap(32, 0, image, 64, 81, 1);
    display.display();
    delay(2000);

    pinMode(boton,INPUT_PULLUP);
    estado = HIGH;
    anterior = HIGH;

} 

void setup_wifi() {
    delay(10);
    // Empezamos conectándonos a una red WiFi.
    Serial.print("Connecting to ");
    Serial.println(ssid);
    //Mensaje en pantalla.
    display.clearDisplay();
    display.setTextColor(WHITE);
    display.setTextSize(2);
    display.setCursor(0, 0);
    display.print("Conectando...");
    display.setTextSize(2);
    display.display();
  
    WiFi.begin(ssid, password);
  
    while (WiFi.status() != WL_CONNECTED) {
      delay(500);
      Serial.print(".");
    }
  
    Serial.println("");
    Serial.println("WiFi connected");
    Serial.println("IP address: ");
    Serial.println(WiFi.localIP());
    //Mensaje en pantalla.
    display.clearDisplay();
    display.setTextColor(WHITE);
    display.setTextSize(2);
    display.setCursor(0, 0);
    display.print("WiFi");
    display.setCursor(0, 20);
    display.print("Conectado!");
    display.display();
}

// Funcion CallBack.
// Esta funcion es muy importante ya que es la que se encarga en estar en modo escucha para algunos topics de MQTT
void callback(char* topic, byte* message, unsigned int length) {
    Serial.print("Mensaje sobre el tema: "); Serial.print(topic);  // Mostramamos el tema del que estamos recibiendo.
    Serial.print("Message: ");    // Mostramamos el mensaje que estamos recibiendo.
    String messageTemp;

    // En esta funcion estamos leyendo caracter por caracter del mensaje entero recibido.
    for (int i = 0; i < length; i++) {
      Serial.print((char)message[i]);
      messageTemp += (char)message[i];
    }

    StaticJsonDocument <256> doc;  //Creamos un documento JSON, donde almacenaremos el mensaje que recibimos en formato JSON.
    deserializeJson(doc,message);  //Se deserializa el el mensaje recibido.

    //Posibles campos recibidos en el JSON.
    String nombre = doc["nombre"];
    String id =  doc["id"];
    String RFID =  doc["RFID"];
    String codigo =  doc["codigo"];

    // Funcion para mandar senal de apertura de la cerradura (Cuando se presenta RFID,codigo o huella dactilar).
    if (String(topic) == "Gabanni/UAMazc/Apertura/1") {
      if(messageTemp == "true"){        // Se desbloquea la cerradura solo por 5 segundos y posterioemente se vuelve a bloquear.
        digitalWrite(ledPin, HIGH);     // Se desbloquea la cerradura solo por 5 segundos y posterioemente se vuelve a bloquear.
        delay(5000);
        digitalWrite(ledPin, LOW);
      } else if(messageTemp == "false"){  // Se desbloquea la cerradura.
        digitalWrite(ledPin, LOW);
      }
    }

    // Funcion para mandar senal de apertura de la cerradura.
    if (String(topic) == "Gabanni/UAMazc/Bloqueo/1") {
      if(messageTemp == "true"){         // Se desbloquea la cerradura.
        digitalWrite(ledPin, HIGH);
      } else if(messageTemp == "false"){ // Se bloquea la cerradura.
        digitalWrite(ledPin, LOW);
      }
    }
    
  // Funcion para indicar al usuario que el metdo de acceso fue incorrecto.
  if (String(topic) == "Gabanni/UAMazc/SinAcceso/1") {
      display.clearDisplay();
      display.setTextColor(WHITE);
      display.setTextSize(2);
      display.setCursor(0, 0);
      display.print("Acceso");
      display.setCursor(0, 20);
      display.print("denegado");
      display.display();
      delay(2000);
  }

  // Funcion para indicar al usuario que el metdo de acceso fue incorrecto.
  if (String(topic) == "Gabanni/UAMazc/Ocupado/1") {
      display.clearDisplay();
      display.setTextColor(WHITE);
      display.setTextSize(2);
      display.setCursor(0, 0);
      display.print("Lab.");
      display.setCursor(0, 20);
      display.print("Ocupado");
      display.display();
      delay(2000);
  }

  if (String(topic) == "Gabanni/UAMazc/AforoLleno/1") {
      display.clearDisplay();
      display.setTextColor(WHITE);
      display.setTextSize(2);
      display.setCursor(0, 0);
      display.print("Aforo");
      display.setCursor(0, 20);
      display.print("lleno");
      display.display();
      delay(2000);
  }

  if (String(topic) == "Gabanni/UAMazc/TemperaturaAlta/1") {
      display.clearDisplay();
      display.setTextColor(WHITE);
      display.setTextSize(2);
      display.setCursor(0, 0);
      display.print("Temp. ");
      display.setCursor(0, 20);
      display.print("corporal");
      display.setCursor(0, 40);
      display.print("alta");
      display.display();
      delay(2000);
  }

  // Funcion para indicar al usuario que el metdo de acceso fue incorrecto.
  if (String(topic) == "Gabanni/UAMazc/Despedida/1") {
      // Mesnaje de identifacion.
      display.clearDisplay();
      display.setTextColor(WHITE);
      display.setTextSize(2);
      display.setCursor(0, 0);
      display.print("Adios");
      display.setCursor(0, 20);
      display.print(nombre);
      display.display();
      delay(2000);
  }

  if (String(topic) == "Gabanni/UAMazc/DeshabilitadoTemperatura/Alumno/1") {
      // Mesnaje de identifacion.
      display.clearDisplay();
      display.setTextColor(WHITE);
      display.setTextSize(2);
      display.setCursor(0, 0);
      display.print("Hola");
      display.setCursor(0, 20);
      display.print(nombre);
      display.display();
      delay(2000);

      StaticJsonDocument<256> doc;  // Creamos un documento JSON, donde enviaremos la informacion de la temperatura y el usuario.
      doc["matricula"] = id;          
      doc["nombre"] = nombre;
      char out[128];
      int b = serializeJson(doc, out);  //Sereliarizamos el JSON para poderlo mandar por mqtt.       
      client.publish("Gabanni/UAMazc/InfoDeshabilitadoTemperatura/Alumno/1", out); //Publicamos en MQTT.
  }

  if (String(topic) == "Gabanni/UAMazc/DeshabilitadoTemperatura/Profesor/1") {
      // Mesnaje de identifacion.
      display.clearDisplay();
      display.setTextColor(WHITE);
      display.setTextSize(2);
      display.setCursor(0, 0);
      display.print("Hola");
      display.setCursor(0, 20);
      display.print(nombre);
      display.display();
      delay(2000);

      StaticJsonDocument<256> doc;  // Creamos un documento JSON, donde enviaremos la informacion de la temperatura y el usuario.
      doc["noEmpleado"] = id;          
      doc["nombre"] = nombre;
      char out[128];
      int b = serializeJson(doc, out);  //Sereliarizamos el JSON para poderlo mandar por mqtt.       
      client.publish("Gabanni/UAMazc/InfoDeshabilitadoTemperatura/Profesor/1", out); //Publicamos en MQTT.
  }

  // Funcion para la lectura de temperatura coorporal para alumnos.
  if (String(topic) == "Gabanni/UAMazc/LecturaTemperatura/Alumno/1") {
      // Mesnaje de identifacion.
      display.clearDisplay();
      display.setTextColor(WHITE);
      display.setTextSize(2);
      display.setCursor(0, 0);
      display.print("Hola");
      display.setCursor(0, 20);
      display.print(nombre);
      display.display();
      delay(2000);

      bool i = true;
      while(i == true){ // Bucle para la lectura de la temperatura coorporal.
        
        // Borra el trigPin
        digitalWrite(trigPin, LOW);
        delayMicroseconds(2);
        // Establece el trigPin en estado ALTO durante 10 microsegundos
        digitalWrite(trigPin, HIGH);
        delayMicroseconds(10);
        digitalWrite(trigPin, LOW);
        
        // Lee el echoPin, devuelve el tiempo de viaje de la onda de sonido en microsegundos
        duration = pulseIn(echoPin, HIGH);
        
        // Calcular la distancia
        int Dist = duration * SOUND_SPEED/2;
        
        //No hay nadie
        if(Dist>DistMin){
          Presente=0;
          Tiempo = millis();
        }
      
        //Llego alguien, tomemos el tiempo
        if(Dist<=DistMin && Presente==0){
          Presente=1;
          Tiempo = millis();
        }
      
        if(Presente == 1){
          if(millis()-Tiempo>Espera){ //Se completo el tiempo
            Presente = 2;
          }
        }
        
        TempObj=mlx.readObjectTempC(); // Temperatura del usuario.
        TempObj = TempObj + 7.05;      // 9.45 Ajuste a la temperatura.
        switch(Presente){
          case 0: // No hay nadie
            display.clearDisplay();
            display.setTextColor(WHITE);
            display.setTextSize(2);
            display.setCursor(0, 30);
            display.print("Buscando..");
            display.display(); 
          break;
      
          case 1: // Llego alguien
            display.clearDisplay();
            display.setTextColor(WHITE);
            display.setTextSize(2);
            display.setCursor(0, 30);
            display.print("Leyendo...");
            display.display(); 
          break;
      
          case 2: // Se Completo el tiempo se muestra la temperatura al usuario.
            display.clearDisplay();
            display.setTextColor(WHITE);
            display.setTextSize(1);
            display.setCursor(0,0);
            display.print("Temperatura corporal:");
            display.setTextSize(2);
            display.setCursor(0,30);
            display.print(TempObj);
            display.print("  ");
            display.setTextSize(1);
            display.cp437(true);
            display.write(167);
            display.setTextSize(2);
            display.print("C");
            display.display();
            delay(2000);
            i = false;

          
          StaticJsonDocument<256> doc;  // Creamos un documento JSON, donde enviaremos la informacion de la temperatura y el usuario.
          doc["matricula"] = id;          
          doc["nombre"] = nombre;
          doc["temperatura"] = TempObj;
          char out[128];
          int b = serializeJson(doc, out);  //Sereliarizamos el JSON para poderlo mandar por mqtt.       
          client.publish("Gabanni/UAMazc/InfoTemperatura/Alumno/1", out); //Publicamos en MQTT.
          break;
        }
      } 
  }

  // Funcion para la lectura de temperatura coorporal para alumnos.
  if (String(topic) == "Gabanni/UAMazc/LecturaTemperatura/Profesor/1") {
      // Mesnaje de identifacion.
      display.clearDisplay();
      display.setTextColor(WHITE);
      display.setTextSize(2);
      display.setCursor(0, 0);
      display.print("Hola");
      display.setCursor(0, 20);
      display.print(nombre);
      display.display();
      delay(2000);

      bool i = true;
      while(i == true){ // Bucle para la lectura de la temperatura coorporal.
        
        // Borra el trigPin
        digitalWrite(trigPin, LOW);
        delayMicroseconds(2);
        // Establece el trigPin en estado ALTO durante 10 microsegundos
        digitalWrite(trigPin, HIGH);
        delayMicroseconds(10);
        digitalWrite(trigPin, LOW);
        
        // Lee el echoPin, devuelve el tiempo de viaje de la onda de sonido en microsegundos
        duration = pulseIn(echoPin, HIGH);
        
        // Calcular la distancia
        int Dist = duration * SOUND_SPEED/2;
        
        //No hay nadie
        if(Dist>DistMin){
          Presente=0;
          Tiempo = millis();
        }
      
        //Llego alguien, tomemos el tiempo
        if(Dist<=DistMin && Presente==0){
          Presente=1;
          Tiempo = millis();
        }
      
        if(Presente == 1){
          if(millis()-Tiempo>Espera){ //Se completo el tiempo
            Presente = 2;
          }
        }
        
        TempObj=mlx.readObjectTempC(); // Temperatura del usuario.
        TempObj = TempObj + 7.05;      // 9.45 Ajuste a la temperatura.
        switch(Presente){
          case 0: // No hay nadie
            display.clearDisplay();
            display.setTextColor(WHITE);
            display.setTextSize(2);
            display.setCursor(0, 30);
            display.print("Buscando..");
            display.display(); 
          break;
      
          case 1: // Llego alguien
            display.clearDisplay();
            display.setTextColor(WHITE);
            display.setTextSize(2);
            display.setCursor(0, 30);
            display.print("Leyendo...");
            display.display(); 
          break;
      
          case 2: // Se Completo el tiempo se muestra la temperatura al usuario.
            display.clearDisplay();
            display.setTextColor(WHITE);
            display.setTextSize(1);
            display.setCursor(0,0);
            display.print("Temperatura corporal:");
            display.setTextSize(2);
            display.setCursor(0,30);
            display.print(TempObj);
            display.print(" ");
            display.setTextSize(1);
            display.cp437(true);
            display.write(167);
            display.setTextSize(2);
            display.print("C");
            display.display();
            delay(2000);
            i = false;
            
          StaticJsonDocument<256> doc;  // Creamos un documento JSON, donde enviaremos la informacion de la temperatura y el usuario.
          doc["noEmpleado"] = id;          
          doc["nombre"] = nombre;
          doc["temperatura"] = TempObj;
          char out[128];
          int b = serializeJson(doc, out);  //Sereliarizamos el JSON para poderlo mandar por mqtt.       
          client.publish("Gabanni/UAMazc/InfoTemperatura/Profesor/1", out); //Publicamos en MQTT. 
          break;
        }
      } 
  }
}

//Funcion para reconnectar a la red.
void reconnect() {
  // Bucle hasta que estemos reconectados.
  while (!client.connected()) {
    Serial.print("Intentando conexión MQTT...");
    // Intento de conexión
    if (client.connect("ESP32Client1")) {
      Serial.println("Connected");
      // Subscribe a topics MQTT.
      client.subscribe("Gabanni/UAMazc/Ocupado/1");
      client.subscribe("Gabanni/UAMazc/Bloqueo/1");
      client.subscribe("Gabanni/UAMazc/Apertura/1");
      client.subscribe("Gabanni/UAMazc/LecturaTemperatura/Alumno/1");
      client.subscribe("Gabanni/UAMazc/LecturaTemperatura/Profesor/1");
      client.subscribe("Gabanni/UAMazc/SinAcceso/1");
      client.subscribe("Gabanni/UAMazc/Despedida/1");
      client.subscribe("Gabanni/UAMazc/AforoLleno/1");
      client.subscribe("Gabanni/UAMazc/TemperaturaAlta/1");
      client.subscribe("Gabanni/UAMazc/DeshabilitadoTemperatura/Alumno/1");
      client.subscribe("Gabanni/UAMazc/DeshabilitadoTemperatura/Profesor/1");
     
      //Ubicacion de la cerradura
      StaticJsonDocument<256> doc;    // Creamos un documento JSON, donde enviaremos la infromacion de la tarjeta RFID para comprobar si esta registrada.
      doc["ubicacion"] = Lab_Aula;         // Laboratorio o aula equipada donde se encuentra la cerradura 
      char out[128];
      int b = serializeJson(doc, out);  //Sereliarizamos el JSON para poderlo mandar por mqtt.
      client.publish("Gabanni/UAMazc/Ubicacion/1", out); //Publicamos en MQTT.
    } else {
      Serial.print("failed, rc=");
      Serial.print(client.state());
      Serial.println(" try again in 5 seconds");
      // Espere 5 segundos antes de volver a intentar.
      display.clearDisplay();
      display.setTextColor(WHITE);
      display.setTextSize(2);
      display.setCursor(0, 0);
      display.print("Error del"); 
      display.setCursor(0, 20);
      display.print("servidor");  
      display.setTextSize(1);   
      display.setCursor(0, 40);
      display.print("  Reconectando ...  ");    
      display.display();
      delay(5000);
    }
  }
}

void loop() {
    if (!client.connected()) { // Reconectado en caso de perdida de senal Wifi.
      reconnect();
    }
    
    client.loop();
    // Si el estado es igual a lo leido, la entrada no ha cambiado lo que
    // significa que no hemos apretado el botón (ni lo hemos soltado); asi que
    // tenemos que parar el temporizador.
    if ( estado==digitalRead(boton) ) {
      temporizador = 0;
    }
    // Si el valor distinto significa que hemos pulsado/soltado el botón. Ahora
    // tendremos que comprobar el estado del temporizador, si vale 0, significa que
    // no hemos guardado el tiempo en el que sa ha producido el cambio, así que 
    // hemos de guardarlo.
    else 
    if ( temporizador == 0 ) {
      // El temporizador no está iniciado, así que hay que guardar
      // el valor de millis en él.
      temporizador = millis();
    }
    else 
    // El temporizador está iniciado, hemos de comprobar si el
    // el tiempo que deseamos de rebote ha pasado.
    if ( millis()-temporizador > tiemporebote ) {
      // Si el tiempo ha pasado significa que el estado es lo contrario
      // de lo que había, asi pues, lo cambiamos.
      estado = !estado;
    }
  
    // Ya hemos leido el botón, podemos trabajar con él.
    if ( anterior==HIGH && estado==LOW ){
        digitalWrite(ledPin, HIGH);     
        delay(5000);
        digitalWrite(ledPin, LOW);
    } 
   
    // Recuerda que hay que guardar el estado anterior.
    anterior = estado;

    display.clearDisplay();
    display.setTextColor(WHITE);
    display.setTextSize(2);
    display.setCursor(0,20);
    display.print("Esperando");
    display.setCursor(0,40);
    display.print("   ....   ");
    display.display();

    //Si el usuario oprime el teclado, le hablamos a la funcion Fun_teclado()
    char key = teclado.getKey();
    if (key){
      display.clearDisplay();
      display.setTextColor(WHITE);
      display.setTextSize(2);
      display.setCursor(0, 20);
      display.print("Escribe tu");    
      display.setCursor(0, 40);
      display.print("clave");   
      display.display();
      Fun_teclado(key);
      delay(2000);
    } 

    // Si el usuario presenta su dedo en el sensor de huellas datilares, le hablamos a la funcion getFingerprintID()
    getFingerprintID();
    
    // Si el usuario presenta una tarjeta en el sensor RFID, le hablamos a la funcion Fun_RFID()
    if(mfrc522.PICC_IsNewCardPresent()) {
       Fun_RFID();
    } 

    EstadoN = digitalRead(pinDoor);
    if(EstadoV != EstadoN){
      EstadoPuerta() ;
    }
}
