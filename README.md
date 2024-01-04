# Note

### setup database
- please set .env file to match your database
- load migration file
```bash
    rake db:migrate
```

### How to import data from csv
1. import students / student_tasks 
```bash 
    rake data:import_student_data_from_csv\['/path/to/your/csv/file.csv'\] 
```
2. import shifts data from csv
```bash
    rake data:import_shifts_data_from_csv\['/path/to/your/csv/file.csv'\] 
```

### How to Calculate statistics 
1. How much should be billed per month
```bash
    rake statistics:calculate_monthly_billed
```
2. How much should be paid as salary per month
```bash
    rake statistics:calculate_monthly_salary
```
3. How many hours has each house spent cleaning pots
```bash
    rake statistics:calculate_hours_per_house
```