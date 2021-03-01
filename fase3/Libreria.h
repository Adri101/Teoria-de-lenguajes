/*
 * Libreria.h
 *
 *  Created on: 23/04/2019
 *      Author: adri
 */

#ifndef LIBRERIA_H_
#define LIBRERIA_H_
#include "Ilist.h"
#include <string.h>

typedef char tipo_cadena[50];
union tipos{
	int entero;
	float real;
	tipo_cadena cadena;
	bool logico;
	int pos[2];

};

struct dato{
 tipo_cadena nombre;
 int tipo;
 /*
    * Entero 				- 0
    * Real   				- 1
  	* string  				- 2
	* position      		- 3
	* Cadena de Caracteres	- 4
	* Sensor temperature 	- 10
	* Sensor light 			- 11
	* Sensor smoke 			- 12
	* Actuador alarm      	- 20
	* Actuador switch     	- 21
	* Actuador message 		- 22
	* Escenario 			- 30
	* Pausa 40
	* start 41
  */
tipos valor;
int coordenada[2]; //Primera coordenada X, segunda coordenada Y
tipo_cadena alias;
};
class Libreria {
private:
	IList<dato> *tipo_tabla;
public:
	Libreria();
	void insertar(dato identificador);
	bool buscar(tipo_cadena nombre, dato &identificador);
	void buscarYEliminar(tipo_cadena nombre);
	bool existe(tipo_cadena nombre);
	~Libreria();
};

#endif /* LIBRERIA_H_ */
