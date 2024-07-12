set serveroutput on;
declare 

	choice varchar(1);
	validate_var varchar(1);
	err_num number;
	err_msg char(100);

	config_id Customer.customer_id%type;
	aconfig_id User_account.account_id%type;


	invalid_entry exception;
	
	




	cursor c1(a number) is select * from Customer where customer_id = a;
	cursor c2(a varchar,b number) is select * from SSID where password_ = a and exists (select * from Customer where customer_id = b);
	cursor c3 is select customer_id from Customer;
	cursor c4(a number) is select * from User_account where Customer_id = a;
	cursor c5 is select transaction_id from T_history;
	-- cursor c6 is select account_id from User_account;



	function roulette return number is
	begin
		return 1;
	end;
		

	procedure t_his(decide in number) is 
		t_id T_history.transaction_id%type;
		pa_no T_history.payer%type;
		py_no T_history.payee%type;
		a_t T_history.amount%type;
		t_y T_history.type_%type;
		c_d T_history.cap_date%type;

		rec_t T_history.transaction_id%type;
		copy_rec T_history.transaction_id%type;
	begin
		
		open c5;
		loop
			fetch c5 into rec_t;
			-- dbms_output.put_line(rec_t);
			exit when c5%notfound;
		end loop;
		close c5;
		
		t_id := rec_t + 1;
		pa_no := aconfig_id;
		py_no := 1001;
		a_t := 10000;
		

		if (decide = 1) then
			t_y := 'Account';
			insert into T_history
			values
			(
				t_id,
				pa_no,
				py_no,
				a_t,
				t_y,
				current_timestamp
			);
				
		end if;

		
	end;

	

	procedure f_d_in is 
    		fd_id Fixed_deposit.deposit_id%type;
       		amt Fixed_deposit.amount%type;
    		i_r Fixed_deposit.interest_rate%type;
    		tenure Fixed_deposit.tenure%type;
       		acc_id Fixed_deposit.account_id%type;
    		s_t Fixed_deposit.status_%type; -- Check the column name
    
    		rec Fixed_deposit%rowtype;
	begin   
    		acc_id := 1001;
    		fd_id := 1005;
    		amt := 100000.00;
    		i_r := 7.20;
    		tenure := 15;
    		s_t := 'active'; -- Check the column name
    
    		insert into Fixed_deposit (account_id, deposit_id, amount, interest_rate, tenure, status_)
    		values
    		(
        		acc_id,
        		fd_id,
        		amt,
        		i_r,
          		tenure,
        		s_t   
    		);     
	end;
	
	procedure sav_acc_in is 
    		sav_acc_id Saving_account.saving_account_id%type;
       		bal Saving_account.balance%type;
    		o_d Saving_account.open_date%type;
       		acc_id Fixed_deposit.account_id%type;
    		s_t Saving_account.status_%type;
    
    		rec Saving_account%rowtype;
	begin   
    		sav_acc_id := 200007;
    		acc_id := 1001;
    		bal := 100000.00;
    		s_t := 'open';
    
    		insert into Saving_account (saving_account_id, balance, status_)
    		values
    		(
        		sav_acc_id,
			balance,
			s_t 
    		);     
	end;

	procedure loans_in is
		l_id Loans.loan_id%type;
		acc_id Loans.account_id%type;
		amt Loans.amount%type;
		i_r Loans.interest_rate%type;
		dur Loans.duration%type;
		r_bal Loans.r_balance%type;
		p_freq Loans.p_frequency%type;
		pay number;		
		
		rec Loans%rowtype;
	begin
		pay := 8000;
		l_id := 3014;
		acc_id := 1001;
		amt := 50000;
		i_r := 3.25;
		dur := 10;
		r_bal := amt - pay;
		p_freq := 'month';
		
		dbms_output.put_line('payment of 8000 successful');		

		insert into Loans (loan_id, account_id, amount, interest_rate, duration, r_balance, p_frequency) 
		values (
			l_id,
			acc_id,
			amt,
			i_r,
			dur,
			r_bal,
			p_freq
		);
	end;

	procedure password_check(login_arg in number) is
    		password_var SSID.password_%type;
		rec2 SSID%rowtype;
	begin
		password_var := 'Password123';
        	open c2(password_var,login_arg);

		loop
            		fetch c2 into rec2;
			exit when c2%found;
		end loop;
		

		-- if c2%found then
				-- dbms_output.put_line('found');		
		-- else
				-- dbms_output.put_line('not found');
		--end if;
		
		dbms_output.put_line(' ');
		close c2;
		
	end;

	procedure login_check is
    		login_id number;
		rec Customer%rowtype;
		password SSID%rowtype;
	begin
		login_id := 100001;
		config_id :=  login_id;
        	open c1(login_id);

		loop
            		fetch c1 into rec;
			exit when c1%found;
		end loop;
		

		if c1%found then
				-- dbms_output.put_line('found');
				dbms_output.put_line('Enter the Password :: ');
				password_check(login_id);
				dbms_output.put_line('Welcome ,'||rec.first_name||' '||rec.last_name );
				
				

		else
				dbms_output.put_line('not found');
		end if;
		close c1;
	end;


	procedure sign_up is
    		rec3 Customer.customer_id%type;
    		n_cust Customer.customer_id%type; 
    		f_name Customer.first_name%type;
    		l_name Customer.last_name%type;
    		d_o_b Customer.date_of_birth%type;
    		gen Customer.gender%type;
    		h_n Customer.house_no%type;
    		st Customer.street%type;
    		ct Customer.city%type;
    		p_c Customer.postal_code%type;
    		sta Customer.state_%type;
    		e Customer.email%type;
    		p_n Customer.phone_no%type;
    		i_p_t Customer.id_proof_type%type;
    		i_p_n Customer.id_proof_number%type;
    
    		pass_ SSID.password_%type;

    		acc_id User_account.account_id%type;
    		acc_type User_account.account_type%type;
    		acc_status User_account.status_%type;
    		rec4 User_account.account_id%type;
	begin
    		open c3;
    
		loop
			fetch c3 into rec3;
			dbms_output.put_line(rec3);
			exit when c3%notfound;
		end loop;
    		close c3;

    		n_cust := rec3 + 1;
		config_id := n_cust;
    		f_name := 'hunt';
    		l_name := '3r';
    		d_o_b  :=  TO_DATE('1990-09-15', 'YYYY-MM-DD') ;
    		gen := 'Female';
    		h_n := 110;
    		st := 'Rosmary Street';
    		ct := 'Virginia';
    		p_c := 145002;
    		sta := 'West Virginia';
    		e := 'dove@icloud.com';
    		p_n := '987-654-3210';
    		i_p_t := 'passport';
    		i_p_n := 'alok19990';

    		insert into Customer 
    		values
    		(   
		n_cust ,
        	f_name,
        	l_name ,
        	d_o_b,
        	gen ,
        	h_n ,
        	st,
        	ct ,
        	p_c ,
        	sta ,
        	e ,
        	p_n ,
        	i_p_t ,
        	i_p_n
    		);

    		pass_ := 'Abcdefg001';
    		insert into SSID
    		values
    		(   
        	n_cust,
        	pass_
    		);

    		acc_id := 1004;
    		acc_type := 'Retirement Account';
    		acc_status := 'open';
    		insert into User_account
    		values
    		(
        	acc_id,
        	n_cust,
        	acc_type,
        	acc_status
    		);
	end;

		
	

	procedure menu is	
		choice_m char(1) := upper('A');
		demo number;
	begin     
		
		case choice_m
			when 'A' then 
				dbms_output.put_line('Fixed Deposit');
				f_d_in();
			
			when 'B' then
				dbms_output.put_line('Loans');
				loans_in();

			when 'C' then
				dbms_output.put_line('Saving Account');
		
			when 'D' then
				dbms_output.put_line('Transaction History');
				-- t_his();
				demo := roulette();
				t_his(demo);
		
			when 'E' then 
				dbms_output.put_line('Money Transfer To Account');
				
		
			when 'F' then 
				dbms_output.put_line('UPI Transaction');
				
			else
				raise invalid_entry;
		end case;
	end; 		

	procedure linking_cust_acc_id  is
		rec User_account%rowtype;
	begin
		open c4(config_id);
		loop 
			fetch c4 into rec;
			exit when c4%found;
		end loop;
			
		aconfig_id := rec.account_id;
		-- dbms_output.put_line(aconfig_id);
		close c4;
	end;
	





		

begin

	choice := '&choice';

	case choice
		when 'y' then
        		login_check();
			-- dbms_output.put_line('yes');

		when 'n' then
			sign_up();
			dbms_output.put_line('no');


		else
			dbms_output.put_line('infinity');
	end case;

	linking_cust_acc_id();

	dbms_output.put_line(' ');
	dbms_output.put_line('Welcome to Bank Management system');

	-- dbms_output.put_line(config_id);
	-- dbms_output.put_line(aconfig_id);

	

	menu();
	


exception
	
	when invalid_entry then
		dbms_output.put_line('Invalid Entry');
		dbms_output.put_line('Terminating Session');
		dbms_output.put_line('Refersh Session');

	when others then
		dbms_output.put_line('Out of Bound Error');
		dbms_output.put_line('Check Code once again');
		err_num:= sqlcode;
		err_msg:= substr(sqlerrm,1,100);
		insert into errors
		values(err_num,err_msg);
		
end;
/
