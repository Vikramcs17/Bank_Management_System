-- Data for Customer table
insert into Customer values (100001, 'John', 'Doe', TO_DATE('1990-05-15', 'YYYY-MM-DD'), 'Male', 12, 'Main Street', 'New York', 123456, 'NY', 'john.doe@gmail.com', '123-456-7890', 'passport', 'ABCD1234');
insert into Customer values (100002, 'Jane', 'Smith', TO_DATE('1985-08-25', 'YYYY-MM-DD'), 'Female', 34, 'Oak Avenue', 'Los Angeles', 456789, 'CA', 'jane.smith@hotmail.com', '987-654-3210', 'aadhar card', 'EFGH5678');
insert into Customer values (100003, 'Alex', 'Lee', TO_DATE('1978-12-10', 'YYYY-MM-DD'), 'Male', 78, 'Pine Road', 'Chicago', 789012, 'IL', 'alex.lee@icloud.com', '456-789-0123', 'pan', 'IJKL9101');

-- Data for User_account table
insert into User_account values (1001, 100001, 'Saving Account', 'open');
insert into User_account values (1002, 100002, 'Certificate Of Deposit', 'closed');
insert into User_account values (1003, 100003, 'Fixed Deposit', 'open');

-- Data for SSID table
insert into SSID values (100001, 'Password123');
insert into SSID values (100002, 'SecurePass456');
insert into SSID values (100003, 'StrongP@ss789');

-- Data for Saving_account table
insert into Saving_account values (200001, 1001, 5000.00, TO_DATE('2024-04-01', 'YYYY-MM-DD'), 'open');
insert into Saving_account values (200002, 1002, 3000.00, TO_DATE('2023-12-15', 'YYYY-MM-DD'), 'closed');
insert into Saving_account values (200003, 1003, 7000.00, TO_DATE('2024-03-10', 'YYYY-MM-DD'), 'froze');

-- Data for Loans table
insert into Loans values (4001, 1001, 2000.00, 6.5, TO_DATE('2024-04-01', 'YYYY-MM-DD'), TO_DATE('2024-06-01', 'YYYY-MM-DD'), 12, 1800.00, 'month');
insert into Loans values (4002, 1002, 3000.00, 7.0, TO_DATE('2023-12-15', 'YYYY-MM-DD'), TO_DATE('2024-12-15', 'YYYY-MM-DD'), 24, 2500.00, 'month');
insert into Loans values (4003, 1003, 5000.00, 6.8, TO_DATE('2024-03-10', 'YYYY-MM-DD'), TO_DATE('2024-06-10', 'YYYY-MM-DD'), 18, 4000.00, 'month');

-- Data for Fixed_deposit table
insert into Fixed_deposit values (3001, TO_DATE('2024-04-01', 'YYYY-MM-DD'), 10000.00, 6.5, 36, TO_DATE('2027-04-01', 'YYYY-MM-DD'), 1001, 'active');
insert into Fixed_deposit values (3002, TO_DATE('2023-12-15', 'YYYY-MM-DD'), 20000.00, 7.0, 48, TO_DATE('2027-12-15', 'YYYY-MM-DD'), 1002, 'closed');
insert into Fixed_deposit values (3003, TO_DATE('2024-03-10', 'YYYY-MM-DD'), 15000.00, 6.8, 24, TO_DATE('2026-03-10', 'YYYY-MM-DD'), 1003, 'mature');

-- Data for Money_account table
insert into Money_account values (1001, 1002, 500.00);
insert into Money_account values (1002, 1001, 300.00);
insert into Money_account values (1003, 1001, 800.00);

-- Data for T_history table
insert into T_history values (5001, 1001, 1002, 200.00, 'UPI', SYSTIMESTAMP);
insert into T_history values (5002, 1002, 1003, 150.00, 'Account', SYSTIMESTAMP);
insert into T_history values (5003, 1001, 1001, 300.00, 'UPI', SYSTIMESTAMP);


-- Data for UPI_link table
insert into UPI_link values ('john.doe@oksbi', 1001);
insert into UPI_link values ('jane.smith@paytm', 1002);
insert into UPI_link values ('alex.lee@paypal', 1003);

-- Data for UPI table
insert into UPI values ('john.doe@oksbi', 1000.00);
insert into UPI values ('jane.smith@paytm', 1500.00);
insert into UPI values ('alex.lee@paypal', 2000.00);

-- Data for UPI_SSID table
insert into UPI_SSID values ('john.doe@oksbi', 'Password@123');
insert into UPI_SSID values ('jane.smith@paytm', 'SecureP@ss456');
insert into UPI_SSID values ('alex.lee@paypal', 'StrongP@ss789');


