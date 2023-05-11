https://github.com/forcedotcom/commerce-on-lightning/blob/develop/docs/setup-guide.md

export SFDX_REST_DEPLOY=false

sudo sfdx update
sudo sfdx plugins:update

sfdx plugins:install https://github.com/forcedotcom/commerce-on-lightning.git\#develop

# packaging
sfdx config:set org-api-version=58.0

====================================================================
sfdx org:list --clean

export SFDX_NPM_REGISTRY=

sfdx force:auth:web:login -d -a "mydevhub"

sfdx commerce:scratchorg:create -u <<ORG_USERNAME>> -a <<ORG_ALIAS>> -v <<DEVHUB_USERNAME>> -w 15 --json
sfdx commerce:scratchorg:create -u mystore10@kam.org -v kamlesh.patel-eu2a@force.com

# perform manual steps i.e. disable cms2 and create one dummy site
sfdx org open --target-org mystore10@kam.org

sfdx commerce:store:create -n <<STORE_NAME>> -o b2c -b <<BUYER_USER_EMAIL>> -u <<ORG_USERNAME>> -v <<DEVHUB_USERNAME>> --apiversion=<<API_VERSION>>
sfdx commerce:store:create -n ev3 -o b2c -b kamipatel+11@gmail.com -u mystore10@kam.org -v kamlesh.patel-eu2a@force.com

sfdx force:source:push --target-org mystore10@kam.org

# Enable Cart API

# Link with RegisteredExternalService 
# Lists all EPN 
sfdx commerce:extension:points:list -u mystore10@kam.org

# Register
sfdx commerce:extension:register -u  mystore10@kam.org -e pricing_demo_service -a PricingDemoService -r Commerce_Domain_Pricing_Service


# ===========================Done UI testing===================================================


# back up
sfdx community:create -u "demo_org_4@1commerce.com" --name "b2cstore04" --templatename "b2c-lite-storefront" --urlpathprefix "b2cstore04" --description "Store b2cstore04 created by Quick Start script." --apiversion=57.0

sfdx commerce:products:import --products-file-csv=./config/NorthernTrail.csv --store-name=D2C --type=b2c -u myscratch --apiversion=57.0
====================================================================

sfdx force:auth:web:login -d -a "mydevhub"

sfdx force:org:create -s -f config/project-scratch-def.json -a "myapp" -o "mydevhub" -d 5
00D8K0000004dl3UAA, username: test-qhp552fpusfx@example.com

sfdx force:source:push -o "myapp"

//sfdx force:user:permset:assign --permsetname TagitPerms -o "myapp" 

sfdx force:org:open -o "myapp"

sfdx force:source:pull -o "myapp"

#### Apex test
sfdx force:apex:test:run --synchronous --resultformat tap --codecoverage -r human  -o "myapp"

#### Package creation
sfdx package:create --name "pricingdemoapp" --package-type Managed  --target-dev-hub "mydevhub" --path force-app
0HoB0000000010kKAA

# PackageId: 0HoB0000000010kKAA
# sfdx force:package:version:create -p "myapp" -x -c --wait 10 -v "mydevhub" --loglevel DEBUG /# packaging/installPackage.apexp?p0=04t3h000004Yr2DAAS

sfdx force:package:version:create --package "pricingdemoapp" --installation-key-bypass --definition-file config/project-scratch-def.json --wait 10 --code-coverage --skip-ancestor-check
https://login.salesforce.com//packaging/installPackage.apexp?p0=04tB0000000BiscIAC

sfdx force:package:version:promote -p "myapp@0.1.0-1" -n --targetdevhubusername "mydevhub"

