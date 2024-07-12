create table Customer (
    customer_id number constraint cus_pk primary key,
    constraint cus_ch_id
    check (length(customer_id) = 6),
    first_name varchar(50),
    last_name varchar(50),
    date_of_birth date,
    gender varchar(10) constraint cus_ch_gen check(gender in ('Male' , 'Female' ,'Others')),
    house_no number constraint cus_ch_hn check (length(house_no) <= 3 and length(house_no)>0),
    street varchar(100),
    city varchar(30),
    postal_code number constraint cus_ch_pc check (length(postal_code)=6),
    state_ varchar(20),
    email varchar(100) constraint cus_ch_em check(email like '%@gmail.com'or email like  '%@hotmail.com' or  email like '%@icloud.com'),
    phone_no varchar(15),
    id_proof_type varchar(50) constraint cus_ch_pr check (id_proof_type in ('passport','aadhar card' ,'pan')),
    id_proof_number varchar(50)
);



create table User_account (
account_id number(4) constraint acc_pk primary key,
constraint acc_ch_id
check (length(account_id) = 4),
customer_id number,
constraint acc_fk_cus
foreign key (customer_id) references Customer (customer_id) on delete set null,
account_type varchar(50) constraint acc_ch_ty check(account_type like  '%Saving Account%' or  account_type like '%Certificate Of Deposit%' or  account_type like '%Fixed Deposit%' or  account_type like '%Retirement Account%%'),
status_ varchar(30) constraint acc_ch_st check (status_ in ('open','closed','froze'))
);



create table SSID (
    customer_id number,
    constraint ssid_fk_cus foreign key (customer_id) references customer(customer_id) on delete cascade,
    constraint ssid_uq unique (customer_id),
    password_ varchar(50),
    constraint ssid_ch_ps check (
        length(password_) > 8 and 
        length(password_) < 30 and 
        regexp_like(password_, '[a-z]') and 
        regexp_like(password_, '[0-9]') and 
        regexp_like(password_, '[A-Z]')
    )
);

create table Saving_account (
    saving_account_id number(6) constraint sav_acc_pk primary key,
    constraint sav_acc_ch_id 
    check (length(saving_account_id)=6),
    account_id number,
    constraint sav_acc_fk_cus
    foreign key (account_id) references User_account(account_id) on delete cascade,
    balance number(10,2),    
    open_date date,
    status_ varchar(30) constraint sav_acc_ch_st check (status_ in ('open','closed','froze'))
);

create table Loans (
    loan_id number(6) constraint loan_pk primary key ,
    account_id number ,
    constraint loan_fk_cus
    foreign key (account_id) 
    references User_account (account_id),
    amount number(10, 2),
    interest_rate number(4, 2),
    start_date date,
    cur_date date,
    duration number(2) constraint loans_ch_dr check (duration < 84),
    r_balance number(10,2),
    p_frequency varchar(5) constraint loans_ch_fq check(p_frequency in ('month'))
);
create table Fixed_deposit (
    deposit_id number constraint fd_pk primary key,
    start_date date,
    amount number(10, 2),
    interest_rate number(5, 2),
    tenure number(3),  -- use tenure + start date to make column for maturity date
    maturity_date date,
    account_id number(4),
    constraint fd_fk_acc
    foreign key (account_id) references User_account (account_id),
    status_ varchar(30) constraint fd_ch_st check (status_ in ('active','closed','mature'))
);

create table Money_account
(
	payer number(4),
	constraint m_acc_fk_1 
	foreign key(payer) references User_account(account_id),
	payee number(4),
	constraint m_acc_fk_2 
	foreign key(payee) references User_account(account_id),
	amount number(8,2)
);

create table T_history
(
	transaction_id number(8) constraint t_h_pk primary key,
	payer number,
	constraint t_acc_fk_1 
	foreign key(payer) references User_account(account_id),
	payee number,
	constraint t_acc_fk_2 
	foreign key(payee) references User_account(account_id),
	amount number(8,2),
	type_ varchar(8) constraint t_h_ch_ty check (type_ in ('UPI','Account')),
	cap_date timestamp           --- insert sysdate while transfer
);

create table UPI_link
(
	upi_id varchar(20) constraint upi_h_pk primary key,
	constraint up_ch_id check (upi_id like '%@oksbi' or upi_id like '%@paytm' or upi_id like '%@paypal'),
	account_id number(4),
	constraint up_l_fk_2
	foreign key(account_id) references User_account(account_id) on delete cascade
);

create table UPI 
(
	upi_id varchar(20),
	constraint up_l_fk_1 
	foreign key(upi_id) references UPI_link(upi_id) on delete cascade,
	amount number(8,2)    
);

create table UPI_SSID
(
	upi_id varchar(20),
	constraint up_ss_fk 
	foreign key(upi_id) references UPI_link(upi_id) on delete cascade,
	password_ varchar(30),
    constraint up_ss_ch_ps check (
        length(password_) > 8 and 
        length(password_) < 30 and 
        regexp_like(password_, '[a-z]') and 
        regexp_like(password_, '[0-9]') and 
        regexp_like(password_, '[A-Z]')
    )
);

