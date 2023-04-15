# Cria a bridge do hotspot, associa a porta 3 a ela, que é a criada pelo nosso
# Vagrantfile para a rede interna
###################################
/interface bridge
add name=cozinha-bridge-hotspot

/interface bridge port
add bridge=cozinha-bridge-hotspot interface=ether3

# Cria listas de interfaces para agrupá-las e referenciá-las depois
/interface list
add name=LAN
add name=WAN

# coloca a bridge do hotspot na lista de LAN, e a ether4
# (interface bridged por onde sai pra internet) na WAN
/interface list member
add interface=cozinha-bridge-hotspot list=LAN
add interface=ether4 list=WAN

# Adiciona cliente dhcp na ether4, pra poder acessar a internet
/ip dhcp-client add disabled=no interface=ether4

# Pool de IPs e DHCP Server
###################################
/ip pool
add name=cozinha-pool ranges=10.50.50.2-10.50.50.254
/ip dhcp-server
add address-pool=cozinha-pool disabled=no interface=cozinha-bridge-hotspot name=cozinha-dhcp-server
/ip dhcp-server network
add address=10.50.50.0/24 comment="rede do hotspot" gateway=10.50.50.1

# Primeiro endereço da rede é bridge, vai ser o gateway dos clientes q se conectarem
/ip address
add address=10.50.50.1/24 interface=cozinha-bridge-hotspot network=10.50.50.0

# Hotspot configurado para derrubar usuários trial em 2 minutos
# e configurado tb com autenticação por mac
###################################
/ip hotspot profile
add dns-name=hotspot.cozinha-lab.mtst hotspot-address=10.50.50.1 login-by=mac,cookie,http-chap,https,http-pap,trial name=cozinha-profile \
  mac-auth-mode=mac-as-username-and-password trial-uptime-limit=2m trial-uptime-reset=2m

/ip hotspot
add address-pool=cozinha-pool disabled=no interface=cozinha-bridge-hotspot name=cozinha-hotspot profile=cozinha-profile

# TODO: Já nascer com alguns usuários?
# /ip hotspot user
# add name=admin
# add name=BA:F9:34:87:BF:B3
# add name=B6:38:71:31:F4:82

# Regra de NAT
###################################
# /ip firewall nat
# add action=masquerade chain=srcnat ipsec-policy=out,none out-interface=cozinha-bridge-hotspot
# TODO: Estudar esses masquerades, precisa ter os dois?
/ip firewall nat
add action=masquerade chain=srcnat ipsec-policy=out,none out-interface-list=WAN comment="defconf: masquerade"  
add action=masquerade chain=srcnat src-address=10.5.50.0/24 comment="masquerade hotspot network" 

# Servidor SAMBA pra mexermos nos arquivos do hotspot direto por fora
# do mikrotik
###################################
/ip smb
set domain=WORKGROUP enabled=yes
/ip smb shares
add directory=/hotspot name=hotspot
/ip smb users
add name=cozinha password=cozinha read-only=no

# Configura apresentação dos logs
###################################
/system logging
add prefix="[hs]" topics=hotspot
add prefix="[fw]" topics=firewall
add prefix="[wp]" topics=web-proxy

# Timezone
###################################
/system clock
set time-zone-name=America/Sao_Paulo
