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
