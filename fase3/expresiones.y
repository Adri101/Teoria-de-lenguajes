	/*Este es el fichero de tipo Bison*/
%{

#include <iostream>
#include <cmath>
#include <stdio.h>
#include <string.h>
#include <fstream>
#include "Libreria.h"

using namespace std;

//elementos externos al analizador sintácticos por haber sido declarados en el analizador léxico
extern int n_lineas; /*Se utiliza en las definiciones y le indicamos que es externo por que lo hemos definido en otra liberúa externa*/
extern int yylex();
extern FILE *yyin;
extern FILE *yyout;
ofstream fout;

int error = 0; //Variable que me detectará los tipos de error en las operaciones
/*0-No hay errores */
int real;
/*Variable que utilizamos para el correcto funcionamiento de las condiciones dentro del programa*/
bool condicionIF=true;
/*Boleano que me detectará si la ejecución ha sido correcta*/
bool malaEjecucion= false;
Libreria *l = new Libreria();
//definición de procedimientos auxiliares
void yyerror(const char* s){         /*    llamada por cada error sintactico de yacc */
	cout << "Error sintáctico en la línea "<< n_lineas<<endl;
}
/*Método para que me diga si un valor es entero o no*/


%}

%start programa

%union{
	int c_entero;
	float c_real;
	char c_cadena[50];
	bool booleano;
}

%token <c_entero> ENTERO
%token <c_cadena> VERDAD FALSO ID INT FLOAT POSITION STRING TEMPERATURE SMOKE LIGHT
%token <c_cadena> ALARM SWITCH MESSAGE ON OFF PAUSE START SCENE	IF THEN ELSE REPEAT
%token <c_cadena>  CADENA
%token <c_real> REAL
%token SEPARADOR
%type <c_real> expr
%type <booleano> exprl
%type <booleano> cmp


%left '+' '-'   /* asociativo por la izquierda, misma prioridad */
%left '*' '/' '%'   /* asociativo por la izquierda, prioridad alta */
%left '(' ')'	/* asociativo por la izquierda, prioridad más alta*/
%left menos
%right '^'
%left '|'
%left '&'
%right '!'
%%

programa: zona1 {fout<<"}"<<endl;}SEPARADOR {fout<<"int main(){"<<endl;
													fout<<"if (entornoIniciar()){"<<endl;} zona2
				;
zona1:  zona1 definicion
				|definicion
				;
definicion : variables
						| asignaciones
						| sensores
						| actuadores
						| error {yyerrok;}
						;
variables : INT  ListaVariables
						| FLOAT ListaVariables
						| POSITION ListaVariables
						| STRING 	ListaVariables
						;
 ListaVariables: 	ID ';'
					| ID ',' ListaVariables
					;					;
asignaciones : ID '=' expr ';'							{dato aux;
																						if(real==1){
																							aux.tipo=1;
																							aux.valor.real=$3;
																							strcpy(aux.nombre,$1);
																							l->insertar(aux);
																						}else{
																							aux.tipo=0;
																							aux.valor.entero=$3;
																							strcpy(aux.nombre,$1);
																							l->insertar(aux);
																							real=0;
																						}}

					| ID '=' '<' expr ',' expr '>' ';'{
																							if(real!=1){
																							dato aux;
																							aux.tipo=3;
																							aux.valor.pos[0]=$4;
																							aux.valor.pos[1]=$6;
																							if(aux.valor.pos[0] <= 600 && aux.valor.pos[1] <=600 ){
																							strcpy(aux.nombre,$1);
																							l->insertar(aux);
																						}else{cout<<"ERROR linea :"<<n_lineas <<"- No se puede utilizar valores fuera de la zona permitida 600 * 600"<<endl;malaEjecucion=true;}
																						} else {cout<<"ERROR linea "<<n_lineas<< " - No puede usar valores reales para definir una posicion"<<endl;malaEjecucion=true;}}

					| ID '='  CADENA  ';'							{dato aux;
																						aux.tipo=2;
																						strcpy(aux.valor.cadena,$3);
																						strcpy(aux.nombre,$1);


																						l->insertar(aux);}
					;
sensores: SMOKE  ID '<' expr ',' expr '>' CADENA ';'{if(real!=1){dato aux;
																											aux.tipo=12;
																											strcpy(aux.nombre,$2);
																											aux.coordenada[0]=$4;
																											aux.coordenada[1]=$6;
																											strcpy(aux.alias,$8);
																											if(strlen($8)>4){
																												cout <<"Warning en la linea " <<n_lineas<<" el alias"<<$8<<" es demasiado largo" << endl;
																											}
																											if(aux.coordenada[0] <= 600 && aux.coordenada[1] <=600 ){
																											l->insertar(aux);
																												fout<<"entornoPonerSensor("<<aux.coordenada[0]<<","<<aux.coordenada[1]<<","<<"S_smoke,"<<0<<","<<aux.alias<<");"<<endl;
																											}else{cout<<"ERROR linea :"<<n_lineas <<"- No se puede utilizar valores fuera de la zona permitida 600 * 600"<<endl;malaEjecucion=true;}
																												}else{cout<<"ERROR linea "<<n_lineas<< "- No puede usar valores reales para definir una posicion"<<endl;malaEjecucion=true;}}
				| LIGHT ID '<' expr ',' expr '>' CADENA ';' {if(real!=1){dato aux;
																										aux.tipo=11;
																										strcpy(aux.nombre,$2);
																									strcpy(aux.alias,$8);
																									if(strlen($8)>4){
																										cout <<"Warning en la linea " <<n_lineas<<" el alias"<<$8<<" es demasiado largo" << endl;
																									}
																									aux.coordenada[0]=$4;
																									aux.coordenada[1]=$6;
																									if(aux.coordenada[0] <= 600 && aux.coordenada[1] <=600 ){
																									l->insertar(aux);
																									fout<<"entornoPonerSensor("<<aux.coordenada[0]<<","<<aux.coordenada[1]<<","<<"S_light,"<<0<<","<<aux.alias<<");"<<endl;
																								}else{cout<<"ERROR linea :"<<n_lineas <<"- No se puede utilizar valores fuera de la zona permitida 600 * 600"<<endl;malaEjecucion=true;}
																									}else{cout<<"ERROR linea :"<<n_lineas <<"- No puede usar valores reales para definir una posicion"<<endl;malaEjecucion=true;}}
				| TEMPERATURE ID ID CADENA ';' {if(real!=1){dato aux,aux1;
																				aux.tipo=10;
																				strcpy(aux.nombre,$2);
																				strcpy(aux.alias,$4);
																				if(strlen($4)>4){
																					cout <<"Warning en la linea " <<n_lineas<<" el alias"<<$4<<" es demasiado largo" << endl;
																				}
																				l->buscar($3,aux1	);
																				if(aux1.tipo==3){
																				aux.coordenada[0]=aux1.valor.pos[0];
																				aux.coordenada[1]=aux1.valor.pos[1];
																				if(aux.coordenada[0] <=600 && aux.coordenada[1] <= 600){
																				l->insertar(aux);
																				fout<<"entornoPonerSensor("<<aux.coordenada[0]<<","<<aux.coordenada[1]<<","<<"S_temperature,"<<0<<","<<aux.alias<<");"<<endl;
																			}else{cout<<"ERROR linea :"<<n_lineas <<"- No se puede puede cambiar el tipo a una variable ya definida"<<endl;malaEjecucion=true;}
																			} else{cout<<"ERROR linea :"<<n_lineas <<"- No se puede utilizar valores fuera de la zona permitida 600 * 600"<<endl;malaEjecucion=true;}
																				}else{cout<<"ERROR linea :"<<n_lineas <<"- No puede usar valores reales para definir una posicion"<<endl;malaEjecucion=true;}}
				;

actuadores: ALARM  ID '<' expr ',' expr '>' CADENA ';'{if(real!=1){dato aux;
																											aux.tipo=20;
																											strcpy(aux.nombre,$2);
																											aux.coordenada[0]=$4;
																											aux.coordenada[1]=$6;
																											if(aux.coordenada[0] <= 600 && aux.coordenada[1] <=600 ){
																											strcpy(aux.alias,$8);
																											if(strlen($8)>4){
																												cout <<"Warning en la linea " <<n_lineas<<" el alias"<<$8<<" es demasiado largo" << endl;
																											}
																											l->insertar(aux);
																										}else{cout<<"ERROR linea :"<<n_lineas <<"- No se puede utilizar valores fuera de la zona permitida 600 * 600"<<endl;malaEjecucion=true;}
																											}else{cout<<"ERROR linea :"<<n_lineas <<"- No puede usar valores reales para definir una posicion"<<endl;malaEjecucion=true;}}
					| ALARM ID ';'{dato aux;
												aux.tipo=20;
												strcpy(aux.nombre,$2);
													l->insertar(aux);
															}
					| SWITCH  ID '<' expr ',' expr '>' CADENA ';'{if(real!=1){dato aux;
																																aux.tipo=21;
																																strcpy(aux.nombre,$2);
																																aux.coordenada[0]=$4;
																																aux.coordenada[1]=$6;
																																if(aux.coordenada[0] <= 600 && aux.coordenada[1] <=600 ){
																																strcpy(aux.alias,$8);
																																if(strlen($8)>4){
																																	cout <<"Warning en la linea " <<n_lineas<<" el alias"<<$8<<" es demasiado largo" << endl;
																																}
																																l->insertar(aux);
																																fout<<"entornoPonerAct_Switch("<<aux.coordenada[0]<<","<<aux.coordenada[1]<<",false,"<<aux.alias<<");"<<endl;
																															}else{cout<<"ERROR linea :"<<n_lineas <<"- No se puede utilizar valores fuera de la zona permitida 600 * 600"<<endl;malaEjecucion=true;}
																															}else{cout<<"ERROR linea :"<<n_lineas <<"- No puede usar valores reales para definir una posicion"<<endl;malaEjecucion=true;}}
					| SWITCH  ID ';'{dato aux;
												aux.tipo=21;
												strcpy(aux.nombre,$2);
													l->insertar(aux);}
					| MESSAGE ID '<' expr ',' expr '>' CADENA ';'{if(real!=1){dato aux;
																																aux.tipo=22;
																																strcpy(aux.nombre,$2);
																																aux.coordenada[0]=$4;
																																aux.coordenada[1]=$6;
																																if(aux.coordenada[0] <= 600 && aux.coordenada[1] <=600 ){
																																strcpy(aux.alias,$8);
																																if(strlen($8)>4){
																																	cout <<"Warning en la linea " <<n_lineas<<" el alias"<<$8<<" es demasiado largo" << endl;
																																}
																																l->insertar(aux);
																															}else{cout<<"ERROR linea :"<<n_lineas <<"- No se puede utilizar valores fuera de la zona permitida 600 * 600"<<endl;malaEjecucion=true;}
																																}else{cout<<"ERROR linea :"<<n_lineas <<"- No puede usar valores reales para definir una posicion"<<endl;malaEjecucion=true;}}
					| MESSAGE ID ';'{dato aux;
												aux.tipo=22;
												strcpy(aux.nombre,$2);
													l->insertar(aux);
													fout<<"entornoBorrarMensaje();"<<endl;}
													;

zona2: escenarios
			| zona2 escenarios
			| error {yyerrok;}
			;
escenarios: SCENE ID {fout<<"entornoPonerEscenario("<<'"'<<$2<<'"'<<");"<<endl;}'['  bloqueInstrucciones  ']' ';'{
																											dato aux;
																											aux.tipo=30;
																											strcpy(aux.nombre,$2);

																											l->insertar(aux);
																										}
					;
bloqueInstrucciones: bloqueInstrucciones listaEscenarios
						|listaEscenarios
						;
listaEscenarios:  ID expr ';' {	if(condicionIF){
																	if(real==1){dato aux;
																	l->buscar($1,aux);
																	if(l->existe(aux.nombre)){
																	aux.valor.real=$2;
																	l->insertar(aux);
																	if(aux.tipo==10){
																		fout<<"entornoPonerSensor("<<aux.coordenada[0]<<","<<aux.coordenada[1]<<",S_temperature,"<<aux.valor.real<<","<<aux.alias<<");"<<endl;
																	} else if(aux.tipo==11){
																			fout<<"entornoPonerSensor("<<aux.coordenada[0]<<","<<aux.coordenada[1]<<","<<"S_light,"<<aux.valor.real<<","<<aux.alias<<");"<<endl;
																	}
																		else if(aux.tipo==12){
																			fout<<"entornoPonerSensor("<<aux.coordenada[0]<<","<<aux.coordenada[1]<<","<<"S_smoke,"<<aux.valor.real<<","<<aux.alias<<");"<<endl;}
																			else if(aux.tipo==20 || aux.tipo ==21 || aux.tipo==22){
																				cout << "ERROR linea " << n_lineas << "a un actuador no se le puede asignar un valor "<< endl;malaEjecucion=true;}
																			}else{cout<<"ERROR linea : "<<n_lineas<< "  La variable, sensor o actuador a utilizar no ha sido previamente definida"<<endl;malaEjecucion=true;}
																		}
																		else if(real==0){
																		dato aux;
																		l->buscar($1,aux);
																		if(l->existe(aux.nombre)){
																		aux.valor.entero=$2;
																		l->insertar(aux);
																		if(aux.tipo==10){
																			fout<<"entornoPonerSensor("<<aux.coordenada[0]<<","<<aux.coordenada[1]<<",S_temperature,"<<aux.valor.entero<<","<<aux.alias<<");"<<endl;
																		} else if(aux.tipo==11){
																				fout<<"entornoPonerSensor("<<aux.coordenada[0]<<","<<aux.coordenada[1]<<","<<"S_light,"<<aux.valor.entero<<","<<aux.alias<<");"<<endl;
																		}else if(aux.tipo==12){
																				fout<<"entornoPonerSensor("<<aux.coordenada[0]<<","<<aux.coordenada[1]<<","<<"S_smoke,"<<aux.valor.entero<<","<<aux.alias<<");"<<endl;}
																				else if(aux.tipo==20 || aux.tipo ==21 || aux.tipo==22){
																					cout << "ERROR linea " << n_lineas << "a un actuador no se le puede asignar un valor "<< endl;malaEjecucion=true;}
																		}else{cout<<"ERROR linea "<<n_lineas<< "  La variable, sensor o actuador "<<$1 <<"no ha sido previamente definida"<<endl;malaEjecucion=true;}
																		}else{cout<<"ERROR linea : "<<n_lineas<< "  No se puede cambiar el tipo de la variable"<<endl;malaEjecucion=true;}}}
						| START ';'{if(condicionIF){fout<<"inicio();"<<endl;}}
						| PAUSE ';'{if(condicionIF){fout <<"entornoPulsarTecla();"<<endl;}}
						| START expr ';'{if(condicionIF && real !=1){dato aux;
													aux.tipo=41;
													strcpy(aux.nombre,$1);

													aux.valor.entero=$2;
													l->insertar(aux);
													fout<<"entornoPausa("<<$2<<");"<<endl;}else{cout<<"ERROR linea :"<<n_lineas <<"- No puede usar valores reales en una instrucción pause"<<endl;malaEjecucion=true;}}
						| PAUSE expr ';'{if(condicionIF){
							 							if(real!=1){dato aux;
													aux.tipo=40;
													strcpy(aux.nombre,$1);

													aux.valor.entero=$2;
													l->insertar(aux);
													fout<<"entornoPausa("<<$2<<");"<<endl;}else{cout<<"ERROR linea :"<<n_lineas <<"- No puede usar valores reales en una instrucción pause"<<endl;malaEjecucion=true;}}}
						| IF exprl  THEN {if($2) {condicionIF=true;}else{ condicionIF=false;}} '[' bloqueInstrucciones']' ';'
						| ELSE {condicionIF=!condicionIF;} '[' bloqueInstrucciones ']'';'{condicionIF=true;}
						| ID OFF ';'{if(condicionIF){dato aux;

													l->buscar($1,aux);
													if(l->existe(aux.nombre)){
													if(aux.tipo==21){
													aux.valor.logico=false;

													l->insertar(aux);
													fout <<"entornoPonerAct_Switch("<<aux.coordenada[0]<<","<<aux.coordenada[1] <<","<<"false"<<","<<aux.alias<<");" <<endl;
													} else if(aux.tipo==22){
														fout<<"entornoBorrarMensaje();"<< endl;
													}else if(aux.tipo<20 || aux.tipo>22){cout<<"ERROR linea : "<<n_lineas<< $1<<"no es un actuador"  <<endl;}
													}else{cout<<"ERROR linea : "<<n_lineas<< " la variable, sensor o actuador no ha sido previamente definida"<<endl;malaEjecucion=true;}
												}}
						| ID ON ';'{if(condicionIF){dato aux;
													l->buscar($1,aux);
													if(l->existe(aux.nombre)){
													if(aux.tipo==21){
													aux.valor.logico=true;

													l->insertar(aux);
													fout <<"entornoPonerAct_Switch("<<aux.coordenada[0]<<","<<aux.coordenada[1] <<","<<"true"<<","<<aux.alias<<");" <<endl;
													}else if(aux.tipo==20){
														fout<<"entornoAlarma();"<<endl;
														}else if(aux.tipo<20 || aux.tipo>22){cout<<"ERROR linea : "<<n_lineas<< $1<<"no es un actuador"<<endl;malaEjecucion=true;}
													}else{cout<<"ERROR linea "<<n_lineas<< " la variable, sensor o actuador "<< $1<< "no ha sido previamente definida"<<endl;malaEjecucion=true;}}}
						| ID ON CADENA ';'{if(condicionIF){fout << "entornoMostrarMensaje("<<$3<<");"<<endl;}}
						| ID OFF CADENA ';'{if(condicionIF){fout << "entornoBorrarMensaje();"<<endl;	}}
						| ID ON ID ';'   {if(condicionIF){ dato aux1, aux2;
															l->buscar($3,aux1);
															l->buscar($1,aux2);
															if(aux2.tipo==22){
																fout<<"entornoMostrarMensaje("<<aux1.valor.cadena<<");"<<endl;
															}
															}
														}
						| ID OFF ID ';'
						| REPEAT expr {if(condicionIF && real!=1){fout<<"for(int i=0;i<"<<$2<<";i++){"<<endl;}else{cout<<"ERROR linea :"<<n_lineas <<"- No puede usar valores reales en una instrucción pause"<<endl;malaEjecucion=true;}}'['  bloqueInstrucciones ']'';' {fout<<"}"<<endl;}
						;

expr: ENTERO 								{$$=$1;real=0;}
			|REAL									{$$=$1;real=1;}
			|ID										{dato aux;
															if(l->buscar($1,aux)){
															if(aux.tipo == 0 ) {$$=aux.valor.entero;real=0;}
															else if(aux.tipo ==1|| aux.tipo == 10 || aux.tipo == 11 ||aux.tipo == 12)
															{$$=aux.valor.real;real=1;}
															if(aux.tipo==2 || aux.tipo ==3){
																cout<<"ERROR en la linea " << n_lineas << "No se pueden realizar operaciones artimeticas con variables de tipo position o string. Variable : " <<aux.nombre << endl;malaEjecucion=true;
															}
															if(aux.tipo==20 || aux.tipo==21 || aux.tipo==22){
																cout << "ERROR en la linea " << n_lineas <<"El actuador"<<aux.nombre  <<"no puede formar parte de una expresión aritmeticologica por que no tiene valor" << endl;malaEjecucion=true;
															}
															}}
			| expr '*' expr 			{$$=$1*$3;}
			| expr '-' expr    		{$$=$1-$3;}
			| expr '+' expr    		{$$=$1+$3;}
			| expr '/' expr       {if(real==0) {$$=(int)$1/(int)$3;}else {$$=$1/$3;}}
			| expr '%' expr 			{if(real==0) {$$=(int)$1%(int)$3;}}
			|'-' expr %prec menos    	{$$=-$2;}
			| expr '^' expr 			{$$=pow ($1,$3);}
      ;
exprl:
				cmp			{$$=$1;}
				| '(' exprl ')'		{$$=$2;}
				| '!' exprl		{$$=!$2;}
				| exprl '&''&' exprl	{$$=$1&&$4;}
				| exprl '|''|' exprl	{$$=$1||$4;}
				| VERDAD		{$$=true;}
				| FALSO			{$$=false;}
			       ;
cmp:  	 expr '=''=' expr	{$$=$1==$4;}
				| expr '!''=' expr	{$$=$1!=$4;}
				| expr '>' expr		{$$=$1>$3;}
				| expr '<' expr		{$$=$1<$3; }
				| expr '<''=' expr	{$$=$1<=$4;}
				| expr '>''=' expr	{$$=$1>=$4;}
				;
%%

int main(int argc, char *argv[] ){

	if(argc < 2)
		cout << "Error en los argumentos" << endl;
	else{
		yyin=fopen(argv[1],"rt");
		fout.open(argv[2]);
		fout << "//===============================================================" << endl;
		fout << "Name : Adrián Fernández Ramos"  << endl;
		fout << "Version :"<<endl;
		fout << "Copyright : Your copyroght notice"<<endl;
		fout << "Description: Fichero para la fase dos del proyecto DSPL" << endl;
		fout << "//===============================================================" << endl;
		fout << "#include <iostream>"<< endl;
		fout << "#include \"entorno_dspl.h\"\n"<<endl;
		fout << "using namespace std;" << endl;
		fout << "void inicio(){"<<endl;

		n_lineas = 0;n_lineas++;
		yyparse();
		fclose(yyin);
		fout<<"entornoTerminar();"<<endl;
		fout<<"}"<<endl;
		fout<<"return 0;"<<endl;
		fout<<"}"<<endl;
		fout.close();
		if(malaEjecucion){
			remove(argv[2]);
		}

		 return 0;
		}


}
