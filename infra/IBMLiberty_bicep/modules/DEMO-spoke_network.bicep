param location string = 'westeurope'
param spokeVnetName string = 'spoke-vnet'
param spokeVnetCidr string = '10.1.0.0/16'
param controlPlaneSubnetCidr string = '10.1.0.0/22'
param computeSubnetCidr string = '10.1.4.0/22'
param acaSubnetCidr string = '10.1.8.0/22'
param tags object = {
  env: 'dev'
  dept: 'it'
}
param controlPlaneVnetName string = 'control-plane'
param computeVnetName string = 'compute'
param acaSubnetName string = 'aca-subnet'
param containerAppEnvironmentName string = 'aca-env'
param acrName string = 'cargotrackeracr'
param acrSku string = 'Standard'

resource cluster_vnet 'Microsoft.Network/virtualNetworks@2022-07-01' = {
  name: spokeVnetName
  location: location
  tags: {
    tagName1: tags.env
    tagName2: tags.dept
  }
  properties: {
    addressSpace: {
      addressPrefixes: [
        spokeVnetCidr
      ]
    }
    subnets: [
      {
        name: controlPlaneVnetName
        properties: {
          addressPrefix: controlPlaneSubnetCidr
        }
      }
      {
        name: computeVnetName
        properties: {
          addressPrefix: computeSubnetCidr
        }
      }
      {
        name: acaSubnetName
        properties: {
          addressPrefix: acaSubnetCidr
        }
      }
    ]
  }
  dependsOn: [
   
  ]
}

// Add an Azure Container Apps environment
resource containerAppEnv 'Microsoft.App/managedEnvironments@2022-03-01' = {
  name: containerAppEnvironmentName
  location: location
  properties: {
    vnetConfiguration: {
      infrastructureSubnetId: resourceId('Microsoft.Network/virtualNetworks/subnets', spokeVnetName, acaSubnetName) // Use the acaSubnetCidr
    }
  }
}

// Add an Azure Container App
resource containerApp 'Microsoft.App/containerApps@2022-03-01' = {
  name: 'javacargotrackeraca0' 
  location: location
  properties: {
    managedEnvironmentId: containerAppEnv.id
    configuration: {
      ingress: {
        external: true
        targetPort: 80 
        traffic: [
          {
            weight: 100
            revisionName: 'default'
          }
        ]
      }
    }
        template: {
          containers: [
            {
              name: 'javacargotrackeraca0'
              image: 'mcr.microsoft.com/azuredocs/aci-helloworld' // Change the container image as needed
            }
          ]
        }
      }
    }
      

// Add an Azure Container Registry
resource containerRegistry 'Microsoft.ContainerRegistry/registries@2021-12-01-preview' = {
  name: acrName
  location: location
  sku: {
    name: acrSku
  }
  properties: {
    adminUserEnabled: true
  }
}
