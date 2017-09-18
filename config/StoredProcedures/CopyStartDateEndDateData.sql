CREATE DEFINER=`redmine`@`%` PROCEDURE `CopyStartDateEndDateData`()
BEGIN

	declare ind int default 0;
    declare total int default 0;
    declare isValueExisted bit default false;
    
    declare issueId int(11) default 0;
    declare startDate datetime;
    declare dueDate datetime;

    create temporary table if not exists CoreData as (
	select id, start_date, due_date
	from issues
	where start_date is not null or due_date is not null);
    
    set total = (select count(*) from CoreData);
        
	CoreDataLoop: LOOP
		if ind > total then
			leave CoreDataLoop;
		end if;
        
        set ind:= ind + 1;
        
        select id from CoreData limit ind, 1 into issueId;
        select start_date from CoreData limit ind, 1 into startDate;
        select due_date from CoreData limit ind, 1 into dueDate;
        
        set isValueExisted = 0;
        
        if startDate is not null then
			select 1 from custom_values where customized_id = issueId and custom_field_id = 39 and `value` ='' into isValueExisted;
            if isValueExisted = 1 then
				update custom_values set `value` = DATE_FORMAT(startDate, '%d/%m/%Y 00:00') where customized_id = issueId and custom_field_id = 39;
			else
				insert into custom_values(customized_type, customized_id, custom_field_id, `value`) values('Issue', issueId, '39', DATE_FORMAT(startDate, '%d/%m/%Y 00:00'));
			end if;
		end if;
        
        set isValueExisted = 0;
                
        if dueDate is not null then
			select 1 from custom_values where customized_id = issueId and custom_field_id = 40 and `value` ='' into isValueExisted;
            if isValueExisted = 1 then
				update custom_values set `value` = DATE_FORMAT(dueDate, '%d/%m/%Y 00:00') where customized_id = issueId and custom_field_id = 40;
			else
				insert into custom_values(customized_type, customized_id, custom_field_id, `value`) values('Issue', issueId, '40', DATE_FORMAT(dueDate, '%d/%m/%Y 00:00'));
			end if;
		end if;
        
        iterate CoreDataLoop;
	end loop;

END