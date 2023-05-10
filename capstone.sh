# Define functions

# List option
function listPatients {
clear
sort -t',' -k2,2 -k3,3 patients.csv | awk -F',' '{print toupper($2) "\t" toupper($3) "\t" $4 "\t" $1}'


}

# Add option
function addPatient {
clear

tput cup 3 12 ; read -p "Enter first name of patient:" firstName
tput cup 4 12 ; read -p "Enter last name of patient: " lastName
tput cup 5 12 ; read -p "Enter phone number: "         phoneNum

lastNameUP=$(echo $lastName | tr '[:lower:]' '[:upper:]')
  lastNamePRE=${lastNameUP:0:4}

initialFirstName=$(echo $firstName | cut -c1)

patientID="$lastNamePRE$initialFirstName"

if grep -q "^$patientID," patients.csv; then
count=2
while grep -q "^${patientID}${count}," patients.csv; do
count=$((count+1))
done
patientID="${patientID}${count}"
fi

echo "${patientID},${firstName},${lastName},${phoneNum}" >> patients.csv

tput cup 15 15 ; echo "Processing..."
tput cup 16 15 ; echo "$firstName $lastName is added to patient records..."
tput cup 17 15 ; echo "The new patient ID is $patientID"

}

# Search Option
function searchPatient {
clear

tput cup 3 12 ; read -p "Enter the last name of the patient: " lastName
awk -F, -v lastName="$lastName" 'tolower($3) ~ tolower(lastName) {printf "%s\t%s\t%s\t%s\n", toupper($2), toupper($3), $4, $1}' patients.csv

}

# Delete Option
function deletePatient {
clear

tput cup 15 15; read -p "Enter the patient's last name to delete:" lastName 
sed -i "/$lastName/d" patients.csv 
tput cup 16 15; echo "Deleted record matching the last name '$lastName'."

}

# Exit Option
function exitScreen {
clear
tput setaf 3
tput cup 3 12 ; echo "***********************************************************************"
tput cup 4 12 ; echo "              Thank you for choosing Farmingdale Hospital!             "
tput cup 5 12 ; echo "***********************************************************************"
tput sgr 0
exit 0
}

# Welcome Screen
clear
tput setaf 3
tput cup 3 12 ; echo "***********************************************************************"
tput cup 4 12 ; echo " Welcome to the Patient Management System for the Farmingdale Hospital "
tput cup 5 12 ; echo "***********************************************************************"
tput sgr0

# Main Menu w/ user input and loop
while true
do
        tput cup 8 15; echo "[L/l] List Patients"
        tput cup 9 15; echo "[A/a] Add a new Patient"
        tput cup 10 15; echo "[S/s] Search Patient"
        tput cup 11 15; echo "[D/d] Delete Patient"
        tput cup 12 15; echo "[E/e] Exit"
        tput cup 13 15; read -p "Enter your choice here: " choice

# User's choice directory
        case "$choice" in
        L|l) listPatients ;;
        A|a) addPatient ;;
        S|s) searchPatient ;;
        D|d) deletePatient ;;
        E|e) exitScreen ;; 
        *) tput 15 15 ;  echo "Invalid. Please enter a choice listed above"
        esac
done
