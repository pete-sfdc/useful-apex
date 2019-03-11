## Trigger Factory Pattern

##### Virtual class instead of interface or abstract class
This is so the developer doesn't explicitly have to override every  trigger context method in order to create a trigger handler class

##### Org Admin Settings
Allows triggers to be completely turned off via a hierarchical custom setting
##### Trigger Switch
Allows object's triggers to be tured off

##### Bulk DML
Adds collections for insert/update/delete of records in bulk at the end of a trigger context. Helps to bulkify triggers