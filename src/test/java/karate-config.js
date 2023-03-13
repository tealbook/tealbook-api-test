function fn(){
var env = karate.env
karate.log('value of env is : ',env)

if (!env){
env = 'dev';
}
var config = {
env : env,
baseURL : 'https://api-poc3.tealbook.com',
}
if (env=='dev'){
baseURL : 'https://stage-poc3.tealbook.com'
var tealbookAdmin = karate.callSingle('classpath:tokenFeature/tealbookAdmin.feature',config)
config.tealbookAdminToken = tealbookAdmin.token ;
var tealbookSupport = karate.callSingle('classpath:tokenFeature/tealbookSupport.feature',config)
config.tealbookSupportToken = tealbookSupport.token ;
var tealbookCda = karate.callSingle('classpath:tokenFeature/tealbookCda.feature',config)
config.tealbookCdaToken = tealbookCda.token ;
var tealbookDq = karate.callSingle('classpath:tokenFeature/tealbookDq.feature',config)
config.tealbookDqToken = tealbookDq.token ;
var tealbookCsm = karate.callSingle('classpath:tokenFeature/tealbookCsm.feature',config)
config.tealbookCsmToken = tealbookCsm.token ;}
else if (env=='staging'){
baseURL : 'https://api-stage.tealbook.com'
var tealbookAdmin = karate.callSingle('classpath:tokenFeature/tealbookAdmin.feature',config)
config.tealbookAdminToken = tealbookAdmin.token ;
var tealbookSupport = karate.callSingle('classpath:tokenFeature/tealbookSupport.feature',config)
config.tealbookSupportToken = tealbookSupport.token ;
var tealbookCda = karate.callSingle('classpath:tokenFeature/tealbookCda.feature',config)
config.tealbookCdaToken = tealbookCda.token ;
var tealbookDq = karate.callSingle('classpath:tokenFeature/tealbookDq.feature',config)
config.tealbookDqToken = tealbookDq.token ;
var tealbookCsm = karate.callSingle('classpath:tokenFeature/tealbookCsm.feature',config)
config.tealbookCsmToken = tealbookCsm.token ;};
}
return config;
}