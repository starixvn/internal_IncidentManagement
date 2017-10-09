# Database Migration
1. Redmine:
```
rake db:migrate
```

2. Plugins:
```
rake redmine:plugins:migrate
```

3. Restart nginx
```
supervisorctl restart nginx
```

# Run Store Procedure to copy date data from Redmine Core to newly created custom field

1. Create new Store procedure

```
IMPORTANT: Change declare value to match id of newly created custom field
```

```sql
CREATE PROCEDURE `CopyStartDateEndDateData`()
BEGIN
	declare reportedDateCustomFieldId int default 34;
    declare resolvedDateCustomFieldId int default 35;
	declare ind int default 0;
    declare total int default 0;
    declare isValueExisted bit default 0;
    declare isRowExisted bit default 0;
    
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
        
        set isRowExisted = 0;
        set isValueExisted = 0;
        
        if startDate is not null then
			-- value existed
			select 1 from custom_values where customized_id = issueId and custom_field_id = reportedDateCustomFieldId and `value` <> '' into isValueExisted;
            if isValueExisted <> 1 then
				select 1 from custom_values where customized_id = issueId and custom_field_id = reportedDateCustomFieldId and `value` = '' into isRowExisted;
				if isRowExisted = 1 then
					update custom_values set `value` = DATE_FORMAT(startDate, '%d/%m/%Y 00:01') where customized_id = issueId and custom_field_id = reportedDateCustomFieldId;
				else
					insert into custom_values(customized_type, customized_id, custom_field_id, `value`) values('Issue', issueId, reportedDateCustomFieldId, DATE_FORMAT(startDate, '%d/%m/%Y 00:01'));
				end if;
			end if;
		end if;
        
        set isRowExisted = 0;
        set isValueExisted = 0;
                
        if dueDate is not null then
			select 1 from custom_values where customized_id = issueId and custom_field_id = resolvedDateCustomFieldId and `value` <> '' into isValueExisted;
				if isValueExisted <> 1 then
				select 1 from custom_values where customized_id = issueId and custom_field_id = resolvedDateCustomFieldId and `value` = '' into isRowExisted;
				if isRowExisted = 1 then
					update custom_values set `value` = DATE_FORMAT(dueDate, '%d/%m/%Y 23:59') where customized_id = issueId and custom_field_id = resolvedDateCustomFieldId;
				else
					insert into custom_values(customized_type, customized_id, custom_field_id, `value`) values('Issue', issueId, resolvedDateCustomFieldId, DATE_FORMAT(dueDate, '%d/%m/%Y 23:59'));
				end if;
			end if;
		end if;
        
        iterate CoreDataLoop;
	end loop;
END
```

2. Call procedure

```sql
call CopyStartDateEndDateData
```

# Files and Folder Permission
1. Ckeditor Rich File Manager
```
create folder 'system` in
app > redmine > public

set permission '0777' for that folder recursively (rwxrwxrwx)
```

2. Redmine Document system
```
create folder 'files' in
app > redmine

set permission '0777' for that folder recursively (rwxrwxrwx)
```

# Docker Timezone

```
Set timezone for Docker to GMT+8
```

# Administration > Settings
1. Administration --> Settings --> Display
    1. Themes: `Incident Nexcel`
    2. Default language: `English`
    3. Force default language for anonymous users: `true`
    4. Force default language for logged-in users: `true`
    5. Category menu tab for creating new objects: `Display the "New Incident" Tab`
2. Administration --> Settings --> Authentication
    1. Time zone: `GMT+8`

# Administration > Plugins
1. DMSF 
    1. File Storage Directory: `files/dmsf`
    2. Allow permission to access `file/dmsf` on server
2. Redmine CKEditor plugin
    1. Skin: moono-lisa
    2. Remove seperator and line break at the end
    ![Remove seperator and line break at the end](https://farm5.staticflickr.com/4498/37556753222_f4fcc9505f_o.png)
    3. Add `Insert code Snippet`
3. Syntax highlighting with highlightjs
    1. Highlight using theme: `vs`
4. Redmine Issue Templates plugin
    1. Configure > Issue templates list / edit templates > Set default & Enable for both Templates
    2. Consider apply global issue template to approriate projects
    
    ![Consider apply global issue template to projects](https://farm5.staticflickr.com/4461/37589249931_83ac2acc5c_o.png)

# Administration > Roles and permissions
1. Manager
    1. Member management: `Only these roles` > All box empty
    
    manager cannot manage member of projects

    ![manager cannot manage member of projects](https://farm5.staticflickr.com/4453/23736521878_7648aa6375_o.png)

    2. Document: Check all boxes
    3. Files: Check all boxes
2. Owner
    1. Document: Check all boxes

# Administration > Custom fields
1. Customer Feedback (GMT+8)
    1. Used as a filter: `checked`
    2. Hours: `Yes`
    3. For all categories: `checked`
2. Reported DateTime (GMT+8)
    1. Used as a filter: `checked`
    2. Hours: `Yes`
    3. For all categories: `checked`
    4. Trackers: `Incidend`, `Problem`
3. Resolved DateTime (GMT+8)
    1. Used as a filter: `checked`
    2. Hours: `Yes`
    3. For all categories: `checked`
    4. Trackers: `Incidend`, `Problem`
4. Set position for these 3 custom fields
    
    Drag the green 2-way arrow

    ![drag the green 2-way arrow](https://farm5.staticflickr.com/4491/36878724584_2198d5a136_o.png)


