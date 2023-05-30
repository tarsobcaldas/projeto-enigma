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


