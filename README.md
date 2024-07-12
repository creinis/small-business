# Small Business Management System

###### Technologies:
<p align="center">
<img src="https://raw.githubusercontent.com/danielcranney/readme-generator/main/public/icons/skills/postgresql-colored.svg" width="75" height="75" alt="PostgreSQL" style="margin: 10px 15px 0 15px;" />
<img src="https://img.icons8.com/color/75/000000/console.png" width="75" height="75" alt="Bash" style="margin: 10px 15px 0 15px;" />
</p>

- **Bash:** Used to write shell scripts that facilitate the setup, maintenance, and querying of the database.
- **PostgreSQL:** Relational database management system used to store data of chemical elements.

## Description

This project is a management system for small businesses, developed to help manage customers, employees, services, and appointments for a beauty salon. The system consists of a PostgreSQL database and a Shell script for interaction with the database, allowing queries and updates.

## Project Structure

### Database Creation SQL File

The `small_business.sql` file contains the database definition, including table creation and initial data insertion. The tables included are:

- `employees`: Stores information about employees.
- `customers`: Stores information about customers.
- `services`: Stores information about the services offered.
- `appointments`: Stores information about service appointments.
- `days`, `months`, `years`: Auxiliary tables to store days, months, and years.
- `times`: Stores available time intervals.
- `purchases`: Stores information about completed purchases.
- `payment_methods`: Stores available payment methods.
- `promotions`: Stores promotions applicable to services.
- `users`: Stores user credentials and roles for authentication.

### Management Shell Script

The `small_business.sh` file is a Shell script that allows interaction with the database through a menu. The functionalities include:

- Query customer information by name, phone, or email.
- View the weekly schedule with available time slots.
- Query available services.
- Create, view, and cancel appointments.
- Authenticate users to control access based on roles (e.g., master and user).

### Authentication System

The system includes an authentication feature to ensure that only authorized users can access certain functionalities. The `auth.sh` script handles user login, verifying credentials against the `users` table in the database. This table uses `pgcrypto` for secure password storage and verification.

#### Benefits of Using `pgcrypto`

- **Enhanced Security:** By storing passwords as cryptographic hashes rather than plain text, `pgcrypto` helps protect user credentials even if the database is compromised.
- **Password Hashing:** The use of `pgcrypto` ensures that passwords are hashed using strong algorithms, adding a layer of security.
- **Role-Based Access Control:** The system differentiates between roles (e.g., master and user), allowing finer control over access to administrative features.

## How to Use

### Database Setup

1. **Ensure `pgcrypto` is installed**: Before creating the database, ensure that the `pgcrypto` extension is installed in PostgreSQL:
    ```sql
    CREATE EXTENSION IF NOT EXISTS pgcrypto;
    ```

2. **Create the Database**: To create the database and its tables, run the SQL file with the command:
    ```bash
    psql -U <username> -f small_business.sql
    ```
    Make sure to replace `<username>` with the PostgreSQL database username.

### Run the Shell Script

1. **Execution Permission**: Ensure that the script has execution permission:
    ```bash
    chmod +x small_business.sh
    ```

2. **Run the Script**: Execute the script to start the management system:
    ```bash
    ./small_business.sh
    ```

### Menu Navigation

- **Main Menu**:
  - **1) Consult Customer**: Allows querying customer information by name, phone, or email.
  - **2) Consult Agenda**: View the weekly schedule with available time slots and create or cancel appointments.
  - **3) Consult Services**: Lists all available services.
  - **4) Exit**: Exits the system.

- **Consult Customer Menu**:
  - **1) Name**: Query customer by name.
  - **2) Phone**: Query customer by phone.
  - **3) Email**: Query customer by email.
  - **4) Back**: Returns to the main menu.

- **Agenda Menu**:
  - **1) Create Appointment**: Creates a new appointment.
  - **2) View Weekly Calendar**: Views the weekly schedule.
  - **3) Cancel Appointment**: Cancels an existing appointment.
  - **4) Back**: Returns to the main menu.

## Technologies Used

- **PostgreSQL**: For database management.
- **Shell Script**: For command-line interface and database interaction.

## Contribution

Contributions are welcome! Feel free to open issues or submit pull requests on the [GitHub repository](https://github.com/username/small-business-management).

## License

This project is licensed under the [MIT License](LICENSE).
