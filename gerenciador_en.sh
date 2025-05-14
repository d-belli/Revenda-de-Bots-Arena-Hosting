#!/bin/bash

# === ANSI COLORS ===
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
NC='\033[0m'  # No color
#!/bin/bash

# === CORES ANSI ===
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'  # Sem cor

# === ÍCONES UNICODE ===
CHECK_MARK='✅'
CROSS_MARK='❌'
WARNING='⚠️'
INFO='ℹ️'
ARROW='➡️'
CIRCLE_ON='◉'  # Círculo verde para ON
CIRCLE_OFF='○' # Círculo vazio para OFF

# === CONFIGURACIÓN ===
# Configuración de la API esperada. Esta es la clave utilizada para validar la conexión con el gestor principal.
API_ESPERADA="ARENAHOSTING"

# === FUNCIÓN PARA VALIDAR LA API ===
# Esta función verifica si la API proporcionada por el gestor principal corresponde con la clave esperada.
# Si no coincide, el script muestra un mensaje de error y se cierra.
# El usuario no debe modificar esta función a menos que comprenda cómo funciona la validación.
validar_api() {
    API_RECIBIDA=$1
    if [ "$API_RECIBIDA" != "$API_ESPERADA" ]; then
        echo -e "${RED}THE API CANNOT CONNECT TO THE MANAGER.SH FILE.${NC}"
        echo -e "${YELLOW}PLEASE PROVIDE THE CONFIGURATION FILE TO RUN THIS SCRIPT.${NC}"
        echo -e "${YELLOW}IF YOU DON'T KNOW, PLEASE CONTACT OUR SUPPORT:${NC}"
        echo -e "${CYAN}https://arenahosting.com.br${NC}"
        exit 1
    fi
}

# === CONFIGURAÇÕES PRINCIPAIS ===
BASE_DIR="/home/container"  # Diretório base onde os ambientes serão criados.
NUM_AMBIENTES=5 # Número de ambientes que serão configurados.
TERMS_FILE="${BASE_DIR}/termos_accepted.txt"  # Caminho do arquivo que indica a aceitação dos termos.
NOMES_ARQUIVO="${BASE_DIR}/nome_ambientes.json"  # Arquivo que armazena os nomes dos ambientes
BACKUP_NUM_AMBIENTES="${BASE_DIR}/num_ambientes_backup.txt"  # Arquivo para backup do número de ambientes

# === CONFIGURAÇÕES ===
WHITELIST_HOSTNAMES=("arenahosting.com.br")
WHITELIST_IPS=("166.0.189.163")
VALIDATED=false
# === CONFIGURAÇÕES DE VERSÃO ===
VERSAO_LOCAL="1.0.1"  # Versão atual do script
URL_SCRIPT="https://raw.githubusercontent.com/d-belli/Multi_Bot-Plano01/refs/heads/main/gerenciador_pt.sh?token=GHSAT0AAAAAADCRJYHQQTRJBXIP2QZR4WHA2BD6Q7Q"  # Link para o conteúdo do script no GitHub

# Obtém o nome do script atual (ex.: gerenciador.sh)
SCRIPT_NOME=$(basename "$0")
SCRIPT_PATH="$0"  # Caminho absoluto do script atual

# === CABEÇALHO DINÂMICO ===
cabecalho() {
    clear
    echo -e "${CYAN}==============================================${NC}"
    echo -e "${BOLD}${CYAN}          SYSTEM MANAGER           ${NC}"
    echo -e "${CYAN}==============================================${NC}"
}

# === ANIMAÇÃO DE TEXTO ===
anima_texto() {
    local texto="$1"
    # Aplica a cor amarela ao texto inteiro antes da animação
    echo -n "${YELLOW}"
    for ((i = 0; i < ${#texto}; i++)); do
        echo -n "${texto:i:1}"
        sleep 0.02
    done
    # Reseta a cor após o texto
    echo "${NC}"
}



# === EXIBIR OUTDOOR 3D ===
exibir_outdoor_3D() {
    cabecalho
    echo -e "${CYAN}${INFO} Initializing system...${NC}"
    sleep 1

    local width=$(tput cols)  # Largura do terminal
    local height=$(tput lines)  # Altura do terminal
    local start_line=$((height / 3))
    local start_col=$(( (width - 60) / 2 ))  # Centraliza o texto

    # Arte 3D do texto principal
    local outdoor_text=(
"  ____  ____     ___  ____    ____ "
" /    ||    \   /  _]|    \  /    |"
"|  o  ||  D  ) /  [_ |  _  ||  o  |"
"|     ||    / |    _]|  |  ||     |"
"|  _  ||    \ |   [_ |  |  ||  _  |"
"|  |  ||  .  \|     ||  |  ||  |  |"
"|__|__||__|\_||_____||__|__||__|__|"
    )  

    # Exibe o texto 3D centralizado
    for i in "${!outdoor_text[@]}"; do
        tput cup $((start_line + i)) $start_col
        echo -e "${CYAN}${outdoor_text[i]}${NC}"
    done

    # Exibe informações adicionais
    local footer="Built by Mauro Gashfix"
    tput cup $((start_line + ${#outdoor_text[@]} + 1)) $(( (width - ${#footer}) / 2 ))
    echo -e "${YELLOW}${footer}${NC}"

    local links="arenahosting.com.br"
    tput cup $((start_line + ${#outdoor_text[@]} + 2)) $(( (width - ${#links}) / 2 ))
    echo -e "${GREEN}${links}${NC}"

spinner() {
    local pid=$1  # ID do processo em segundo plano
    local delay=0.1
    local spin='-\|/'  # Caracteres do spinner
    local char_width=1

    while kill -0 $pid 2>/dev/null; do
        for i in $(seq 0 3); do
            printf "\r[${spin:$i:1}] ${CYAN}Carregando...${NC}"
            sleep $delay
        done
    done

    printf "\r${GREEN}[✔] Concluído!${NC}       \n"
}

# Exemplo de uso
long_running_task() {
    sleep 5  # Simula uma tarefa longa
}

echo -e "${CYAN}Starting system...${NC}"
long_running_task &
spinner $!
}

# === EXIBIR TERMOS DE SERVIÇO ===
exibir_termos() {
    exibir_outdoor_3D
    sleep 1

    echo -e "${BLUE}${INFO} This system is only allowed on the Arena Hosting platform.${NC}"
    echo -e "${CYAN}==============================================${NC}"

    if [ ! -f "$TERMS_FILE" ]; then
        while true; do
            echo -e "${YELLOW}${WARNING} DO YOU ACCEPT THE TERMS OF SERVICE? (SIM/NÃO)${NC}"
            read -p "> " ACEITE
            if [ "$ACEITE" = "sim" ]; then
                echo -e "${GREEN}${CHECK_MARK} Terms accepted on $(date).${NC}" > "$TERMS_FILE"
                echo -e "${CYAN}==============================================${NC}"
                echo -e "${GREEN}${CHECK_MARK} TERMS ACCEPTED. CONTINUING...${NC}"
                break
            elif [ "$ACEITE" = "não" ]; then
                echo -e "${RED}${CROSS_MARK} YOU MUST ACCEPT THE TERMS TO CONTINUE.${NC}"
            else
                echo -e "${RED}${CROSS_MARK} INVALID OPTION. TYPE 'YES' OR 'NO'.${NC}"
            fi
        done
    else
        echo -e "${GREEN}${CHECK_MARK} TERMS ALREADY ACCEPTED. CONTINUING...${NC}"
    fi
}

# === CRIAR PASTAS DOS AMBIENTES ===
criar_pastas() {
    cabecalho
    echo -e "${CYAN}${INFO} Creating environment folders...${NC}"
    sleep 1

    for i in $(seq 1 $NUM_AMBIENTES); do
        AMBIENTE_PATH="${BASE_DIR}/ambiente${i}"
        if [ ! -d "$AMBIENTE_PATH" ]; then
            mkdir -p "$AMBIENTE_PATH"
            echo -e "${GREEN}${CHECK_MARK} Environment folder ${i} created.${NC}"
        else
            echo -e "${YELLOW}${INFO} Environment folder ${i} already exists.${NC}"
        fi
    done
}

# === ATUALIZAR STATUS DO AMBIENTE ===
atualizar_status() {
    AMBIENTE_PATH=$1
    NOVO_STATUS=$2
    echo "$NOVO_STATUS" > "${AMBIENTE_PATH}/status"
    echo -e "${CYAN}${INFO} Environment status updated to: ${GREEN}${NOVO_STATUS}${NC}"
}

# === RECUPERAR STATUS DO AMBIENTE ===
recuperar_status() {
    AMBIENTE_PATH=$1
    if [ -f "${AMBIENTE_PATH}/status" ]; then
        cat "${AMBIENTE_PATH}/status"
    else
        echo "OFF"
    fi
}

# === VERIFICAR SESSÕES EM BACKGROUND ===
verificar_sessoes() {
    echo -e "${CYAN}======================================${NC}"
    anima_texto "       CHECKING BACKGROUND SESSIONS"
    echo -e "${CYAN}======================================${NC}"

    for i in $(seq 1 $NUM_AMBIENTES); do
        AMBIENTE_PATH="${BASE_DIR}/ambiente${i}"

        # Verifica se o arquivo .session existe
        if [ -f "${AMBIENTE_PATH}/.session" ]; then
            STATUS=$(recuperar_status "$AMBIENTE_PATH")

            # Define o indicador visual de status
    if [ "$STATUS" = "ON" ]; then
        INDICADOR_STATUS="${GREEN}●${NC}"
    else
        INDICADOR_STATUS="${RED}●${NC}"
    fi
            
            # Exibe o status do ambiente
            echo -e "${YELLOW}Verificando ambiente ${i}...${NC}"
            echo -e "${CYAN}Current status: ${INDICADOR_STATUS} (${STATUS})${NC}"

            # Verifica se o status é ON
            if [ "$STATUS" = "ON" ]; then
                COMANDO=$(cat "${AMBIENTE_PATH}/.session")
                if [ -n "$COMANDO" ]; then
                    echo -e "${YELLOW}Restoring session for environment ${i}...${NC}"
                    
                    # Verifica se o processo já está rodando
                    PROCESSO_JA_RODANDO=false
                    if [ -f "${AMBIENTE_PATH}/.pid" ]; then
                        OLD_PID=$(cat "${AMBIENTE_PATH}/.pid")
                        if kill -0 "$OLD_PID" >/dev/null 2>&1; then
                            echo -e "${GREEN}[ATIVO] Session is already running (PID: $OLD_PID).${NC}"
                            PROCESSO_JA_RODANDO=true
                        fi
                    fi
                    
                    # Somente inicia se não estiver rodando
                    if [ "$PROCESSO_JA_RODANDO" = false ]; then
                        cd "$AMBIENTE_PATH" || continue
                        
                        echo -e "${YELLOW}Starting session in background...${NC}"
                        nohup $COMANDO > "${AMBIENTE_PATH}/nohup.out" 2>&1 &
                        NEW_PID=$!
                        echo "$NEW_PID" > "${AMBIENTE_PATH}/.pid"
                        
                        echo -e "${GREEN}[SUCESSO] Session restored for environment ${i}. (PID: $NEW_PID)${NC}"
                    fi
                else
                    echo -e "${YELLOW}[AVISO] Empty command found in .session file of environment ${i}.${NC}"
                fi
            else
                echo -e "${RED}[IGNORADO] The environment ${i} is with status OFF.${NC}"
            fi
        else
            echo -e "${RED}[IGNORADO] No .session file found in environment ${i}.${NC}"
        fi

        echo -e "${CYAN}--------------------------------------${NC}"
    done

    echo -e "${CYAN}======================================${NC}"
    anima_texto "       CHECK COMPLETE"
    echo -e "${CYAN}======================================${NC}"
}


# === FUNÇÃO PARA OBTER IPS ===
obter_ips() {
    IP_PRIVADO=$(hostname -I | awk '{print $1}')
    IP_PUBLICO=""
    SERVICOS=("ifconfig.me" "api64.ipify.org" "ipecho.net/plain")

    for SERVICO in "${SERVICOS[@]}"; do
        IP_PUBLICO=$(curl -s --max-time 5 "http://${SERVICO}")
        if [[ $IP_PUBLICO =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
            break
        fi
    done

    if [ -z "$IP_PUBLICO" ]; then
        IP_PUBLICO="Could not obtain public IP"
    fi

    echo "$IP_PRIVADO" "$IP_PUBLICO"
}


# ###########################################
# Configurações principais
# - Propósito: Define o diretório base e outras configurações essenciais do sistema.
# - Editar:
#   * `BASE_DIR`: Modifique para alterar o diretório base onde os ambientes serão criados.
#   * `NUM_AMBIENTES`: Ajuste o número de ambientes que deseja criar.
#   * `TERMS_FILE`: Altere o caminho do arquivo de termos, se necessário.
# - Não editar: Não altere a lógica de uso das variáveis, apenas seus valores.
# ###########################################

# === GERENCIAR AMBIENTE ===
gerenciar_ambiente() {
    # Define o caminho do ambiente com base no índice
    AMBIENTE_PATH="${BASE_DIR}/ambiente$1"

    # Recupera o status do ambiente
        STATUS=$(recuperar_status "$AMBIENTE_PATH")
    
    # Obtém o nome do ambiente, se existir
    NOME=$(obter_nome_ambiente $1)

        # Define o indicador visual de status (círculo colorido)
        if [ "$STATUS" = "ON" ]; then
        INDICADOR_STATUS="${GREEN}●${NC}"
    else
        INDICADOR_STATUS="${RED}●${NC}"
    fi

    # Verifica se os arquivos /proc estão disponíveis
    if [ -f "/proc/stat" ] && [ -f "/proc/meminfo" ]; then
        # Calcula o uso de CPU
        CPU_INFO=$(grep '^cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {printf "%.0f%%", usage}')

        # Calcula o uso de RAM
        MEM_TOTAL=$(grep 'MemTotal' /proc/meminfo | awk '{print $2}')
        MEM_FREE=$(grep 'MemFree' /proc/meminfo | awk '{print $2}')
        MEM_USED=$((MEM_TOTAL - MEM_FREE))
        MEM_USAGE=$((MEM_USED * 100 / MEM_TOTAL))  # Uso de RAM em porcentagem
        MEM_USED_MB=$((MEM_USED / 1024))           # Converte KB para MB
        RAM_INFO="${MEM_USAGE}% (${MEM_USED_MB} MB)"
    else
        # Define valores padrão se /proc não estiver disponível
        CPU_INFO="N/A"
        RAM_INFO="N/A"
        echo -e "${YELLOW}AVISO: Os arquivos /proc não estão disponíveis neste sistema.${NC}"
        echo -e "${YELLOW}Uso de CPU e RAM não pode ser calculado.${NC}"
    fi

    # Cabeçalho do menu
    echo -e "${CYAN}======================================${NC}"
    if [ -z "$NOME" ]; then
        echo -e "${CYAN}GERENCIANDO AMBIENTE $1${NC}"
    else
        echo -e "${CYAN}GERENCIANDO AMBIENTE $1 - ${YELLOW}${NOME}${NC}"
    fi
    echo -e "${CYAN}======================================${NC}"
    echo -e "${RED} ATUALIZAÇÃO: OPÇÃO 2 Iniciar Bot depois 5 foi atualizada"
    echo -e "${YELLOW}Status do Ambiente: ${INDICADOR_STATUS} (${STATUS})${NC}"
    echo -e "${YELLOW}Uso de CPU: ${CYAN}${CPU_INFO}${NC}"
    echo -e "${YELLOW}Uso de RAM: ${CYAN}${RAM_INFO}${NC}"
    echo -e "${CYAN}--------------------------------------${NC}"

    # Opções do menu
    echo -e "${YELLOW}1 - ESCOLHER BOT PRONTO DA ARENA HOSTING${NC}"
    echo -e "${YELLOW}2 - INICIAR O BOT ${INDICADOR_STATUS}${NC}"
    echo -e "${YELLOW}3 - PARAR O BOT - SERÁ ATUALIZADO EM BREVE${NC}"
    echo -e "${YELLOW}4 - REINICIAR O BOT - SERÁ ATUALIZADO EM BREVE${NC}"
    echo -e "${YELLOW}5 - VISUALIZAR O TERMINAL - SERÁ ATUALIZADO EM BREVE${NC}"
    echo -e "${YELLOW}6 - DELETAR SESSÃO - SERÁ ATUALIZADO EM BREVE${NC}"
    echo -e "${YELLOW}7 - REMOVER BOT ATUAL${NC}"
    echo -e "${YELLOW}8 - CLONAR REPOSITÓRIO${NC}"
    echo -e "${RED}0 - VOLTAR${NC}"

    # Recebe a opção do usuário
    read -p "> " OPCAO

    # Switch para redirecionar para a função correspondente
    case $OPCAO in
        1) 
            # Escolher bot pronto
            escolher_bot_pronto "$AMBIENTE_PATH"
            ;;
        2) 
            # Iniciar o bot
            iniciar_bot "$AMBIENTE_PATH"
            ;;
        3) 
            # Parar o bot
            parar_bot "$AMBIENTE_PATH"
            ;;
        4) 
            # Reiniciar o bot
            reiniciar_bot "$AMBIENTE_PATH"
            ;;
        5) 
            # Visualizar o terminal
            ver_terminal "$AMBIENTE_PATH"
            ;;
        6) 
            # Deletar sessão
            deletar_sessao "$AMBIENTE_PATH"
            ;;
        7) 
            # Remover bot atual
            remover_bot "$AMBIENTE_PATH"
            ;;
        8) 
            # Clonar repositório
            clonar_repositorio "$AMBIENTE_PATH"
            ;;
        0) 
            # Voltar ao menu principal
            menu_principal
            ;;
        *) 
            # Opção inválida
            echo -e "${RED}Opção inválida.${NC}"
            gerenciar_ambiente "$1"
            ;;
    esac
}

# === ESCOLHER BOT PRONTO ===
escolher_bot_pronto() {
    AMBIENTE_PATH=$1
    cabecalho
    anima_texto "ESCOLHER BOT PRONTO"
    echo -e "${CYAN}==============================================${NC}"
    echo -e "${GREEN}1${NC} - BOTS EM PORTUGUÊS"
    echo -e "${GREEN}2${NC} - BOTS EM ESPANHOL"
    echo -e "${RED}0${NC} - VOLTAR"
    echo -e "${CYAN}==============================================${NC}"

    read -p "> " OPCAO_BOT

    case $OPCAO_BOT in
        1)
            listar_bots "$AMBIENTE_PATH" "portugues"
            ;;
        2)
            listar_bots "$AMBIENTE_PATH" "espanhol"
            ;;
        0)
            menu_principal
            ;;
        *)
            echo -e "${RED}${CROSS_MARK} OPÇÃO INVÁLIDA.${NC}"
            sleep 2
            escolher_bot_pronto "$AMBIENTE_PATH"
            ;;
    esac
}

# === LISTAR BOTS DISPONÍVEIS ===
listar_bots() {
    AMBIENTE_PATH=$1
    LINGUA=$2

    cabecalho
    anima_texto "BOTS DISPONÍVEIS - ${LINGUA^^}"
    echo -e "${CYAN}==============================================${NC}"

    if [ "$LINGUA" = "portugues" ]; then
        BOTS=(
            "MORY BOT NOVO ATUALIZADO COM BOTOES - https://github.com/MauroSupera/morybot.git"
            "BLACK BOT - https://github.com/MauroSupera/blackbot.git"
            "YOSHINO BOT - https://github.com/MauroSupera/yoshinobot.git"
            "MIKASA ASCENDANCY V3 - https://github.com/maurogashfix/MikasaAscendancyv3.git"
            "INATSUKI BOT - https://github.com/MauroSupera/inatsukibot.git"
            "ESDEATH BOT - https://github.com/Salientekill/ESDEATHBOT.git"
            "CHRIS BOT - https://github.com/MauroSupera/chrisbot.git"
            "TAIGA BOT - https://github.com/MauroSupera/TAIGA-BOT3.git"
            "AGATHA BOT - https://github.com/MauroSupera/agathabotnew.git"
        )
    elif [ "$LINGUA" = "espanhol" ]; then
        BOTS=(
            "GATA BOT - https://github.com/GataNina-Li/GataBot-MD.git"
            "GATA BOT LITE - https://github.com/GataNina-Li/GataBotLite-MD.git"
            "KATASHI BOT - https://github.com/KatashiFukushima/KatashiBot-MD.git"
            "CURIOSITY BOT - https://github.com/AzamiJs/CuriosityBot-MD.git"
            "NOVA BOT - https://github.com/elrebelde21/NovaBot-MD.git"
            "MEGUMIN BOT - https://github.com/David-Chian/Megumin-Bot-MD"
            "YAEMORI BOT - https://github.com/OfcKing/SenkoBot-MD"
            "THEMYSTIC BOT - https://github.com/BrunoSobrino/TheMystic-Bot-MD.git"
        )
    fi

    for i in "${!BOTS[@]}"; do
        echo -e "${GREEN}$((i+1))${NC} - ${BOTS[$i]%% -*}"
    done

    echo -e "${RED}0${NC} - VOLTAR"
    echo -e "${CYAN}==============================================${NC}"

    read -p "> " BOT_ESCOLHIDO

    if [ "$BOT_ESCOLHIDO" -ge 1 ] && [ "$BOT_ESCOLHIDO" -le "${#BOTS[@]}" ]; then
        REPOSITORIO="${BOTS[$((BOT_ESCOLHIDO-1))]#*- }"
        verificar_instalacao_bot "$AMBIENTE_PATH" "$REPOSITORIO"
    elif [ "$BOT_ESCOLHIDO" = "0" ]; then
        escolher_bot_pronto "$AMBIENTE_PATH"
    else
        echo -e "${RED}${CROSS_MARK} OPÇÃO INVÁLIDA.${NC}"
        sleep 2
        listar_bots "$AMBIENTE_PATH" "$LINGUA"
    fi
}

# ###########################################
# Função para verificar a instalação de um bot
# - Propósito: Checa se already exists um bot instalado no ambiente. Se sim, oferece a opção de substituí-lo.
# ###########################################
verificar_instalacao_bot() {
    AMBIENTE_PATH=$1
    REPOSITORIO=$2

    if [ -f "${AMBIENTE_PATH}/package.json" ]; then
        echo -e "${YELLOW}Já existe um bot instalado neste ambiente.${NC}"
        echo -e "${YELLOW}Deseja remover o bot existente para instalar o novo? (sim/não)${NC}"
        read -p "> " RESPOSTA
        if [ "$RESPOSTA" = "sim" ]; then
            # Ativa a flag antes de chamar remover_bot
            CHAMADA_VERIFICAR_INSTALACAO=true
            remover_bot "$AMBIENTE_PATH"
            # Desativa a flag após a remoção
            CHAMADA_VERIFICAR_INSTALACAO=false
            # Instala o novo bot
            instalar_novo_bot "$AMBIENTE_PATH" "$REPOSITORIO"
        else
            echo -e "${RED}Retornando ao menu principal...${NC}"
            menu_principal
        fi
    else
        # Se não há bot instalado, instala diretamente
        instalar_novo_bot "$AMBIENTE_PATH" "$REPOSITORIO"
    fi
}
# ###########################################
# Função para instalar um novo bot
# - Propósito: Clona o repositório do bot e verifica os módulos necessários para instalação.
# - Editar: Não é necessário editar a lógica. Apenas ajuste as mensagens, se necessário.
# ###########################################
instalar_novo_bot() {
    AMBIENTE_PATH=$1
    REPOSITORIO=$2
    NOME_BOT=$(basename "$REPOSITORIO" .git)

    echo -e "${CYAN}Iniciando a instalação do bot: ${GREEN}$NOME_BOT${NC}..."
    git clone "$REPOSITORIO" "$AMBIENTE_PATH" 2>/dev/null
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Bot $NOME_BOT instalado com sucesso no ambiente $AMBIENTE_PATH!${NC}"
        verificar_node_modules "$AMBIENTE_PATH"
    else
        echo -e "${RED}Erro ao clonar o repositório do bot $NOME_BOT. Verifique a URL e tente novamente.${NC}"
        gerenciar_ambiente "$(basename "$AMBIENTE_PATH" | sed 's/ambiente//')"
    fi
}

# ###########################################
# Função para verificar e instalar módulos Node.js
# - Propósito: Certifica-se de que todos os módulos necessários estejam instalados.
# - Editar: Apenas ajuste as mensagens, se necessário.
# ###########################################
verificar_node_modules() {
    AMBIENTE_PATH=$1

    if [ ! -d "${AMBIENTE_PATH}/node_modules" ]; then
        echo -e "${YELLOW}Módulos não instalados neste bot.${NC}"
        echo -e "${YELLOW}Escolha uma opção para instalação:${NC}"
        echo -e "${GREEN}1 - npm install${NC}"
        echo -e "${GREEN}2 - yarn install${NC}"
        echo -e "${RED}0 - Voltar${NC}"
        read -p "> " OPCAO_MODULOS

        case $OPCAO_MODULOS in
            1)
                echo -e "${CYAN}Instalando módulos com npm...${NC}"
                cd "$AMBIENTE_PATH" && npm install
                if [ $? -eq 0 ]; then
                    echo -e "${GREEN}Módulos instalados com sucesso!${NC}"
                else
                    echo -e "${RED}Erro ao instalar módulos com npm.${NC}"
                fi
                ;;
            2)
                echo -e "${CYAN}Instalando módulos com yarn...${NC}"
                cd "$AMBIENTE_PATH" && yarn
                if [ $? -eq 0 ]; then
                    echo -e "${GREEN}Módulos instalados com sucesso!${NC}"
                else
                    echo -e "${RED}Erro ao instalar módulos com yarn.${NC}"
                fi
                ;;
            0)
                gerenciar_ambiente "$(basename "$AMBIENTE_PATH" | sed 's/ambiente//')"
                ;;
            *)
                echo -e "${RED}Opção inválida.${NC}"
                verificar_node_modules "$AMBIENTE_PATH"
                ;;
        esac
    else
        echo -e "${GREEN}Todos os módulos necessários já estão instalados.${NC}"
    fi

    # Redireciona para o menu do ambiente após a instalação
    gerenciar_ambiente "$(basename "$AMBIENTE_PATH" | sed 's/ambiente//')"
}

# ###########################################
# Função para remover bot atual
# - Propósito: Remove todos os arquivos do ambiente para liberar espaço para outro bot.
# - Editar: Apenas ajuste as mensagens, se necessário.
# ###########################################
remover_bot() {
    AMBIENTE_PATH=$1

    if [ -f "${AMBIENTE_PATH}/package.json" ]; then
        echo -e "${YELLOW}Bot detectado neste ambiente.${NC}"
        echo -e "${RED}Deseja realmente remover o bot atual? (sim/não)${NC}"
        read -p "> " CONFIRMAR
        if [ "$CONFIRMAR" = "sim" ]; then
            # Remove todos os arquivos do ambiente
            find "$AMBIENTE_PATH" -mindepth 1 -exec rm -rf {} + 2>/dev/null
            
            # Verifica se o diretório está vazio após a remoção
            if [ -z "$(ls -A "$AMBIENTE_PATH")" ]; then
                echo -e "${GREEN}Bot removido com sucesso.${NC}"
                gerenciar_ambiente "$(basename "$AMBIENTE_PATH" | sed 's/ambiente//')"
                
                # Verifica se foi chamada por verificar_instalacao_bot
                if [ "$CHAMADA_VERIFICAR_INSTALACAO" = false ]; then
                    # Retorna ao menu do ambiente
                    AMBIENTE_NUM=$(basename "$AMBIENTE_PATH" | sed 's/ambiente//')
                    gerenciar_ambiente "$AMBIENTE_NUM"
                fi
            else
                echo -e "${RED}Erro ao remover o bot.${NC}"
            fi
        else
            echo -e "${RED}Remoção cancelada.${NC}"
        fi
    else
        echo -e "${RED}Nenhum bot encontrado neste ambiente.${NC}"
    fi

    # Se não for chamada por verificar_instalacao_bot, retorna ao menu principal
    if [ "$CHAMADA_VERIFICAR_INSTALACAO" = false ]; then
        AMBIENTE_NUM=$(basename "$AMBIENTE_PATH" | sed 's/ambiente//')
        gerenciar_ambiente "$AMBIENTE_NUM"
    fi
}
# ###########################################
# Função para clonar repositório
# - Propósito: Permite clonar repositórios públicos e privados no ambiente.
# ###########################################
clonar_repositorio() {
    AMBIENTE_PATH=$1

    echo -e "${CYAN}======================================${NC}"
    anima_texto "CLONAR REPOSITÓRIO"
    echo -e "${CYAN}======================================${NC}"

    echo -e "${YELLOW}1 - Clonar repositório público${NC}"
    echo -e "${YELLOW}2 - Clonar repositório privado${NC}"
    echo -e "${RED}0 - Voltar ao menu do ambiente${NC}"
    read -p "> " OPCAO_CLONAR

    case $OPCAO_CLONAR in
        1)
            echo -e "${CYAN}Forneça a URL do repositório público:${NC}"
            read -p "> " URL_REPOSITORIO
            if [[ $URL_REPOSITORIO != https://github.com/* ]]; then
                echo -e "${RED}URL inválida! Certifique-se de fornecer uma URL válida do GitHub.${NC}"
                clonar_repositorio "$AMBIENTE_PATH"
                return
            fi
            echo -e "${CYAN}Clonando repositório público...${NC}"
            git clone "$URL_REPOSITORIO" "$AMBIENTE_PATH" 2>/dev/null
            if [ $? -eq 0 ]; then
                echo -e "${GREEN}✅ Repositório clonado com sucesso!${NC}"
            else
                echo -e "${RED}❌ Erro ao clonar o repositório. Verifique a URL e tente novamente.${NC}"
            fi
            ;;
        2)
            echo -e "${CYAN}Forneça a URL do repositório privado:${NC}"
            read -p "> " URL_REPOSITORIO
            echo -e "${CYAN}Usuário do GitHub:${NC}"
            read -p "> " USERNAME
            echo -e "${CYAN}Forneça o token de acesso (mantenha-o seguro):${NC}"
            read -s -p "> " TOKEN
            echo
            GIT_URL="https://${USERNAME}:${TOKEN}@$(echo $URL_REPOSITORIO | cut -d/ -f3-)"
            echo -e "${CYAN}Clonando repositório privado...${NC}"
            git clone "$GIT_URL" "$AMBIENTE_PATH" 2>/dev/null
            if [ $? -eq 0 ]; then
                echo -e "${GREEN}✅ Repositório privado clonado com sucesso!${NC}"
            else
                echo -e "${RED}❌ Erro ao clonar o repositório privado. Verifique suas credenciais e tente novamente.${NC}"
            fi
            ;;
        0)
            gerenciar_ambiente "$(basename "$AMBIENTE_PATH" | sed 's/ambiente//')"
            ;;
        *)
            echo -e "${RED}❌ Opção inválida. Tente novamente.${NC}"
            clonar_repositorio "$AMBIENTE_PATH"
            ;;
    esac

    # Redireciona ao menu do ambiente após a operação
    gerenciar_ambiente "$(basename "$AMBIENTE_PATH" | sed 's/ambiente//')"
}

# ###########################################
# Função para o menu pós-clone
# - Propósito: Permite que o usuário escolha o que fazer após clonar um repositório.
# ###########################################
pos_clone_menu() {
    AMBIENTE_PATH=$1

    echo -e "${CYAN}======================================${NC}"
    anima_texto "O QUE VOCÊ DESEJA FAZER AGORA?"
    echo -e "${CYAN}======================================${NC}"

    echo -e "${YELLOW}1 - Executar o bot${NC}"
    echo -e "${YELLOW}2 - Instalar módulos${NC}"
    echo -e "${RED}0 - Voltar ao menu do ambiente${NC}"
    read -p "> " OPCAO_POS_CLONE

    case $OPCAO_POS_CLONE in
        1)
            iniciar_bot "$AMBIENTE_PATH"
            ;;
        2)
            instalar_modulos "$AMBIENTE_PATH"
            ;;
        0)
            gerenciar_ambiente "$(basename "$AMBIENTE_PATH" | sed 's/ambiente//')"
            ;;
        *)
            echo -e "${RED}❌ Opção inválida. Tente novamente.${NC}"
            pos_clone_menu "$AMBIENTE_PATH"
            ;;
    esac
}

# ###########################################
# Função para instalar módulos
# - Propósito: Garante que as dependências necessárias para o bot sejam instaladas.
# ###########################################
instalar_modulos() {
    AMBIENTE_PATH=$1

    echo -e "${CYAN}======================================${NC}"
    anima_texto "INSTALAR MÓDULOS"
    echo -e "${CYAN}======================================${NC}"

    echo -e "${YELLOW}1 - Instalar com npm install${NC}"
    echo -e "${YELLOW}2 - Instalar com yarn install${NC}"
    echo -e "${RED}0 - Voltar ao menu do ambiente${NC}"
    read -p "> " OPCAO_MODULOS

    case $OPCAO_MODULOS in
        1)
            echo -e "${CYAN}Instalando módulos com npm...${NC}"
            cd "$AMBIENTE_PATH" && npm install > /dev/null 2>&1
            if [ $? -eq 0 ]; then
                echo -e "${GREEN}✅ Módulos instalados com sucesso!${NC}"
            else
                echo -e "${RED}❌ Erro ao instalar módulos com npm. Verifique o arquivo package.json.${NC}"
            fi
            ;;
        2)
            echo -e "${CYAN}Instalando módulos com yarn...${NC}"
            cd "$AMBIENTE_PATH" && yarn > /dev/null 2>&1
            if [ $? -eq 0 ]; then
                echo -e "${GREEN}✅ Módulos instalados com sucesso!${NC}"
            else
                echo -e "${RED}❌ Erro ao instalar módulos com yarn. Verifique o arquivo package.json.${NC}"
            fi
            ;;
        0)
            gerenciar_ambiente "$(basename "$AMBIENTE_PATH" | sed 's/ambiente//')"
            ;;
        *)
            echo -e "${RED}❌ Opção inválida. Tente novamente.${NC}"
            instalar_modulos "$AMBIENTE_PATH"
            ;;
    esac

    # Redireciona ao menu do ambiente após a operação
    gerenciar_ambiente "$(basename "$AMBIENTE_PATH" | sed 's/ambiente//')"
}

# ###########################################
# Função para iniciar o bot
# - Propósito: Inicia o bot com base nas configurações do ambiente.
# ###########################################
iniciar_bot() {
    AMBIENTE_PATH=$1

    # Exibe as opções de inicialização
    echo -e "${CYAN}Escolha como deseja iniciar o bot:${NC}"
    echo -e "${GREEN}1 - Inicialização padrão - npm start${NC}"
    echo -e "${GREEN}2 - Especificar arquivo (ex: index.js ou start.sh)${NC}"
    echo -e "${GREEN}3 - Instalar módulos e executar o bot${NC}"
    echo -e "${GREEN}4 - Instalar módulos específicos e executar o bot${NC}"
    echo -e "${YELLOW}5 - Ativar bot em segundo plano (background) [SOFREU ATUALIZAÇÃO]${NC}"
    echo -e "${RED}0 - Voltar${NC}"
    read -p "> " INICIAR_OPCAO

    case $INICIAR_OPCAO in
        1)
            COMANDO="npm start"
            ;;
        2)
            echo -e "${YELLOW}Digite o nome do arquivo para executar:${NC}"
            read ARQUIVO
            if [[ $ARQUIVO == *.sh ]]; then
                COMANDO="sh $ARQUIVO"
            else
                COMANDO="node $ARQUIVO"
            fi
            ;;
        3)
            verificar_node_modules "$AMBIENTE_PATH"
            COMANDO="npm start"
            ;;
        4)
            instalar_modulos_especificos "$AMBIENTE_PATH"
            COMANDO="npm start"
            ;;
        5)
            echo -e "${YELLOW}Ativando bot em segundo plano...${NC}"
COMANDO="npm start"

# Salvar o comando no arquivo .session (essa é a parte crucial)
echo "$COMANDO" > "${AMBIENTE_PATH}/.session"

# Já que o sistema usa o arquivo .session para execução,
# precisamos garantir que o processo anterior seja encerrado
if [ -f "${AMBIENTE_PATH}/.pid" ]; then
    OLD_PID=$(cat "${AMBIENTE_PATH}/.pid")
    kill -0 "$OLD_PID" >/dev/null 2>&1 || true
    kill -15 "$OLD_PID" >/dev/null 2>&1 || true
    rm "${AMBIENTE_PATH}/.pid" 2>/dev/null || true
fi

# Executar o comando diretamente para garantir compatibilidade com o painel
cd "$AMBIENTE_PATH" || { 
    echo -e "${RED}Não foi possível acessar o diretório.${NC}"; 
    return 1; 
}

# Iniciar o processo em segundo plano conforme esperado pelo sistema
nohup $COMANDO > "nohup.out" 2>&1 &
PID=$!

# Registrar o PID para controle
echo "$PID" > "${AMBIENTE_PATH}/.pid"

# Atualizar status e informar ao usuário
atualizar_status "$AMBIENTE_PATH" "ON"
echo -e "${GREEN}Bot ativado em segundo plano com sucesso!${NC}"
echo -e "${YELLOW}PID: $PID - Comando: $COMANDO${NC}"

# Esperar um momento para garantir que a mensagem seja visível
sleep 2

# Voltar ao menu de gerenciamento
gerenciar_ambiente "$(basename "$AMBIENTE_PATH" | sed 's/ambiente//')"
return
            ;;
        0)
            gerenciar_ambiente "$(basename "$AMBIENTE_PATH" | sed 's/ambiente//')"
            return
            ;;
        *)
            echo -e "${RED}Opção inválida.${NC}"
            iniciar_bot "$AMBIENTE_PATH"
            return
            ;;
    esac

    # Executa o bot em primeiro plano para permitir interação inicial
    echo -e "${CYAN}Iniciando o bot... Aguarde o QR Code ou outras instruções.${NC}"
    cd "$AMBIENTE_PATH" || return
    eval "$COMANDO"  # Executa o bot em primeiro plano

    # Após a execução do bot, retorna ao menu principal
    echo -e "${YELLOW}Pressione Enter para voltar ao menu principal...${NC}"
    read
    gerenciar_ambiente "$(basename "$AMBIENTE_PATH" | sed 's/ambiente//')"
}
# ###########################################
# Função para instalar módulos específicos
# - Propósito: Permite ao usuário instalar pacotes personalizados separados por vírgula.
# ###########################################
instalar_modulos_especificos() {
    AMBIENTE_PATH=$1

    echo -e "${CYAN}======================================${NC}"
    anima_texto "INSTALAR MÓDULOS ESPECÍFICOS"
    echo -e "${CYAN}======================================${NC}"

    echo -e "${YELLOW}Escolha o gerenciador de pacotes:${NC}"
    echo -e "${GREEN}1 - npm${NC}"
    echo -e "${GREEN}2 - yarn${NC}"
    echo -e "${RED}0 - Voltar${NC}"
    read -p "> " GERENCIADOR

    case $GERENCIADOR in
        1)
            GERENCIADOR_CMD="npm install"
            ;;
        2)
            GERENCIADOR_CMD="yarn add"
            ;;
        0)
            gerenciar_ambiente "$(basename "$AMBIENTE_PATH" | sed 's/ambiente//')"
            return
            ;;
        *)
            echo -e "${RED}❌ Opção inválida.${NC}"
            instalar_modulos_especificos "$AMBIENTE_PATH"
            return
            ;;
    esac

    echo -e "${YELLOW}Digite os pacotes que deseja instalar (separados por vírgula):${NC}"
    echo -e "${CYAN}Exemplo: express,lodash${NC}"
    read PACOTES

    # Converte os pacotes em um array
    IFS=',' read -ra PACOTES_ARRAY <<< "$PACOTES"

    echo -e "${CYAN}Verificando pacotes antes da instalação...${NC}"
    PACOTES_INVALIDOS=()
    for PACOTE in "${PACOTES_ARRAY[@]}"; do
        PACOTE=$(echo "$PACOTE" | xargs)  # Remove espaços extras
        if ! npm show "$PACOTE" > /dev/null 2>&1; then
            PACOTES_INVALIDOS+=("$PACOTE")
        fi
    done

    if [ ${#PACOTES_INVALIDOS[@]} -gt 0 ]; then
        echo -e "${RED}⚠️ Os seguintes pacotes não foram encontrados ou são inválidos:${NC}"
        for PACOTE in "${PACOTES_INVALIDOS[@]}"; do
            echo -e "${RED}- $PACOTE${NC}"
        done
        echo -e "${YELLOW}Deseja continuar a instalação mesmo assim? (sim/não)${NC}"
        read -p "> " CONTINUAR
        if [ "$CONTINUAR" != "sim" ]; then
            echo -e "${RED}Instalação cancelada.${NC}"
            gerenciar_ambiente "$(basename "$AMBIENTE_PATH" | sed 's/ambiente//')"
            return
        fi
    fi

    echo -e "${CYAN}Instalando pacotes...${NC}"
    cd "$AMBIENTE_PATH" || return
    for PACOTE in "${PACOTES_ARRAY[@]}"; do
        PACOTE=$(echo "$PACOTE" | xargs)  # Remove espaços extras
        echo -e "${CYAN}Instalando $PACOTE...${NC}"
        if $GERENCIADOR_CMD "$PACOTE" > /dev/null 2>&1; then
            echo -e "${GREEN}✅ $PACOTE instalado com sucesso!${NC}"
        else
            echo -e "${RED}❌ Erro ao instalar $PACOTE.${NC}"
            echo -e "${YELLOW}Deseja forçar a instalação usando --force? (sim/não)${NC}"
            read -p "> " FORCAR
            if [ "$FORCAR" = "sim" ]; then
                echo -e "${CYAN}Forçando a instalação de $PACOTE...${NC}"
                if $GERENCIADOR_CMD "$PACOTE" --force > /dev/null 2>&1; then
                    echo -e "${GREEN}✅ $PACOTE instalado com sucesso usando --force.${NC}"
                else
                    echo -e "${RED}❌ Falha ao forçar a instalação de $PACOTE.${NC}"
                fi
            fi
        fi
    done

    echo -e "${YELLOW}Deseja voltar ao menu do ambiente? (sim/não)${NC}"
    read -p "> " VOLTAR
    if [ "$VOLTAR" = "sim" ]; then
        gerenciar_ambiente "$(basename "$AMBIENTE_PATH" | sed 's/ambiente//')"
    else
        instalar_modulos_especificos "$AMBIENTE_PATH"
    fi
}
# ###########################################
# Função para parar o bot
# - Propósito: Finaliza o processo do bot em execução em segundo plano.
# ###########################################
# Função para forçar atualização de estado do script
atualizar_estado() {
    # Cria um arquivo de flag para indicar que precisamos recarregar o estado
    echo "1" > "${BASE_DIR}/.reload_needed"
    echo -e "${YELLOW}Estado do script marcado para atualização na próxima chamada do menu.${NC}"
}

# Função para verificar se precisa recarregar o estado
verificar_atualizacao_estado() {
    if [ -f "${BASE_DIR}/.reload_needed" ]; then
        echo -e "${CYAN}======================================${NC}"
        anima_texto "ATUALIZANDO ESTADO DO SCRIPT"
        echo -e "${CYAN}======================================${NC}"
        
        echo -e "${YELLOW}Recarregando estado dos ambientes...${NC}"
        
        # Remove a flag de recarga
        rm -f "${BASE_DIR}/.reload_needed"
        
        # Força verificação de todos os estados dos bots
        verificar_sessoes
        
        echo -e "${GREEN}Estado do script atualizado com sucesso!${NC}"
        sleep 1
    fi
}

# Modificação da função parar_bot
parar_bot() {
    AMBIENTE_PATH=$1

    echo -e "${CYAN}======================================${NC}"
    anima_texto "PARAR O BOT"
    echo -e "${CYAN}======================================${NC}"

    # Verifica se há uma sessão ativa
    if [ -f "${AMBIENTE_PATH}/.session" ]; then
        COMANDO=$(cat "${AMBIENTE_PATH}/.session")
        
        # Verifica se existe um PID registrado
        if [ -f "${AMBIENTE_PATH}/.pid" ]; then
            PID=$(cat "${AMBIENTE_PATH}/.pid")
            
            # Verifica se o processo ainda está rodando
            if kill -0 "$PID" >/dev/null 2>&1; then
                echo -e "${YELLOW}Finalizando o processo do bot (PID: $PID)...${NC}"
                
                # Envia sinal TERM e depois força com KILL se necessário
                kill -15 "$PID" >/dev/null 2>&1
                sleep 2
                
                # Verifica se o processo ainda está rodando após o TERM
                if kill -0 "$PID" >/dev/null 2>&1; then
                    echo -e "${YELLOW}Processo ainda em execução, forçando finalização...${NC}"
                    kill -9 "$PID" >/dev/null 2>&1
                fi
                
                echo -e "${GREEN}Processo do bot finalizado. Reinicie o servidor para dar efeito${NC}"
            else
                echo -e "${YELLOW}O processo (PID: $PID) não está mais em execução.${NC}"
            fi
            
            # Remove o arquivo PID
            rm -f "${AMBIENTE_PATH}/.pid"
        else
            echo -e "${YELLOW}Nenhum PID registrado. Tentando finalizar pelo comando...${NC}"
            pkill -f "$COMANDO" 2>/dev/null
        fi

        # Remove os arquivos de sessão e logs
        rm -f "${AMBIENTE_PATH}/.session"
        echo -e "${YELLOW}Arquivo de sessão removido.${NC}"
        
        # Atualiza o status para OFF
        atualizar_status "$AMBIENTE_PATH" "OFF"
        
        # Marca para atualização de estado
        atualizar_estado

        echo -e "${GREEN}Bot parado com sucesso.${NC}"
    else
        echo -e "${RED}Nenhuma sessão ativa encontrada para parar.${NC}"
    fi

    # Retorna ao menu do ambiente
    gerenciar_ambiente "$(basename "$AMBIENTE_PATH" | sed 's/ambiente//')"
}
# ###########################################
# Função para reiniciar o bot
# - Propósito: Reinicia o processo do bot com base nas configurações do ambiente.
# ###########################################
reiniciar_bot() {
    AMBIENTE_PATH=$1

    echo -e "${CYAN}======================================${NC}"
    anima_texto "REINICIAR O BOT"
    echo -e "${CYAN}======================================${NC}"

    # Verifica se há uma sessão ativa e salva o comando original
    COMANDO=""
    if [ -f "${AMBIENTE_PATH}/.session" ]; then
        COMANDO=$(cat "${AMBIENTE_PATH}/.session")
        echo -e "${YELLOW}Encontrada sessão com comando: $COMANDO${NC}"
        
        # Se existe um PID registrado, usa ele para matar o processo
        if [ -f "${AMBIENTE_PATH}/.pid" ]; then
            PID=$(cat "${AMBIENTE_PATH}/.pid")
            
            # Verifica se o processo ainda está rodando
            if kill -0 "$PID" >/dev/null 2>&1; then
                echo -e "${YELLOW}Parando o processo atual (PID: $PID)...${NC}"
                
                # Envia sinal TERM e depois força com KILL se necessário
                kill -15 "$PID" >/dev/null 2>&1
                sleep 2
                
                # Verifica se o processo ainda está rodando após o TERM
                if kill -0 "$PID" >/dev/null 2>&1; then
                    echo -e "${YELLOW}Processo ainda em execução, forçando finalização...${NC}"
                    kill -9 "$PID" >/dev/null 2>&1
                fi
                
                echo -e "${GREEN}Processo parado com sucesso.${NC}"
            else
                echo -e "${YELLOW}O processo (PID: $PID) não está mais em execução.${NC}"
            fi
            
            # Remove o arquivo PID (será recriado ao iniciar)
            rm -f "${AMBIENTE_PATH}/.pid"
        else
            echo -e "${YELLOW}Nenhum PID registrado. Tentando finalizar pelo comando...${NC}"
            pkill -f "$COMANDO" 2>/dev/null
        fi
    else
        echo -e "${RED}Nenhuma sessão ativa encontrada para reiniciar.${NC}"
        echo -e "${YELLOW}Iniciando com o comando padrão (npm start)...${NC}"
        COMANDO="npm start"
    fi

    # Se não temos um comando válido, use o padrão
    if [ -z "$COMANDO" ]; then
        echo -e "${YELLOW}Nenhum comando encontrado. Usando comando padrão (npm start)...${NC}"
        COMANDO="npm start"
    fi

    # Muda para o diretório correto
    cd "$AMBIENTE_PATH" || { 
        echo -e "${RED}Não foi possível acessar o diretório.${NC}"; 
        return 1; 
    }
    
    # Inicia o processo em segundo plano com o comando recuperado
    echo -e "${YELLOW}Reiniciando o bot com o comando: $COMANDO${NC}"
    nohup $COMANDO > "${AMBIENTE_PATH}/nohup.out" 2>&1 &
    NEW_PID=$!
    
    # Registra o novo PID
    echo "$NEW_PID" > "${AMBIENTE_PATH}/.pid"
    
    # Garante que o comando esteja salvo no arquivo .session
    echo "$COMANDO" > "${AMBIENTE_PATH}/.session"

    # Atualiza o status para ON
    atualizar_status "$AMBIENTE_PATH" "ON"

    echo -e "${GREEN}Bot reiniciado com sucesso!${NC}"
    echo -e "${YELLOW}PID: $NEW_PID${NC}"

    # Esperar um momento para garantir que a mensagem seja visível
    sleep 2

    # Retorna ao menu do ambiente
    gerenciar_ambiente "$(basename "$AMBIENTE_PATH" | sed 's/ambiente//')"
}
# ###########################################
# Função para visualizar o terminal
# - Propósito: Permite visualizar os logs gerados pelo bot.
# - Editar:
#   * Ajustar mensagens exibidas.
#   * Não alterar a lógica para evitar erros ao acessar os logs.
# ###########################################
ver_terminal() {
    AMBIENTE_PATH=$1

    echo -e "${CYAN}======================================${NC}"
    anima_texto "VISUALIZAR O TERMINAL"
    echo -e "${CYAN}======================================${NC}"

    # Verifica se há uma sessão ativa
    if [ -f "${AMBIENTE_PATH}/.session" ]; then
        COMANDO=$(cat "${AMBIENTE_PATH}/.session")
        STATUS=$(recuperar_status "$AMBIENTE_PATH")

        if [ "$STATUS" = "ON" ]; then
            echo -e "${YELLOW}Uma sessão ativa foi encontrada. Finalizando a sessão antes de visualizar os logs...${NC}"
            pkill -f "$COMANDO" 2>/dev/null
            atualizar_status "$AMBIENTE_PATH" "OFF"
            sleep 2
        fi
    fi

    # Verifica se o arquivo de logs existe
    if [ -f "${AMBIENTE_PATH}/nohup.out" ]; then
        clear
        echo -e "${YELLOW}Visualizando os logs em tempo real. Pressione Ctrl+C para voltar ao menu.${NC}"
        echo -e "${CYAN}======================================${NC}"
        tail -f "${AMBIENTE_PATH}/nohup.out"

        # Após sair da visualização, retorna ao menu do ambiente
        echo -e "${CYAN}Saindo da visualização de logs...${NC}"
        gerenciar_ambiente "$(basename "$AMBIENTE_PATH" | sed 's/ambiente//')"
    else
        echo -e "${RED}Nenhuma saída encontrada para o terminal.${NC}"
        gerenciar_ambiente "$(basename "$AMBIENTE_PATH" | sed 's/ambiente//')"
    fi
}

# ###########################################
# Função para deletar a sessão
# - Propósito: Remove o arquivo de sessão associado ao bot e finaliza o processo em execução.
# ###########################################
deletar_sessao() {
    AMBIENTE_PATH=$1

    echo -e "${CYAN}======================================${NC}"
    anima_texto "DELETAR SESSÃO"
    echo -e "${CYAN}======================================${NC}"

    # Verifica se há uma sessão ativa
    if [ -f "${AMBIENTE_PATH}/.session" ]; then
        COMANDO=$(cat "${AMBIENTE_PATH}/.session")

        # Finaliza o processo do bot
        echo -e "${YELLOW}Finalizando o processo do bot...${NC}"
        pkill -f "$COMANDO" 2>/dev/null

        # Remove os arquivos de sessão e logs
        rm -f "${AMBIENTE_PATH}/.session"
        rm -f "${AMBIENTE_PATH}/nohup.out"

        # Atualiza o status para OFF
        atualizar_status "$AMBIENTE_PATH" "OFF"

        echo -e "${GREEN}Sessão deletada com sucesso.${NC}"
        echo -e "${YELLOW}Por favor, reinicie seu servidor para dar efeito.${NC}"
    else
        echo -e "${RED}Nenhuma sessão ativa encontrada para deletar.${NC}"
    fi

    # Retorna ao menu do ambiente
    gerenciar_ambiente "$(basename "$AMBIENTE_PATH" | sed 's/ambiente//')"
}

# ###########################################
# Função para obter o nome do ambiente
# - Propósito: Recupera o nome personalizado do ambiente a partir do arquivo JSON.
# ###########################################
obter_nome_ambiente() {
    AMBIENTE_NUM=$1
    
    # Verifica se o arquivo de nomes existe
    if [ -f "$NOMES_ARQUIVO" ]; then
        # Verifica se jq está instalado
        if command -v jq >/dev/null 2>&1; then
            # Usa jq para obter o nome do ambiente
            NOME=$(jq -r ".ambiente$AMBIENTE_NUM" "$NOMES_ARQUIVO" 2>/dev/null)
            # Se o nome for null ou o ambiente não existir no arquivo, retorna vazio
            if [ "$NOME" = "null" ]; then
                echo ""
            else
                echo "$NOME"
            fi
        else
            # Fallback básico se jq não estiver disponível
            NOME=$(grep -o "\"ambiente$AMBIENTE_NUM\":\"[^\"]*\"" "$NOMES_ARQUIVO" 2>/dev/null | cut -d'"' -f4)
            echo "$NOME"
        fi
    else
        # Se o arquivo não existir, retorna vazio
        echo ""
    fi
}

# ###########################################
# Função para nomear ambientes
# - Propósito: Permite ao usuário atribuir nomes personalizados aos ambientes.
# ###########################################
nomear_ambientes() {
    cabecalho
    echo -e "${CYAN}======================================${NC}"
    anima_texto "       NOMEAR AMBIENTES"
    echo -e "${CYAN}======================================${NC}"
    
    echo -e "${YELLOW}Escolha uma opção:${NC}"
    echo -e "${GREEN}1${NC} - Nomear ambiente"
    echo -e "${GREEN}2${NC} - Renomear ambiente"
    echo -e "${GREEN}3${NC} - Remover nome do ambiente"
    echo -e "${RED}0${NC} - Voltar ao menu principal"
    echo -e "${CYAN}--------------------------------------${NC}"

    read -p "> " OPCAO_NOMEAR
    
    case $OPCAO_NOMEAR in
        1)
            # Nomear ambiente
            nomear_novo_ambiente
            ;;
        2)
            # Renomear ambiente
            renomear_ambiente
            ;;
        3)
            # Remover nome do ambiente
            remover_nome_ambiente
            ;;
        0) 
            # Voltar ao menu principal
            menu_principal
            ;;
        *) 
            echo -e "${RED}${CROSS_MARK} Opção inválida.${NC}"
            sleep 2
            nomear_ambientes
            ;;
    esac
}

# ###########################################
# Função para nomear um novo ambiente
# - Propósito: Atribui um nome a um ambiente que ainda não foi nomeado.
# ###########################################
nomear_novo_ambiente() {
    cabecalho
    echo -e "${CYAN}======================================${NC}"
    anima_texto "       NOMEAR NOVO AMBIENTE"
    echo -e "${CYAN}======================================${NC}"
    
    echo -e "${YELLOW}Escolha o ambiente (1-${NUM_AMBIENTES}):${NC}"
    for i in $(seq 1 $NUM_AMBIENTES); do
        NOME=$(obter_nome_ambiente $i)
        if [ -z "$NOME" ]; then
            echo -e "${GREEN}$i${NC} - Ambiente $i ${YELLOW}(Sem nome)${NC}"
        else
            echo -e "${GREEN}$i${NC} - Ambiente $i ${CYAN}(Nome atual: $NOME)${NC}"
        fi
    done
    echo -e "${RED}0${NC} - Voltar"
    
    read -p "> " AMBIENTE_ESCOLHIDO
    
    if [ "$AMBIENTE_ESCOLHIDO" = "0" ]; then
        nomear_ambientes
        return
    fi
    
    if [[ "$AMBIENTE_ESCOLHIDO" =~ ^[0-9]+$ ]] && [ "$AMBIENTE_ESCOLHIDO" -ge 1 ] && [ "$AMBIENTE_ESCOLHIDO" -le "$NUM_AMBIENTES" ]; then
        NOME_ATUAL=$(obter_nome_ambiente $AMBIENTE_ESCOLHIDO)
        
        if [ ! -z "$NOME_ATUAL" ]; then
            echo -e "${YELLOW}${WARNING} Este ambiente já possui um nome: ${CYAN}$NOME_ATUAL${NC}"
            echo -e "${YELLOW}Deseja renomeá-lo? (sim/não)${NC}"
            read -p "> " CONFIRMA
            
            if [ "$CONFIRMA" != "sim" ]; then
                nomear_ambientes
                return
            fi
        fi
        
        echo -e "${YELLOW}Forneça um nome para o Ambiente $AMBIENTE_ESCOLHIDO:${NC}"
        read -p "> " NOVO_NOME
        
        echo -e "${YELLOW}Nome escolhido: ${CYAN}$NOVO_NOME${NC}"
        echo -e "${YELLOW}Deseja editar ou salvar como está? (editar/salvar)${NC}"
        read -p "> " ACAO
        
        if [ "$ACAO" = "editar" ]; then
            echo -e "${YELLOW}Forneça o novo nome:${NC}"
            read -p "> " NOVO_NOME
        fi
        
        # Salva o nome no arquivo JSON
        salvar_nome_ambiente "$AMBIENTE_ESCOLHIDO" "$NOVO_NOME"
        
        echo -e "${GREEN}${CHECK_MARK} Nome do ambiente salvo com sucesso!${NC}"
        sleep 2
        nomear_ambientes
    else
        echo -e "${RED}${CROSS_MARK} Ambiente inválido.${NC}"
        sleep 2
        nomear_novo_ambiente
    fi
}

# ###########################################
# Função para renomear um ambiente
# - Propósito: Altera o nome de um ambiente já nomeado.
# ###########################################
renomear_ambiente() {
    cabecalho
    echo -e "${CYAN}======================================${NC}"
    anima_texto "       RENOMEAR AMBIENTE"
    echo -e "${CYAN}======================================${NC}"
    
    echo -e "${YELLOW}Escolha o ambiente (1-${NUM_AMBIENTES}):${NC}"
    for i in $(seq 1 $NUM_AMBIENTES); do
        NOME=$(obter_nome_ambiente $i)
        if [ -z "$NOME" ]; then
            echo -e "${GREEN}$i${NC} - Ambiente $i ${YELLOW}(Sem nome)${NC}"
        else
            echo -e "${GREEN}$i${NC} - Ambiente $i ${CYAN}(Nome atual: $NOME)${NC}"
        fi
    done
    echo -e "${RED}0${NC} - Voltar"
    
    read -p "> " AMBIENTE_ESCOLHIDO
    
    if [ "$AMBIENTE_ESCOLHIDO" = "0" ]; then
        nomear_ambientes
        return
    fi
    
    if [[ "$AMBIENTE_ESCOLHIDO" =~ ^[0-9]+$ ]] && [ "$AMBIENTE_ESCOLHIDO" -ge 1 ] && [ "$AMBIENTE_ESCOLHIDO" -le "$NUM_AMBIENTES" ]; then
        NOME_ATUAL=$(obter_nome_ambiente $AMBIENTE_ESCOLHIDO)
        
        if [ -z "$NOME_ATUAL" ]; then
            echo -e "${YELLOW}${WARNING} Este ambiente não possui um nome ainda. Redirecionando para nomear...${NC}"
            sleep 2
            nomear_novo_ambiente
            return
        fi
        
        echo -e "${YELLOW}Nome atual: ${CYAN}$NOME_ATUAL${NC}"
        echo -e "${YELLOW}Forneça o novo nome para o Ambiente $AMBIENTE_ESCOLHIDO:${NC}"
        read -p "> " NOVO_NOME
        
        echo -e "${YELLOW}Novo nome escolhido: ${CYAN}$NOVO_NOME${NC}"
        echo -e "${YELLOW}Deseja editar ou salvar como está? (editar/salvar)${NC}"
        read -p "> " ACAO
        
        if [ "$ACAO" = "editar" ]; then
            echo -e "${YELLOW}Forneça o novo nome:${NC}"
            read -p "> " NOVO_NOME
        fi
        
        # Salva o nome no arquivo JSON
        salvar_nome_ambiente "$AMBIENTE_ESCOLHIDO" "$NOVO_NOME"
        
        echo -e "${GREEN}${CHECK_MARK} Nome do ambiente atualizado com sucesso!${NC}"
        sleep 2
        nomear_ambientes
    else
        echo -e "${RED}${CROSS_MARK} Ambiente inválido.${NC}"
        sleep 2
        renomear_ambiente
    fi
}

# ###########################################
# Função para remover o nome de um ambiente
# - Propósito: Remove o nome personalizado de um ambiente.
# ###########################################
remover_nome_ambiente() {
    cabecalho
    echo -e "${CYAN}======================================${NC}"
    anima_texto "       REMOVER NOME DO AMBIENTE"
    echo -e "${CYAN}======================================${NC}"
    
    echo -e "${YELLOW}Escolha o ambiente (1-${NUM_AMBIENTES}):${NC}"
    for i in $(seq 1 $NUM_AMBIENTES); do
        NOME=$(obter_nome_ambiente $i)
        if [ -z "$NOME" ]; then
            echo -e "${GREEN}$i${NC} - Ambiente $i ${YELLOW}(Sem nome)${NC}"
        else
            echo -e "${GREEN}$i${NC} - Ambiente $i ${CYAN}(Nome atual: $NOME)${NC}"
        fi
    done
    echo -e "${RED}0${NC} - Voltar"
    
    read -p "> " AMBIENTE_ESCOLHIDO
    
    if [ "$AMBIENTE_ESCOLHIDO" = "0" ]; then
        nomear_ambientes
        return
    fi
    
    if [[ "$AMBIENTE_ESCOLHIDO" =~ ^[0-9]+$ ]] && [ "$AMBIENTE_ESCOLHIDO" -ge 1 ] && [ "$AMBIENTE_ESCOLHIDO" -le "$NUM_AMBIENTES" ]; then
        NOME_ATUAL=$(obter_nome_ambiente $AMBIENTE_ESCOLHIDO)
        
        if [ -z "$NOME_ATUAL" ]; then
            echo -e "${YELLOW}${WARNING} Este ambiente não tem nenhum nome, sendo assim nenhuma alteração foi feita.${NC}"
            sleep 2
            nomear_ambientes
            return
        fi
        
        # Remove o nome do arquivo JSON
        salvar_nome_ambiente "$AMBIENTE_ESCOLHIDO" ""
        
        echo -e "${GREEN}${CHECK_MARK} Nome do ambiente removido com sucesso!${NC}"
        sleep 2
        nomear_ambientes
    else
        echo -e "${RED}${CROSS_MARK} Ambiente inválido.${NC}"
        sleep 2
        remover_nome_ambiente
    fi
}

# ###########################################
# Função para salvar o nome do ambiente no arquivo JSON
# - Propósito: Atualiza o arquivo JSON com os nomes dos ambientes.
# ###########################################
salvar_nome_ambiente() {
    AMBIENTE_NUM=$1
    NOME=$2
    
    # Cria o arquivo JSON caso não exista
    if [ ! -f "$NOMES_ARQUIVO" ]; then
        echo "{}" > "$NOMES_ARQUIVO"
    fi
    
    # Verifica se jq está instalado
    if command -v jq >/dev/null 2>&1; then
        # Usa jq para atualizar o nome do ambiente no arquivo JSON
        TEMP_FILE=$(mktemp)
        jq ".ambiente$AMBIENTE_NUM = \"$NOME\"" "$NOMES_ARQUIVO" > "$TEMP_FILE"
        mv "$TEMP_FILE" "$NOMES_ARQUIVO"
    else
        # Fallback básico se jq não estiver disponível
        CONTEUDO=$(cat "$NOMES_ARQUIVO")
        # Remove a entrada existente (se houver)
        CONTEUDO=$(echo "$CONTEUDO" | sed "s/\"ambiente$AMBIENTE_NUM\":\"[^\"]*\",//g" | sed "s/\"ambiente$AMBIENTE_NUM\":\"[^\"]*\"//g")
        # Remove a última chave
        CONTEUDO=${CONTEUDO%\}}
        # Adiciona a nova entrada
        if [ -z "$NOME" ]; then
            # Se o nome for vazio, não adiciona a entrada
            echo "${CONTEUDO}}" > "$NOMES_ARQUIVO"
        else
            # Se houver conteúdo, adiciona vírgula se necessário
            if [ "$CONTEUDO" != "{" ]; then
                CONTEUDO="${CONTEUDO},"
            fi
            echo "${CONTEUDO}\"ambiente$AMBIENTE_NUM\":\"$NOME\"}" > "$NOMES_ARQUIVO"
        fi
    fi
}

# === MENU PRINCIPAL ===
menu_principal() {
    cabecalho

    # Executa a verificação de sessões ao carregar o menu
    verificar_sessoes

    # Verifica automaticamente por atualizações
    verificar_atualizacoes
    verificar_atualizacao_estado
    echo -e "${CYAN}==============================================${NC}"
    echo -e "       GERENCIAMENTO DE SISTEMAS"
    echo -e "${CYAN}==============================================${NC}"

    # Exibe os ambientes configurados dinamicamente
    echo -e "${RED} ATUALIZAÇÃO: OPÇÃO 2 - Iniciar Bot Iniciar Bot depois 5 foi atualizada"
        echo -e "${GREEN} ATUALIZAÇÃO: Novas funçōes: Nomear Ambientes, Adicionar Ambientes e Remover Animações foram adicionadas no menu principal."

    for i in $(seq 1 $NUM_AMBIENTES); do
        AMBIENTE_PATH="${BASE_DIR}/ambiente${i}"
    STATUS=$(recuperar_status "$AMBIENTE_PATH")
        NOME=$(obter_nome_ambiente $i)

        # Define o indicador visual de status
    if [ "$STATUS" = "ON" ]; then
        INDICADOR_STATUS="${GREEN}●${NC}"
    else
        INDICADOR_STATUS="${RED}●${NC}"
    fi

        # Exibe o nome do ambiente, se existir
        if [ -z "$NOME" ]; then
            echo -e "${YELLOW}AMBIENTE ${i} | STATUS: ${INDICADOR_STATUS} (${STATUS})${NC}"
        else
            echo -e "${YELLOW}AMBIENTE ${i} - ${CYAN}${NOME}${NC} | STATUS: ${INDICADOR_STATUS} (${STATUS})${NC}"
        fi
    done

    echo -e "${CYAN}==============================================${NC}"
    echo -e "${YELLOW}ESCOLHA UMA OPÇÃO:${NC}"
    echo -e "${GREEN}1-${NUM_AMBIENTES}${NC} - ESCOLHA ENTRE 1-${NUM_AMBIENTES} PARA GERENCIAR UM AMBIENTE"
    echo -e "${YELLOW}N${NC} - NOMEAR AMBIENTES"
    echo -e "${YELLOW}C${NC} - CONFIGURAR AMBIENTES (ADICIONAR/REMOVER)"
    echo -e "${YELLOW}A${NC} - CONFIGURAR ANIMAÇÕES"
    echo -e "${YELLOW}AM${NC} - ATUALIZAÇÃO MANUAL"
    echo -e "${RED}0${NC} - REINICIAR CONTAINER"
    echo -e "${CYAN}==============================================${NC}"

    read -p "> " OPCAO_PRINCIPAL

    # Valida a escolha do usuário
    if [[ "$OPCAO_PRINCIPAL" =~ ^[0-9]+$ ]] && [ "$OPCAO_PRINCIPAL" -ge 1 ] && [ "$OPCAO_PRINCIPAL" -le "$NUM_AMBIENTES" ]; then
        # Gerenciar um ambiente específico
        gerenciar_ambiente "$OPCAO_PRINCIPAL"
    elif [[ "$OPCAO_PRINCIPAL" == "N" || "$OPCAO_PRINCIPAL" == "n" ]]; then
        # Nomear ambientes
        nomear_ambientes
    elif [[ "$OPCAO_PRINCIPAL" == "C" || "$OPCAO_PRINCIPAL" == "c" ]]; then
        # Configurar ambientes
        configurar_ambientes
    elif [[ "$OPCAO_PRINCIPAL" == "A" || "$OPCAO_PRINCIPAL" == "a" ]]; then
        # Configurar animações
        gerenciar_animacoes
    elif [[ "$OPCAO_PRINCIPAL" == "AM" || "$OPCAO_PRINCIPAL" == "am" ]]; then
        # Atualização manual
        aplicar_atualizacao_manual
    elif [[ "$OPCAO_PRINCIPAL" == "0" ]]; then
        # Reiniciar o container
        echo -e "${GREEN}CONTAINER REINICIADO COM SUCESSO!${NC}"
        exit 0
    else
        echo -e "${RED}${CROSS_MARK} ESCOLHA INVÁLIDA. TENTE NOVAMENTE.${NC}"
        sleep 2
        menu_principal
    fi
}

# ###########################################
# Função para verificar atualizações automáticas
# - Propósito: Verifica se há uma nova versão do script disponível.
# ###########################################
verificar_atualizacoes() {
    echo -e "${CYAN}======================================${NC}"
    echo -e "       VERIFICANDO ATUALIZAÇÕES"
    echo -e "${CYAN}======================================${NC}"

    # Obtém o conteúdo remoto do GitHub
    CONTEUDO_REMOTO=$(curl -s --max-time 5 "$URL_SCRIPT")
    if [ -z "$CONTEUDO_REMOTO" ]; then
        echo -e "${YELLOW}Não foi possível verificar atualizações. Tente novamente mais tarde.${NC}"
        return
    fi

    # Extrai a versão remota do conteúdo
    VERSAO_REMOTA=$(echo "$CONTEUDO_REMOTO" | grep -oP 'VERSAO_LOCAL="\K[0-9]+\.[0-9]+\.[0-9]+')
    if [ -z "$VERSAO_REMOTA" ]; then
        echo -e "${YELLOW}Não foi possível extrair a versão do arquivo remoto.${NC}"
        return
    fi

    echo -e "${CYAN}Versão Atual: ${GREEN}${VERSAO_LOCAL}${NC}"
    echo -e "${CYAN}Versão Disponível: ${GREEN}${VERSAO_REMOTA}${NC}"

    # Compara as versões
    if [ "$VERSAO_REMOTA" = "$VERSAO_LOCAL" ]; then
        echo -e "${GREEN}Você está usando a versão mais recente do nosso script.${NC}"
    elif [[ "$VERSAO_REMOTA" > "$VERSAO_LOCAL" ]]; then
        echo -e "${YELLOW}Nova atualização disponível! (${VERSAO_REMOTA})${NC}"
        echo -e "${YELLOW}Instalando atualização automaticamente...${NC}"
        aplicar_atualizacao_automatica
    else
        echo -e "${RED}Erro ao atualizar: A versão disponível (${VERSAO_REMOTA}) é menor que a versão atual (${VERSAO_LOCAL}).${NC}"
    fi
}

# ###########################################
# Função para aplicar atualizações automáticas
# - Propósito: Baixa a nova versão do script e substitui o atual.
# ###########################################
aplicar_atualizacao_automatica() {
    # Primeiro, faz backup do número de ambientes
    backup_num_ambientes
    
    echo -e "${CYAN}Baixando a nova versão do script...${NC}"
    curl -s -o "${BASE_DIR}/script_atualizado.sh" "$URL_SCRIPT"

    if [ $? -ne 0 ]; then
        echo -e "${RED}Erro ao baixar a nova versão do script.${NC}"
        menu_principal
        return
    fi

    echo -e "${CYAN}Substituindo o script atual...${NC}"
    mv "${BASE_DIR}/script_atualizado.sh" "$SCRIPT_PATH"
    chmod +x "$SCRIPT_PATH"

    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Atualização aplicada com sucesso!${NC}"
        echo -e "${YELLOW}Reiniciando o script para aplicar as alterações e restaurar configurações...${NC}"
        sleep 2
        # Ao reiniciar, a função restaurar_num_ambientes será chamada
        exec "$SCRIPT_PATH"
    else
        echo -e "${RED}Erro ao aplicar a atualização.${NC}"
    fi
}

# ###########################################
# Função para aplicar atualizações manuais
# - Propósito: Baixa a nova versão do script e substitui o atual.
# ###########################################
aplicar_atualizacao_manual() {
    echo -e "${CYAN}Verificando atualizações manuais...${NC}"

    # Obtém o conteúdo remoto do GitHub
    CONTEUDO_REMOTO=$(curl -s --max-time 5 "$URL_SCRIPT")
    if [ -z "$CONTEUDO_REMOTO" ]; then
        echo -e "${YELLOW}Não foi possível verificar atualizações. Tente novamente mais tarde.${NC}"
        return
    fi

    # Extrai a versão remota do conteúdo
    VERSAO_REMOTA=$(echo "$CONTEUDO_REMOTO" | grep -oP 'VERSAO_LOCAL="\K[0-9]+\.[0-9]+\.[0-9]+')
    if [ -z "$VERSAO_REMOTA" ]; then
        echo -e "${YELLOW}Não foi possível extrair a versão do arquivo remoto.${NC}"
        return
    fi

    echo -e "${CYAN}Versão Atual: ${GREEN}${VERSAO_LOCAL}${NC}"
    echo -e "${CYAN}Versão Disponível: ${GREEN}${VERSAO_REMOTA}${NC}"

    # Compara as versões
    if [ "$VERSAO_REMOTA" = "$VERSAO_LOCAL" ]; then
        echo -e "${GREEN}Você já está usando a versão mais recente do nosso script.${NC}"
        menu_principal
    elif [[ "$VERSAO_REMOTA" > "$VERSAO_LOCAL" ]]; then
        echo -e "${YELLOW}Nova atualização disponível! (${VERSAO_REMOTA})${NC}"
        echo -e "${YELLOW}Aplicando atualização manualmente...${NC}"
        # Primeiro, faz backup do número de ambientes
        backup_num_ambientes
        # Aplica a atualização
        echo -e "${CYAN}Baixando a nova versão do script...${NC}"
        curl -s -o "${BASE_DIR}/script_atualizado.sh" "$URL_SCRIPT"

        if [ $? -ne 0 ]; then
            echo -e "${RED}Erro ao baixar a nova versão do script.${NC}"
            menu_principal
            return
        fi

        echo -e "${CYAN}Substituindo o script atual...${NC}"
        mv "${BASE_DIR}/script_atualizado.sh" "$SCRIPT_PATH"
        chmod +x "$SCRIPT_PATH"

        if [ $? -eq 0 ]; then
            echo -e "${GREEN}Atualização aplicada com sucesso!${NC}"
            echo -e "${YELLOW}Reiniciando o script para aplicar as alterações e restaurar configurações...${NC}"
            sleep 2
            # Ao reiniciar, a função restaurar_num_ambientes será chamada
            exec "$SCRIPT_PATH"
        else
            echo -e "${RED}Erro ao aplicar a atualização.${NC}"
        fi
 else
        echo -e "${RED}Erro ao atualizar: A versão disponível (${VERSAO_REMOTA}) é menor que a versão atual (${VERSAO_LOCAL}).${NC}"
        menu_principal
    fi
}

# ###########################################
# Função para configurar ambientes
# - Propósito: Permite adicionar ou remover ambientes do sistema.
# ###########################################
configurar_ambientes() {
    cabecalho
    echo -e "${CYAN}======================================${NC}"
    anima_texto "       CONFIGURAR AMBIENTES"
    echo -e "${CYAN}======================================${NC}"
    
    echo -e "${YELLOW}Escolha uma opção:${NC}"
    echo -e "${GREEN}1${NC} - Adicionar Ambiente"
    echo -e "${GREEN}2${NC} - Remover Ambientes"
    echo -e "${RED}0${NC} - Voltar ao menu principal"
    echo -e "${CYAN}--------------------------------------${NC}"
    
    read -p "> " OPCAO_CONFIG
    
    case $OPCAO_CONFIG in
        1)
            # Adicionar ambiente
            adicionar_ambiente
            ;;
        2)
            # Remover ambientes
            remover_ambientes
            ;;
        0)
            # Voltar ao menu principal
            menu_principal
            ;;
        *)
            echo -e "${RED}${CROSS_MARK} Opção inválida.${NC}"
            sleep 2
            configurar_ambientes
            ;;
    esac
}

# ###########################################
# Função para adicionar um novo ambiente
# - Propósito: Cria novos ambientes no sistema e atualiza a configuração.
# ###########################################
adicionar_ambiente() {
    cabecalho
    echo -e "${CYAN}======================================${NC}"
    anima_texto "       ADICIONAR AMBIENTE"
    echo -e "${CYAN}======================================${NC}"
    
    echo -e "${YELLOW}Número atual de ambientes: ${CYAN}${NUM_AMBIENTES}${NC}"
    echo -e "${YELLOW}Digite quantos ambientes deseja adicionar:${NC}"
    read -p "> " QTD_ADICIONAR
    
    # Verifica se o input é um número válido
    if ! [[ "$QTD_ADICIONAR" =~ ^[0-9]+$ ]]; then
        echo -e "${RED}${CROSS_MARK} Por favor, digite um número válido.${NC}"
        sleep 2
        adicionar_ambiente
        return
    fi
    
    if [ "$QTD_ADICIONAR" -le 0 ]; then
        echo -e "${RED}${CROSS_MARK} O número de ambientes a adicionar deve ser maior que zero.${NC}"
        sleep 2
        adicionar_ambiente
        return
    fi
    
    # Calcula o novo número total de ambientes
    NOVO_NUM_AMBIENTES=$((NUM_AMBIENTES + QTD_ADICIONAR))
    
    echo -e "${YELLOW}Você tem certeza que deseja adicionar ${CYAN}${QTD_ADICIONAR}${YELLOW} ambiente(s)?${NC}"
    echo -e "${YELLOW}Total após adição: ${CYAN}${NOVO_NUM_AMBIENTES}${NC} ambiente(s)"
    echo -e "${GREEN}sim${NC} para confirmar ou ${RED}cancelar${NC} para voltar"
    read -p "> " CONFIRMA
    
    if [ "$CONFIRMA" = "sim" ]; then
        echo -e "${YELLOW}Criando novos ambientes...${NC}"
        
        # Cria as novas pastas de ambiente
        for i in $(seq $((NUM_AMBIENTES + 1)) $NOVO_NUM_AMBIENTES); do
            AMBIENTE_PATH="${BASE_DIR}/ambiente${i}"
            if [ ! -d "$AMBIENTE_PATH" ]; then
                mkdir -p "$AMBIENTE_PATH"
                echo -e "${GREEN}${CHECK_MARK} Environment folder ${i} created.${NC}"
            else
                echo -e "${YELLOW}${INFO} Environment folder ${i} already exists.${NC}"
            fi
        done
        
        # Atualiza a variável global
        NUM_AMBIENTES=$NOVO_NUM_AMBIENTES
        
        # Atualiza o valor no arquivo principal
        atualizar_num_ambientes_no_script
        
        echo -e "${GREEN}${CHECK_MARK} Ambientes adicionados com sucesso!${NC}"
        echo -e "${YELLOW}Novo total de ambientes: ${CYAN}${NUM_AMBIENTES}${NC}"
        sleep 2
        configurar_ambientes
    else
        echo -e "${YELLOW}Operação cancelada pelo usuário.${NC}"
        sleep 2
        configurar_ambientes
    fi
}

# ###########################################
# Função para remover ambientes
# - Propósito: Remove ambientes existentes do sistema.
# ###########################################
remover_ambientes() {
    cabecalho
    echo -e "${CYAN}======================================${NC}"
    anima_texto "       REMOVER AMBIENTES"
    echo -e "${CYAN}======================================${NC}"
    
    echo -e "${YELLOW}${WARNING} AVISO IMPORTANTE ${WARNING}${NC}"
    echo -e "${RED}Esta função permite remover ambientes do sistema.${NC}"
    echo -e "${YELLOW}Você pode remover ambientes das seguintes formas:${NC}"
    echo -e "${CYAN}• Digite um único número (ex: ${GREEN}3${CYAN}) para remover o ambiente 3${NC}"
    echo -e "${CYAN}• Use hífen para remover um intervalo (ex: ${GREEN}1-5${CYAN}) para remover ambientes de 1 a 5${NC}"
    echo -e "${CYAN}• Use vírgulas para múltiplos ambientes (ex: ${GREEN}2,5,7${CYAN}) para remover apenas esses ambientes${NC}"
    echo -e "${RED}${WARNING} ATENÇÃO: Todos os dados dos ambientes selecionados serão PERDIDOS PERMANENTEMENTE!${NC}"
    echo -e "${RED}${WARNING} Bots em execução nesses ambientes serão encerrados!${NC}"
    echo -e "${CYAN}--------------------------------------${NC}"
    echo -e "${GREEN}C${NC} - Continuar com a remoção"
    echo -e "${RED}V${NC} - Voltar ao menu anterior"
    read -p "> " ESCOLHA_REMOVER
    
    if [[ "$ESCOLHA_REMOVER" == "V" || "$ESCOLHA_REMOVER" == "v" ]]; then
        configurar_ambientes
        return
    elif [[ "$ESCOLHA_REMOVER" != "C" && "$ESCOLHA_REMOVER" != "c" ]]; then
        echo -e "${RED}${CROSS_MARK} Opção inválida.${NC}"
        sleep 2
        remover_ambientes
        return
    fi
    
    # Mostra os ambientes atuais
    cabecalho
    echo -e "${CYAN}======================================${NC}"
    anima_texto "       REMOVER AMBIENTES"
    echo -e "${CYAN}======================================${NC}"
    
    echo -e "${YELLOW}Ambientes disponíveis:${NC}"
    for i in $(seq 1 $NUM_AMBIENTES); do
        AMBIENTE_PATH="${BASE_DIR}/ambiente${i}"
        STATUS="OFF"
        if [ -f "${AMBIENTE_PATH}/status" ]; then
            STATUS=$(cat "${AMBIENTE_PATH}/status")
        fi
        
        NOME=$(obter_nome_ambiente $i)
        if [ -z "$NOME" ]; then
            echo -e "${GREEN}$i${NC} - Ambiente $i ${YELLOW}(Status: $STATUS)${NC}"
        else
            echo -e "${GREEN}$i${NC} - Ambiente $i - ${CYAN}$NOME${NC} ${YELLOW}(Status: $STATUS)${NC}"
        fi
    done
    
    echo -e "${CYAN}--------------------------------------${NC}"
    echo -e "${YELLOW}Digite os ambientes que deseja remover:${NC}"
    echo -e "${CYAN}(Formatos aceitos: ${GREEN}3${CYAN} ou ${GREEN}1-5${CYAN} ou ${GREEN}2,4,7${CYAN})${NC}"
    read -p "> " AMBIENTES_REMOVER
    
    # Verifica se o input está vazio
    if [ -z "$AMBIENTES_REMOVER" ]; then
        echo -e "${RED}${CROSS_MARK} Nenhum ambiente especificado.${NC}"
        sleep 2
        remover_ambientes
        return
    fi
    
    # Processa a entrada do usuário
    AMBIENTES_A_DELETAR=()
    
    # Caso seja um intervalo com hífen (ex: 1-5)
    if [[ "$AMBIENTES_REMOVER" =~ ^[0-9]+-[0-9]+$ ]]; then
        INICIO=$(echo "$AMBIENTES_REMOVER" | cut -d'-' -f1)
        FIM=$(echo "$AMBIENTES_REMOVER" | cut -d'-' -f2)
        
        if [ "$FIM" -gt "$NUM_AMBIENTES" ]; then
            echo -e "${RED}${CROSS_MARK} Você tem menos ambientes (${NUM_AMBIENTES}) que os citados (até ${FIM}).${NC}"
            echo -e "${YELLOW}Por favor, especifique um intervalo válido.${NC}"
            sleep 3
            remover_ambientes
            return
        fi
        
        for i in $(seq $INICIO $FIM); do
            AMBIENTES_A_DELETAR+=($i)
        done
        
        echo -e "${YELLOW}Você selecionou ambientes de ${CYAN}$INICIO${YELLOW} a ${CYAN}$FIM${YELLOW}.${NC}"
    
    # Caso sejam múltiplos valores separados por vírgula (ex: 2,5,7)
    elif [[ "$AMBIENTES_REMOVER" =~ ^[0-9]+(,[0-9]+)*$ ]]; then
        IFS=',' read -ra VALORES <<< "$AMBIENTES_REMOVER"
        
        for i in "${VALORES[@]}"; do
            if [ "$i" -gt "$NUM_AMBIENTES" ]; then
                echo -e "${YELLOW}${WARNING} Ambiente $i não existe e será ignorado.${NC}"
            else
                AMBIENTES_A_DELETAR+=($i)
            fi
        done
        
        if [ ${#AMBIENTES_A_DELETAR[@]} -eq 0 ]; then
            echo -e "${RED}${CROSS_MARK} Nenhum ambiente válido para remover.${NC}"
            sleep 2
            remover_ambientes
            return
        fi
        
        echo -e "${YELLOW}Você selecionou os ambientes: ${CYAN}${AMBIENTES_A_DELETAR[*]}${NC}"
    
    # Caso seja um único valor (ex: 3)
    elif [[ "$AMBIENTES_REMOVER" =~ ^[0-9]+$ ]]; then
        if [ "$AMBIENTES_REMOVER" -gt "$NUM_AMBIENTES" ]; then
            echo -e "${RED}${CROSS_MARK} The environment $AMBIENTES_REMOVER não existe.${NC}"
            sleep 2
            remover_ambientes
            return
        fi
        
        AMBIENTES_A_DELETAR+=($AMBIENTES_REMOVER)
        echo -e "${YELLOW}Você selecionou o ambiente: ${CYAN}$AMBIENTES_REMOVER${NC}"
    
    # Formato inválido
    else
        echo -e "${RED}${CROSS_MARK} Formato inválido. Use um número, um intervalo com hífen ou números separados por vírgula.${NC}"
        sleep 3
        remover_ambientes
        return
    fi
    
    # Confirmação final
    echo -e "${RED}${WARNING} ATENÇÃO: Esta ação não pode ser desfeita!${NC}"
    echo -e "${YELLOW}Tem certeza que deseja remover os ambientes selecionados? (sim/não)${NC}"
    read -p "> " CONFIRMA_FINAL
    
    if [ "$CONFIRMA_FINAL" != "sim" ]; then
        echo -e "${YELLOW}Operação cancelada pelo usuário.${NC}"
        sleep 2
        configurar_ambientes
        return
    fi
    
    # Procede com a remoção
    REMOVIDOS=0
    echo -e "${YELLOW}Removendo ambientes...${NC}"
    
    for AMBIENTE_NUM in "${AMBIENTES_A_DELETAR[@]}"; do
        AMBIENTE_PATH="${BASE_DIR}/ambiente${AMBIENTE_NUM}"
        
        # Verifica se o ambiente existe
        if [ ! -d "$AMBIENTE_PATH" ]; then
            echo -e "${YELLOW}${WARNING} Ambiente $AMBIENTE_NUM não existe ou já foi removido.${NC}"
            continue
        fi
        
        # Para quaisquer processos ativos neste ambiente
        if [ -f "${AMBIENTE_PATH}/.pid" ]; then
            PID=$(cat "${AMBIENTE_PATH}/.pid")
            if kill -0 "$PID" 2>/dev/null; then
                echo -e "${YELLOW}Encerrando processo ativo no ambiente $AMBIENTE_NUM...${NC}"
                kill -15 "$PID" 2>/dev/null
                sleep 1
                kill -9 "$PID" 2>/dev/null
            fi
        fi
        
        # Remove o diretório e seu conteúdo
        echo -e "${YELLOW}Removendo ambiente $AMBIENTE_NUM...${NC}"
        rm -rf "$AMBIENTE_PATH"
        
        if [ ! -d "$AMBIENTE_PATH" ]; then
            echo -e "${GREEN}${CHECK_MARK} Ambiente $AMBIENTE_NUM removido com sucesso.${NC}"
            REMOVIDOS=$((REMOVIDOS + 1))
        else
            echo -e "${RED}${CROSS_MARK} Erro ao remover ambiente $AMBIENTE_NUM.${NC}"
        fi
    done
    
    echo -e "${GREEN}${CHECK_MARK} $REMOVIDOS ambiente(s) removido(s) com sucesso.${NC}"
    
    # Decide se precisa reorganizar os ambientes
    echo -e "${YELLOW}Deseja reorganizar os números dos ambientes? (sim/não)${NC}"
    echo -e "${CYAN}(Isso renumerará os ambientes para eliminar lacunas na sequência)${NC}"
    read -p "> " REORGANIZAR
    
    if [ "$REORGANIZAR" = "sim" ]; then
        reorganizar_ambientes
    else
        # Apenas atualiza o número total, sem reorganizar
        NOVO_NUM_AMBIENTES=$(find "$BASE_DIR" -maxdepth 1 -type d -name "ambiente*" | wc -l)
        NUM_AMBIENTES=$NOVO_NUM_AMBIENTES
        
        # Atualiza o valor no arquivo do script
        atualizar_num_ambientes_no_script
        
        echo -e "${YELLOW}Número total de ambientes atualizado: ${CYAN}$NUM_AMBIENTES${NC}"
    fi
    
    sleep 2
    configurar_ambientes
}

# ###########################################
# Função para reorganizar ambientes
# - Propósito: Renumera os ambientes após remoções para eliminar lacunas.
# ###########################################
reorganizar_ambientes() {
    echo -e "${YELLOW}Reorganizando ambientes...${NC}"
    
    # Lista todos os diretórios de ambiente existentes
    AMBIENTES_EXISTENTES=($(find "$BASE_DIR" -maxdepth 1 -type d -name "ambiente*" | sort -V))
    TOTAL_EXISTENTES=${#AMBIENTES_EXISTENTES[@]}
    
    if [ $TOTAL_EXISTENTES -eq 0 ]; then
        echo -e "${YELLOW}Nenhum ambiente encontrado para reorganizar.${NC}"
        NUM_AMBIENTES=0
        atualizar_num_ambientes_no_script
        return
    fi
    
    # Cria diretório temporário para reorganização
    TEMP_DIR="${BASE_DIR}/temp_reorganizacao"
    mkdir -p "$TEMP_DIR"
    
    # Move os ambientes existentes para pastas temporárias numeradas sequencialmente
    NOVO_INDICE=1
    for AMBIENTE_PATH in "${AMBIENTES_EXISTENTES[@]}"; do
        AMBIENTE_NUM=$(basename "$AMBIENTE_PATH" | sed 's/ambiente//')
        
        # Se o número já está correto, pula
        if [ "$AMBIENTE_NUM" -eq "$NOVO_INDICE" ]; then
            echo -e "${YELLOW}Ambiente $AMBIENTE_NUM já está na posição correta.${NC}"
            NOVO_INDICE=$((NOVO_INDICE + 1))
            continue
        fi
        
        # Move para diretório temporário
        echo -e "${YELLOW}Renumerando: Ambiente $AMBIENTE_NUM → Ambiente $NOVO_INDICE${NC}"
        mv "$AMBIENTE_PATH" "${TEMP_DIR}/ambiente${NOVO_INDICE}"
        NOVO_INDICE=$((NOVO_INDICE + 1))
    done
    
    # Move os ambientes do diretório temporário de volta para o diretório base
    find "$TEMP_DIR" -maxdepth 1 -type d -name "ambiente*" -exec mv {} "$BASE_DIR/" \;
    
    # Remove o diretório temporário
    rm -rf "$TEMP_DIR"
    
    # Atualiza o número total de ambientes
    NUM_AMBIENTES=$((NOVO_INDICE - 1))
    
    # Atualiza o valor no arquivo do script
    atualizar_num_ambientes_no_script
    
    echo -e "${GREEN}${CHECK_MARK} Ambientes reorganizados com sucesso!${NC}"
    echo -e "${YELLOW}Novo total de ambientes: ${CYAN}$NUM_AMBIENTES${NC}"
}

# ###########################################
# Função para atualizar o número de ambientes no script
# - Propósito: Atualiza a variável NUM_AMBIENTES no arquivo do script.
# ###########################################
atualizar_num_ambientes_no_script() {
    # Certifica-se de que o caminho do script está correto
    if [ ! -f "$SCRIPT_PATH" ]; then
        echo -e "${RED}Erro: Não foi possível encontrar o arquivo do script em $SCRIPT_PATH${NC}"
        # Tenta encontrar o script no diretório base
        if [ -f "${BASE_DIR}/${SCRIPT_NOME}" ]; then
            SCRIPT_PATH="${BASE_DIR}/${SCRIPT_NOME}"
            echo -e "${YELLOW}Usando caminho alternativo: $SCRIPT_PATH${NC}"
        else
            echo -e "${RED}Não foi possível encontrar o script. A atualização do número de ambientes falhou.${NC}"
            return 1
        fi
    fi
    
    # Faz backup do script antes de modificar
    cp "$SCRIPT_PATH" "${SCRIPT_PATH}.bak"
    
    # Atualiza a variável NUM_AMBIENTES no arquivo do script
    sed -i "s/^NUM_AMBIENTES=.*$/NUM_AMBIENTES=$NUM_AMBIENTES # Número de ambientes que serão configurados./" "$SCRIPT_PATH"
    
    # Verifica se a alteração foi feita com sucesso
    if grep -q "NUM_AMBIENTES=$NUM_AMBIENTES" "$SCRIPT_PATH"; then
        echo -e "${GREEN}O número de ambientes foi atualizado para ${CYAN}$NUM_AMBIENTES${NC} no arquivo principal.${NC}"
        return 0
    else
        echo -e "${RED}Falha ao atualizar o número de ambientes no arquivo principal.${NC}"
        # Restaura o backup se a alteração falhou
        mv "${SCRIPT_PATH}.bak" "$SCRIPT_PATH"
        return 1
    fi
}
# ###########################################
# Função para gerenciar as animações iniciais
# - Propósito: Permite ao usuário pular ou ativar as animações iniciais do sistema.
# ###########################################
gerenciar_animacoes() {
    cabecalho
    echo -e "${CYAN}======================================${NC}"
    anima_texto "       GERENCIAR ANIMAÇÕES"
    echo -e "${CYAN}======================================${NC}"
    
    # Verifica o status atual da animação
    local STATUS_ATUAL="ON"
    if [ -f "${BASE_DIR}/animacao_status.json" ]; then
        STATUS_ATUAL=$(cat "${BASE_DIR}/animacao_status.json")
    fi
    
    echo -e "${YELLOW}Current status das animações: ${STATUS_ATUAL}${NC}"
    echo -e "${CYAN}--------------------------------------${NC}"
    echo -e "${YELLOW}Escolha uma opção:${NC}"
    echo -e "${GREEN}1${NC} - Pular animação inicial (Desativar)"
    echo -e "${GREEN}2${NC} - Ligar animação inicial (Ativar)"
    echo -e "${RED}0${NC} - Voltar ao menu principal"
    
    read -p "> " OPCAO_ANIMACAO
    
    case $OPCAO_ANIMACAO in
        1)
            echo "OFF" > "${BASE_DIR}/animacao_status.json"
            echo -e "${GREEN}${CHECK_MARK} Animações iniciais desativadas com sucesso!${NC}"
            echo -e "${YELLOW}Na próxima execução, o script irá diretamente para o menu principal.${NC}"
            sleep 2
            menu_principal
            ;;
        2)
            echo "ON" > "${BASE_DIR}/animacao_status.json"
            echo -e "${GREEN}${CHECK_MARK} Animações iniciais ativadas com sucesso!${NC}"
            echo -e "${YELLOW}Na próxima execução, todas as animações serão exibidas.${NC}"
            sleep 2
            menu_principal
            ;;
        0)
            menu_principal
            ;;
        *) 
            echo -e "${RED}${CROSS_MARK} Opção inválida.${NC}"
            sleep 2
            gerenciar_animacoes
            ;;
    esac
}

# ###########################################
# Função para verificar o status da animação
# - Propósito: Verifica se o usuário optou por pular as animações iniciais.
# ###########################################
verificar_status_animacao() {
    if [ -f "${BASE_DIR}/animacao_status.json" ]; then
        local STATUS=$(cat "${BASE_DIR}/animacao_status.json")
        if [ "$STATUS" = "OFF" ]; then
            return 1  # Animações desativadas
        fi
    fi
    return 0  # Animações ativadas (padrão)
}

# ###########################################
# Função principal para execução inicial
# - Propósito: Executa as etapas iniciais com ou sem animações.
# ###########################################
execucao_inicial() {
    # Define VALIDATED como false para evitar erros
    VALIDATED=false
    
    # Verifica se as animações estão ativadas
    verificar_status_animacao
    ANIMACOES_ATIVADAS=$?
    
    # Se as animações estiverem desativadas (OFF)
    if [ $ANIMACOES_ATIVADAS -eq 1 ]; then
        # Apenas verifica se os termos já foram aceitos (obrigatório)
        if [ ! -f "$TERMS_FILE" ]; then
            cabecalho
            echo -e "${BLUE}${INFO} This system is only allowed on the Arena Hosting platform.${NC}"
            echo -e "${CYAN}==============================================${NC}"
            
            while true; do
                echo -e "${YELLOW}${WARNING} DO YOU ACCEPT THE TERMS OF SERVICE? (SIM/NÃO)${NC}"
                read -p "> " ACEITE
                if [ "$ACEITE" = "sim" ]; then
                    echo -e "${GREEN}${CHECK_MARK} Terms accepted on $(date).${NC}" > "$TERMS_FILE"
                    echo -e "${CYAN}==============================================${NC}"
                    echo -e "${GREEN}${CHECK_MARK} TERMS ACCEPTED. CONTINUING...${NC}"
                    break
                elif [ "$ACEITE" = "não" ]; then
                    echo -e "${RED}${CROSS_MARK} YOU MUST ACCEPT THE TERMS TO CONTINUE.${NC}"
                else
                    echo -e "${RED}${CROSS_MARK} INVALID OPTION. TYPE 'YES' OR 'NO'.${NC}"
                fi
            done
        fi
        
        # Simula a validação para evitar erros, sem exibir animações
        if [ ! -f "firewall.json" ]; then
            echo '{"status": "skip"}' > firewall.json
        fi
        VALIDATED=true
        
        # Cria pastas se necessário (obrigatório, mas sem mensagens)
        for i in $(seq 1 $NUM_AMBIENTES); do
            AMBIENTE_PATH="${BASE_DIR}/ambiente${i}"
            if [ ! -d "$AMBIENTE_PATH" ]; then
                mkdir -p "$AMBIENTE_PATH"
            fi
        done
        
        # APENAS verificar_sessoes e menu_principal
        verificar_sessoes
        menu_principal
    else
        # Execução normal com todas as animações
        inicializar_gerenciador "$API_ESPERADA"
        
        if [ "$VALIDATED" = false ]; then
            validar_ambiente
        fi
        
exibir_termos
criar_pastas
        
verificar_sessoes
menu_principal
    fi
}

# ###########################################
# Função para verificação silenciosa de sessões
# - Propósito: Verifica e restaura sessões sem animações.
# ###########################################
verificar_sessoes_silencioso() {
    for i in $(seq 1 $NUM_AMBIENTES); do
        AMBIENTE_PATH="${BASE_DIR}/ambiente${i}"

        # Verifica se o arquivo .session existe
        if [ -f "${AMBIENTE_PATH}/.session" ]; then
            STATUS=$(recuperar_status "$AMBIENTE_PATH")
            
            # Verifica se o status é ON
            if [ "$STATUS" = "ON" ]; then
                COMANDO=$(cat "${AMBIENTE_PATH}/.session")
                if [ -n "$COMANDO" ]; then
                    # Verifica se o processo já está rodando
                    PROCESSO_JA_RODANDO=false
                    if [ -f "${AMBIENTE_PATH}/.pid" ]; then
                        OLD_PID=$(cat "${AMBIENTE_PATH}/.pid")
                        if kill -0 "$OLD_PID" >/dev/null 2>&1; then
                            PROCESSO_JA_RODANDO=true
                        fi
                    fi
                    
                    # Somente inicia se não estiver rodando
                    if [ "$PROCESSO_JA_RODANDO" = false ]; then
                        cd "$AMBIENTE_PATH" || continue
                        nohup $COMANDO > "${AMBIENTE_PATH}/nohup.out" 2>&1 &
                        NEW_PID=$!
                        echo "$NEW_PID" > "${AMBIENTE_PATH}/.pid"
                    fi
                fi
            fi
        fi
    done
}

# ###########################################
# Função para backup do número de ambientes
# - Propósito: Salva o número atual de ambientes em um arquivo de backup.
# ###########################################
backup_num_ambientes() {
    echo -e "${YELLOW}Criando backup do número de ambientes...${NC}"
    echo "$NUM_AMBIENTES" > "$BACKUP_NUM_AMBIENTES"
    echo -e "${GREEN}Backup do número de ambientes (${NUM_AMBIENTES}) criado com sucesso.${NC}"
}

# ###########################################
# Função para restaurar o número de ambientes
# - Propósito: Restaura o número de ambientes a partir do arquivo de backup.
# ###########################################
restaurar_num_ambientes() {
    if [ -f "$BACKUP_NUM_AMBIENTES" ]; then
        BACKUP_VALOR=$(cat "$BACKUP_NUM_AMBIENTES")
        
        # Verifica se o valor atual é diferente do backup
        if [ "$NUM_AMBIENTES" != "$BACKUP_VALOR" ]; then
            echo -e "${YELLOW}Valor de NUM_AMBIENTES diferente do backup.${NC}"
            echo -e "${YELLOW}Atual: ${NUM_AMBIENTES}, Backup: ${BACKUP_VALOR}${NC}"
            
            # Atualiza o valor no arquivo do script
            sed -i "s/^NUM_AMBIENTES=.*$/NUM_AMBIENTES=$BACKUP_VALOR # Número de ambientes que serão configurados./" "$SCRIPT_PATH"
            
            echo -e "${GREEN}Número de ambientes restaurado para: ${BACKUP_VALOR}${NC}"
            echo -e "${YELLOW}Reiniciando o script para aplicar as alterações...${NC}"
            exec "$SCRIPT_PATH"
        else
            echo -e "${GREEN}Número de ambientes coincide com o backup.${NC}"
            # Remove o arquivo de backup
            rm -f "$BACKUP_NUM_AMBIENTES"
            echo -e "${GREEN}Arquivo de backup removido.${NC}"
        fi
    else
        echo -e "${YELLOW}Nenhum arquivo de backup encontrado.${NC}"
    fi
}

# ###########################################
# Função para verificar consistência entre diretórios e valor NUM_AMBIENTES
# - Propósito: Garante que o valor NUM_AMBIENTES corresponda ao número real de pastas de ambientes
# ###########################################
verificar_consistencia_ambientes() {
    echo -e "${YELLOW}Verificando consistência do número de ambientes...${NC}"
    
    # Conta quantos diretórios de ambiente existem realmente
    PASTAS_EXISTENTES=$(find "$BASE_DIR" -maxdepth 1 -type d -name "ambiente*" | wc -l)
    
    if [ "$PASTAS_EXISTENTES" -ne "$NUM_AMBIENTES" ]; then
        echo -e "${YELLOW}Detectada inconsistência no número de ambientes!${NC}"
        echo -e "${YELLOW}Valor atual no script: ${CYAN}$NUM_AMBIENTES${NC}"
        echo -e "${YELLOW}Pastas realmente existentes: ${CYAN}$PASTAS_EXISTENTES${NC}"
        
        echo -e "${YELLOW}Atualizando o valor de NUM_AMBIENTES para corresponder à realidade...${NC}"
        NUM_AMBIENTES=$PASTAS_EXISTENTES
        atualizar_num_ambientes_no_script
        
        echo -e "${GREEN}Consistência restaurada. O script agora usará o valor correto: ${CYAN}$NUM_AMBIENTES${NC}"
        
        # Reinicia o script para usar o novo valor
        echo -e "${YELLOW}Reiniciando o script para aplicar as alterações...${NC}"
        sleep 2
        exec "$SCRIPT_PATH"
    else
        echo -e "${GREEN}Número de ambientes está consistente: ${CYAN}$NUM_AMBIENTES${NC}"
    fi
}

# Execução principal
# Verifica se existe backup do número de ambientes e o restaura se necessário
restaurar_num_ambientes
# Verifica a consistência entre as pastas existentes e o valor NUM_AMBIENTES
verificar_consistencia_ambientes
execucao_inicial
#verificar_whitelist
# === CONFIGURATION ===
# Configuration for the expected API. This is the key used to validate the connection with the main manager.
API_EXPECTED="ARENAHOSTING"

# === FUNCTION TO VALIDATE THE API ===
# This function checks if the API provided by the main manager matches the expected key.
# If it doesn't match, the script displays an error message and exits.
# The user should not modify this function unless they understand how the validation system works.
validate_api() {
    API_RECEIVED=$1
    if [ "$API_RECEIVED" != "$API_EXPECTED" ]; then
        echo -e "${RED}API CANNOT CONNECT TO THE MANAGER.SH FILE.${NC}"
        echo -e "${YELLOW}PLEASE PROVIDE THE CONFIGURATION FILE TO EXECUTE THIS FILE.${NC}"
        echo -e "${YELLOW}IF YOU DON'T KNOW, CONTACT OUR SUPPORT:${NC}"
        echo -e "${CYAN}https://arenahosting.com.br${NC}"
        exit 1 # ====> IF YOU WANT THIS MESSAGE TO BE SHOWED WITHOUT CRASHING THE TERMINAL JUST AJUST IT BY CHANGING exit 1 to exec /bin/bash
    fi
}

# === INITIALIZING MANAGER ===
# Validates the provided API and, if correct, starts the systems. The user can add
# custom commands after the validation, if necessary.
echo -e "${CYAN}==============================================${NC}"
echo -e "${YELLOW}VALIDATING API...${NC}"
validate_api "$1"
echo -e "${GREEN}API CONNECTED SUCCESSFULLY! SYSTEMS VALIDATED.${NC}"
echo -e "${CYAN}==============================================${NC}"

# === BELOW START EXECUTING THE SCRIPT BUT FIRST CHECK THE HOSTNAMES AND IPS ===

# ###########################################
# Whitelist Settings
# This section defines the authorized hostnames and IPs.
# Edit the arrays below to include the allowed hostnames and IPs for your project.
# ###########################################
WHITELIST_HOSTNAMES=("ptero.arenahosting.com.br" "arenahosting.com.br") # Adicione aqui os domínios autorizados.
WHITELIST_IPS=("172.18.0.27" "34.46.165.63")                 # Adicione os IPs autorizados.
VALIDATED=true  # Flag para indicar se o ambiente foi validado com sucesso.

# ###########################################
# Function to get private and public IPs
# This function retrieves the machine's private IP and tries to fetch the public IP 
# using multiple online services. Ensure the system has internet access.
# ###########################################
obter_ips() {
    # Obter o IP privado
    IP_PRIVADO=$(hostname -I | awk '{print $1}')
    
    # Obter o IP público usando alternativas
    IP_PUBLICO=""
    SERVICOS=("ifconfig.me" "api64.ipify.org" "ipecho.net/plain")
    
    for SERVICO in "${SERVICOS[@]}"; do
        IP_PUBLICO=$(curl -s --max-time 5 "http://${SERVICO}")
        if [[ $IP_PUBLICO =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
            break
        fi
    done

    # Check if you managed to get the public IP
    if [ -z "$IP_PUBLICO" ]; then
        IP_PUBLICO="Unable to fetch the public IP"
    fi

    echo "$IP_PRIVADO" "$IP_PUBLICO"
}

# ###########################################
# Function to validate environment
# This function verifies whether the current environment is authorized
# by checking the private or public IP against the whitelist.
# ###########################################
validar_ambiente() {
    # Exibição de validação inicial
    echo -e "\033[1;36m======================================"
    echo -e "       VALIDATING ENVIRONMENT..."
    echo -e "======================================\033[0m"
    sleep 2  # Simulate validation process

    # Obter IPs públicos e privados
    read -r IP_PRIVADO IP_PUBLICO <<<"$(obter_ips)"

    # Resolver IPs associados aos hostnames na whitelist
    for HOSTNAME in "${WHITELIST_HOSTNAMES[@]}"; do
        RESOLVIDOS=$(getent ahosts "$HOSTNAME" | awk '{print $1}' | sort -u)
        WHITELIST_IPS+=($RESOLVIDOS)
    done

    # Mostrar informações coletadas
    echo -e "\033[1;33mCurrent hostname: $(hostname)"
    echo -e "Current private IP: $IP_PRIVADO"
    echo -e "Current public IP: $IP_PUBLICO"
    echo -e "======================================\033[0m"
    sleep 3  # Allow the user to review the information

    # Verificar IP privado
    if [[ " ${WHITELIST_IPS[@]} " =~ " ${IP_PRIVADO} " ]] || [[ " ${WHITELIST_IPS[@]} " =~ " ${IP_PUBLICO} " ]]; then
        echo -e "\033[1;32m✔ Environment successfully validated! Proceeding...\033[0m"
        VALIDATED=true
        return 0
    fi

    # Mensagem de erro
    while true; do
        clear
        echo -e "\033[1;31m======================================"
        echo -e "❌ ERROR: UNAUTHORIZED ENVIRONMENT"
        echo -e "--------------------------------------"
        echo -e "⚠️  This system is not licensed for external use."
        echo -e "⚠️  Using this system outside authorized servers is strictly prohibited."
        echo -e "--------------------------------------"
        echo -e "➡️  Current hostname: $(hostname)"
        echo -e "➡️  Current private IP: $IP_PRIVADO"
        echo -e "➡️  Current public IP: $IP_PUBLICO"
        echo -e "--------------------------------------"
        echo -e "✅ Authorized servers: ${WHITELIST_HOSTNAMES[*]}"
        echo -e "✅ Authorized IPs: ${WHITELIST_IPS[*]}"
        echo -e "--------------------------------------"
        echo -e "💡 To purchase a license or hosting services:"
        echo -e "   🌐 Visit: \033[1;34mhttps://arenahosting.com.br\033[0m"
        echo -e "======================================\033[0m"
        sleep 10
    done
}

# ###########################################
# Função de validação secundária
# This function revalidates the environment in subsequent operations.
# ###########################################
validar_secundario() {
    echo -e "\033[1;36mRevalidating environment...\033[0m"
    sleep 2
    validar_ambiente
}

# ###########################################
# Verificar whitelist antes de qualquer operação
# Ensure the environment is validated before performing any operations.
# ###########################################
if [ "$VALIDATED" = false ]; then
    validar_ambiente
fi

# Simulate validations on subsequent runs
echo -e "\033[1;36mWelcome to the authorized system! Preparing for subsequent validations...\033[0m"
sleep 5
validar_secundario

# ###########################################
# Início do script principal
# The main script starts here after the environment is validated.
# ###########################################
echo -e "\033[1;32m======================================"
echo -e "    Authorized and operational system!"
echo -e "======================================\033[0m"

# ###########################################
# Main Configurations
# This section contains key configurations for the script.
# - BASE_DIR: Directory where main files are stored. Edit as needed.
# - NUM_AMBIENTES: Number of environments to simulate or configure.
# - TERMS_FILE: File used to store the acceptance of terms. Edit if necessary.
# ###########################################
BASE_DIR="/home/container"
NUM_AMBIENTES=3
TERMS_FILE="${BASE_DIR}/termos_accepted.txt"

# ###########################################
# ANSI Colors
# These are the color codes used for text styling in terminal outputs.
# Edit these colors if you need to customize the display theme.
# ###########################################
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No color

# ###########################################
# Animation Function
# This function displays a given text character by character, simulating an animation.
# Edit the 'delay' variable to increase or decrease animation speed.
# ###########################################
anima_texto() {
    local texto="$1"
    local delay=0.1
    for (( i=0; i<${#texto}; i++ )); do
        printf "${YELLOW}${texto:$i:1}${NC}"
        sleep "$delay"
    done
    echo ""
}

# ###########################################
# Function to display the 3D billboard with static text below
# This function creates a 3D text display in the terminal. The text, footer, and links
# can be edited for your project. Ensure the terminal supports ANSI escape sequences.
# ###########################################
exibir_outdoor_3D() {
    clear
    local width=$(tput cols)  # Terminal width
    local height=$(tput lines)  # Terminal height
    local start_line=$(( height / 3 ))
    local start_col=$(( (width - 60) / 2 ))  # Center the text

    # 3D art of the main text
    # ==== IMPORTANT, YOU CAN EDIT BY ADDING TEXT OR 3D TEXT EVEN MORE BUT DO NOT FORGET TO ADD IN "" LIKE "VORTEXUS" WITHOUT " " IT MAY CRASH THE CODE IF YOU RUN IT =====
    local outdoor_text=(
        "    ___    ____  _____ _   _   ___   "
"   /   |  / __ \|  _  | \ | | / _ \  "
"  / /| | / / _` | | | |  \| |/ /_\ \ "
" / ___ | | (_| | |_| | |\  ||  _  | "
"/_/  |_| \____/ \___/ |_| \_/\_| |_/ "
"                                     "
"              A R E N A             "
    )

    # Display the 3D text centered
    for i in "${!outdoor_text[@]}"; do
        tput cup $((start_line + i)) $start_col
        echo -e "${CYAN}${outdoor_text[i]}${NC}"
    done

    # Display "Created by Mauro Gashfix" below the 3D text
    local footer="Created by Mauro Gashfix"
    tput cup $((start_line + ${#outdoor_text[@]} + 1)) $(( (width - ${#footer}) / 2 ))
    echo -e "${YELLOW}${footer}${NC}"

    # Display links below the footer
    local links="arenahosting.com.br"
    tput cup $((start_line + ${#outdoor_text[@]} + 2)) $(( (width - ${#links}) / 2 ))
    echo -e "${GREEN}${links}${NC}"

    # Display the initialization bar below the links
    local progress_bar="Initializing..."
    tput cup $((start_line + ${#outdoor_text[@]} + 4)) $(( (width - ${#progress_bar} - 20) / 2 ))
    echo -ne "${CYAN}${progress_bar}${NC}"
    for i in $(seq 1 20); do
        echo -ne "${GREEN}#${NC}"
        sleep 0.1
    done
    echo ""
}

# ###########################################
# Function to display terms of service
# This function shows the terms of service and checks if the user has accepted them.
# - TERMS_FILE: File storing the acceptance status. Edit to match your project.
# - Messages: Update the terms messages to suit your service requirements.
# ###########################################
exibir_termos() {
    exibir_outdoor_3D
    sleep 1
    echo -e "${BLUE}This system is authorized only on the Arena Hosting platform.${NC}"
    echo -e "${CYAN}======================================${NC}"

    if [ ! -f "$TERMS_FILE" ]; then
        while true; do
            echo -e "${YELLOW}DO YOU ACCEPT THE TERMS OF SERVICE? (YES/NO)${NC}"
            read -p "> " ACEITE
            if [ "$ACEITE" = "yes" ]; then
                echo -e "${GREEN}Terms accepted on $(date).${NC}" > "$TERMS_FILE"
                echo -e "${CYAN}======================================${NC}"
                echo -e "${GREEN}TERMS ACCEPTED. PROCEEDING...${NC}"
                break
            elif [ "$ACEITE" = "no" ]; then
                echo -e "${RED}YOU MUST ACCEPT THE TERMS TO CONTINUE.${NC}"
            else
                echo -e "${RED}INVALID OPTION. TYPE 'YES' OR 'NO'.${NC}"
            fi
        done
    else
        echo -e "${GREEN}TERMS ALREADY ACCEPTED PREVIOUSLY. PROCEEDING...${NC}"
    fi
}




# ###########################################
# Function to create environment folders
# This function creates folders for each environment.
# - Purpose: Creates a directory for each environment to organize related files.
# - Edit: You can edit the "AMBIENTE_PATH" to change the folder names as they are created.
# - Do not edit: The loop and logic for creating folders should not be changed.
# ###########################################
criar_pastas() {
    for i in $(seq 1 $NUM_AMBIENTES); do
        AMBIENTE_PATH="${BASE_DIR}/ambiente${i}"  # You can rename "ambiente" to suit your project
        if [ ! -d "$AMBIENTE_PATH" ]; then
            mkdir -p "$AMBIENTE_PATH"
            echo -e "${GREEN}ENVIRONMENT FOLDER ${i} CREATED.${NC}"
        fi
    done
}

# ###########################################
# Update environment status
# - Purpose: Updates the status (e.g., ON/OFF) of a specific environment by writing it to a file.
# - Edit: Only edit the text in the echo commands to suit your project.
# - Do not edit: The logic for writing to the "status" file must remain unchanged.
# ###########################################
atualizar_status() {
    AMBIENTE_PATH=$1
    NOVO_STATUS=$2
    echo "$NOVO_STATUS" > "${AMBIENTE_PATH}/status"  # Writes the new status to a file
    echo -e "${CYAN}Environment status updated to: ${GREEN}${NOVO_STATUS}${NC}"
}

# ###########################################
# Retrieve environment status
# - Purpose: Reads the status (e.g., ON/OFF) of a specific environment.
# - Edit: Only edit the text in the echo commands if needed.
# - Do not edit: The logic for checking and returning the "status" file must not be changed.
# ###########################################
recuperar_status() {
    AMBIENTE_PATH=$1
    if [ -f "${AMBIENTE_PATH}/status" ]; then
        cat "${AMBIENTE_PATH}/status"  # Reads the status from the file
    else
        echo "OFF"  # Default status if no file exists
    fi
}

# ###########################################
# Check and restart background sessions
# - Purpose: Verifies and restarts background sessions for each environment if needed.
# - Edit: You can modify the echo texts to suit your project requirements.
# - Do not edit: The logic for handling sessions and commands should not be changed.
# ###########################################
verificar_sessoes() {
    echo -e "${CYAN}======================================${NC}"
    anima_texto "CHECKING BACKGROUND SESSIONS..."
    for i in $(seq 1 $NUM_AMBIENTES); do
        AMBIENTE_PATH="${BASE_DIR}/ambiente${i}"
        if [ -f "${AMBIENTE_PATH}/.session" ]; then
            STATUS=$(recuperar_status "$AMBIENTE_PATH")
            if [ "$STATUS" = "ON" ]; then
                COMANDO=$(cat "${AMBIENTE_PATH}/.session")
                
                if [ -n "$COMANDO" ]; then
                    echo -e "${YELLOW}Executing background session for environment ${i}...${NC}"
                    pkill -f "$COMANDO" 2>/dev/null
                    cd "$AMBIENTE_PATH" || continue
                    nohup $COMANDO > nohup.out 2>&1 &
                    if [ $? -eq 0 ]; then
                        echo -e "${GREEN}BACKGROUND SESSION ACTIVE FOR ENVIRONMENT ${i}.${NC}"
                    else
                        echo -e "${RED}Error while trying to activate session in environment ${i}.${NC}"
                    fi
                else
                    echo -e "${YELLOW}Empty command found in the .session file for environment ${i}.${NC}"
                fi
            else
                echo -e "${RED}Environment ${i} is OFF. Skipping...${NC}"
            fi
        else
            echo -e "${RED}No .session file found for environment ${i}.${NC}"
        fi
    done
    echo -e "${CYAN}======================================${NC}"
}

# ###########################################
# Main menu function
# - Purpose: Displays the main menu and allows users to select an environment to manage.
# - Edit: You can change the echo texts and menu options to fit your project.
# - Do not edit: The logic for handling menu input and calling functions must remain unchanged.
# ###########################################
menu_principal() {
    echo -e "${CYAN}======================================${NC}"
    anima_texto "       ENVIRONMENT MANAGEMENT"
    echo -e "${CYAN}======================================${NC}"
    for i in $(seq 1 $NUM_AMBIENTES); do
        AMBIENTE_PATH="${BASE_DIR}/ambiente${i}"
        STATUS=$(recuperar_status "$AMBIENTE_PATH")
        echo -e "${YELLOW}ENVIRONMENT ${i}:${NC} ${GREEN}STATUS - $STATUS${NC}"
    done
    echo -e "${CYAN}======================================${NC}"
    echo -e "${YELLOW}CHOOSE AN ENVIRONMENT TO MANAGE (1-${NUM_AMBIENTES}):${NC}"
    echo -e "${RED}0 - EXIT${NC}"
    read -p "> " AMBIENTE_ESCOLHIDO

    if [ "$AMBIENTE_ESCOLHIDO" -ge 1 ] && [ "$AMBIENTE_ESCOLHIDO" -le "$NUM_AMBIENTES" ]; then
        gerenciar_ambiente "$AMBIENTE_ESCOLHIDO"
    elif [ "$AMBIENTE_ESCOLHIDO" = "0" ]; then
        anima_texto "EXITING..."
        exit 0
    else
        echo -e "${RED}INVALID CHOICE. TRY AGAIN.${NC}"
        menu_principal
    fi
}

# ###########################################
# Function to choose a pre-configured bot from Vortexus
# - Purpose: Allows users to select pre-configured bots based on language.
# - Edit: You can add or remove language options and adjust the echo texts.
# - Do not edit: The logic for handling bot selection must remain unchanged.
# ###########################################
escolher_bot_pronto() {
    AMBIENTE_PATH=$1
    echo -e "${CYAN}======================================${NC}"
    anima_texto "       CHOOSE PRE-CONFIGURED BOT"
    echo -e "${CYAN}======================================${NC}"
    echo -e "${YELLOW}1 - BOTS IN PORTUGUESE${NC}"
    echo -e "${YELLOW}2 - BOTS IN SPANISH${NC}"
    echo -e "${RED}0 - BACK${NC}"
    read -p "> " OPCAO_BOT

    case $OPCAO_BOT in
        1)
            listar_bots "$AMBIENTE_PATH" "portugues"
            ;;
        2)
            listar_bots "$AMBIENTE_PATH" "espanhol"
            ;;
        0)
            menu_principal
            ;;
        *)
            echo -e "${RED}Invalid option.${NC}"
            escolher_bot_pronto "$AMBIENTE_PATH"
            ;;
    esac
}

# ###########################################
# Function to list available bots
# - Purpose: Displays a list of pre-configured bots based on the selected language.
# - Edit: Add or modify the bot repositories in the "BOTS" arrays to include new bots.
# - Do not edit: The logic for handling bot selection and repository URLs must remain unchanged.
# ###########################################
listar_bots() {
    AMBIENTE_PATH=$1
    LINGUA=$2
    echo -e "${CYAN}======================================${NC}"
    anima_texto "       AVAILABLE BOTS - ${LINGUA^^}"
    echo -e "${CYAN}======================================${NC}"

    # Structure for available bots
    if [ "$LINGUA" = "portugues" ]; then
        BOTS=(
            "BLACK BOT - https://github.com/MauroSupera/blackbot.git"
            "YOSHINO BOT - https://github.com/MauroSupera/yoshinobot.git"
            "MIKASA ASCENDANCY V3 - https://github.com/maurogashfix/MikasaAscendancyv3.git"
            "INATSUKI BOT - https://github.com/MauroSupera/inatsukibot.git"
            "ESDEATH BOT - https://github.com/Salientekill/ESDEATHBOT.git"
            "CHRIS BOT - https://github.com/MauroSupera/chrisbot.git"
            "TAIGA BOT - https://github.com/MauroSupera/TAIGA-BOT3.git"
            "AGATHA BOT - https://github.com/MauroSupera/agathabotnew.git"
        )
    elif [ "$LINGUA" = "espanhol" ]; then
        BOTS=(
            "GATA BOT - https://github.com/GataNina-Li/GataBot-MD.git"
            "GATA BOT LITE - https://github.com/GataNina-Li/GataBotLite-MD.git"
            "KATASHI BOT - https://github.com/KatashiFukushima/KatashiBot-MD.git"
            "CURIOSITY BOT - https://github.com/AzamiJs/CuriosityBot-MD.git"
            "NOVA BOT - https://github.com/elrebelde21/NovaBot-MD.git"
            "MEGUMIN BOT - https://github.com/David-Chian/Megumin-Bot-MD"
            "YAEMORI BOT - https://github.com/Dev-Diego/YaemoriBot-MD"
            "THEMYSTIC BOT - https://github.com/BrunoSobrino/TheMystic-Bot-MD.git"
        )
    fi

    for i in "${!BOTS[@]}"; do
        echo -e "${GREEN}$((i+1)) - ${BOTS[$i]%% -*}${NC}"
    done
    echo -e "${RED}0 - BACK${NC}"

    read -p "> " BOT_ESCOLHIDO

    if [ "$BOT_ESCOLHIDO" -ge 1 ] && [ "$BOT_ESCOLHIDO" -le "${#BOTS[@]}" ]; then
        REPOSITORIO="${BOTS[$((BOT_ESCOLHIDO-1))]#*- }"
        verificar_instalacao_bot "$AMBIENTE_PATH" "$REPOSITORIO"
    elif [ "$BOT_ESCOLHIDO" = "0" ]; then
        escolher_bot_pronto "$AMBIENTE_PATH"
    else
        echo -e "${RED}Invalid option.${NC}"
        listar_bots "$AMBIENTE_PATH" "$LINGUA"
    fi
}

# ###########################################
# Logic for adding more bots or languages
# - To add a new language:
#   1. Create a new "elif" block like the ones above.
#   2. Set the "BOTS" array with bot names and repository URLs.
#   3. Use the same structure: "BOT NAME - REPOSITORY URL".
# - To add more types of bots in existing languages:
#   1. Add the new bot details to the respective "BOTS" array.
#   2. Ensure the repository URL is correct and accessible.
# ###########################################

# ###########################################
# Function to check bot installation
# - Purpose: Verifies if a bot is already installed in the environment.
# - Edit: You can modify the echo texts to match your project's tone.
# - Do not edit: The logic for checking and installing bots must remain unchanged.
# ###########################################
verificar_instalacao_bot() {
    AMBIENTE_PATH=$1
    REPOSITORIO=$2

    if [ -f "${AMBIENTE_PATH}/package.json" ]; then
        echo -e "${YELLOW}A bot is already installed in this environment.${NC}"
        echo -e "${YELLOW}Do you want to remove the existing bot to install the new one? (yes/no)${NC}"
        read -p "> " RESPOSTA
        if [ "$RESPOSTA" = "yes" ]; then
            remover_bot "$AMBIENTE_PATH"
            instalar_novo_bot "$AMBIENTE_PATH" "$REPOSITORIO"
        else
            echo -e "${RED}Returning to the main menu...${NC}"
            menu_principal
        fi
    else
        instalar_novo_bot "$AMBIENTE_PATH" "$REPOSITORIO"
    fi
}

# ###########################################
# Function to install a new bot
# - Purpose: Clones the repository of the selected bot into the environment.
# - Edit: Only modify echo texts or error messages as needed.
# - Do not edit: The git cloning logic and directory structure must remain intact.
# ###########################################
instalar_novo_bot() {
    AMBIENTE_PATH=$1
    REPOSITORIO=$2

    NOME_BOT=$(basename "$REPOSITORIO" .git)
    echo -e "${CYAN}Starting installation of bot: ${GREEN}$NOME_BOT${NC}..."
    git clone "$REPOSITORIO" "$AMBIENTE_PATH" 2>/dev/null
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Bot $NOME_BOT successfully installed in environment $AMBIENTE_PATH!${NC}"
        verificar_node_modules "$AMBIENTE_PATH"
    else
        echo -e "${RED}Error cloning the repository for bot $NOME_BOT. Verify the URL and try again.${NC}"
    fi
}

# ###########################################
# Function to verify and install node_modules
# - Purpose: Ensures all required modules for the bot are installed.
# - Edit: Modify echo texts or installation commands if needed (npm or yarn).
# - Do not edit: The logic for detecting and installing modules should not change.
# ###########################################
verificar_node_modules() {
    AMBIENTE_PATH=$1
    if [ ! -d "${AMBIENTE_PATH}/node_modules" ]; then
        echo -e "${YELLOW}Modules not installed for this bot.${NC}"
        echo -e "${YELLOW}Choose an option to install:${NC}"
        echo -e "${GREEN}1 - npm install${NC}"
        echo -e "${GREEN}2 - yarn install${NC}"
        echo -e "${RED}0 - Back${NC}"
        read -p "> " OPCAO_MODULOS
        case $OPCAO_MODULOS in
            1)
                echo -e "${CYAN}Installing modules with npm...${NC}"
                cd "$AMBIENTE_PATH" && npm install
                [ $? -eq 0 ] && echo -e "${GREEN}Modules successfully installed!${NC}" || echo -e "${RED}Error installing modules with npm.${NC}"
                ;;
            2)
                echo -e "${CYAN}Installing modules with yarn...${NC}"
                cd "$AMBIENTE_PATH" && yarn install
                [ $? -eq 0 ] && echo -e "${GREEN}Modules successfully installed!${NC}" || echo -e "${RED}Error installing modules with yarn.${NC}"
                ;;
            0)
                menu_principal
                ;;
            *)
                echo -e "${RED}Invalid option.${NC}"
                verificar_node_modules "$AMBIENTE_PATH"
                ;;
        esac
    else
        echo -e "${GREEN}All required modules are already installed.${NC}"
    fi
    pos_clone_menu "$AMBIENTE_PATH"
}


# ###########################################
# Function to remove the current bot
# - Purpose: Removes all files from the environment folder, effectively uninstalling the bot.
# - Edit: Only modify the echo texts if needed.
# - Do not edit: The logic for file removal and confirmation should not be changed.
# ###########################################
remover_bot() {
    AMBIENTE_PATH=$1

    if [ -f "${AMBIENTE_PATH}/package.json" ]; then
        echo -e "${YELLOW}Bot detected in this environment.${NC}"
        echo -e "${RED}Do you really want to remove the current bot? (yes/no)${NC}"
        read -p "> " CONFIRMAR
        if [ "$CONFIRMAR" = "yes" ]; then
            find "$AMBIENTE_PATH" -mindepth 1 -exec rm -rf {} + 2>/dev/null
            [ -z "$(ls -A "$AMBIENTE_PATH")" ] && echo -e "${GREEN}Bot successfully removed.${NC}" || echo -e "${RED}Error removing the bot.${NC}"
        else
            echo -e "${RED}Removal canceled.${NC}"
        fi
    else
        echo -e "${RED}No bot found in this environment.${NC}"
    fi
    menu_principal
}

# ###########################################
# Function to clone a repository
# - Purpose: Clones a public or private repository into the environment folder.
# - Edit: Adjust echo texts to match your project's tone if necessary.
# - Do not edit: The logic for cloning repositories and handling inputs must remain unchanged.
# ###########################################
clonar_repositorio() {
    AMBIENTE_PATH=$1
    echo -e "${CYAN}======================================${NC}"
    anima_texto "       CLONE REPOSITORY"
    echo -e "${CYAN}======================================${NC}"
    echo -e "${YELLOW}1 - Clone public repository${NC}"
    echo -e "${YELLOW}2 - Clone private repository${NC}"
    echo -e "${RED}0 - Back${NC}"
    read -p "> " OPCAO_CLONAR

    case $OPCAO_CLONAR in
        1)
            echo -e "${CYAN}Provide the URL of the public repository:${NC}"
            read -p "> " URL_REPOSITORIO
            if [[ $URL_REPOSITORIO != https://github.com/* ]]; then
                echo -e "${RED}Invalid URL!${NC}"
                clonar_repositorio "$AMBIENTE_PATH"
                return
            fi
            echo -e "${CYAN}Cloning public repository...${NC}"
            git clone "$URL_REPOSITORIO" "$AMBIENTE_PATH" 2>/dev/null
            [ $? -eq 0 ] && echo -e "${GREEN}Repository cloned successfully!${NC}" || echo -e "${RED}Error cloning the repository.${NC}"
            ;;
        2)
            echo -e "${CYAN}Provide the URL of the private repository:${NC}"
            read -p "> " URL_REPOSITORIO
            echo -e "${CYAN}GitHub Username:${NC}"
            read -p "> " USERNAME
            echo -e "${CYAN}Provide the access token:${NC}"
            read -s -p "> " TOKEN
            echo
            GIT_URL="https://${USERNAME}:${TOKEN}@$(echo $URL_REPOSITORIO | cut -d/ -f3-)"
            echo -e "${CYAN}Cloning private repository...${NC}"
            git clone "$GIT_URL" "$AMBIENTE_PATH" 2>/dev/null
            [ $? -eq 0 ] && echo -e "${GREEN}Private repository cloned successfully!${NC}" || echo -e "${RED}Error cloning the private repository.${NC}"
            ;;
        0)
            menu_principal
            ;;
        *)
            echo -e "${RED}Invalid option.${NC}"
            clonar_repositorio "$AMBIENTE_PATH"
            ;;
    esac
}

# ###########################################
# Post-clone menu function
# - Purpose: Provides options to execute the bot, install modules, or return to the main menu.
# - Edit: Adjust the echo texts for clarity or add more options if needed.
# - Do not edit: The logic for handling menu selections and calling respective functions.
# ###########################################
pos_clone_menu() {
    AMBIENTE_PATH=$1
    echo -e "${CYAN}======================================${NC}"
    anima_texto "WHAT DO YOU WANT TO DO NOW?"
    echo -e "${CYAN}======================================${NC}"
    echo -e "${YELLOW}1 - Run the bot${NC}"
    echo -e "${YELLOW}2 - Install modules${NC}"
    echo -e "${RED}0 - Back to main menu${NC}"
    read -p "> " OPCAO_POS_CLONE

    case $OPCAO_POS_CLONE in
        1)
            iniciar_bot "$AMBIENTE_PATH"
            ;;
        2)
            instalar_modulos "$AMBIENTE_PATH"
            ;;
        0)
            menu_principal
            ;;
        *)
            echo -e "${RED}Invalid option.${NC}"
            pos_clone_menu "$AMBIENTE_PATH"
            ;;
    esac
}

# ###########################################
# Function to install modules
# - Purpose: Installs necessary modules using npm or yarn in the selected environment.
# - Edit: You can modify echo texts to guide users on module installation options.
# - Do not edit: The logic for executing npm or yarn commands must remain unchanged.
# ###########################################
instalar_modulos() {
    AMBIENTE_PATH=$1
    echo -e "${CYAN}======================================${NC}"
    anima_texto "INSTALL MODULES"
    echo -e "${CYAN}======================================${NC}"
    echo -e "${YELLOW}1 - Install with npm install${NC}"
    echo -e "${YELLOW}2 - Install with yarn install${NC}"
    echo -e "${RED}0 - Back to main menu${NC}"
    read -p "> " OPCAO_MODULOS

    case $OPCAO_MODULOS in
        1)
            echo -e "${CYAN}Installing modules with npm...${NC}"
            cd "$AMBIENTE_PATH" && npm install
            if [ $? -eq 0 ]; then
                echo -e "${GREEN}Modules installed successfully!${NC}"
            else
                echo -e "${RED}Error installing modules with npm.${NC}"
            fi
            pos_clone_menu "$AMBIENTE_PATH"
            ;;
        2)
            echo -e "${CYAN}Installing modules with yarn...${NC}"
            cd "$AMBIENTE_PATH" && yarn install
            if [ $? -eq 0 ]; then
                echo -e "${GREEN}Modules installed successfully!${NC}"
            else
                echo -e "${RED}Error installing modules with yarn.${NC}"
            fi
            pos_clone_menu "$AMBIENTE_PATH"
            ;;
        0)
            menu_principal
            ;;
        *)
            echo -e "${RED}Invalid option.${NC}"
            instalar_modulos "$AMBIENTE_PATH"
            ;;
    esac
}

# Função para iniciar o bot
iniciar_bot() {
    AMBIENTE_PATH=$1
    if [ -f "${AMBIENTE_PATH}/.session" ]; then
        STATUS=$(recuperar_status "$AMBIENTE_PATH")
        if [ "$STATUS" = "OFF" ]; then
            echo -e "${YELLOW}Existing session with status OFF.${NC}"
            echo -e "${YELLOW}1 - Restart the bot${NC}"
            echo -e "${RED}0 - Back${NC}"
            read -p "> " OPCAO_EXISTENTE
            case $OPCAO_EXISTENTE in
                1)
                    COMANDO=$(cat "${AMBIENTE_PATH}/.session")
                    nohup sh -c "cd $AMBIENTE_PATH && $COMANDO" > "${AMBIENTE_PATH}/nohup.out" 2>&1 &
                    clear
                    atualizar_status "$AMBIENTE_PATH" "ON"
                    echo -e "${GREEN}Bot successfully restarted!${NC}"
                    menu_principal
                    ;;
                0)
                    menu_principal
                    ;;
                *)
                    echo -e "${RED}Invalid option.${NC}"
                    iniciar_bot "$AMBIENTE_PATH"
                    ;;
            esac
        elif [ "$STATUS" = "ON" ]; then
            echo -e "${RED}There is already an active session in this environment.${NC}"
            echo -e "${RED}Please end the current session before starting another.${NC}"
            echo -e "${YELLOW}0 - Back${NC}"
            read -p "> " OPCAO
            [ "$OPCAO" = "0" ] && menu_principal
        fi
    else
        echo -e "${CYAN}Choose how you want to start the bot:${NC}"
        echo -e "${YELLOW}1 - npm start${NC}"
        echo -e "${YELLOW}2 - Specify a file (e.g., index.js or start.sh)${NC}"
        echo -e "${YELLOW}3 - Install modules and run the bot${NC}"
        echo -e "${RED}0 - Back${NC}"
        read -p "> " INICIAR_OPCAO

        case $INICIAR_OPCAO in
            1)
                echo "npm start" > "${AMBIENTE_PATH}/.session"
                clear
                echo -e "${YELLOW}Restart the server once finished to apply changes${NC}"
                atualizar_status "$AMBIENTE_PATH" "ON"
                while true; do
                    cd "$AMBIENTE_PATH" && npm start
                    echo -e "${YELLOW}1 - Restart the bot${NC}"
                    echo -e "${YELLOW}2 - Save and go back to the main menu${NC}"
                    echo -e "${RED}0 - Back${NC}"
                    read -p "> " OPC_REINICIAR
                    case $OPC_REINICIAR in
                        1)
                            echo -e "${CYAN}Restarting the process...${NC}"
                            ;;
                        2)
                            echo -e "${GREEN}Saving and returning to the main menu...${NC}"
                            menu_principal
                            ;;
                        0)
                            menu_principal
                            ;;
                        *)
                            echo -e "${RED}Invalid option.${NC}"
                            ;;
                    esac
                done
                ;;
            2)
                echo -e "${YELLOW}Enter the name of the file to execute:${NC}"
                read ARQUIVO
                if [[ $ARQUIVO == *.sh ]]; then
                    echo "sh $ARQUIVO" > "${AMBIENTE_PATH}/.session"
                else
                    echo "node $ARQUIVO" > "${AMBIENTE_PATH}/.session"
                fi
                clear
                echo -e "${YELLOW}Restart the server once finished to apply changes${NC}"
                atualizar_status "$AMBIENTE_PATH" "ON"
                while true; do
                    if [[ $ARQUIVO == *.sh ]]; then
                        cd "$AMBIENTE_PATH" && sh "$ARQUIVO"
                    else
                        cd "$AMBIENTE_PATH" && node "$ARQUIVO"
                    fi
                    echo -e "${YELLOW}1 - Restart the bot${NC}"
                    echo -e "${YELLOW}2 - Save and go back to the main menu${NC}"
                    echo -e "${RED}0 - Back${NC}"
                    read -p "> " OPC_REINICIAR
                    case $OPC_REINICIAR in
                        1)
                            echo -e "${CYAN}Restarting the process...${NC}"
                            ;;
                        2)
                            echo -e "${GREEN}Saving and returning to the main menu...${NC}"
                            menu_principal
                            ;;
                        0)
                            menu_principal
                            ;;
                        *)
                            echo -e "${RED}Invalid option.${NC}"
                            ;;
                    esac
                done
                ;;
            3)
                verificar_node_modules "$AMBIENTE_PATH"
                if [ $? -eq 0 ]; then
                    echo "npm start" > "${AMBIENTE_PATH}/.session"
                    cd "$AMBIENTE_PATH" && npm start
                else
                    echo -e "${RED}Error installing modules. Returning to the menu...${NC}"
                    pos_clone_menu "$AMBIENTE_PATH"
                fi
                ;;
            0)
                menu_principal
                ;;
            *)
                echo -e "${RED}Invalid option.${NC}"
                iniciar_bot "$AMBIENTE_PATH"
                ;;
        esac
    fi
}



# ###########################################
# Function to stop the bot
# - Purpose: Stops the active bot session by terminating its process.
# - Edit: Only modify the echo texts if necessary to fit your project.
# - Do not edit: The logic for stopping the session and updating the status must remain unchanged.
# ###########################################
parar_bot() {
    AMBIENTE_PATH=$1
    echo -e "${CYAN}======================================${NC}"
    anima_texto "STOP THE BOT"
    echo -e "${CYAN}======================================${NC}"
    if [ -f "${AMBIENTE_PATH}/.session" ]; then
        COMANDO=$(cat "${AMBIENTE_PATH}/.session")

        pkill -f "$COMANDO" 2>/dev/null
        clear
        atualizar_status "$AMBIENTE_PATH" "OFF"
        echo -e "${GREEN}Bot successfully stopped.${NC}"
        echo -e "${YELLOW}Restart the server after stopping to apply changes.${NC}"
        exec /bin/bash
    else
        echo -e "${RED}No active session found to stop.${NC}"
    fi
    menu_principal
}

# ###########################################
# Function to restart the bot
# - Purpose: Restarts the bot by stopping the current session and starting a new one.
# - Edit: Only modify the echo texts if necessary to fit your project.
# - Do not edit: The logic for stopping, restarting, and updating the status must remain unchanged.
# ###########################################
reiniciar_bot() {
    AMBIENTE_PATH=$1
    echo -e "${CYAN}======================================${NC}"
    anima_texto "RESTART THE BOT"
    echo -e "${CYAN}======================================${NC}"
    if [ -f "${AMBIENTE_PATH}/.session" ]; then
        COMANDO=$(cat "${AMBIENTE_PATH}/.session")

        pkill -f "$COMANDO" 2>/dev/null
        cd "$AMBIENTE_PATH" && nohup $COMANDO > nohup.out 2>&1 &
        clear
        atualizar_status "$AMBIENTE_PATH" "ON"
        echo -e "${GREEN}Bot successfully restarted.${NC}"
    else
        echo -e "${RED}No active session found to restart.${NC}"
    fi
    menu_principal
}

# ###########################################
# Function to view the terminal
# - Purpose: Displays the terminal output of the bot session in real-time.
# - Edit: Only modify the echo texts if necessary.
# - Do not edit: The logic for accessing and displaying the terminal output must remain unchanged.
# ###########################################
ver_terminal() {
    AMBIENTE_PATH=$1
    echo -e "${CYAN}======================================${NC}"
    anima_texto "VIEW THE TERMINAL"
    echo -e "${CYAN}======================================${NC}"
    if [ -f "${AMBIENTE_PATH}/nohup.out" ]; then
        clear
        echo -e "${YELLOW}After restarting the server, you need to access the ENVIRONMENT and start the server again using option 2.${NC}"
        atualizar_status "$AMBIENTE_PATH" "OFF"
        tail -f "${AMBIENTE_PATH}/nohup.out"
    else
        echo -e "${RED}No terminal output found.${NC}"
    fi
    menu_principal
}

# ###########################################
# Function to delete the session
# - Purpose: Deletes the current bot session and terminates its process.
# - Edit: Only modify the echo texts if necessary.
# - Do not edit: The logic for deleting the session file and stopping the process must remain unchanged.
# ###########################################
deletar_sessao() {
    AMBIENTE_PATH=$1
    echo -e "${CYAN}======================================${NC}"
    anima_texto "DELETE SESSION"
    echo -e "${CYAN}======================================${NC}"
    if [ -f "${AMBIENTE_PATH}/.session" ]; then
        COMANDO=$(cat "${AMBIENTE_PATH}/.session")
        pkill -f "$COMANDO" 2>/dev/null
        rm -f "${AMBIENTE_PATH}/.session"
        clear
        atualizar_status "$AMBIENTE_PATH" "OFF"
        echo -e "${GREEN}Session successfully deleted. Please restart your server to apply changes.${NC}"
        exec /bin/bash
    else
        echo -e "${RED}No active session found to delete.${NC}"
    fi
    menu_principal
}

# ###########################################
# Function to manage the environment
# - Purpose: Provides a menu to manage a specific environment, allowing the user to perform various actions.
# - Edit: You can modify the echo texts to fit your project's style or requirements.
# - Do not edit: The logic for handling menu options and calling respective functions must remain unchanged.
# ###########################################
gerenciar_ambiente() {
    AMBIENTE_PATH="${BASE_DIR}/ambiente$1"
    echo -e "${CYAN}======================================${NC}"
    anima_texto "MANAGING ENVIRONMENT $1"
    echo -e "${CYAN}======================================${NC}"
    echo -e "${YELLOW}1 - CHOOSE PRE-CONFIGURED BOT FROM ARENA HOSTING${NC}"
    echo -e "${YELLOW}2 - START THE BOT${NC}"
    echo -e "${YELLOW}3 - STOP THE BOT${NC}"
    echo -e "${YELLOW}4 - RESTART THE BOT${NC}"
    echo -e "${YELLOW}5 - VIEW THE TERMINAL${NC}"
    echo -e "${YELLOW}6 - DELETE SESSION${NC}"
    echo -e "${YELLOW}7 - REMOVE CURRENT BOT${NC}"
    echo -e "${YELLOW}8 - CLONE REPOSITORY${NC}"
    echo -e "${RED}0 - BACK${NC}"
    read -p "> " OPCAO

    case $OPCAO in
        1) escolher_bot_pronto "$AMBIENTE_PATH" ;;  # Choose a pre-configured bot
        2) iniciar_bot "$AMBIENTE_PATH" ;;          # Start the bot
        3) parar_bot "$AMBIENTE_PATH" ;;            # Stop the bot
        4) reiniciar_bot "$AMBIENTE_PATH" ;;        # Restart the bot
        5) ver_terminal "$AMBIENTE_PATH" ;;         # View the bot's terminal
        6) deletar_sessao "$AMBIENTE_PATH" ;;       # Delete the bot's session
        7) remover_bot "$AMBIENTE_PATH" ;;          # Remove the current bot
        8) clonar_repositorio "$AMBIENTE_PATH" ;;   # Clone a repository
        0) menu_principal ;;                        # Return to the main menu
        *) 
            echo -e "${RED}Invalid option.${NC}"
            gerenciar_ambiente "$1" 
            ;;
    esac
}

# Execução principal
exibir_termos
criar_pastas
verificar_sessoes
menu_principal
verificar_whitelist