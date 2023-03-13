@data
Feature: suppliers - PUT supplier

  Background:
    * url baseURL
    * def postSupplierRequestBody = read('../requests/postSupplier.json')


  @regression @smoke @postSupplier
  Scenario Outline: put supplier
    * def createSupplierCall = call read('postSupplier.feature@postSupplier')
    * def supplierId = createSupplierCall.supplier_id
    Given path '/data/suppliers'
    * path supplierId
    And header Authorization = tealbookAdminToken
    * def payload = '<requestPayload>'
    When request payload
    When method PUT
    Then status 200
    And print 'Response Body -> ',response
    * def supplier_id = response.supplier_id
    Examples:
      | requestPayload                       |
      | {"supplier_name": "abcdef inc"}      |
      | {"supplier_description": "test"}     |
      | {"cage_code": "test"}                |
      | {"twitter_id": "test"}               |
      | {"naics": "test"}                    |
      | {"supplier_dba_name": "test"}        |
      | {"date_founded": "1989-01-01"}       |
      | {"meta_data": {}}                    |
      | {"country_of_incorporation": "test"} |
      | {"duns_id": "test"}                  |
      | {"state_of_incorporation": "test"}   |
      | {"head_count": "test"}               |
      | {"linkedin_url": "test"}             |
      | {"yearly_revenue": "test"}           |
      | {"website_url": "test"}              |
      | {"lei": "test"}                      |
      | {"web_domain": "test"}               |
      | {"entity_source": "test"}            |
      | {"facebook_url": "test"}             |
      | {"email_domain": "test"}             |


  @regression @smoke
  Scenario: put supplier details 400
    * def createSupplierCall = call read('postSupplier.feature@postSupplier')
    * def supplierId = createSupplierCall.supplier_id
    Given path '/data/suppliers'
    * path supplierId
    And header Authorization = tealbookAdminToken
    * def payload = {"abc": "cbd"}
    When request payload
    When method PUT
    Then status 400
    And print 'Response Body -> ',response
    And assert response.description=='Input failed validation.'


  @regression @smoke
  Scenario: put supplier details 400
    Given path '/data/suppliers'
    * path '123'
    And header Authorization = tealbookAdminToken
    When request postSupplierRequestBody
    When method PUT
    Then status 400
    And print 'Response Body -> ',response
    And assert response.description=='Input failed validation.'

  @regression @smoke
  Scenario: put supplier id detail 404
    * def randomUuid = Java.type('utils.GenerateRandomVariables').randomUuid()
    Given path '/data/suppliers'
    * path randomUuid
    And header Authorization = tealbookAdminToken
    When request postSupplierRequestBody
    When method PUT
    Then status 404
    And print 'Response Body -> ',response
    And match response.description contains 'not found'


  @regression @smoke
  Scenario Outline: put supplier details 401
    * def randomUuid = Java.type('utils.GenerateRandomVariables').randomUuid()
    Given path '/data/suppliers'
    * path randomUuid
    And header Authorization = '<key>'
    When request postSupplierRequestBody
    And print 'Request Body -> ',postSupplierRequestBody
    When method PUT
    Then status 401
    And print 'Response Body -> ',response
    And assert response.description=='<response>'
    Examples:
      | key  | response                   |
      | ksjd | no bearer token in request |




