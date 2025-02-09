#! /bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"
echo -e "\n~~~~~ MY SALON ~~~~~\n"

SERVICES(){
  echo Welcome to my Salon, how may i can help you?

  if [[ $1 ]]
  then 
    echo -e "\n$1\n"
  fi
  echo -e "
  1) Creambath
  2) Cutting
  3) Coloring
  4) Styling
  5) Perm"

  read SERVICE_ID_SELECTED

  case $SERVICE_ID_SELECTED in
  1) APPOINTMENT_SERVICES ;;
  2) APPOINTMENT_SERVICES ;;
  3) APPOINTMENT_SERVICES ;;
  4) APPOINTMENT_SERVICES ;;
  5) APPOINTMENT_SERVICES ;;
  *) SERVICES "Sorry, i could not find that service. what would you like today?";;
  esac
}

APPOINTMENT_SERVICES() {
  echo -e "\nWhat is you phone number?"
  read CUSTOMER_PHONE
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  if [[ -z $CUSTOMER_NAME ]]
  then
    #get customer name
    echo -e "\nWhat's your name"
    read CUSTOMER_NAME

    #insert customer name
    INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name,phone) VALUES('$CUSTOMER_NAME','$CUSTOMER_PHONE')")
  fi
  #TIME INPUT
  CUSTOMER_NAME_FORMAT=$(echo $CUSTOMER_NAME | sed -E 's/^ *| *$//g')
  echo -e "\nWhat time you want to cut, $CUSTOMER_NAME_FORMAT?"
  read SERVICE_TIME
  #INSERT CUSTOMER_ID INTO APPOINTMENTS
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
  INSERT_CUSTOMER_SERVICE=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID,$SERVICE_ID_SELECTED,'$SERVICE_TIME')")
  
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
  echo -e "\nI have put you down for a$SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME_FORMAT."

  echo -e "\nThank you for making appointment at My Salon, please be here when your schedule is on\n"
}
SERVICES
