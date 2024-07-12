# Small Business Management System


###### Technologies:
<p align="center">
<img src="https://raw.githubusercontent.com/danielcranney/readme-generator/main/public/icons/skills/postgresql-colored.svg" width="75" height="75" alt="PostgreSQL" style="margin: 10px 15px 0 15px;" />
<img src="https://img.icons8.com/color/75/000000/console.png" width="75" height="75" alt="Bash" style="margin: 10px 15px 0 15px;" />
</p>

- **Bash:** Utilizado para escrever scripts de shell que facilitam a configuração, manutenção e consulta do banco de dados.
- **PostgreSQL:** Sistema de gerenciamento de banco de dados relacional utilizado para armazenar os dados dos elementos químicos.

## Descrição

Este projeto é um sistema de gerenciamento para pequenas empresas, desenvolvido para ajudar a gerenciar clientes, funcionários, serviços e agendamentos de um salão de beleza. O sistema é composto por um banco de dados PostgreSQL e um script em Shell para interação com o banco de dados, permitindo consultas e atualizações.

## Estrutura do Projeto

### Arquivo SQL de Criação do Banco de Dados

O arquivo `small_business.sql` contém a definição do banco de dados, incluindo a criação de tabelas e inserção de dados iniciais. As tabelas incluídas são:

- `employees`: Armazena informações sobre os funcionários.
- `customers`: Armazena informações sobre os clientes.
- `services`: Armazena informações sobre os serviços oferecidos.
- `appointments`: Armazena informações sobre os agendamentos de serviços.
- `days`, `months`, `years`: Tabelas auxiliares para armazenar dias, meses e anos.
- `times`: Armazena intervalos de tempo disponíveis.
- `purchases`: Armazena informações sobre compras realizadas.
- `payment_methods`: Armazena métodos de pagamento disponíveis.
- `promotions`: Armazena promoções aplicáveis aos serviços.

### Script Shell para Gerenciamento

O arquivo `small_business.sh` é um script em Shell que permite a interação com o banco de dados através de um menu. As funcionalidades incluem:

- Consultar informações de clientes por nome, telefone ou email.
- Visualizar a agenda semanal com disponibilidade de horários.
- Consultar serviços disponíveis.
- Criar, visualizar e cancelar agendamentos.

## Como Usar

### Configuração do Banco de Dados

1. **Criação do Banco de Dados**: Para criar o banco de dados e suas tabelas, execute o arquivo SQL com o comando:
    ```bash
    psql -U <username> -f small_business.sql
    ```
    Certifique-se de substituir `<username>` pelo nome do usuário do banco de dados PostgreSQL.

### Execução do Script Shell

1. **Permissão de Execução**: Garanta que o script tenha permissão de execução:
    ```bash
    chmod +x small_business.sh
    ```

2. **Executar o Script**: Execute o script para iniciar o sistema de gerenciamento:
    ```bash
    ./small_business.sh
    ```

### Navegação no Menu

- **Main Menu**:
  - **1) Consult Customer**: Permite consultar informações de clientes por nome, telefone ou email.
  - **2) Consult Agenda**: Visualiza a agenda semanal com os horários disponíveis e permite criar ou cancelar agendamentos.
  - **3) Consult Services**: Lista todos os serviços disponíveis.
  - **4) Exit**: Sai do sistema.

- **Consult Customer Menu**:
  - **1) Name**: Consulta cliente pelo nome.
  - **2) Phone**: Consulta cliente pelo telefone.
  - **3) Email**: Consulta cliente pelo email.
  - **4) Back**: Retorna ao menu principal.

- **Agenda Menu**:
  - **1) Create Appointment**: Cria um novo agendamento.
  - **2) View Weekly Calendar**: Visualiza a agenda semanal.
  - **3) Cancel Appointment**: Cancela um agendamento existente.
  - **4) Back**: Retorna ao menu principal.

## Tecnologias Utilizadas

- **PostgreSQL**: Para gerenciamento do banco de dados.
- **Shell Script**: Para a interface de linha de comando e interação com o banco de dados.

## Contribuição

Contribuições são bem-vindas! Sinta-se à vontade para abrir issues ou enviar pull requests no [repositório do GitHub](https://github.com/username/small-business-management).

## Licença

Este projeto está licenciado sob a [MIT License](LICENSE).

---