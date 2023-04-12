#!/bin/bash

. ./env

if [[ -z "$1" ]]; then
  echo "Uso: $0 <ação>"
  echo ""
  echo "'ação' pode ser:"
  echo "  - 'hotspot'  - para testar o laboratório; o cliente fica sem acesso à internet, precisando usar o hotspot "
  echo "  - 'internet' - para configurar, atualizar o ambiente, etc; o cliente acessa a internet diretamente usando NAT"
  exit 1
fi

action="$1"

case $action in
  hotspot)
    echo "Desligando a rede NAT do cliente e conectando ao roteador"
    VBoxManage controlvm $CLIENT nic1 intnet $NETWORK
    ;;
  internet)
    echo "Desconectando cliente do roteador e reconectando à rede NAT"
    VBoxManage controlvm $CLIENT nic1 nat
    ;;
  *)
    echo "Ação desconhecida: $1"
    exit 2
    ;;
esac
