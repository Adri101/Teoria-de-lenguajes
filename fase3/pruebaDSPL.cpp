//===============================================================
Name : Adrián Fernández Ramos
Version :
Copyright : Your copyroght notice
Description: Fichero para la fase dos del proyecto DSPL
//===============================================================
#include <iostream>
#include "entorno_dspl.h"

using namespace std;
void inicio(){
entornoPonerSensor(25,25,S_temperature,0,"T1");
entornoPonerSensor(250,250,S_smoke,0,"SH");
entornoPonerAct_Switch(480,420,false,"CA");
entornoBorrarMensaje();
}
int main(){
if (entornoIniciar()){
entornoPonerEscenario("Winter");
inicio();
entornoPulsarTecla();
entornoPonerSensor(25,25,S_temperature,18.2,"T1");
entornoPonerAct_Switch(480,420,true,"CA");
entornoMostrarMensaje("Calefacción encendida");
entornoPausa(3);
entornoBorrarMensaje();
entornoPonerSensor(25,25,S_temperature,28.2,"T1");
entornoPonerAct_Switch(480,420,false,"CA");
entornoMostrarMensaje("Calefacción apagada");
entornoPulsarTecla();
entornoBorrarMensaje();
entornoPonerEscenario("Fire");
inicio();
entornoPausa(1);
entornoPonerSensor(250,250,S_smoke,100,"SH");
entornoMostrarMensaje("Alarma. Alta probabilidad de incendio");
for(int i=0;i<2;i++){
entornoAlarma();
entornoPausa(1);
}
entornoBorrarMensaje();
entornoTerminar();
}
return 0;
}
