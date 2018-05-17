#!/bin/bash
sfdx force:org:create -f config/project-scratch-def.json -s -a ducatiCustomerExperience -d 29
sfdx force:source:push
sfdx force:user:permset:assign -n Ducati_App
sfdx force:data:tree:import -p data/importPlan.json
sfdx force:user:password:generate

sfdx force:org:open

# create the app from app.json
sfdx shane:heroku:repo:deploy -g mshanemc -r ducati-demo-server -n `basename "${PWD}"` --envUser SFDC_USERNAME --envPassword SFDC_PASSWORD -t autodeployed-demos
sfdx shane:heroku:repo:deploy -g mshanemc -r ducati-demo-server -n `basename "${PWD}"`-stg --envUser SFDC_USERNAME --envPassword SFDC_PASSWORD -t autodeployed-demos

# attach to a pipeline
heroku pipelines:create `basename "${PWD}"` -a `basename "${PWD}"` --stage production --team autodeployed-demos
heroku pipelines:add `basename "${PWD}"` -a `basename "${PWD}"`-stg --stage staging
heroku pipelines:connect `basename "${PWD}"` --repo mshanemc/ducati-demo-server