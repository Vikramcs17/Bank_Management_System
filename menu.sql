set serveroutput on

declare 
	
	invalid_entry exception;
	
	err_num number;
	err_msg char(100);
	config_id Customer.customer_id%type;
	aconfig_id User_account.account_id%type;

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
		
		
		acc_id := aconfig_id;
		fd_id := 1005;
		amt := 100000.00;
		i_r := 7.20;
		tenure := 15;
		s_d := to_char(sysdate, 'yyyy-mm-dd');
		m_d := to_char(sysdate+15,'yyyy-mm-dd');
		
			insert into Fixed_deposit (deposit_id, amount, interest_rate, start_date, tenure, maturity_date)
			values
			(
				fd_id,
				amt,
				i_r,
				s_d,
				tenure,
				m_d	
			);
				
	end;

	procedure menu is	
	choice_m char(1) := upper('A');
	begin     
		
		case choice_m
			when 'A' then 
				dbms_output.put_line('Fixed Deposit');
				f_d_in();
			
			when 'B' then
				dbms_output.put_line('Loans');

			when 'C' then
				dbms_output.put_line('Saving Account');
		
			when 'D' then
				dbms_output.put_line('Transaction History');
				-- t_his();
		
			when 'E' then 
				dbms_output.put_line('Money Transfer To Account');
		
			when 'F' then 
				dbms_output.put_line('UPI Transaction');
				
			else
				raise invalid_entry;
		end case;
	end; 		
		



begin

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
