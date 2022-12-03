#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"
echo -e "Welcome to My Salon, how can I help you?\n"

MAIN_MENU() { 
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi
  servicelist=$($PSQL "select * from services order by service_id;")
  echo "$servicelist" | while read service_id bar name
  do
    echo "$service_id) $name"
  done
  read SERVICE_ID_SELECTED

  case $SERVICE_ID_SELECTED in
    1) HAIRCUT ;;
    2) PERM ;;
    3) CLEAN ;;
    *) MAIN_MENU "I could not find that service. What would you like today?" ;;
  esac
}

HAIRCUT() {
  echo "What's your phone number?"
  read CUSTOMER_PHONE

  CUSTOMER_NAME=$($PSQL "select name from customers where phone='$CUSTOMER_PHONE';")
  
  if [[ -z $CUSTOMER_NAME ]]
  then
    echo "I don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME
    NEW_CUSTOMER=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME');")
    echo $NEW_CUSTOMER
  fi

  echo "What time would you like your haircut,$CUSTOMER_NAME?"
  read SERVICE_TIME
  CUSTOMER_ID=$($PSQL "select customer_id from customers where phone='$CUSTOMER_PHONE';")

  INSERT_APPOINTMENTS=$($PSQL "insert into appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME');")
  echo $INSERT_APPOINTMENTS

  echo "I have put you down for a haircut at $SERVICE_TIME, $(echo $CUSTOMER_NAME | awk '$1=$1')."
}

PERM() {
  echo "What's your phone number?"
  read CUSTOMER_PHONE

  CUSTOMER_NAME=$($PSQL "select name from customers where phone='$CUSTOMER_PHONE';")
  
  if [[ -z $CUSTOMER_NAME ]]
  then
    echo "I don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME
    NEW_CUSTOMER=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME');")
    echo $NEW_CUSTOMER
  fi

  echo "What time would you like your perm,$CUSTOMER_NAME?"
  read SERVICE_TIME
  CUSTOMER_ID=$($PSQL "select customer_id from customers where phone='$CUSTOMER_PHONE';")

  INSERT_APPOINTMENTS=$($PSQL "insert into appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME');")
  echo $INSERT_APPOINTMENTS

  echo "I have put you down for a perm at $SERVICE_TIME, $(echo $CUSTOMER_NAME | awk '$1=$1')."
}

CLEAN() {
  echo "What's your phone number?"
  read CUSTOMER_PHONE

  CUSTOMER_NAME=$($PSQL "select name from customers where phone='$CUSTOMER_PHONE';")
  
  if [[ -z $CUSTOMER_NAME ]]
  then
    echo "I don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME
    NEW_CUSTOMER=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME');")
    echo $NEW_CUSTOMER
  fi

  echo "What time would you like your clean, $CUSTOMER_NAME?"
  read SERVICE_TIME
  CUSTOMER_ID=$($PSQL "select customer_id from customers where phone='$CUSTOMER_PHONE';")

  INSERT_APPOINTMENTS=$($PSQL "insert into appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME');")
  echo $INSERT_APPOINTMENTS

  echo "I have put you down for a clean at $SERVICE_TIME, $(echo $CUSTOMER_NAME | awk '$1=$1')."
}

MAIN_MENU
