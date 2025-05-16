#!/bin/bash

# Variáveis importantes (serão herdadas do script principal)
# BASE_DIR, URL_SCRIPT, SCRIPT_PATH

verificar_atualizacoes() {
    VERSAO_LOCAL="1.0.0"

    echo -e "${CYAN}======================================${NC}"
    echo -e "       VERIFICANDO ATUALIZAÇÕES"
    echo -e "${CYAN}======================================${NC}"

    echo -e "${CYAN}Versão Atual: ${GREEN}${VERSAO_LOCAL}${NC}"
    echo -e "${CYAN}Versão Disponível: ${GREEN}${VERSAO_REMOTA}${NC}"

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

aplicar_atualizacao_automatica() {
    backup_num_ambientes

    echo -e "${CYAN}Baixando a nova versão do script...${NC}"
    curl -s -o "${BASE_DIR}/script_atualizado.sh" "$URL_SCRIPT"

    if [ $? -ne 0 ]; then
        echo -e "${RED}Erro ao baixar a nova versão do script.${NC}"
        return 1
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
        return 1
    fi
}
