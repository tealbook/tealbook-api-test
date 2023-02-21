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
baseURL : 'https://api-poc3.tealbook.com'
var tealbookAdmin = karate.callSingle('classpath:tokenFeature/tealbookAdmin.feature',config)
config.tealbookAdminToken = tealbookAdmin.token ;
var tealbookSupport = karate.callSingle('classpath:tokenFeature/tealbookSupport.feature',config)
config.tealbookSupportToken = tealbookSupport.token ;
var tealbookCda = karate.callSingle('classpath:tokenFeature/tealbookCda.feature',config)
config.tealbookCdaToken = tealbookCda.token ;
var buyerOrgAdmin = karate.callSingle('classpath:tokenFeature/buyerOrgAdmin.feature',config)
config.buyerOrgAdminToken = buyerOrgAdmin.token ;
var buyerOrgUser = karate.callSingle('classpath:tokenFeature/buyerOrgUser.feature',config)
config.buyerOrgUserToken = buyerOrgUser.token ;}
else if (env=='staging'){
baseURL : 'https://api-stage.tealbook.com'
var tealbookAdmin = karate.callSingle('classpath:tokenFeature/tealbookAdmin.feature',config)
config.tealbookAdminToken = {Authorization: tealbookAdmin.token };
var tealbookSupport = karate.callSingle('classpath:tokenFeature/tealbookSupport.feature',config)
config.tealbookSupportToken = {Authorization: tealbookSupport.token };
var tealbookCda = karate.callSingle('classpath:tokenFeature/tealbookCda.feature',config)
config.tealbookCdaToken = {Authorization: tealbookCda.token };
var buyerOrgAdmin = karate.callSingle('classpath:tokenFeature/buyerOrgAdmin.feature',config)
config.buyerOrgAdminToken = {Authorization: buyerOrgAdmin.token };
var buyerOrgUser = karate.callSingle('classpath:tokenFeature/buyerOrgUser.feature',config)
config.buyerOrgUserToken = {Authorization: buyerOrgUser.token };
}
return config;
}