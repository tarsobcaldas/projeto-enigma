# projeto-enigma
Neste projeto no âmbito da cadeira de Sistemas Embutidos, tentámos replicar a máquina criptográfica Enigma da II Guerra Mundial.
Este é um modelo adaptado aos dias de hoje, que servindo-se de 2 arduinos e 1 raspberry pi consegue escrever uma mensagem, encriptá-la segundo o algoritmo da enigma e enviá-la para um dispositivo android através de um serviço na Google Cloud.

Serve portanto a presente documentação para explicar o funcionamento do projeto assim como como executar cada componente.

## Teclado
O teclado utilizado consiste num keypad de 16 teclas (10 numéricas, 4 letras ABCD e um * e #). Dada a configuração deste, foi necessário escrever um sketch em arduino (que pode ser encontrado em Code/Keypad) que simule os antigos teclados numéricos dos telemóveis que possibilitam com apenas 9 teclas escrever todo o alfabeto se desejado. Assim sendo, apenas as teclas numéricas (para introdução de letras, pontuação e espaços) e a tecla A (para envio da mensagem) estão em utilização.

## Ecrã
O ecrã utilizado no projeto foi um LCD Shield para arduino, como tal foi necessária a utilização de um segundo arduino (flashado com o sketch em Code/Display) que ligado pela entrada Serial ao arduino do keypad, recebe caratér a caratér a mensagem escrita no teclado, e vai exibindo essa mensagem no monitor, havendo 3 cenários importantes a destacar:

- Quando o tamanho da mensagem excede o tamanho da linha, o monitor passa para a linha de baixo e continua a escrever.
- Quando o tamanho da mensagem excede o tamanho do ecrã, o monitor dá clear e continua a escrever para o lado.
- Quando a tecla um '\0' é recebido (caratér mapeado pela tecla A no keypad) o monitor da clear da mensagem e fica pronto a receber uma nova (ao exibir o '$' que indica o início de uma nova consola de introdução de texto)

## Raspberry PI
O raspberry PI vai atuar como unidade de processamento e comunicação em simultâneo. Vai portanto receber a mensagem, aplicar o algoritmo de encriptação em Code/Encrypt que também vai abrir uma conexão com o serviço a correr em cloud e enviar o output encriptado. 

### Google Cloud
O Google Cloud está a correr um simples servidor http que recebe pedidos e encaminha para a aplicação android de modo às mensagens serem descodificadas

## Android

# Enigma Decrypter

O "Enigma Decrypter" é um aplicativo Flutter que implementa uma máquina de criptografia Enigma. O código consiste em várias classes que trabalham juntas para implementar o funcionamento da máquina Enigma.

## Classes

### EnigmaMachine

A classe `EnigmaMachine` representa a máquina Enigma em si. Ela possui uma lista de rotores e um refletor. A função `setRotorPositions` é usada para definir as posições iniciais dos rotores. A função `decrypt` é usada para descriptografar uma mensagem usando a máquina Enigma. A função `rotateRotors` é responsável por girar os rotores após cada caractere descriptografado.

### Rotor

A classe `Rotor` representa um rotor da máquina Enigma. Cada rotor possui uma configuração de fiação, uma posição e uma posição de encaixe (notch). A função `set_position` é usada para definir a posição do rotor. As funções `encrypt_forward` e `encrypt_backward` são usadas para criptografar e descriptografar letras, respectivamente, usando o rotor.

### Reflector

A classe `Reflector` representa o refletor da máquina Enigma. O refletor não possui posição ou encaixe. A função `encrypt` é usada para criptografar uma letra usando o refletor.

### MyApp

A classe `MyApp` é a raiz do aplicativo Flutter. Ela configura o tema do aplicativo e define a página inicial como `HomePage`.

### HomePage

A classe `HomePage` é a página principal do aplicativo. Ela exibe uma lista de mensagens criptografadas e fornece a funcionalidade para descriptografá-las. A função `fetchData` é usada para buscar as mensagens criptografadas de uma URL fornecida. A função `decryptMessage` é usada para descriptografar uma mensagem selecionada usando a máquina Enigma.

## Funcionalidades

O aplicativo permite ao usuário:

- Ver uma lista de mensagens criptografadas.
- Selecionar uma mensagem para descriptografar.
- Atualizar a lista de mensagens criptografadas.
- Escolher as posições iniciais dos rotores.
- Descriptografar a mensagem selecionada.

