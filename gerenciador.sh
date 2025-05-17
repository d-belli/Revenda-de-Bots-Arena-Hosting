#!/bin/bash

# === CORES ANSI ===
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
NC='\033[0m'  # Sem cor

# === ABAIXO COMECA A EXECUTAR O SCRIPT MAS PRIMEIRO VERIFICA OS HOSTNAMES E IPS ===

# ###########################################
# Configurações da whitelist
# - Propósito: Define os hostnames e IPs autorizados para o sistema.
# - Editar: 
#   * Você pode adicionar ou remover hostnames em `WHITELIST_HOSTNAMES`.
#   * Pode incluir ou excluir IPs em `WHITELIST_IPS`.
# - Não editar: A estrutura da lista e a lógica de validação devem permanecer intactas.
# ###########################################
WHITELIST_HOSTNAMES=("ptero.arenahosting.com.br")
WHITELIST_IPS=("166.0.189.163")
VALIDATED=true

# === CONFIGURAÇÕES DE VERSÃO ===
VERSAO_LOCAL="1.0.4"  # Versão atual do script
URL_SCRIPT="https://raw.githubusercontent.com/d-belli/Multi_Bot-Plano01/refs/heads/main/gerenciador.sh"  # Link para o conteúdo do script no GitHub

# ###########################################
# Função para obter IPs privados e públicos
# - Propósito: Coleta os IPs privados e públicos do servidor em execução.
# - Editar: Não é necessário editar esta função, pois ela é independente de configurações externas.
# ###########################################
obter_ips() {
    # Obtém o IP privado
    IP_PRIVADO=$(hostname -I | awk '{print $1}')
    
    # Obtém o IP público usando diferentes serviços online
    IP_PUBLICO=""
    SERVICOS=("ifconfig.me" "api64.ipify.org" "ipecho.net/plain")
    
    for SERVICO in "${SERVICOS[@]}"; do
        IP_PUBLICO=$(curl -s --max-time 5 "http://${SERVICO}")
        if [[ $IP_PUBLICO =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
            break
        fi
    done

    # Caso não consiga obter o IP público
    if [ -z "$IP_PUBLICO" ]; then
        IP_PUBLICO="Não foi possível obter o IP público"
    fi

    echo "$IP_PRIVADO" "$IP_PUBLICO"
}

verificar_whitelist() {
    local valor="$1"

    # Verifica no array de hostnames
    for h in "${WHITELIST_HOSTNAMES[@]}"; do
        if [[ "$valor" == "$h" ]]; then
            return 0
        fi
    done

    # Verifica no array de IPs
    for ip in "${WHITELIST_IPS[@]}"; do
        if [[ "$valor" == "$ip" ]]; then
            return 0
        fi
    done

    return 1  # Não encontrado na whitelist
}

# ###########################################
# Função para validar o ambiente
# - Propósito: Confirma se o ambiente atual está autorizado a executar o sistema.
# - Editar:
#   * Você pode ajustar as mensagens exibidas no terminal (os comandos `echo`).
# - Não editar: Não altere a lógica de verificação ou o comportamento do loop.
# ###########################################
validar_ambiente() {
    # Exibe uma mensagem de validação inicial
    echo -e "\033[1;36m======================================"
    echo -e "       VALIDANDO AMBIENTE..."
    echo -e "======================================\033[0m"
    sleep 2  # Simula o tempo de validação

    # Coleta os IPs público e privado
    read -r IP_PRIVADO IP_PUBLICO <<<"$(obter_ips)"

    # Resolve os IPs dos hostnames na whitelist
    for HOSTNAME in "${WHITELIST_HOSTNAMES[@]}"; do
        RESOLVIDOS=$(getent ahosts "$HOSTNAME" | awk '{print $1}' | sort -u)
        WHITELIST_IPS+=($RESOLVIDOS)
    done

    # Mostra as informações coletadas
    echo -e "\033[1;33mHostname atual: $(hostname)"
    echo -e "IP privado atual: $IP_PRIVADO"
    echo -e "IP público atual: $IP_PUBLICO"
    echo -e "======================================\033[0m"
    sleep 3  # Dá tempo para o usuário ver as informações

    # Verifica se o IP privado ou público está autorizado
    if [[ " ${WHITELIST_IPS[@]} " =~ " ${IP_PRIVADO} " ]] || [[ " ${WHITELIST_IPS[@]} " =~ " ${IP_PUBLICO} " ]]; then
        echo -e "\033[1;32m✔ Ambiente validado com sucesso! Continuando...\033[0m"
        VALIDATED=true
        return 0
    fi

    # Loop para ambientes não autorizados
    while true; do
        clear
        echo -e "\033[1;31m======================================"
        echo -e "❌ ERRO: AMBIENTE NÃO AUTORIZADO"
        echo -e "--------------------------------------"
        echo -e "⚠️  Este sistema não é licenciado para uso externo."
        echo -e "⚠️  É estritamente proibido utilizar este sistema fora dos servidores autorizados."
        echo -e "--------------------------------------"
        echo -e "➡️  Hostname atual: $(hostname)"
        echo -e "➡️  IP privado atual: $IP_PRIVADO"
        echo -e "➡️  IP público atual: $IP_PUBLICO"
        echo -e "--------------------------------------"
        echo -e "✅ Servidores autorizados: ${WHITELIST_HOSTNAMES[*]}"
        echo -e "✅ IPs autorizados: ${WHITELIST_IPS[*]}"
        echo -e "--------------------------------------"
        echo -e "💡 Para adquirir uma licença ou contratar nossos serviços de hospedagem:"
        echo -e "   🌐 Acesse clicando aqui: \033[1;34mhttps://arenahosting.com.br\033[0m"
        echo -e "======================================\033[0m"
        sleep 10
    done
}

# ###########################################
# Função de validação secundária
# - Propósito: Realiza uma validação adicional para confirmar o ambiente autorizado.
# - Editar: Não é necessário editar esta função.
# ###########################################
validar_secundario() {
    echo -e "\033[1;36mRevalidando ambiente...\033[0m"
    sleep 2
    validar_ambiente
}

# ###########################################
# Verificação inicial da whitelist
# - Propósito: Realiza a validação antes de iniciar qualquer operação.
# - Editar: Não é necessário editar esta função.
# ###########################################
if [ "$VALIDATED" = false ]; then
    validar_ambiente
fi

# ###########################################
# Início do script principal
# - Propósito: Exibe uma mensagem inicial após a validação bem-sucedida.
# - Editar: Pode ajustar o texto exibido pelo comando `echo`.
# ###########################################
echo -e "\033[1;36mBem-vindo ao sistema autorizado! Preparando validações subsequentes...\033[0m"
sleep 5
validar_secundario

echo -e "\033[1;32m======================================"
echo -e "    Sistema autorizado e operacional!"
echo -e "======================================\033[0m"

# ###########################################
# Configurações principais
# - Propósito: Define o diretório base e outras configurações essenciais do sistema.
# - Editar:
#   * `BASE_DIR`: Modifique para alterar o diretório base onde os ambientes serão criados.
#   * `NUM_AMBIENTES`: Ajuste o número de ambientes que deseja criar.
#   * `TERMS_FILE`: Altere o caminho do arquivo de termos, se necessário.
# - Não editar: Não altere a lógica de uso das variáveis, apenas seus valores.
# ###########################################
BASE_DIR="/home/container" # Diretório base onde os ambientes serão criados.
NUM_AMBIENTES="${NUM_AMBIENTES:-3}"            # Número de ambientes que serão configurados.
TERMS_FILE="${BASE_DIR}/termos_accepted.txt" # Caminho do arquivo que indica a aceitação dos termos de serviço.
NOMES_ARQUIVO="${BASE_DIR}/nome_ambientes.json"  # Arquivo que armazena os nomes dos ambientes

# ###########################################
# Cores ANSI
# - Propósito: Define cores para saída no terminal.
# - Editar: Não é necessário editar a configuração das cores.
# ###########################################
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
NC='\033[0m' # Sem cor

# ###########################################
# Função de animação
# - Propósito: Exibe um texto animado no terminal.
# - Editar: Você pode alterar o texto passado para a função quando utilizá-la.
# - Não editar: Não é necessário alterar a lógica da animação.
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
# Função para exibir o outdoor 3D com texto estático
# - Propósito: Exibe um cabeçalho em formato de arte ASCII.
# - Editar:
#   * Você pode personalizar o texto ASCII e as informações exibidas abaixo.
#   * Altere os links ou mensagens para adequar ao seu projeto.
# - Não editar: A lógica para centralizar o texto e exibir a animação.
# ###########################################
exibir_outdoor_3D() {
    clear
    local width=$(tput cols)  # Largura do terminal
    local height=$(tput lines)  # Altura do terminal
    local start_line=$(( height / 3 ))
    local start_col=$(( (width - 60) / 2 ))  # Centraliza o texto

    # Arte 3D do texto principal
    local outdoor_text=(
       " _______  ______    _______  __    _  _______ "
        "|   _   ||    _ |  |       ||  |  | ||   _   |"
        "|  |_|  ||   | ||  |    ___||   |_| ||  |_|  |"
        "|       ||   |_||_ |   |___ |       ||       |"
        "|       ||    __  ||    ___||  _    ||       |"
        "|   _   ||   |  | ||   |___ | | |   ||   _   |"
        "|__| |__||___|  |_||_______||_|  |__||__| |__|" 
    )

    # Exibe o texto 3D centralizado
    for i in "${!outdoor_text[@]}"; do
        tput cup $((start_line + i)) $start_col
        echo -e "${CYAN}${outdoor_text[i]}${NC}"
    done

    # Exibe "Created by Mauro Gashfix" diretamente abaixo do texto 3D
    local footer="Revenda de Bots - Arena Hosting"
    tput cup $((start_line + ${#outdoor_text[@]} + 1)) $(( (width - ${#footer}) / 2 ))
    echo -e "${YELLOW}${footer}${NC}"

    # Exibe os links diretamente abaixo do footer
    local links="arenahosting.com.br"
    tput cup $((start_line + ${#outdoor_text[@]} + 2)) $(( (width - ${#links}) / 2 ))
    echo -e "${GREEN}${links}${NC}"

    # Exibe a barra de inicialização diretamente abaixo dos links
    local progress_bar="Inicializando..."
    tput cup $((start_line + ${#outdoor_text[@]} + 4)) $(( (width - ${#progress_bar} - 20) / 2 ))
    echo -ne "${CYAN}${progress_bar}${NC}"
    for i in $(seq 1 20); do
        echo -ne "${GREEN}#${NC}"
        sleep 0.1
    done
    echo ""
}

# ###########################################
# Função para exibir os termos de serviço
# - Propósito: Solicita que o usuário aceite os termos antes de continuar.
# - Editar:
#   * Personalize as mensagens de termos de serviço exibidas ao usuário.
#   * Altere o texto "ACEITA OS TERMOS?" para refletir as políticas do seu projeto.
# - Não editar: A lógica de verificação e armazenamento do aceite.
# ###########################################
exibir_termos() {
    exibir_outdoor_3D
    sleep 1
    echo -e "${BLUE}Este sistema é exclusivo da Arena Hosting.${NC}"
    echo -e "${CYAN}======================================${NC}"

    if [ ! -f "$TERMS_FILE" ]; then
        while true; do
            echo -e "${YELLOW}VOCÊ ACEITA OS TERMOS DE SERVIÇO? (SIM/NÃO)${NC}"
            read -p "> " ACEITE
            if [ "$ACEITE" = "sim" ]; then
                echo -e "${GREEN}Termos aceitos em $(date).${NC}" > "$TERMS_FILE"
                echo -e "${CYAN}======================================${NC}"
                echo -e "${GREEN}TERMOS ACEITOS. PROSSEGUINDO...${NC}"
                break
            elif [ "$ACEITE" = "não" ]; then
                echo -e "${RED}VOCÊ DEVE ACEITAR OS TERMOS PARA CONTINUAR.${NC}"
            else
                echo -e "${RED}OPÇÃO INVÁLIDA. DIGITE 'SIM' OU 'NÃO'.${NC}"
            fi
        done
    else
        echo -e "${GREEN}TERMOS JÁ ACEITOS ANTERIORMENTE. PROSSEGUINDO...${NC}"
    fi
}

# ###########################################
# Função para criar pastas dos ambientes
# - Propósito: Cria as pastas necessárias para cada ambiente configurado.
# - Editar:
#   * Altere o número de ambientes em `NUM_AMBIENTES` se desejar criar mais ou menos pastas.
# - Não editar: A lógica de criação de pastas.
# ###########################################
criar_pastas() {
    for i in $(seq 1 $NUM_AMBIENTES); do
        AMBIENTE_PATH="${BASE_DIR}/ambiente${i}"
        if [ ! -d "$AMBIENTE_PATH" ]; then
            mkdir -p "$AMBIENTE_PATH"
            echo -e "${GREEN}PASTA DO AMBIENTE ${i} CRIADA.${NC}"
        fi
    done
}

# ###########################################
# Atualizar status do ambiente
# - Propósito: Atualiza o status de um ambiente específico.
# - Editar: Não é necessário editar esta função.
# ###########################################
atualizar_status() {
    AMBIENTE_PATH=$1
    NOVO_STATUS=$2
    echo "$NOVO_STATUS" > "${AMBIENTE_PATH}/status"
    echo -e "${CYAN}Status do ambiente atualizado para: ${GREEN}${NOVO_STATUS}${NC}"
}

# ###########################################
# Recuperar status do ambiente
# - Propósito: Obtém o status atual de um ambiente específico.
# - Editar: Não é necessário editar esta função.
# ###########################################
recuperar_status() {
    AMBIENTE_PATH=$1
    if [ -f "${AMBIENTE_PATH}/status" ]; then
        cat "${AMBIENTE_PATH}/status"
    else
        echo "OFF"
    fi
}

# ###########################################
# Função para verificar e reiniciar sessões em background
# - Propósito: Verifica se há sessões em execução nos ambientes e reinicia, se necessário.
# - Editar: Não é necessário editar essa função. Somente ajuste as mensagens de texto para refletir o seu projeto.
# - Não editar: A lógica de verificação de sessões e reinício.
# ###########################################
verificar_sessoes() {
    echo -e "${CYAN}======================================${NC}"
    anima_texto "VERIFICANDO SESSOES EM BACKGROUND..."
    for i in $(seq 1 $NUM_AMBIENTES); do
        AMBIENTE_PATH="${BASE_DIR}/ambiente${i}"
        if [ -f "${AMBIENTE_PATH}/.session" ]; then
            STATUS=$(recuperar_status "$AMBIENTE_PATH")
            if [ "$STATUS" = "ON" ]; then
                COMANDO=$(cat "${AMBIENTE_PATH}/.session")
                
                if [ -n "$COMANDO" ]; then
                    echo -e "${YELLOW}Executando sessão em background para o ambiente ${i}...${NC}"
                    pkill -f "$COMANDO" 2>/dev/null
                    cd "$AMBIENTE_PATH" || continue
                    nohup $COMANDO > nohup.out 2>&1 &
                    if [ $? -eq 0 ]; then
                        echo -e "${GREEN}SESSÃO EM BACKGROUND ATIVA PARA O AMBIENTE ${i}.${NC}"
                    else
                        echo -e "${RED}Erro ao tentar ativar a sessão no ambiente ${i}.${NC}"
                    fi
                else
                    echo -e "${YELLOW}Comando vazio encontrado no arquivo .session do ambiente ${i}.${NC}"
                fi
            else
                echo -e "${RED}O ambiente ${i} está com status OFF. Ignorando...${NC}"
            fi
        else
            echo -e "${RED}Nenhum arquivo .session encontrado no ambiente ${i}.${NC}"
        fi
    done
    echo -e "${CYAN}======================================${NC}"
}

# ###########################################
# Função para obter o nome do ambiente
# - Propósito: Recupera o nome personalizado do ambiente a partir do arquivo JSON.
# ###########################################
obter_nome_ambiente() {
    local AMBIENTE_NUM=$1
    
    # Verifica se o arquivo de nomes existe
    if [ -f "$NOMES_ARQUIVO" ]; then
        # Verifica se jq está instalado
        if command -v jq >/dev/null 2>&1; then
            # Usa jq para obter o nome do ambiente, pode ser null
            local NOME
            NOME=$(jq -r --arg key "ambiente$AMBIENTE_NUM" '.[$key] // empty' "$NOMES_ARQUIVO" 2>/dev/null)
            echo "$NOME"
        else
            # Fallback básico: procura pela chave no JSON e extrai valor
            local NOME
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

cabecalho() {
    clear
    echo -e "${CYAN}======================================${NC}"
}

nomear_ambiente_unico() {
    local AMBIENTE_NUM=$1
    local NOMES_ARQUIVO="${BASE_DIR}/nome_ambientes.json"

    echo -e "${CYAN}======================================${NC}"
    anima_texto "       NOMEAR AMBIENTE $AMBIENTE_NUM"
    echo -e "${CYAN}======================================${NC}"
    echo -e "${YELLOW}Forneça um novo nome para o ambiente $AMBIENTE_NUM:${NC}"
    read -p "> " NOVO_NOME

    # Cria o arquivo se não existir
    if [ ! -f "$NOMES_ARQUIVO" ]; then
        echo "{}" > "$NOMES_ARQUIVO"
    fi

    # Salva o nome no JSON
    if command -v jq >/dev/null 2>&1; then
        jq ".ambiente${AMBIENTE_NUM} = \"$NOVO_NOME\"" "$NOMES_ARQUIVO" > "${NOMES_ARQUIVO}.tmp" && mv "${NOMES_ARQUIVO}.tmp" "$NOMES_ARQUIVO"
    else
        # Fallback simples com sed (não confiável para JSON complexo)
        sed -i "/\"ambiente${AMBIENTE_NUM}\"/d" "$NOMES_ARQUIVO"
        echo "\"ambiente${AMBIENTE_NUM}\":\"$NOVO_NOME\"" >> "$NOMES_ARQUIVO"
    fi

    echo -e "${GREEN} Nome do ambiente $AMBIENTE_NUM salvo com sucesso: $NOVO_NOME${NC}"
    sleep 1
    # Apenas retorna para o menu anterior — sem reiniciar
}

renomear_ambiente_unico() {
    AMBIENTE_NUM=$1
    NOMES_ARQUIVO="${BASE_DIR}/nome_ambientes.json"

    # Obtém nome atual
    NOME_ATUAL=$(obter_nome_ambiente "$AMBIENTE_NUM")
    [ -z "$NOME_ATUAL" ] && NOME_ATUAL="(sem nome)"

    echo -e "${YELLOW}Nome atual do AMBIENTE $AMBIENTE_NUM:${NC} ${BLUE}${NOME_ATUAL}${NC}"
    echo -e "${YELLOW}Digite o novo nome:${NC}"
    read -p "> " NOVO_NOME

    # Cria o arquivo se não existir
    if [ ! -f "$NOMES_ARQUIVO" ]; then
        echo "{}" > "$NOMES_ARQUIVO"
    fi

    # Atualiza o nome no JSON
    jq ".ambiente${AMBIENTE_NUM} = \"$NOVO_NOME\"" "$NOMES_ARQUIVO" > "${NOMES_ARQUIVO}.tmp" && mv "${NOMES_ARQUIVO}.tmp" "$NOMES_ARQUIVO"

    echo -e "${GREEN}Ambiente $AMBIENTE_NUM renomeado com sucesso!${NC}"

    # Volta para o menu do ambiente
    gerenciar_ambiente "$AMBIENTE_NUM"
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

nomear_ambiente_individual() {
    AMBIENTE_NUM=$1
    NOMES_ARQUIVO="${BASE_DIR}/nome_ambientes.json"

    echo -e "${YELLOW}Digite o nome para o AMBIENTE $AMBIENTE_NUM:${NC}"
    read -p "> " NOVO_NOME

    # Cria o arquivo se não existir
    if [ ! -f "$NOMES_ARQUIVO" ]; then
        echo "{}" > "$NOMES_ARQUIVO"
    fi

    # Atualiza o nome no JSON
    jq ".ambiente${AMBIENTE_NUM} = \"$NOVO_NOME\"" "$NOMES_ARQUIVO" > "${NOMES_ARQUIVO}.tmp" && mv "${NOMES_ARQUIVO}.tmp" "$NOMES_ARQUIVO"

    echo -e "${GREEN}Nome definido com sucesso para o ambiente $AMBIENTE_NUM!${NC}"

    # Volta para o menu do ambiente
    gerenciar_ambiente "$AMBIENTE_NUM"
}

# ###########################################
# Função para exibir o menu principal
# - Propósito: Gerencia a navegação entre os ambientes configurados.
# - Editar: Ajuste as mensagens e opções de texto conforme necessário.
# - Não editar: A lógica de navegação e escolha de ambiente.
# ###########################################
menu_principal() {
    # Verifica automaticamente por atualizações
    verificar_atualizacoes
    verificar_atualizacao_estado

    echo -e "${CYAN}======================================${NC}"
    anima_texto "       GERENCIAMENTO DE AMBIENTES"
    echo -e "${CYAN}======================================${NC}"

    # Caminho do arquivo com os nomes dos ambientes
    NOMES_ARQUIVO="${BASE_DIR}/nome_ambientes.json"

    for i in $(seq 1 $NUM_AMBIENTES); do
        AMBIENTE_PATH="${BASE_DIR}/ambiente${i}"
        STATUS=$(recuperar_status "$AMBIENTE_PATH")

        # Busca o nome no JSON compartilhado
        if [ -f "$NOMES_ARQUIVO" ]; then
            if command -v jq >/dev/null 2>&1; then
                NOME_AMBIENTE=$(jq -r ".ambiente${i}" "$NOMES_ARQUIVO" 2>/dev/null)
                [ "$NOME_AMBIENTE" = "null" ] && NOME_AMBIENTE="(sem nome)"
            else
                NOME_AMBIENTE=$(grep -o "\"ambiente${i}\":\"[^\"]*\"" "$NOMES_ARQUIVO" | cut -d'"' -f4)
                [ -z "$NOME_AMBIENTE" ] && NOME_AMBIENTE="(sem nome)"
            fi
        else
            NOME_AMBIENTE="(sem nome)"
        fi

        echo -e "${YELLOW}AMBIENTE ${i}:${NC} ${BLUE}${NOME_AMBIENTE}${NC} ${GREEN}- STATUS: $STATUS${NC}"
    done

    echo -e "${CYAN}======================================${NC}"
    echo -e "${YELLOW}ESCOLHA UM AMBIENTE PARA GERENCIAR (1-${NUM_AMBIENTES}):${NC}"
    echo -e "${RED}0 - SAIR${NC}"
    read -p "> " AMBIENTE_ESCOLHIDO

    if [ "$AMBIENTE_ESCOLHIDO" -ge 1 ] && [ "$AMBIENTE_ESCOLHIDO" -le "$NUM_AMBIENTES" ]; then
        gerenciar_ambiente "$AMBIENTE_ESCOLHIDO"
    elif [ "$AMBIENTE_ESCOLHIDO" = "0" ]; then
        anima_texto "SAINDO..."
        exit 0
    else
        echo -e "${RED}ESCOLHA INVÁLIDA. TENTE NOVAMENTE.${NC}"
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

    CONTEUDO_REMOTO=$(curl -s --max-time 5 "$URL_SCRIPT")
    if [ -z "$CONTEUDO_REMOTO" ]; then
        echo -e "${YELLOW}Não foi possível verificar atualizações. Tente novamente mais tarde.${NC}"
        return
    fi

    VERSAO_REMOTA=$(echo "$CONTEUDO_REMOTO" | sed -n 's/.*VERSAO[_LOCAL]* *= *"\([0-9]\+\.[0-9]\+\.[0-9]\+\)".*/\1/p' | head -n1)
    if [ -z "$VERSAO_REMOTA" ]; then
        echo -e "${YELLOW}Não foi possível extrair a versão do arquivo remoto.${NC}"
        return
    fi

    echo -e "${CYAN}Versão Atual: ${GREEN}${VERSAO_LOCAL}${NC}"
    echo -e "${CYAN}Versão Disponível: ${GREEN}${VERSAO_REMOTA}${NC}"

    if [ "$VERSAO_REMOTA" = "$VERSAO_LOCAL" ]; then
        echo -e "${GREEN}Você está usando a versão mais recente do nosso script.${NC}"
    elif [ "$(printf "%s\n" "$VERSAO_LOCAL" "$VERSAO_REMOTA" | sort -V | head -n1)" != "$VERSAO_LOCAL" ]; then
        echo -e "${YELLOW}Nova atualização disponível! (${VERSAO_REMOTA})${NC}"
        echo -e "${YELLOW}Instalando atualização automaticamente...${NC}"
        aplicar_atualizacao_automatica
    else
        echo -e "${RED}Erro: a versão disponível (${VERSAO_REMOTA}) é menor que a atual (${VERSAO_LOCAL}).${NC}"
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

# ###########################################
# Função para aplicar atualizações automáticas
# - Propósito: Baixa a nova versão do script e substitui o atual.
# ###########################################
aplicar_atualizacao_automatica() {
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
        echo -e "${YELLOW}Reiniciando o script para aplicar as alterações...${NC}"
        sleep 2
        exec "$SCRIPT_PATH"
    else
        echo -e "${RED}Erro ao aplicar a atualização.${NC}"
    fi
}


# ###########################################
# Função para escolher um bot pronto da Vortexus
# - Propósito: Permite ao usuário selecionar uma lista de bots disponíveis.
# - Editar: Adicione ou remova opções de idiomas disponíveis.
# - Não editar: A lógica de escolha e navegação de menus.
# ###########################################
escolher_bot_pronto() {
    AMBIENTE_PATH=$1
    echo -e "${CYAN}======================================${NC}"
    anima_texto "       ESCOLHER BOT PRONTO"
    echo -e "${CYAN}======================================${NC}"
    echo -e "${YELLOW}1 - BOTS EM PORTUGUÊS${NC}"
    echo -e "${YELLOW}2 - BOTS EM ESPANHOL${NC}"
    echo -e "${RED}0 - VOLTAR${NC}"
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
            echo -e "${RED}Opção inválida.${NC}"
            escolher_bot_pronto "$AMBIENTE_PATH"
            ;;
    esac
}

# ###########################################
# Função para listar bots disponíveis
# - Propósito: Lista os bots disponíveis de acordo com o idioma selecionado.
# - Editar:
#   * Para adicionar novos bots, insira uma nova linha na estrutura correspondente ao idioma:
#     Exemplo para português:
#       "NOME DO BOT - LINK DO REPOSITÓRIO"
#   * Para adicionar novos idiomas, copie a estrutura `elif` e substitua o idioma e os bots.
# - Não editar: A lógica de listagem e seleção de bots.
# ###########################################
listar_bots() {
    AMBIENTE_PATH=$1
    LINGUA=$2
    echo -e "${CYAN}======================================${NC}"
    anima_texto "       BOTS DISPONÍVEIS - ${LINGUA^^}"
    echo -e "${CYAN}======================================${NC}"

    # Estrutura de bots disponíveis
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

    # Passo a passo para adicionar bots:
    # 1. Para cada idioma, localize o bloco `if [ "$LINGUA" = "<idioma>" ];`.
    # 2. Adicione uma nova linha no formato:
    #    "NOME DO BOT - LINK DO REPOSITÓRIO"
    # 3. Para adicionar um novo idioma:
    #    a. Copie um dos blocos existentes (como o `elif [ "$LINGUA" = "espanhol" ];`).
    #    b. Substitua `<idioma>` pelo novo idioma.
    #    c. Adicione os bots correspondentes.
    # 4. Certifique-se de manter o formato correto para que os bots sejam exibidos corretamente.

    for i in "${!BOTS[@]}"; do
        echo -e "${GREEN}$((i+1)) - ${BOTS[$i]%% -*}${NC}"
    done
    echo -e "${RED}0 - VOLTAR${NC}"

    read -p "> " BOT_ESCOLHIDO

    if [ "$BOT_ESCOLHIDO" -ge 1 ] && [ "$BOT_ESCOLHIDO" -le "${#BOTS[@]}" ]; then
        REPOSITORIO="${BOTS[$((BOT_ESCOLHIDO-1))]#*- }"
        verificar_instalacao_bot "$AMBIENTE_PATH" "$REPOSITORIO"
    elif [ "$BOT_ESCOLHIDO" = "0" ]; then
        escolher_bot_pronto "$AMBIENTE_PATH"
    else
        echo -e "${RED}Opção inválida.${NC}"
        listar_bots "$AMBIENTE_PATH" "$LINGUA"
    fi
}


# ###########################################
# Função para verificar a instalação de um bot
# - Propósito: Checa se já existe um bot instalado no ambiente. Se sim, oferece a opção de substituí-lo.
# - Editar: Não é necessário editar a lógica. Somente ajuste as mensagens de texto, se necessário.
# ###########################################
verificar_instalacao_bot() {
    AMBIENTE_PATH=$1
    REPOSITORIO=$2

    if [ -f "${AMBIENTE_PATH}/package.json" ]; then
        echo -e "${YELLOW}Já existe um bot instalado neste ambiente.${NC}"
        echo -e "${YELLOW}Deseja remover o bot existente para instalar o novo? (sim/não)${NC}"
        read -p "> " RESPOSTA
        if [ "$RESPOSTA" = "sim" ]; then
            remover_bot "$AMBIENTE_PATH"
            instalar_novo_bot "$AMBIENTE_PATH" "$REPOSITORIO"
        else
            echo -e "${RED}Retornando ao menu principal...${NC}"
            menu_principal
        fi
    else
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
                [ $? -eq 0 ] && echo -e "${GREEN}Módulos instalados com sucesso!${NC}" || echo -e "${RED}Erro ao instalar módulos com npm.${NC}"
                ;;
            2)
                echo -e "${CYAN}Instalando módulos com yarn...${NC}"
                cd "$AMBIENTE_PATH" && yarn install
                [ $? -eq 0 ] && echo -e "${GREEN}Módulos instalados com sucesso!${NC}" || echo -e "${RED}Erro ao instalar módulos com yarn.${NC}"
                ;;
            0)
                menu_principal
                ;;
            *)
                echo -e "${RED}Opção inválida.${NC}"
                verificar_node_modules "$AMBIENTE_PATH"
                ;;
        esac
    else
        echo -e "${GREEN}Todos os módulos necessários já estão instalados.${NC}"
    fi
    pos_clone_menu "$AMBIENTE_PATH"
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
            find "$AMBIENTE_PATH" -mindepth 1 -exec rm -rf {} + 2>/dev/null
            [ -z "$(ls -A "$AMBIENTE_PATH")" ] && echo -e "${GREEN}Bot removido com sucesso.${NC}" || echo -e "${RED}Erro ao remover o bot.${NC}"
        else
            echo -e "${RED}Remoção cancelada.${NC}"
        fi
    else
        echo -e "${RED}Nenhum bot encontrado neste ambiente.${NC}"
    fi
    menu_principal
}

# ###########################################
# Função para clonar repositório
# - Propósito: Permite clonar repositórios públicos e privados no ambiente.
# - Editar:
#   * Ajuste as mensagens, se necessário.
#   * Para tokens de acesso privado, mantenha as instruções para o usuário.
# ###########################################
clonar_repositorio() {
    AMBIENTE_PATH=$1
    echo -e "${CYAN}======================================${NC}"
    anima_texto "       CLONAR REPOSITÓRIO"
    echo -e "${CYAN}======================================${NC}"
    echo -e "${YELLOW}1 - Clonar repositório público${NC}"
    echo -e "${YELLOW}2 - Clonar repositório privado${NC}"
    echo -e "${RED}0 - Voltar${NC}"
    read -p "> " OPCAO_CLONAR

    case $OPCAO_CLONAR in
        1)
            echo -e "${CYAN}Forneça a URL do repositório público:${NC}"
            read -p "> " URL_REPOSITORIO
            if [[ $URL_REPOSITORIO != https://github.com/* ]]; then
                echo -e "${RED}URL inválida!${NC}"
                clonar_repositorio "$AMBIENTE_PATH"
                return
            fi
            echo -e "${CYAN}Clonando repositório público...${NC}"
            git clone "$URL_REPOSITORIO" "$AMBIENTE_PATH" 2>/dev/null
            [ $? -eq 0 ] && echo -e "${GREEN}Repositório clonado com sucesso!${NC}" || echo -e "${RED}Erro ao clonar o repositório.${NC}"
            ;;
        2)
            echo -e "${CYAN}Forneça a URL do repositório privado:${NC}"
            read -p "> " URL_REPOSITORIO
            echo -e "${CYAN}Usuário do GitHub:${NC}"
            read -p "> " USERNAME
            echo -e "${CYAN}Forneça o token de acesso:${NC}"
            read -s -p "> " TOKEN
            echo
            GIT_URL="https://${USERNAME}:${TOKEN}@$(echo $URL_REPOSITORIO | cut -d/ -f3-)"
            echo -e "${CYAN}Clonando repositório privado...${NC}"
            git clone "$GIT_URL" "$AMBIENTE_PATH" 2>/dev/null
            [ $? -eq 0 ] && echo -e "${GREEN}Repositório privado clonado com sucesso!${NC}" || echo -e "${RED}Erro ao clonar o repositório privado.${NC}"
            ;;
        0)
            menu_principal
            ;;
        *)
            echo -e "${RED}Opção inválida.${NC}"
            clonar_repositorio "$AMBIENTE_PATH"
            ;;
    esac
}

# ###########################################
# Função para o menu pós-clone
# - Propósito: Permite que o usuário escolha o que fazer após clonar um repositório.
# - Editar: 
#   * Ajustar mensagens, se necessário.
#   * Não é necessário alterar a lógica principal.
# ###########################################
pos_clone_menu() {
    AMBIENTE_PATH=$1
    echo -e "${CYAN}======================================${NC}"
    anima_texto "O QUE VOCÊ DESEJA FAZER AGORA?"
    echo -e "${CYAN}======================================${NC}"
    echo -e "${YELLOW}1 - Executar o bot${NC}"
    echo -e "${YELLOW}2 - Instalar módulos${NC}"
    echo -e "${RED}0 - Voltar para o menu principal${NC}"
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
            echo -e "${RED}Opção inválida.${NC}"
            pos_clone_menu "$AMBIENTE_PATH"
            ;;
    esac
}

# ###########################################
# Função para instalar módulos
# - Propósito: Garante que as dependências necessárias para o bot sejam instaladas.
# - Editar:
#   * Ajustar mensagens, se necessário.
#   * A lógica principal não requer alterações.
# ###########################################
instalar_modulos() {
    AMBIENTE_PATH=$1
    echo -e "${CYAN}======================================${NC}"
    anima_texto "INSTALAR MÓDULOS"
    echo -e "${CYAN}======================================${NC}"
    echo -e "${YELLOW}1 - Instalar com npm install${NC}"
    echo -e "${YELLOW}2 - Instalar com yarn install${NC}"
    echo -e "${RED}0 - Voltar para o menu principal${NC}"
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
            pos_clone_menu "$AMBIENTE_PATH"
            ;;
        2)
            echo -e "${CYAN}Instalando módulos com yarn...${NC}"
            cd "$AMBIENTE_PATH" && yarn install
            if [ $? -eq 0 ]; then
                echo -e "${GREEN}Módulos instalados com sucesso!${NC}"
            else
                echo -e "${RED}Erro ao instalar módulos com yarn.${NC}"
            fi
            pos_clone_menu "$AMBIENTE_PATH"
            ;;
        0)
            menu_principal
            ;;
        *)
            echo -e "${RED}Opção inválida.${NC}"
            instalar_modulos "$AMBIENTE_PATH"
            ;;
    esac
}

# ###########################################
# Função para iniciar o bot
# - Propósito: Inicia o bot com base nas configurações do ambiente.
# - Editar:
#   * Ajustar mensagens, se necessário.
#   * Mantenha a lógica principal inalterada para evitar conflitos.
# ###########################################
# Ajuste da função iniciar_bot()
iniciar_bot() {
    AMBIENTE_PATH=$1
    if [ -f "${AMBIENTE_PATH}/.session" ]; then
        STATUS=$(recuperar_status "$AMBIENTE_PATH")
        if [ "$STATUS" = "OFF" ]; then
            echo -e "${YELLOW}Sessão existente com status OFF.${NC}"
            echo -e "${YELLOW}1 - Reiniciar o bot${NC}"
            echo -e "${RED}0 - Voltar${NC}"
            read -p "> " OPCAO_EXISTENTE
            case $OPCAO_EXISTENTE in
                1)
                    COMANDO=$(cat "${AMBIENTE_PATH}/.session")
                    nohup sh -c "cd $AMBIENTE_PATH && $COMANDO" > "${AMBIENTE_PATH}/nohup.out" 2>&1 &
                    echo $! > "${AMBIENTE_PATH}/.bot.pid"
                    atualizar_status "$AMBIENTE_PATH" "ON"
                    monitorar_bot "$AMBIENTE_PATH" &
                    echo $! > "${AMBIENTE_PATH}/.monitor.pid"
                    clear
                    echo -e "${GREEN}Bot reiniciado com sucesso! Voltando ao menu principal em 5 segundos...${NC}"
                    sleep 5
                    menu_principal
                    ;;
                0)
                    menu_principal
                    ;;
                *)
                    echo -e "${RED}Opção inválida.${NC}"
                    iniciar_bot "$AMBIENTE_PATH"
                    ;;
            esac
        elif [ "$STATUS" = "ON" ]; then
            echo -e "${RED}Já existe uma sessão ativa neste ambiente.${NC}"
            echo -e "${RED}Por favor, finalize a sessão atual antes de iniciar outra.${NC}"
            echo -e "${YELLOW}0 - Voltar${NC}"
            read -p "> " OPCAO
            [ "$OPCAO" = "0" ] && menu_principal
        fi
    else
        echo -e "${CYAN}Escolha como deseja iniciar o bot:${NC}"
        echo -e "${YELLOW}1 - node .${NC}"
        echo -e "${YELLOW}2 - Especificar arquivo (ex: index.js ou start.sh)${NC}"
        echo -e "${RED}0 - Voltar${NC}"
        read -p "> " INICIAR_OPCAO

        case $INICIAR_OPCAO in
            1)
                echo "node ." > "${AMBIENTE_PATH}/.session"
                nohup sh -c "cd $AMBIENTE_PATH && node ." > "${AMBIENTE_PATH}/nohup.out" 2>&1 &
                echo $! > "${AMBIENTE_PATH}/.bot.pid"
                atualizar_status "$AMBIENTE_PATH" "ON"
                monitorar_bot "$AMBIENTE_PATH" &
                echo $! > "${AMBIENTE_PATH}/.monitor.pid"
                clear
                echo -e "${GREEN}Bot iniciado com sucesso! Voltando ao menu principal em 5 segundos...${NC}"
                sleep 5
                menu_principal
                ;;
            2)
                echo -e "${YELLOW}Digite o nome do arquivo para executar:${NC}"
                read ARQUIVO
                if [[ $ARQUIVO == *.sh ]]; then
                    echo "sh $ARQUIVO" > "${AMBIENTE_PATH}/.session"
                    nohup sh -c "cd $AMBIENTE_PATH && sh $ARQUIVO" > "${AMBIENTE_PATH}/nohup.out" 2>&1 &
                else
                    echo "node $ARQUIVO" > "${AMBIENTE_PATH}/.session"
                    nohup sh -c "cd $AMBIENTE_PATH && node $ARQUIVO" > "${AMBIENTE_PATH}/nohup.out" 2>&1 &
                fi
                echo $! > "${AMBIENTE_PATH}/.bot.pid"
                atualizar_status "$AMBIENTE_PATH" "ON"
                monitorar_bot "$AMBIENTE_PATH" &
                echo $! > "${AMBIENTE_PATH}/.monitor.pid"
                clear
                echo -e "${GREEN}Bot iniciado com sucesso! Voltando ao menu principal em 5 segundos...${NC}"
                sleep 5
                menu_principal
                ;;
            0)
                menu_principal
                ;;
            *)
                echo -e "${RED}Opção inválida.${NC}"
                iniciar_bot "$AMBIENTE_PATH"
                ;;
        esac
    fi
}

# ###########################################
# Função para parar o bot
# - Propósito: Finaliza o processo do bot em execução em segundo plano.
# - Editar:
#   * Ajustar mensagens exibidas, se necessário.
#   * A lógica de finalização do processo e atualização do status não deve ser alterada.
# ###########################################
parar_bot() {
    AMBIENTE_PATH=$1
    echo -e "${CYAN}======================================${NC}"
    anima_texto "PARAR O BOT"
    echo -e "${CYAN}======================================${NC}"
    if [ -f "${AMBIENTE_PATH}/.session" ]; then
        COMANDO=$(cat "${AMBIENTE_PATH}/.session")

        # Mata processo do bot
        pkill -f "cd $AMBIENTE_PATH && $COMANDO" 2>/dev/null

        # Mata monitor de status
        if [ -f "${AMBIENTE_PATH}/.monitor.pid" ]; then
            kill $(cat "${AMBIENTE_PATH}/.monitor.pid") 2>/dev/null
            rm "${AMBIENTE_PATH}/.monitor.pid"
        fi

        atualizar_status "$AMBIENTE_PATH" "OFF"
        clear
        echo -e "${GREEN}Bot parado com sucesso.${NC}"
        menu_principal
    else
        echo -e "${RED}Nenhuma sessão ativa encontrada para parar.${NC}"
        menu_principal
    fi
}

# ###########################################
# Função para reiniciar o bot
# - Propósito: Reinicia o processo do bot com base nas configurações do ambiente.
# - Editar:
#   * Mensagens exibidas, se necessário.
#   * A lógica principal deve permanecer inalterada para evitar conflitos.
# ###########################################
reiniciar_bot() {
    AMBIENTE_PATH=$1
    echo -e "${CYAN}======================================${NC}"
    anima_texto "REINICIAR O BOT"
    echo -e "${CYAN}======================================${NC}"
    if [ -f "${AMBIENTE_PATH}/.session" ]; then
        COMANDO=$(cat "${AMBIENTE_PATH}/.session")
        
        # Finaliza o processo antigo e inicia um novo
        pkill -f "$COMANDO" 2>/dev/null
        cd "$AMBIENTE_PATH" && nohup $COMANDO > nohup.out 2>&1 &
        clear
        atualizar_status "$AMBIENTE_PATH" "ON"
        echo -e "${GREEN}Bot reiniciado com sucesso.${NC}"
    else
        echo -e "${RED}Nenhuma sessão ativa encontrada para reiniciar.${NC}"
    fi
    menu_principal
}

monitorar_bot() {
    AMBIENTE_PATH="$1"

    while true; do
        sleep 120  # espera 2 minutos

        STATUS=$(recuperar_status "$AMBIENTE_PATH")

        # Verifica se o processo do bot ainda está rodando
        if [ "$STATUS" = "ON" ]; then
            COMANDO=$(cat "${AMBIENTE_PATH}/.session")
            if ! pgrep -f "$COMANDO" > /dev/null; then
                echo -e "${RED}O bot caiu inesperadamente. Reiniciando...${NC}"
                nohup sh -c "cd $AMBIENTE_PATH && $COMANDO" > "${AMBIENTE_PATH}/nohup.out" 2>&1 &
                echo "$(date) - Bot reiniciado automaticamente." >> "${AMBIENTE_PATH}/monitor.log"
            fi
        else
            echo "$(date) - Bot desligado manualmente. Monitoramento pausado." >> "${AMBIENTE_PATH}/monitor.log"
            break
        fi
    done
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

    if [ -f "${AMBIENTE_PATH}/nohup.out" ]; then
        clear
        echo -e "${YELLOW}Digite 'exit' para sair e voltar ao menu principal.${NC}"
        # Inicia tail em background
        tail -f "${AMBIENTE_PATH}/nohup.out" &
        TAIL_PID=$!

        while true; do
            read -r -p "> " CMD
            if [ "$CMD" = "exit" ]; then
                kill $TAIL_PID 2>/dev/null
                wait $TAIL_PID 2>/dev/null
                break
            else
                echo -e "${RED}Comando inválido. Digite 'exit' para sair.${NC}"
            fi
        done
    else
        echo -e "${RED}Nenhuma saída encontrada para o terminal.${NC}"
    fi

    clear          # LIMPA A TELA AO SAIR DO TAIL
    menu_principal # MOSTRA O MENU NOVAMENTE
}

# ###########################################
# Função para deletar a sessão
# - Propósito: Remove o arquivo de sessão associado ao bot e finaliza o processo em execução.
# - Editar:
#   * Ajustar mensagens exibidas, se necessário.
#   * A lógica de exclusão e finalização do processo deve ser mantida.
# ###########################################
deletar_sessao() {
    AMBIENTE_PATH=$1
    echo -e "${CYAN}======================================${NC}"
    anima_texto "DELETAR SESSÃO"
    echo -e "${CYAN}======================================${NC}"
    if [ -f "${AMBIENTE_PATH}/.session" ]; then
        COMANDO=$(cat "${AMBIENTE_PATH}/.session")
        
        # Finaliza o processo e remove o arquivo de sessão
        pkill -f "$COMANDO" 2>/dev/null
        rm -f "${AMBIENTE_PATH}/.session"
        clear
        atualizar_status "$AMBIENTE_PATH" "OFF"
        echo -e "${GREEN}Sessão deletada com sucesso. Por favor, reinicie seu servidor para dar efeito.${NC}"
        exec /bin/bash
    else
        echo -e "${RED}Nenhuma sessão ativa encontrada para deletar.${NC}"
    fi
    menu_principal
}

# ###########################################
# Função para gerenciar ambiente
# - Propósito: Fornece um menu interativo para gerenciar um ambiente específico.
# - Editar:
#   * Mensagens exibidas para o usuário podem ser personalizadas.
#   * Não altere as chamadas de funções ou lógica principal do menu.
# ###########################################
gerenciar_ambiente() {
    AMBIENTE_PATH="${BASE_DIR}/ambiente$1"

    echo -e "${CYAN}======================================${NC}"
    anima_texto "GERENCIANDO AMBIENTE $1"
    echo -e "${CYAN}======================================${NC}"

    echo -e "${YELLOW}1 - INICIAR O BOT${NC}"
    echo -e "${YELLOW}2 - PARAR O BOT${NC}"
    echo -e "${YELLOW}3 - REINICIAR O BOT${NC}"
    echo -e "${YELLOW}4 - VISUALIZAR O TERMINAL${NC}"
    echo -e "${YELLOW}5 - DELETAR SESSÃO${NC}"
    echo -e "${YELLOW}6 - REMOVER BOT ATUAL${NC}"
    echo -e "${YELLOW}7 - CLONAR REPOSITÓRIO${NC}"
    echo -e "${YELLOW}8 - NOMEAR ESTE AMBIENTE${NC}"
    echo -e "${YELLOW}9 - RENOMEAR ESTE AMBIENTE${NC}"
    echo -e "${RED}0 - VOLTAR${NC}"

    read -p "> " OPCAO

    case $OPCAO in
        1) iniciar_bot "$AMBIENTE_PATH" ;;
        2) parar_bot "$AMBIENTE_PATH" ;;
        3) reiniciar_bot "$AMBIENTE_PATH" ;;
        4) ver_terminal "$AMBIENTE_PATH" ;;
        5) deletar_sessao "$AMBIENTE_PATH" ;;
        6) remover_bot "$AMBIENTE_PATH" ;;
        7) clonar_repositorio "$AMBIENTE_PATH" ;;
        8)
            nomear_ambiente_unico "$1"
            sleep 1
            gerenciar_ambiente "$1"
            ;;
        9)
            renomear_ambiente_unico "$1"
            sleep 1
            gerenciar_ambiente "$1"
            ;;
        0) menu_principal ;;
        *)
            echo -e "${RED}Opção inválida.${NC}"
            sleep 1
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