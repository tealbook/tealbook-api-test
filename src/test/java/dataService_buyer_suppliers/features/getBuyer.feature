Feature: supplier buyer - GET buyers

  Background:
    * url baseURL
    * def createSupplierBuyerCall = call read('postBuyerKnownAs.feature@postBuyer')
    * def internal_supplier_id = createSupplierBuyerCall.internal_supplier_id
    * def internal_supplier_id_source = createSupplierBuyerCall.internal_supplier_id_source
    * def org_id=createSupplierBuyerCall.buyer_id
    * def companyName = createSupplierCall.company_name
    * def randomUuid = Java.type('utils.GenerateRandomVariables').randomUuid()


  @regression @smoke
  Scenario: get buyers detail
    Given path '/data/suppliers/buyer'
    * def query = {internal_supplier_id:'$(internal_supplier_id)', internal_supplier_id_source:'$(internal_supplier_id)',org_id : '$(org_id)'}
    And params query
    And header Authorization = tealbookAdminToken
    When method GET
    Then status 200
    And print 'Response Body -> ',response
    And match response.supplier_name contains companyName


  @regression @smoke
  Scenario: get bueyrs detail 400
    Given path '/data/suppliers/buyer'
    * def query = {internal_supplier_id_source:'$(internal_supplier_id)',org_id : '$(org_id)'}
    And params query
    And header Authorization = tealbookAdminToken
    When method GET
    Then status 400
    And print 'Response Body -> ',response
    And assert response.description == 'Input failed validation.'


  @regression @smoke
  Scenario: get supplier buyers detail 404
    Given path '/data/suppliers/buyer'
    * def query = {internal_supplier_id:'123', internal_supplier_id_source:'$(internal_supplier_id)',org_id : '$(org_id)'}
    And params query
    And header Authorization = tealbookAdminToken
    When method GET
    Then status 404
    And print 'Response Body -> ',response
    And match response.description contains 'not found'


  @regression @smoke
  Scenario: get supplier buyers detail 403
    Given path '/data/suppliers/buyer'
    * def query = {internal_supplier_id:'$(internal_supplier_id)', internal_supplier_id_source:'$(internal_supplier_id)',org_id : '$(org_id)'}
    And params query
    And header Authorization = buyerOrgUserToken
    When method GET
    Then status 403
    And print 'Response Body -> ',response
    And match response.description contains 'permission'

  @regression @smoke
  Scenario Outline: get supplier buyer known as details 401
    Given path '/data/suppliers/buyer'
    * def query = {internal_supplier_id:'$(internal_supplier_id)', internal_supplier_id_source:'$(internal_supplier_id)',org_id : '$(org_id)'}
    And params query
    And header Authorization = '<key>'
    When method GET
    Then status 401
    And print 'Response Body -> ',response
    And assert response.description=='<response>'
    Examples:
      | key          | response                   |
      | ksjd         | no bearer token in request |
