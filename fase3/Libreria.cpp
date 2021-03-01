/*
 * Libreria.cpp
 *
 *  Created on: 23/04/2019
 *      Author: adri
 */

#include "Libreria.h"

Libreria::Libreria() {
	this->tipo_tabla = new IList<dato>();

}
/**
 * Método que utilizamos para poder insertar correctamente los datos
 * Si después de buscarlo no hemos encontrado el objeto lo añadimos sino cambiamos
 * su valor y comprobar que no se modifica su tipo
 */
void Libreria::insertar(dato identificador) {
	dato aux;
	strcpy(aux.nombre, identificador.nombre);
	if (this->tipo_tabla->empty()) {
		this->tipo_tabla->insert(identificador);
		this->tipo_tabla->next();
	} else {
		if (!this->existe(identificador.nombre)) {
			this->tipo_tabla->insert(identificador);
			this->tipo_tabla->next();
		} else {
			this->buscarYEliminar(identificador.nombre);
			this->tipo_tabla->insert(identificador);
		}
	}
}

/*
 * Método que me detecta si un elemento está o no en la tabla de símbolos
 */
bool Libreria::existe(tipo_cadena nombre) {
	bool enc = false;
	dato aux;
	this->tipo_tabla->moveToBegin();
	while (!this->tipo_tabla->end() && !enc) {
		this->tipo_tabla->consult(aux);
		if (strcmp(aux.nombre, nombre) == 0) {
			enc = true;
		}
		this->tipo_tabla->next();
	}
	return enc;
}
/**
 * Método que devuelve true si ha encontrado el nombre y los datos del ítem por identificador
 */
bool Libreria::buscar(tipo_cadena nombre, dato &identificador) {
	bool enc = false;
	dato aux;
	if (!this->tipo_tabla->empty()) {
		this->tipo_tabla->moveToBegin();
		while (!this->tipo_tabla->end() && !enc) {
			this->tipo_tabla->consult(aux);
			if (strcmp(aux.nombre, nombre) == 0) {
				identificador = aux;
				enc = true;
			}
			this->tipo_tabla->next();
		}
	}
	return enc;
}
/**
Método que busca un elemento y lo elimina de la lista para luego poder insertarlo otra vez
*/
void Libreria::buscarYEliminar(tipo_cadena nombre) {
	dato aux;
	bool enc = false;
	this->tipo_tabla->moveToBegin();
	while (!this->tipo_tabla->end() && !enc) {
		this->tipo_tabla->consult(aux);
		if (!strcmp(nombre, aux.nombre)) {
			enc = true;
			this->tipo_tabla->remove();
		}
		this->tipo_tabla->next();

	}
}
Libreria::~Libreria() {

}
