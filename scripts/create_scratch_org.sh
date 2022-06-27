username=${1:-"eburyDemo"}
scratch_org_config=config/project-scratch-def.json

echo 'Creating scratch org...'
sfdx force:org:create -f $scratch_org_config -d 1 -s -a $username -w 30

echo 'Sleeping for 20 seconds to give the scratch org a chance to fully build....'
sleep 20

echo 'Creating open link for scratch org...'
sfdx force:org:open -u $username -r

echo 'Deploying metadata using source:deploy...'
sfdx force:source:deploy -u $username -p force-app -w 30

echo "Inserting User to Queue"
sfdx force:apex:execute -f scripts/apex/hello.apex -u $username