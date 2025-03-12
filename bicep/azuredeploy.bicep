
/* *************************************************************** */
/* Parameters */
/* *************************************************************** */
param location string = 'eastus'

param name string = 'ai-${uniqueString(resourceGroup().id)}'

param appServiceSku string = 'S1'

param openAiSku string = 'S0'

/* *************************************************************** */
/* Variables */
/* *************************************************************** */

var openAiSettings = {
  name: '${name}-openai'
  sku: openAiSku
  maxConversationTokens: '100'
  maxCompletionTokens: '500'
  gptModel: {
    name: 'gpt-4o'
    version: '2024-05-13'
    deployment: {
      name: 'gpt-4o'
    }
    sku: {
      name: 'Standard'
      capacity: 200
    }
  }
  embeddingsModel: {
    name: 'text-embedding-3-small'
    version: '1'
    deployment: {
      name: 'embeddings'
    }
    sku: {
      name: 'Standard'
      capacity: 50
    }
  }
  dalleModel: {
    name: 'dall-e-3'
    version: '3.0'
    deployment: {
      name: 'dalle-3'
    }
    sku: {
      name: 'Standard'
      capacity: 1
    }
  }
}

var appServiceSettings = {
  plan: {
    name: '${name}-web'
    sku: appServiceSku
  }
  proxy: {
    name: '${name}-proxy'
  }
}

/* *************************************************************** */
/* Azure OpenAI */
/* *************************************************************** */

resource azureAiAccount 'Microsoft.CognitiveServices/accounts@2023-05-01' = {
  name: '${name}-aisvc'
  location: location
  sku: {
    name: openAiSettings.sku    
  }
  kind: 'AIServices'
  properties: {
    customSubDomainName: '${name}-aisvc'
    publicNetworkAccess: 'Enabled'
  }
}

resource openAiAccount 'Microsoft.CognitiveServices/accounts@2023-05-01' = {
  name: openAiSettings.name
  location: location
  sku: {
    name: openAiSettings.sku    
  }
  kind: 'OpenAI'
  properties: {
    customSubDomainName: openAiSettings.name
    publicNetworkAccess: 'Enabled'
  }
}

resource openAiEmbeddingsModelDeployment 'Microsoft.CognitiveServices/accounts/deployments@2023-05-01' = {
  parent: openAiAccount
  name: openAiSettings.embeddingsModel.deployment.name  
  sku: {
    name: openAiSettings.embeddingsModel.sku.name
    capacity: openAiSettings.embeddingsModel.sku.capacity
  }
  properties: {
    model: {
      format: 'OpenAI'
      name: openAiSettings.embeddingsModel.name
      version: openAiSettings.embeddingsModel.version
    }
  }
}

resource openAiGpt4oModelDeployment 'Microsoft.CognitiveServices/accounts/deployments@2023-05-01' = {
  parent: openAiAccount
  name: openAiSettings.gptModel.deployment.name
  dependsOn: [
    openAiEmbeddingsModelDeployment
  ]
  sku: {
    name: openAiSettings.gptModel.sku.name
    capacity: openAiSettings.gptModel.sku.capacity
  }
  properties: {
    model: {
      format: 'OpenAI'
      name: openAiSettings.gptModel.name
      version: openAiSettings.gptModel.version
    }    
  }
}

resource openAiDalleModelDeployment 'Microsoft.CognitiveServices/accounts/deployments@2023-05-01' = {
  parent: openAiAccount
  name: openAiSettings.dalleModel.deployment.name
  dependsOn: [
    openAiEmbeddingsModelDeployment
    openAiGpt4oModelDeployment
  ]
  sku: {
    name: openAiSettings.dalleModel.sku.name
    capacity: openAiSettings.dalleModel.sku.capacity
  }
  properties: {
    model: {
      format: 'OpenAI'
      name: openAiSettings.dalleModel.name
      version: openAiSettings.dalleModel.version
    }    
  }
}

/* *************************************************************** */
/* Logging and instrumentation */
/* *************************************************************** */

resource logAnalytics 'Microsoft.OperationalInsights/workspaces@2021-06-01' = {
  name: '${name}-loganalytics'
  location: location
  properties: {
    sku: {
      name: 'PerGB2018'
    }
  }
}

resource appServiceWebInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: '${name}-appi'
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: logAnalytics.id
  }
}


/* *************************************************************** */
/* App Plan Hosting - Azure App Service Plan */
/* *************************************************************** */
resource appServicePlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: '${appServiceSettings.plan.name}-asp'
  location: location
  sku: {
    name: appServiceSettings.plan.sku
  }
  kind: 'linux'
  properties: {
    reserved: true
  }
}


/* *************************************************************** */
/* Front-end Web App Hosting - Azure App Service */
/* *************************************************************** */

resource appServiceWeb 'Microsoft.Web/sites@2022-03-01' = {
  name: appServiceSettings.proxy.name
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
    siteConfig: {
      linuxFxVersion: 'NODE|20-lts'
      appCommandLine: 'pm2 serve /home/site/wwwroot/dist --no-daemon --spa'
      alwaysOn: true
    }
  }
}

resource appServiceWebSettings 'Microsoft.Web/sites/config@2022-03-01' = {
  parent: appServiceWeb
  name: 'appsettings'
  kind: 'string'
  properties: {
    APPINSIGHTS_INSTRUMENTATIONKEY: appServiceWebInsights.properties.InstrumentationKey
  }
}

/* *************************************************************** */
/* Azure AI Service */
/* *************************************************************** */

resource computerVision 'Microsoft.CognitiveServices/accounts@2023-05-01' = {
  name: '${name}-cv'
  location: location
  kind: 'ComputerVision'
  properties: {
    customSubDomainName: '${name}-cv'
    publicNetworkAccess: 'Enabled'
  }
  sku: {
    name: 'S1'
  }
}


resource speechService 'Microsoft.CognitiveServices/accounts@2021-04-30' = {
  name: '${name}-speech'
  location: location
  kind: 'SpeechServices'
  sku: {
    name: 'S0'
  }
  properties: {
    apiProperties: {
      qnaRuntimeEndpoint: 'https://{speechServiceName}.api.cognitive.microsoft.com'
    }
  }
}

resource translatorService 'Microsoft.CognitiveServices/accounts@2021-04-30' = {
  name: '${name}-translator'
  location: location
  kind: 'TextTranslation'
  sku: {
    name: 'S1'
  }
  properties: {
    apiProperties: {
      qnaRuntimeEndpoint: 'https://{translatorServiceName}.api.cognitive.microsoft.com'
    }
  }
}
