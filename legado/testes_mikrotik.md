# Prova de Conceito com MikroTik

## Resumo

No momento apenas uma prova de conceito, com:
- Rede wi-fi aberta
- Portal de captura padrão do próprio mikrotik, ainda a ser personalizado
- Acesso liberado no modo "trial", sem qualquer configuração adicional

## Equipamentos utilizados

### Em Laboratório
- Conseguimos 3 mikrotiks RB750, cedidos para laboratório, para fazer a configuração do acesso à internet e o hotspot com portal de captura; não possuem wifi
- Como acess point, no momento, temos um TP-Link WR840N, servindo apenas como antena wifi mesmo

### Para produção (modelos atuais e preços)
Há algumas opções de arquitetura, mas idealmente teríamos APs `802.11ac` (wifi 5), os mais modernos e potentes disponíveis no momento, enquanto equipamentos `ax` (wifi 6) não se popularizam por aqui. Antenas `802.11n` (wifi 4), a versão anterior, são suficientes também dependendo da expectativa de uso e número de usuários simultâneos.

Opções:
1) Podemos utilizar uma placa mikrotik cabeada e qualquer roteador/ap sem fio, como no ambiente de laboratório
2) Podemos já comprar um mikrotik com wifi, há vários modelos alguns apenas 2GHz, outros com 2 e 5, wifi 4 ou 5, etc
3) Podemos inclusive utilizar um mikrotik com wifi 4, por exemplo, e caso necessário estender o sinal com algum AP comum

#### Estimativa de custo dos equipamentos:
- Os modelos mais baratos que encontrei foram o [hAP lite](https://mikrotik.com/product/RB941-2nD) e o [hAP mini](https://mikrotik.com/product/RB931-2nD)
  - Preços variavam de R$ 150,00 a R$ 300,00, a depender de modelo, loja, etc.
- Os modelos de mikrotik cabeados (versões modernas da RB750 que temos no laboratório) estavam mais caros do que os com wifi
  - [hEX](https://mikrotik.com/product/RB750Gr3) e [hEX lite](https://mikrotik.com/product/RB750r2)
  - O motivo disso é velocidade de rede (o hEX tem 5 portas gigabit ethernet), frequência do processador, e memória
  - Os preços variavam de R$ 350,00 a R$ 500,00
- Numa busca rápida, encontrei também roteadores comuns (para funcionar de AP) de 802.11ac (wifi 5) por cerca de R$ 150,00
- Lojas onde procurei:
  - Amazon Brasil
  - Mercado Livre
  - [NR Store](https://www.nrstore.com.br) - especializada em mikrotik e ubiquiti (outra marca semelhante)

## Links e documentações
- [Site mikrotik](https://mikrotik.com)
- [Documentação oficial](https://help.mikrotik.com/docs/)
- [Wiki](https://wiki.mikrotik.com/wiki/Main_Page)
- [Documentação Hotspot](https://help.mikrotik.com/docs/pages/viewpage.action?pageId=56459266)

## Configuração feita em laboratório (MUITO POR ALTO):

## Mikrotik
- Há uma ferramenta gráfica de administração e configuração chamada winbox ([download](https://mikrotik.com/download)) 
- Ela funciona em windows, mas é possível rodá-la em linux utilizando [wine](https://www.winehq.org/)
- Após as configurações feitas, é possível exportar para um arquivo, de maneira que possam ser replicadas posteriormente
- Vou colocar aqui o script inicial gerado, e comentarei depois

```
# sep/30/2021 13:14:12 by RouterOS 6.48.4
# software id = 4ARS-7NBQ
#
# model = 750
# serial number = 2F2D025B5922
 /interface bridge
add name=br-lan
add name=br-wifi
/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik
/ip hotspot profile
add hotspot-address=10.5.50.1 login-by=cookie,http-chap,trial name=hsprof1
/ip pool
add name=dhcp_pool0 ranges=10.1.1.2-10.1.1.254
add name=hs-pool-7 ranges=10.5.50.2-10.5.50.254
/ip dhcp-server
add address-pool=dhcp_pool0 disabled=no interface=br-lan name=dhcp1
add address-pool=hs-pool-7 disabled=no interface=br-wifi lease-time=1h name=dhcp2
/ip hotspot
add address-pool=hs-pool-7 disabled=no interface=br-wifi name=hotspot1 profile=hsprof1
/interface bridge port
add bridge=br-lan interface=ether2
add bridge=br-lan interface=ether3
add bridge=br-wifi interface=ether4
add bridge=br-wifi interface=ether5
/ip address
add address=10.1.1.1/24 interface=br-lan network=10.1.1.0
add address=10.5.50.1/24 comment="hotspot network" interface=br-wifi network=10.5.50.0
/ip dhcp-client
add disabled=no interface=ether1
/ip dhcp-server network
add address=10.1.1.0/24 gateway=10.1.1.1
add address=10.5.50.0/24 comment="hotspot network" gateway=10.5.50.1
/ip firewall filter
add action=passthrough chain=unused-hs-chain comment="place hotspot rules here" disabled=yes
/ip firewall nat
add action=passthrough chain=unused-hs-chain comment="place hotspot rules here" disabled=yes
add action=masquerade chain=srcnat
add action=masquerade chain=srcnat comment="masquerade hotspot network" src-address=10.5.50.0/24
add action=masquerade chain=srcnat comment="masquerade hotspot network" src-address=10.5.50.0/24
add action=masquerade chain=srcnat comment="masquerade hotspot network" src-address=10.5.50.0/24
/ip hotspot user
add name=admin password=admin
/system clock
set time-zone-name=America/Sao_Paulo
```

---

### Por partes:

Essas linhas aqui são comentários gerados automaticamente com dados da versão do sistema, modelo do aparelho, etc.
```
# sep/30/2021 13:14:12 by RouterOS 6.48.4
# software id = 4ARS-7NBQ
#
# model = 750
# serial number = 2F2D025B5922
```

Criamos 2 _bridges_, q aqui são apenas agrupamentos de portas ethernet do mikrotik. Essa placa tem 5 portas, e estamos usando assim:
- Porta 1: WAN. É onde vai chegar o sinal de internet no mikrotik; não criamos uma _bridge_ pra ela, ela vai ficar sozinha mesmo
- Portas 2 e 3: `br-lan` é LAN física; a ideia é usar para administração, porque queremos proteger a interface de administração da rede da galera que conecta no wifi
- Portas 4 e 5: `br-wifi` é a LAN onde o pessoal do wifi estará conectado;
```
/interface bridge
add name=br-lan
add name=br-wifi
```

Não tenho a mais vaga ideia do que isso aqui faz 😅
```
/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik
```

Aqui criamos um "perfil de hotspot", que configura coisas como o tipo de autenticação que esse hotspot utilizará, o IP dele, etc. Acho que não mexi em nada (ou quase nada0 daqui, tá tudo meio padrão. Importante habilitar o "trial", pq na real acho q não exigiremos login de verdade, apenas que as pessoas dêem seu whatsapp. O esquema de trial é sem login, mas podemos configurar quanto tempo aquele MAC address fica com acesso, etc. entender isso aqui melhor.
O ip da rede 10.5.50.0 é pq ele estará na rede da bridge `br-wifi`, mas veremos a questão dos IPs adiante
```
/ip hotspot profile
add hotspot-address=10.5.50.1 login-by=cookie,http-chap,trial name=hsprof1
```

Aqui criamos os pools de IP que o servidor DHCP utilizará para distribuir IPs para quem se conectar a cada rede; os nomes ficaram meio padrão, e eu acho que só coloquei "hs-pool" no segundo, não entendi porque ficou com o nome `hs-pool-7`; o primeiro pool será utilizado para a rede associada à bridge `br-lan`, e o segundo à rede wifi
```
/ip pool
add name=dhcp_pool0 ranges=10.1.1.2-10.1.1.254
add name=hs-pool-7 ranges=10.5.50.2-10.5.50.254
```

Aqui criamos dois servidores DHCP, um pra atender à rede `br-lan` e outro à wifi, com os pools de IP correspondentes
```
/ip dhcp-server
add address-pool=dhcp_pool0 disabled=no interface=br-lan name=dhcp1
add address-pool=hs-pool-7 disabled=no interface=br-wifi lease-time=1h name=dhcp2
```

Aqui criamos efetivamente o "hotspot", que é esse esquema todo de portal de captura, etc. Associa a uma interface (no caso, a bridge `br-wifi`), o perfil que criamos antes, e um pool de IPs
```
/ip hotspot
add address-pool=hs-pool-7 disabled=no interface=br-wifi name=hotspot1 profile=hsprof1
```

Aqui associamos cada _bridge_ que criamos às portas correspondentes, como indicado anteriormente
```
/interface bridge port
add bridge=br-lan interface=ether2
add bridge=br-lan interface=ether3
add bridge=br-wifi interface=ether4
add bridge=br-wifi interface=ether5
```

Configura os endereços das bridges
```
/ip address
add address=10.1.1.1/24 interface=br-lan network=10.1.1.0
add address=10.5.50.1/24 comment="hotspot network" interface=br-wifi network=10.5.50.0
```

Indicamos que a porta 1 vai usar um dhcp-client para pegar IP, já que ela é a porta WAN. esse será o IP dado pelo modem do provedor
```
/ip dhcp-client
add disabled=no interface=ether1
```

Aqui criamos os servidores DHCP que distribuirão IPs nas duas redes que criamos
```
/ip dhcp-server network
add address=10.1.1.0/24 gateway=10.1.1.1
add address=10.5.50.0/24 comment="hotspot network" gateway=10.5.50.1
```

Configuramos as regras de firewall (filtros desabilitados no momento)... 
```
/ip firewall filter
add action=passthrough chain=unused-hs-chain comment="place hotspot rules here" disabled=yes
```

... e de NAT (para que todos os pacotes dentro da bridge `br-wifi` saiam com o IP da bridge, fazendo NAT para dentro)
```
/ip firewall nat
add action=passthrough chain=unused-hs-chain comment="place hotspot rules here" disabled=yes
add action=masquerade chain=srcnat
add action=masquerade chain=srcnat comment="masquerade hotspot network" src-address=10.5.50.0/24
add action=masquerade chain=srcnat comment="masquerade hotspot network" src-address=10.5.50.0/24
add action=masquerade chain=srcnat comment="masquerade hotspot network" src-address=10.5.50.0/24
```

Cria um usuário padrão para o hotspot (admin/admin aqui); não é tão importante aqui pois usaremos o acesso "trial", mas precisa ter um
```
/ip hotspot user
add name=admin password=admin
```

Configura fuso horário
```
/system clock
set time-zone-name=America/Sao_Paulo
```

---

Ao criar o hotspot, o mikrotik automaticamente gerou uma pasta com os arquivos referentes à autenticação. Basicamente html/css/js. Me parece que o fluxo que queremos será implementado substituindo essas páginas e códigos pelos nossos, ou redirecionando para algum lugar externo (vps?) onde nosso código roda. Aí podemos fazer o fluxo de whatsapp como pensamos. Abre o portal de captura, clica num link que leva para o whatsapp com a mensagem; pensar em como validar isso para liberar o acesso, etc.


### AP (TP-Link tl-wr840n)
- Peguei as especificações embaixo do aparelho
- Achei o [manual](https://www.tp-link.com/br/support/download/tl-wr840n/v2/)
- Resetei as configurações de fábrica
- Aparelho ligado (apenas na tomada), usei os dados encontrados na etiqueta embaixo para conectar na rede wifi que ele gera e logar na página de adminstração web
- Essa versão (V2) não tem a configuração simples de "modo de operação AP", ele funciona sempre como roteador
- Assim, para que funcione apenas como AP, devemos:
  - Desligar o DHCP, para que não tente entregar IPs aos clientes (esse trabalho será feito pelo mikrotik)
  - Colocar um IP de LAN fixo (dentro da faixa que o servidor DHCP do mikrotik entrega)
- Fazer as configurações da rede sem fio dele
  - SSID
  - Segurança (desliguei, pois queremos a rede aberta)


## Próximos passos e decisões a tomar

### Questões técnicas
- Seria bom uma estimativa de número de usuários num dia normal, de usuários simultâneos, de uso, para dimensionar os equipamentos
  - Também seria legal uma ideia de tamanho e geometria, mas isso deve variar muito caso a caso
  - Tendo isso, poderemos pensar em que versão de wifi é suficiente (802.11n ou ac), velocidade das portas ethernet (fast ou gigabit), quantidade de APs, etc
- Pensar em requisitos de segurança, para configurar firewall, etc
- Pensar em filtros de conteúdo e como utilizá-los
  - O que queremos filtrar?
  - O próprio roteador provê uma maneira mais "alto nível" de filtrar por assunto, ou só IPs, por exemplo?
  - Que serviços externos podemos utilizar?
- Queremos uma maneira centralizada de configurar, resolver problemas?
  - Abrimos a interface de adminsitração pra fora? Como evitar problemas de segurança?
  - Se não abrimos, conseguimos ter gente sempre por perto para eventuais problemas de acesso, lentidão, etc?
- Pra além da arquitetura atual, podemos pensar em replicá-la com outros hardwares e OpenWRT / DD-WRT / Tomato ou algum outro


### Questões legais
- Não ferir o Marco Civil, LGPD, etc.
- O que precisamos / queremos guardar de logs?
  - Por exemplo, mac address que fez determinado acesso em determinada hora, coisas assim
- Como obter consentimento para logar o que precisamos logar?
- Por quanto tempo precisamos guardar esses logs?

## Mais ideias e considerações
- Podemos tentar oferecer capacitação em redes e dessa solução em específico para membros do movimento, do núcleo, etc? Como?
- Faz sentido ter diferentes tipos de autenticação, oferecendo diferentes níveis de acesso/privilégio?
  - Por exemplo, membros do movimento, acampados, coordenadores, poderiam autenticar com o App da Vitória
  - Se tivermos que limitar quantidade de uso de banda e transferência por questões de custo, por exemplo, podemos querer garantir acesso ilimitado ou menos restrito aos membros, ou coisa do tipo

## Fluxograma para acesso a rede - Versão esboço
![Cozinhas](https://user-images.githubusercontent.com/26493929/136297031-0ea97ed8-14dd-4574-a27b-9342092caf2b.png)

