#!/bin/bash

. ./env

# levanta as duas máquinas e faz o aprovisionamento inicial de cada uma
# - no caso do cliente, instala alguns pacotes e faz configurações iniciais
#   - pra isso, o cliente tem que estar conectado à internet (tem placa de rede com NAT mesmo)
# - no caso do routeros, roda o script inicial de configuração
vagrant up
