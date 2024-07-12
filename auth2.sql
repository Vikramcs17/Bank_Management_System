set serveroutput on;
declare 

	choice varchar(1);
	validate_var varchar(1);
	demo number := 0;
	

	err_num number;
	err_msg char(100);

	config_id Customer.customer_id%type;
	aconfig_id User_account.account_id%type;


	invalid_entry exception;
	negative_balance exception;
	sav_acc_err exception;
	
	




	cursor c1(a number) is select * from Customer where customer_id = a;
	cursor c2(a varchar,b number) is select * from SSID where password_ = a and exists (select * from Customer where customer_id = b);
	cursor c3 is select customer_id from Customer;
	cursor c4(a number) is select * from User_account where Customer_id = a;
	cursor c5 is select transaction_id from T_history;
	cursor c6 is select * from T_history;
	cursor c7(d number) is select balance from Saving_account where account_id = d;
	cursor c8 is select account_id from User_account;
	cursor c9(a varchar, b varchar) is select * from UPI_SSID where upi_id like a;
	cursor c10(a varchar) is select account_id from UPI_link where upi_id = a;
	cursor c11 is select loan_id from Loans;
	cursor c12 is select saving_account_id from Saving_account;



	procedure upi_pass(ui_arg in char, des_arg out number) is
		pass_ UPI_SSID.password_%type;

		
	begin
		pass_ := 'Password@123';

		open c9(ui_arg,pass_);
		loop
			exit when c9%found;
		end loop;

		if c9%found then
			des_arg := 1;
		end if;

		close c9;
	end;


	procedure upi_in is 
		u_id UPI.upi_id%type;
		amt UPI.amount%type; 
		decision number;
			
		rec UPI_link.account_id%type;
		rec_b Saving_account.balance%type;


		t_id T_history.transaction_id%type;
		a_t T_history.amount%type;
		t_y T_history.type_%type;
		c_d T_history.cap_date%type;

		rec_t T_history.transaction_id%type;
		rec_m Saving_account.balance%type;

		pa_r Money_account.payer%type;
		py_r Money_account.payee%type;


	begin
		u_id := 'john.doe@oksbi';
		upi_pass(u_id,decision);
			
		if (decision = 1) then 
			amt := 100;
			
			open c10(u_id);
				loop
    				fetch c10 into rec;
    				exit when c10%notfound; -- Exit the loop when no records are found
			end loop;
			 
			if c10%found then
				insert into UPI 
				values(u_id,amt);
				
				open c7(aconfig_id);
				loop
					fetch c7 into rec_b;
					exit when c7%found;
				end loop;
				close c7;
				

				rec_b := rec_b - amt;
				
				if rec_b<=0 then
					raise sav_acc_err;
				else

					update Saving_account
					set balance = balance + amt
					where account_id = rec;

					update Saving_account
					set balance = balance - amt
					where account_id = aconfig_id;

					open c5;
					loop
						fetch c5 into rec_t;
						-- dbms_output.put_line(rec_t);
						exit when c5%notfound;
					end loop;
					close c5;
		
					t_id := rec_t + 1;
					pa_r := aconfig_id;
					py_r := rec;
		

					t_y := 'UPI';
					insert into T_history
					values
					(
					t_id,
					pa_r,
					py_r,
					amt,
					t_y,
					current_timestamp
					);

				end if;
			end if;
		end if;
	end;






	procedure sav_acc_in is 
    		sav_acc_id Saving_account.saving_account_id%type;
       		bal Saving_account.balance%type;
    		o_d Saving_account.open_date%type;
       		acc_id Saving_account.account_id%type;
    		s_t Saving_account.status_%type;
    
    		rec Saving_account.saving_account_id%type;
	begin   

		open c12;
		loop
			fetch c12 into rec;
			exit when c12%notfound;
		end loop;
		close c12;
		
    		sav_acc_id := rec + 1;
    		acc_id := aconfig_id;
    		bal := 100000.00;
    		s_t := 'open';
    
    		insert into Saving_account
    		values
    		(
        		sav_acc_id,
				acc_id,
				bal,
				sysdate,
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
		
		rec Loans.loan_id%type;
	begin
		pay := 8000;

		open c11;
		loop
			fetch c11 into rec;
			exit when c11 %notfound;
		end loop;
		close c11;

		l_id := rec+1;
		acc_id := 1001;
		amt := 50000;
		i_r := 3.25;
		dur := 10;
		r_bal := amt - pay;
		p_freq := 'month';
		
		insert into Loans 
		values (
			l_id,
			acc_id,
			amt,
			i_r,
			to_date(sysdate,'yyyy-mm-dd'),
			to_date(sysdate+dur,'yyyy-mm-dd'),
			dur,
			r_bal,
			p_freq
		);
	end;

		

	procedure m_trans is
		pa_r Money_account.payer%type;
		py_r Money_account.payee%type;
		amt Money_account.amount%type;

		t_id T_history.transaction_id%type;
		a_t T_history.amount%type;
		t_y T_history.type_%type;
		c_d T_history.cap_date%type;

		rec_t T_history.transaction_id%type;
		rec_m Saving_account.balance%type;


	begin
		pa_r := 1001;
		py_r := 1002;
		amt := 100;
		
		insert into Money_account
		values (
			pa_r,
			py_r,
			amt
		);
		
		
		open c7(pa_r);
		loop 
			fetch c7 into rec_m;
			exit when c7%found;
		end loop;
		
		rec_m := rec_m - amt;

		if (rec_m < 0) then
			dbms_output.put_line('no negative balance');
			raise negative_balance;

		else
			update Saving_account 
			set balance = balance - amt
			where account_id = pa_r;
		
			update Saving_account 
			set balance = balance + amt 
			where account_id = py_r;
		end if;
		close c7;

		open c5;
		loop
			fetch c5 into rec_t;
			-- dbms_output.put_line(rec_t);
			exit when c5%notfound;
		end loop;
		close c5;
		
		t_id := rec_t + 1;
		pa_r := aconfig_id;
		py_r := 1001;
		amt := 100;
		

		t_y := 'Account';
			insert into T_history
			values
			(
				t_id,
				pa_r,
				py_r,
				amt,
				t_y,
				current_timestamp
			);
	end;






	procedure t_his is 
		rec_t T_history%rowtype;
	begin
		
		open c6;
		loop
			fetch c6 into rec_t;
			-- dbms_output.put_line(rec_t);
			dbms_output.put_line('Send By :: ' || rec_t.payer || ' to ' || rec_t.payee || ' reference :: ' || rec_t.transaction_id); 
			exit when c5%notfound;
		end loop;
		close c5;
		
	end;

	
	
	procedure f_d_in is 
		fd_id Fixed_deposit.deposit_id%type;
		s_d Fixed_deposit.start_date%type;
		amt Fixed_deposit.amount%type;
		i_r Fixed_deposit.interest_rate%type;
		tenure Fixed_deposit.tenure%type;
		m_d Fixed_deposit.maturity_date%type;
		acc_id Fixed_deposit.account_id%type;
		status Fixed_deposit.status_%type;

		rec Fixed_deposit%rowtype;
	begin
		
		
		acc_id := 1003;
		fd_id := 1010;
		amt := 100000.00;
		i_r := 7.20;
		tenure := 15;
		s_d := sysdate;
		m_d := ADD_MONTHS(s_d, tenure);

		insert into Fixed_deposit (deposit_id, amount, interest_rate, tenure, start_date, maturity_date)
		values
		(
				fd_id,
				amt,
				i_r,
				tenure,
				s_d,
				m_d	
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


		u_id UPI_link.upi_id%type;
		pass_2 UPI_SSID.password_%type;
		acc_id_2 UPI_link.account_id%type;

		
	begin
    		open c3;
    
		loop
			fetch c3 into rec3;
			-- dbms_output.put_line(rec3);
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

		open c8;
		loop 
			fetch c8 into rec4;
			exit when c8%notfound;
		end loop;
		close c8;

    		acc_id := rec4+1;
    		acc_type := 'Saving Account';
    		acc_status := 'open';
    		insert into User_account
    		values
    		(
        	acc_id,
        	n_cust,
        	acc_type,
        	acc_status
    		);

		u_id := 'imishan@oksbi';
		pass_2 := 'Hunt3r1009i#@';
		acc_id_2 := acc_id;

		insert into UPI_link
		values(u_id,acc_id_2);

		insert into UPI_SSID
		values(u_id,pass_2);
		
	end;

		
	

	procedure menu is	
		choice_m char(1) := upper('C');
		demo number;
	begin     
		
		case choice_m
			when 'A' then 
				dbms_output.put_line('Fixed Deposit successful');
				f_d_in();
			
			when 'B' then
				dbms_output.put_line('Loan sanctioned!');
				loans_in();

			when 'C' then
				dbms_output.put_line(demo);
				if (demo = 1) then 
					dbms_output.put_line('Saving Account created!');
					sav_acc_in();
				else
					raise sav_acc_err;
				end if;
		
			when 'D' then
				dbms_output.put_line('Here''s the Transaction History!');
				t_his();
		
			when 'E' then 
				dbms_output.put_line('Money Transfer To Accountsuccess!');
				m_trans();
				
				
			when 'F' then 
				dbms_output.put_line('UPI Transaction successfull!');
				upi_in();
				
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
			demo := 0;
			-- dbms_output.put_line('yes');

		when 'n' then
			sign_up();
			demo := 1;
			-- dbms_output.put_line('no');


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

	when negative_balance then 
		dbms_output.put_line('Cannot Proceed');
		dbms_output.put_line('Refresh Session');

	when sav_acc_err then
		dbms_output.put_line('Already Having Saving Account Associated with this account');
		dbms_output.put_line('Refresh Session');
		err_num := 109;
		err_msg := 'Already Having Saving Account Associated with this account';
		insert into errors
		values(err_num,err_msg);

	when others then
		dbms_output.put_line('Out of Bound Error');
		dbms_output.put_line('Check Code once again');
		err_num:= sqlcode;
		err_msg:= substr(sqlerrm,1,100);
		insert into errors
		values(err_num,err_msg);
		
end;
/
