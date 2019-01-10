rm ManagedApp.zip
zip ManagedApp.zip createUiDefinition.json mainTemplate.json
git add .
git commit -m "new commit"
git push origin master


#Deploy
# Create resource group
az group create --name appDefinitionGroup --location northeurope

# Get Azure Active Directory group to manage the application
groupid=$(az ad group show --group ManagedAppAdmins23462125 --query objectId --output tsv)
roleid=$(az role definition list --name Owner --query [].name --output tsv)

# Create the definition for a managed application
az managedapp definition create \
  --name "ManagedStorage02" \
  --location "northeurope" \
  --resource-group appDefinitionGroup \
  --lock-level ReadOnly \
  --display-name "Managed Storage Account" \
  --description "Managed Azure Storage Account" \
  --authorizations "$groupid:$roleid" \
  --package-file-uri "https://github.com/KillerFeature/ManagedAppDemo/raw/master/ManagedApp.zip"
