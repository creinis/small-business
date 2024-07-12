#!/bin/bash

source ./auth.sh

authenticate

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

PSQL="psql -X --username=carlosreinis --dbname=small_business --tuples-only -c"

echo -e "\n    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ SMALL BUSINESS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n"
echo -e "          Welcome to Small Business Management, how can I help you?\n"

# Main Menu Function
MAIN_MENU() {
  echo -e "\nMain Menu:"
  echo "1) Consult Customer"
  echo "2) Consult Agenda"
  echo "3) Consult Services"
  echo "4) Exit"
  read MAIN_MENU_OPTION
  case $MAIN_MENU_OPTION in
    1) CONSULT_CUSTOMER_MENU ;;
    2) CONSULT_AGENDA_MENU ;;
    3) CONSULT_SERVICES_MENU ;;
    4) exit ;;
    *) MAIN_MENU "Invalid option. Please try again." ;;
  esac
}

# Function to consult customer by name, phone, or email
CONSULT_CUSTOMER_MENU() {
  echo -e "\nConsult Customer:"
  echo "1) Name"
  echo "2) Phone"
  echo "3) Email"
  echo "4) Back"
  read CUSTOMER_MENU_OPTION
  case $CUSTOMER_MENU_OPTION in
    1) CONSULT_CUSTOMER "name" ;;
    2) CONSULT_CUSTOMER "phone" ;;
    3) CONSULT_CUSTOMER "email" ;;
    4) MAIN_MENU ;;
    *) CONSULT_CUSTOMER_MENU "Invalid option. Please try again." ;;
  esac
}

CONSULT_CUSTOMER() {
  local QUERY_TYPE=$1
  echo -e "\nEnter the customer's $QUERY_TYPE:"
  read CUSTOMER_INFO
  CUSTOMER_DATA=$($PSQL "SELECT * FROM customers WHERE $QUERY_TYPE = '$CUSTOMER_INFO'")
  if [[ -z $CUSTOMER_DATA ]]; then
    echo "Customer not found. Please try again."
    CONSULT_CUSTOMER_MENU
  else
    echo "$CUSTOMER_DATA"
    MAIN_MENU
  fi
}

# Function to get days of the week starting from today
GET_DAYS_OF_WEEK() {
  local current_day=$(date +"%d")
  local days=()

  for ((i = 0; i < 7; i++)); do
    day=$((current_day + i))
    if ((day > 31)); then
      day=$((day - 31))
    fi
    days+=("$day")
  done

  echo "${days[@]}"
}

# Function to get current month and year
GET_CURRENT_MONTH_YEAR() {
  CURRENT_MONTH=$(date +"%m")
  CURRENT_YEAR=$(date +"%Y")
  echo "$CURRENT_MONTH/$CURRENT_YEAR"
}

# Function to get available times from the database
GET_TIMES() {
  $PSQL "SELECT time_interval FROM public.times WHERE time_interval >= '10:00' AND time_interval <= '21:30' ORDER BY time_interval;"
}

# Function to draw the weekly calendar
DRAW_WEEKLY_CALENDAR() {
  local days=($(GET_DAYS_OF_WEEK))
  local month_year=$(GET_CURRENT_MONTH_YEAR)
  local month=$(date +"%B")
  local year=$(date +"%Y")

  echo -e "\n    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ WEEKLY CALENDAR ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n"
  echo -e "    Week of: $(date +"%d/%m/%Y")\n"

  echo "    $month_year"
  echo "    $month"

  echo -n "                "
  for day in "${days[@]}"; do
    printf "%-11s" "$day"
  done
  echo ""
  
  echo "  +--------+----------+----------+----------+----------+----------+----------+----------+"
  
  local times=$(GET_TIMES)
  local time_array=($times)
  local num_times=${#time_array[@]}
  
  for ((t = 0; t < $num_times; t++)); do
    local time=${time_array[$t]}
    printf "  | %-6s |" "$time"
    for ((d = 0; d < ${#days[@]}; d++)); do
      APPOINTMENT=$($PSQL "SELECT service_id FROM appointments WHERE appointment_date = '$(date +"%Y-%m")-${days[$d]}' AND appointment_time = '$time'")
      if [[ -z $APPOINTMENT ]]; then
        printf "          |"
      else
        printf " XXXXXXXX |"
      fi
    done
    echo ""
    if [[ $t -lt $(($num_times - 1)) ]]; then
      echo "  +--------+----------+----------+----------+----------+----------+----------+----------+"
    fi
  done

  echo "  +--------+----------+----------+----------+----------+----------+----------+----------+"
}

# Function to create an appointment
CREATE_APPOINTMENT() {
  echo "O Cliente é:"
  echo "1. Novo"
  echo "2. Frequente"
  read CUSTOMER_TYPE

  if [[ $CUSTOMER_TYPE -eq 1 ]]; then
    while true; do
      echo "Enter customer's email (or type 0 to go back):"
      read CUSTOMER_EMAIL
      if [[ $CUSTOMER_EMAIL == "0" ]]; then
        AGENDA_MENU
        return
      fi
      CUSTOMER_DATA=$($PSQL "SELECT customer_id, name, phone, email, birthday FROM customers WHERE email = '$CUSTOMER_EMAIL'")
      if [[ -n $CUSTOMER_DATA ]]; then
        echo "Email already exists. Switching to frequent customer mode."
        CUSTOMER_TYPE=2
        break
      else
        break
      fi
    done

    if [[ $CUSTOMER_TYPE -eq 1 ]]; then
      echo "Please register the customer."
      echo "Enter customer's name (or type 0 to go back):"
      read CUSTOMER_NAME
      if [[ $CUSTOMER_NAME == "0" ]]; then
        AGENDA_MENU
        return
      fi
      echo "Enter customer's phone (or type 0 to go back):"
      read PHONE
      if [[ $PHONE == "0" ]]; then
        AGENDA_MENU
        return
      fi
      echo "Enter customer's birthday (format: YYYY-MM-DD) (or type 0 to go back):"
      read CUSTOMER_BIRTHDAY
      if [[ $CUSTOMER_BIRTHDAY == "0" ]]; then
        AGENDA_MENU
        return
      fi
      INSERT_CUSTOMER=$($PSQL "INSERT INTO customers (name, phone, email, birthday) VALUES ('$CUSTOMER_NAME', '$PHONE', '$CUSTOMER_EMAIL', '$CUSTOMER_BIRTHDAY')")
      CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE email = '$CUSTOMER_EMAIL'")
      if [[ -z $CUSTOMER_ID ]]; then
        echo "Error registering customer. Please try again."
        return
      else
        echo "Customer registered successfully."
        echo "Bem vindo, $CUSTOMER_NAME!"

        # Automaticamente mudar para o modo Frequente com os dados do cliente recém-registrado
        CUSTOMER_TYPE=2
        CUSTOMER_INFO=$CUSTOMER_EMAIL
      fi
    fi
  fi

  if [[ $CUSTOMER_TYPE -eq 2 ]]; then
    CUSTOMER_INFO=$CUSTOMER_EMAIL  # Utiliza o email do cliente recém-registrado
    CUSTOMER_DATA=$($PSQL "SELECT customer_id, name, phone, email, birthday FROM customers WHERE email = '$CUSTOMER_INFO'")
    if [[ -z $CUSTOMER_DATA ]]; then
      echo "Customer not found. Please enter a valid phone, email, or name."
      CREATE_APPOINTMENT
      return
    else
      CUSTOMER_ID=$(echo $CUSTOMER_DATA | cut -d '|' -f 1 | xargs)
      CUSTOMER_NAME=$(echo $CUSTOMER_DATA | cut -d '|' -f 2 | xargs)
      PHONE=$(echo $CUSTOMER_DATA | cut -d '|' -f 3 | xargs)
      CUSTOMER_EMAIL=$(echo $CUSTOMER_DATA | cut -d '|' -f 4 | xargs)
      CUSTOMER_BIRTHDAY=$(echo $CUSTOMER_DATA | cut -d '|' -f 5 | xargs)
      echo "Customer Details: Name: $CUSTOMER_NAME, Phone: $PHONE, Email: $CUSTOMER_EMAIL, Birthday: $CUSTOMER_BIRTHDAY"
    fi
  else
    echo "Invalid option. Please try again."
    CREATE_APPOINTMENT
    return
  fi

  while true; do
    echo "Available Services:"
    SERVICES=$($PSQL "SELECT service_id, name, price FROM services")
    echo "$SERVICES"
    echo "Enter the ID of the desired service (or type 0 to go back):"
    read SERVICE_ID
    if [[ $SERVICE_ID == "0" ]]; then
      AGENDA_MENU
      return
    fi
    SERVICE_VALID=$($PSQL "SELECT count(*) FROM services WHERE service_id = $SERVICE_ID")
    if [[ $SERVICE_VALID -eq 0 ]]; then
      echo "Serviço inválido. Por favor, digite um serviço disponível na lista."
    else
      break
    fi
  done

  while true; do
    echo "Available Employees:"
    EMPLOYEES=$($PSQL "SELECT employee_id, name, job_title FROM employees")
    echo "$EMPLOYEES"
    echo "Enter the employee's name or ID (or type 0 to go back):"
    read EMPLOYEE
    if [[ $EMPLOYEE == "0" ]]; then
      AGENDA_MENU
      return
    fi
    EMPLOYEE_VALID=$($PSQL "SELECT count(*) FROM employees WHERE employee_id = '$EMPLOYEE' OR name = '$EMPLOYEE'")
    if [[ $EMPLOYEE_VALID -eq 0 ]]; then
      echo "Funcionário inválido. Por favor, digite um funcionário disponível na lista."
    else
      break
    fi
  done

  while true; do
    echo "Insira o mês (1 ou 2 dígitos):"
    read MONTH
    if [[ $MONTH == "0" ]]; then
      AGENDA_MENU
      return
    fi
    if ! [[ $MONTH =~ ^[1-9]$|^1[0-2]$ ]]; then
      echo "Mês inválido. Por favor, insira um mês válido (1-12)."
    else
      break
    fi
  done

  while true; do
    echo "Insira o dia (1 ou 2 dígitos):"
    read DAY
    if [[ $DAY == "0" ]]; then
      AGENDA_MENU
      return
    fi
    if ! [[ $DAY =~ ^[1-9]$|^[12][0-9]$|^3[01]$ ]]; then
      echo "Dia inválido. Por favor, insira um dia válido (1-31)."
    else
      break
    fi
  done

  YEAR=$(date +"%Y")
  DATE="$YEAR-$(printf "%02d" $MONTH)-$(printf "%02d" $DAY)"

  while true; do
    echo "Enter the appointment time (format: HH:MM) (or type 0 to go back):"
    read TIME
    if [[ $TIME == "0" ]]; then
      AGENDA_MENU
      return
    fi
    if [[ ! "$TIME" =~ ^([01][0-9]|2[0-3]):[0-5][0-9]$ ]]; then
      echo "Invalid time format. Please enter the time in HH:MM format."
    else
      break
    fi
  done

  INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments (customer_id, employee_id, service_id, appointment_date, appointment_time) VALUES ('$CUSTOMER_ID', '$EMPLOYEE', '$SERVICE_ID', '$DATE', '$TIME')")
  if [[ $? -eq 0 ]]; then
    echo "Appointment successfully created for $CUSTOMER_NAME on $DATE at $TIME with employee $EMPLOYEE for service ID $SERVICE_ID."
  else
    echo "Error creating appointment. Please try again."
  fi

  DRAW_WEEKLY_CALENDAR
  AGENDA_MENU
}


# Function to cancel an appointment
CANCEL_APPOINTMENT() {
  echo "Enter appointment date to cancel (format: DD-MM):"
  read DATE

  if ! DATE_VALIDATED=$(date -d "$DATE" +"%Y-%m-%d" 2>/dev/null); then
    echo "Invalid date format. Please enter the date in DD-MM format."
    CANCEL_APPOINTMENT
    return
  fi

  echo "Enter appointment time to cancel (format: HH:MM):"
  read TIME

  APPOINTMENT=$($PSQL "SELECT * FROM appointments WHERE appointment_date = '$DATE_VALIDATED' AND appointment_time = '$TIME'")

  if [[ -z $APPOINTMENT ]]; then
    echo "No appointment found on $DATE_VALIDATED at $TIME."
  else
    echo "Appointment found:"
    echo "$APPOINTMENT"
    read -p "Confirm cancel appointment? (Y/N): " CONFIRM_CANCEL
    if [[ $CONFIRM_CANCEL == "Y" || $CONFIRM_CANCEL == "y" ]]; then
      DELETE=$($PSQL "DELETE FROM appointments WHERE appointment_date = '$DATE_VALIDATED' AND appointment_time = '$TIME'")
      echo "Appointment on $DATE_VALIDATED at $TIME canceled successfully."
    else
      echo "Cancellation canceled."
    fi
  fi

  AGENDA_MENU
}


# Function to display the agenda menu
AGENDA_MENU() {
  echo -e "\nAgenda Menu:"
  echo "1- Create Appointment"
  echo "2- Cancel Appointment"
  echo "3- Main Menu"
  read -p "Choose an option: " AGENDA_OPTION
  case $AGENDA_OPTION in
    1) CREATE_APPOINTMENT ;;
    2) CANCEL_APPOINTMENT ;;
    3) MAIN_MENU ;;
    *) AGENDA_MENU "Invalid option. Please try again." ;;
  esac
}

# Function to consult agenda
CONSULT_AGENDA_MENU() {
  DRAW_WEEKLY_CALENDAR
  AGENDA_MENU
}

# Function to consult services
CONSULT_SERVICES_MENU() {
  SERVICES=$($PSQL "SELECT service_id, name, price FROM services")
  echo -e "\n          Available Services:\n\n$SERVICES"
  MAIN_MENU
}

# Start the main menu
MAIN_MENU
