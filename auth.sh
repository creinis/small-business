
# Fonte do script de autenticação
source ./auth.sh

# Realizar autenticação
authenticate

# Se o usuário for master, oferecer escolha entre área administrativa e área do cliente
if [[ "$USER_ROLE" == "master" ]]; then
    echo -e "Access granted to Admin Menu\n"
    echo -e "Welcome Master Adm.\n"
    echo "1. Adm Area"
    echo "2. Client Area"
    read MASTER_OPTION
    case $MASTER_OPTION in
        1)
            source ./adm.sh
            echo "Accessing Admin Area..."
            ADM_MENU
            ;;
        2)
            echo "Accessing Client Area..."
            ;;
        *)
            echo "Invalid option. Defaulting to Client Area..."
            ;;
    esac
fi







#!/bin/bash

# Função para autenticação de usuário
authenticate() {
  echo -n "Username: "
  read USERNAME
  echo -n "Password: "
  read -s PASSWORD
  echo

  # Verificar credenciais
  RESULT=$(psql -U seu_usuario -d beauty_salon -t -c "SELECT role FROM users WHERE username='$USERNAME' AND password=crypt('$PASSWORD', password);")
  
  if [[ -z "$RESULT" ]]; then
    echo "Login falhou. Tente novamente."
    exit 1
  else
    USER_ROLE=$(echo $RESULT | xargs)
    echo "Login bem-sucedido. Bem-vindo, $USERNAME!"
  fi
}

# Função para criar novo usuário (apenas para master)
create_user() {
  if [[ "$USER_ROLE" != "master" ]]; then
    echo "Acesso negado. Apenas usuário master pode criar novos usuários."
    return
  fi

  echo -n "Novo username: "
  read NEW_USERNAME
  echo -n "Novo password: "
  read -s NEW_PASSWORD
  echo
  echo -n "Confirme o novo password: "
  read -s CONFIRM_PASSWORD
  echo

  if [[ "$NEW_PASSWORD" != "$CONFIRM_PASSWORD" ]]; then
    echo "Passwords não coincidem. Tente novamente."
    return
  fi

  # Inserir novo usuário no banco de dados
  psql -U seu_usuario -d beauty_salon -c "INSERT INTO users (username, password, role) VALUES ('$NEW_USERNAME', crypt('$NEW_PASSWORD', gen_salt('bf')), 'user');"
  echo "Novo usuário criado com sucesso."
}

# Função para alterar um serviço (apenas para master)
alter_service() {
  if [[ "$USER_ROLE" != "master" ]]; then
    echo "Acesso negado. Apenas usuário master pode alterar serviços."
    return
  fi

  # Implementar lógica para alterar serviços aqui
  echo "Função para alterar serviços ainda não implementada."
}
