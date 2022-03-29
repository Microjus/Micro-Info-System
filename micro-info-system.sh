#!/usr/bin/env bash

#------------------------------CABEÇALHO---------------------------------------|
#
# AUTOR:             | Microjus <microjus.oficial@gmail.com>
# URL:               | https://github.com/Microjus/Micro-Info-System
# DATA:              | 2022-03-06
# PROGRAMA:          | Micro-Info-System
# VERSÃO:            | final
# LICENÇA:           | GPL3
# DESCRIÇÃO:         | Este script pode fornecer 
#		       diversas informaçoes do sistema
#		       com comandos nativos do shell


#-----------------------------BIBLIOTECA---------------------------------------|

source /etc/os-release

#-------------------------------TESTES-----------------------------------------|

# Verifica se o usiario é administrador do sistema.

[[ $UID -ne 0 ]] && { clear ; printf "E: Execute como adminstrador." ; exit 100 ; } || :

#------------------------------------------------------------------------------|

trap ctrl_c INT

ctrl_c() {

        clear ; printf "[+] (Ctrl + C ) Detectado, Tentativa de saida ...\n" ; sleep 2s
        printf "\n[+] Encerrando serviços , Aguarde  ...\n"
        # Funçao de encerramento
        printf '\n[+] Obrigado por usar este programa  =).'
        exit 1 
}

# Inicio do programa 
# Banner
function _banner() { clear ; tput setaf 2
Lin[0]="┌┬┐┬┌─┐┬─┐┌─┐   ┌─┐┬ ┬┌─┐┌┬┐┌─┐┌┬┐"
Lin[1]="│││││  ├┬┘│ │───└─┐└┬┘└─┐ │ ├┤ │││"
Lin[2]="┴ ┴┴└─┘┴└─└─┘   └─┘ ┴ └─┘ ┴ └─┘┴ ┴"
Lin[3]="┬┌┐┌┌─┐┌─┐┬─┐┌┬┐┌─┐┌┬┐┬┌─┐┌┐┌     "
Lin[4]="││││├┤ │ │├┬┘│││├─┤ │ ││ ││││     "
Lin[5]="┴┘└┘└  └─┘┴└─┴ ┴┴ ┴ ┴ ┴└─┘┘└┘     "
	
let ColIni=($(tput cols) - ${#Lin[3]})/9

for ((i=0; i<=5; i++))
    {
    tput cup $((LinIni + i)) $ColIni
    echo "${Lin[i]}"
    sleep 0.1
    }

}

# Menu
function _init_program() { _banner
tput civis ; read -s -p "

	- 1 - Modelo do dispositivo
	- 2 - Programas instalados 
	- 3 - Sistema operacional
	- 4 - Memoria do sistema
        - 5 - IP do sistema
	- 6 - Processador
	- 7 - Kernel
	- 0 - Exit
	
	 [+] " -n1 _OPC 

case $_OPC in
	
1)
	{ tput flash ; printf 'Pressione ENTER - Modelo:' ; # Capura Modelo do dispositivo
	 dmidecode -t1 | grep -oP "Product[^:]+:\K.+" ; read -s ; _init_program ; }
	;;
	
2)
	{ tput flash ; sudo dpkg -l ; _init_program ; } # Exibe os programas instalados
	;;
	
3)
	[[ -e /etc/os-release ]] && : || { printf "E: Sistema não compativel." ; exit 1 ; } # Captura o sistema rodando
	{ tput flash ; printf "Pressione ENTER - Sistema: $PRETTY_NAME" ; read -s ; _init_program ; }
	;;
	
4)
	{ tput flash ; printf "Pressione ENTER - Memoria Livre: $(free -m  | grep ^Mem | tr -s ' ' | cut -d ' ' -f 4)" ;
	read -s ; _init_program ; } # Exibe a memoria livre
	;;

5)
	{ tput flash ; printf "Pressione ENTER - IP_REDE: $(hostname -I)" ; read -s ; _init_program ; } # Exibe o ip da rede
	;;

6) 
	{ tput flash ; printf 'Pressione ENTER - Processador:' & # Captura o processador do dispositivo
	grep -m1 -oP "model name[^:]+:\K.+" /proc/cpuinfo ; read -s ; _init_program ; }
	;;

7)	
	{ tput flash ; printf 'Pressione ENTER - Kernel: ' ; uname -r & read -s ; _init_program ; } # Exibe o kernel
	;;

0)
	{ tput flash ; clear ; printf "Saindo" ; tput reset ; exit 0 ; } # Sai do programa
 	;;

*)
	{ tput flash ; clear ; printf "E: Opçao invalida." ; sleep 1s ; _init_program ; } # Retorno de opçoes invalidas
	;;
  
esac

} ; _init_program
