#!/bin/bash

# Função para autenticação de usuário
authenticate() {
  echo -n "Username: "
  read USERNAME
  echo -n "Password: "
  read -s PASSWORD
  echo

  # Verificar credenciais
  RESULT=$(psql -U carlosreinis -d small_business -t -c "SELECT role FROM users WHERE username='$USERNAME' AND password=crypt('$PASSWORD', password);")
  
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
  psql -U seu_usuario -d small_business -c "INSERT INTO users (username, password, role) VALUES ('$NEW_USERNAME', crypt('$NEW_PASSWORD', gen_salt('bf')), 'user');"
  echo "Novo usuário criado com sucesso."
}

