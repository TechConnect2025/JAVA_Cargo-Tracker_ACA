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
