/*Fichero tipo Flex*/
%{
#include "expresiones.h"
#include <math.h>
int n_lineas;
%}


%option noyywrap

%%
[#].*                                                            {}
[%][%]                                                            return SEPARADOR;
["][^"]*["]                            strcpy(yylval.c_cadena,yytext);  return CADENA;
[;]                                                             return (yytext[0]);
[i][n][t]                                                        return INT;
[f][l][o][a][t]                                                  return FLOAT;
position                                                         return POSITION;
string                                                           return STRING;
temperature                                                      return TEMPERATURE;
smoke                                                            return SMOKE;
light                                                            return LIGHT;
alarm                                                            return ALARM;
switch                                                           return SWITCH;
message                                                          return MESSAGE;
ON                                                               return ON;
OFF                                                              return OFF;
pause                                                            return PAUSE;
start                                                            return START;
scene                                                            return SCENE;
if                                                               return IF;
then                                                             return THEN;
else                                                             return ELSE;
repeat                                                           return REPEAT;
[Tt][Rr][Uu][Ee]			                                           return VERDAD;
[Ff][Aa][Ll][Ss][Ee]			                                       return FALSO;
[0-9]+					                 yylval.c_entero = atoi(yytext); return ENTERO;
[0-9]*[.][0-9]+([e][+-][0-9]*)?		  yylval.c_real= atof(yytext); return REAL;
[a-zA-Z_][a-zA-Z0-9_]*      		 strcpy(yylval.c_cadena,yytext); return ID;
\n					                                                     n_lineas++;
[\t ]					                                                   ;
. 					                                                     return (yytext[0]);
%%
