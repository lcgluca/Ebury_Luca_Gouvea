// Use .apex files to store anonymous Apex.
// You can execute anonymous Apex in VS Code by selecting the
//     apex text and running the command:
//     SFDX: Execute Anonymous Apex with Currently Selected Text
// You can also execute the entire file by running the command:
//     SFDX: Execute Anonymous Apex with Editor Contents

Id queueId = [SELECT Id FROM Group WHERE type = 'Queue' AND DeveloperName ='Trade_Reviewers' LIMIT 1].Id;
Id userId =  [SELECT Id FROM User WHERE Name = 'User User' LIMIT 1].Id;
GroupMember gm = new GroupMember(UserOrGroupId = userId, GroupId = queueId);
insert gm;