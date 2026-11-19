# multi-tcserver
Multi-site launcher para o servidor de terminais de consulta TC Server da Gertec. Permite executar múltiplas instâncias do TC Server em uma mesma máquina.

## Para que serve?
Desenvolvi este launcher para resolver um problema interno do meu trabalho. Tínhamos um TC Server por loja, executando em um computador aleatório (do gerente, frente de caixa, depósito...). Sempre ocorria de alguém se deparar com a janela do TC Server, não saber o que é, fechar e então tirar de operação todos os Busca-Preços da loja.

Inicialmente, minha idéia era criar 8 máquinas virtuais em um de nossos servidores e executar lá os TC Servers isolados, já que por padrão não é possível executar mais de uma instância do TC Server na mesma máquina. E mesmo se você forçar o Java a lançar mais de uma instância do JAR, o TC Server sempre escreve as configs em `%userprofile%\.tc-server\`. Então um sobrescreve a configuração de portas/banco de dados do outro e nada funciona.

Como é meio ridículo ter que rodar 8 SOs inteiros para poder fazer isso funcionar, fui atrás de uma abordagem melhor.

## Como funciona?
O batch do launcher configura algumas variáveis do Java para mentir sobre o local do diretório do usuário na execução, mandando cada um dos binários buscar sua .tc-server dentro de um diretório diferente. Assim, as configurações de portas e DBs ficam devidamente separadas.

Um JAR de 2KB (title-agent) insere na barra de títulos da janela do TC Server a identificação da instância (`- Loja 1`, `- Loja 2`, `- Loja 3`) para que não haja confusão na hora de gerenciar cada uma das instâncias.

### Detalhes

- Número de instâncias para execução facilmente personalizável;
- JAR original da Gertec, sem modificações;
- Número da loja/instância inserido na janela de título, facilitando a identificação;
- Launcher compatível com Windows 7, complemento Java compatível com JRE 1.8, mantendo compatibilidade plena do ambiente com as especificações do TCServer.

# Utilizando o Launcher
Em `C:\Gertec`, abra para edição o script `tclauncher.bat`

No script, configure o número de instâncias que deseja executar:

`set "TOTAL_INSTANCES=8"`

onde 8 executa 8 instâncias do TC Server.

Ao iniciar os TC Servers, todos concorrerão pelo mesmo conjunto de portas. Uma das instâncias inicializará normalmente. As outras printarão erros de JVM_bind nas portas já utilizadas e ficarão com os serviços parados.

O TC Server utiliza 4 portas, das quais 3 são editáveis através da janela principal:
- 6500
- 16510
- 8080

Uma das portas, a 6503, é utilizada pelo serviço de atualização de firmware e é hardcoded no binário. Não é possível alterá-la sem modificações ao binário fornecido pela Gertec.

Ao iniciar os TC Servers pela primeira vez, pare os serviços que estiverem em execução e edite as portas.

Para referência, adotei o seguinte esquema:


| Loja  | Porta SC501  | Porta SC504  | Porta HTTP  |
| ------------ | ------------ | ------------ | ------------ |
| Loja 1  | 65001  | 16511  | 8081  |
| Loja 2  | 65002  | 15512  | 8082  |
| Loja 3  | 65003  | 15513  | 8083  |
| Loja 4  | 65004  | 15514  | 8084  |

Como não é possível utilizar a porta 6503, pulei para a faixa 65000. Seguindo esta lógica e iniciando em 65001 para a loja 1, ainda seria possível subir 535 no mesmo servidor.

Após editar todas as portas, inicie todos os serviços um-a-um apertando nos respectivos botões 'Iniciar' de cada janela. Isto salvará a nova configuração em cada um dos diretórios .tc-server correspondentes às instâncias. Também já pode configurar seu banco de dados.

Após, feche todas as janelas e execute o `tclauncher.bat` novamente. O launcher deve executar cada uma das instâncias e o log de inicialização deve reportar que um dos servidor SC501 está escutado na porta 6500x, enquanto o próximo SC501 reportará o erro de JVM_Bind. Este segundo é inofensivo. Apenas não será possível utilizar o serviço de atualização de firmware.
