
Install the sf CLI from <a href="https://developer.salesforce.com/docs/atlas.en-us.sfdx_setup.meta/sfdx_setup/sfdx_setup_install_cli.htm">here</a>
sfdx plugins:install @salesforce/commerce
sfdx plugins:install https://github.com/forcedotcom/commerce-on-lightning.git\#develop
sfdx plugins:install @salesforce/plugin-packaging

Devhub org: kamlesh.patel-8zqt@force.com

## Signup for a devhub and namespace org

## Enable DevHub and 2GP packaing in the devhub org

# Create a managed package namespace in the namespace org

# Link namespace org to the devhub org

# Clone this git repo and open in visual code

# Authenticate against devhub org
sfdx force:auth:web:login -d -a "mydevhub"

# Create scratch org with commerce features
sfdx commerce:scratchorg:create -u mystore1@kam.demo -a "myapp" -v kamlesh.patel-8zqt@force.com -w 30 --json

sfdx commerce:scratchorg:create -u mystore91@kam.demo -a "myapp" -v kamlesh.patel-8zqt@force.com -w 30 --json

sfdx commerce:scratchorg:create -u chris@app.demo -a "myapp2" -v kamlesh.patel-8zqt@force.com --json

# Open the scartch org
sfdx org open --target-org mystore1@kam.demo

sfdx org open --target-org mystore91@kam.demo

# Perform manual step to disable Digital Experience platform check box 
# Perform manual step to create a b2c storefront site from Digital Experience platform 

# Create a commerce storefront with products, cms etc
sfdx commerce:store:create -n ev1 -o b2c -b mystoredemouser+1@gmail.com -u mystore1@kam.demo -v kamlesh.patel-8zqt@force.com

sfdx commerce:store:create -n ev1 -o b2b -b mystoredemouser+9@gmail.com -u mystore91@kam.demo -v kamlesh.patel-8zqt@force.com


# Push the pricing service apex code to the scratch org
sfdx force:source:push -o "myapp"

# Register pricing extension class in the RegisteredExternalService 
sfdx commerce:extension:register --targetusername mystore1@kam.demo --apex-class-name PricingDemoService --extension-point-name Commerce_Domain_Pricing_Service --registered-extension-name PricingDemoService

# Manual - Associate the extension to the ev1 store. Validate the pricing on the store front

# Run Apex unit test for the code coverage
sfdx force:apex:test:run --synchronous --resultformat tap --codecoverage -r human  -o "myapp" --classnames PricingDemoServiceTest

# Create a package
sfdx package:create --name "kampricingdemo" --package-type Managed  --target-dev-hub "mydevhub" --path force-app

# Create a package version
sfdx package:version:create --package "kampricingdemo" --installation-key-bypass --definition-file config/both-project-scratch-def.json --wait 10 --code-coverage --skip-ancestor-check

# Promote the package
sfdx force:package:version:promote -p "kampricingdemo@0.1.0-1" -n --target-dev-hub "mydevhub"

# Test the package
# Create a new scratch org for testing
sfdx commerce:scratchorg:create -u teststore1@kam.demo -a "testapp" -v kamlesh.patel-8zqt@force.com -w 10 --json

# Open the test scartch org
sfdx org open --target-org teststore1@kam.demo

# Perform manual step to disable Digital Experience platform check box 
# Perform manual step to create a b2c storefront site from Digital Experience platform 

# Create a commerce storefront with products, cms etc
sfdx commerce:store:create -n evtest -o b2c -b teststoredemouser+1@gmail.com -u teststore1@kam.demo -v kamlesh.patel-6fd1@force.com --json 

# Install the package in the org
sfdx force:package:install --package kampricingdemo@0.1.0-1 --target-org teststore1@kam.demo

# Register pricing extension class in the RegisteredExternalService
sfdx commerce:extension:register --targetusername teststore1@kam.demo --apex-class-name PricingDemoService --extension-point-name Commerce_Domain_Pricing_Service --registered-extension-name PricingDemoService

# Manual - Associate the extension (from the package) to the evtest store. Validate the pricing on the store front

