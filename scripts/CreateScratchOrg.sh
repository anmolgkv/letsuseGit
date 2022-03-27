source ./scripts/config.sh

execute() {
  $@ || exit
}
echo "1 in sh file"
echo $DEV_HUB_URL
echo "2"
echo "3"
echo $SCRATCH_ORG_ALIAS
echo "4"

if [  $DEV_HUB_URL ]; then
  echo "set default devhub user"
  execute sfdx force:config:set defaultdevhubusername=$DEV_HUB_ALIAS

  echo "deleting old scratch org"
  sfdx force:org:delete -p -u $SCRATCH_ORG_ALIAS
fi


echo "Creating scratch ORG..."
execute sfdx force:org:create -a $SCRATCH_ORG_ALIAS -s -f ./config/project-scratch-def.json -d 7

echo "Pushing changes to scratch org..."
execute sfdx force:source:push

# echo "Assigning permission"
# execute sfdx force:user:permset:assign -n {Permission Set}

echo "Make sure Org user is english"
sfdx force:data:record:update -s User -w "Name='User User'" -v "Languagelocalekey=en_US"

echo "Running apex tests..."
execute sfdx force:apex:test:run -l RunLocalTests -w 30

# if [ -f "package.json" ]; then
#   echo "Running jest tests"
#   execute npm install
#   execute npm run test:unit
# fi
