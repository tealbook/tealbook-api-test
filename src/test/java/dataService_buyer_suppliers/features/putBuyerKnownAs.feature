Feature: supplier buy - PUT buyer known as

  Background:
    * url baseURL
    * def postSupplierBuyerRequestBody = read('../requests/buyerKnownAs.json')
    * def randomUuid = Java.type('utils.GenerateRandomVariables').randomUuid()


  @regression @smoke
  Scenario Outline: put buyer known as
    * def createSupplierBuyerCall = call read('postBuyerKnownAs.feature@postBuyer')
    * def buyer_known_as_id = createSupplierBuyerCall.buyer_known_as_id
    Given path '/data/suppliers/buyer/buyer_known_as'
    * path buyer_known_as_id
    And header Authorization = tealbookAdminToken
    * def payload = '<requestPayload>'
    When request payload
    When method PUT
    Then status 200
    And print 'Response Body -> ',response
    Examples:
      | requestPayload                                                |
      | {"diversity_category": "test"}                                |
      | {"diversity_status": "test"}                                  |
      | {"company_name": "test inc"}                                  |
      | {"internal_supplier_id": "12334"}                             |
      | {"known_as_supplier_id": ""}                                  |
      | {"supplier_buyer_id": "3fa85f64-5717-4562-b3fc-2c963f66afa6"} |
      | {"internal_supplier_id_source": "string"}                     |
      | {"preferred_status": "string"}                                |
      | {"internal_source_name": "string"}                            |


  @regression @smoke
  Scenario: put buyer known as details 400
    * def createSupplierBuyerCall = call read('postBuyerKnownAs.feature@postBuyer')
    * def buyer_known_as_id = createSupplierBuyerCall.buyer_known_as_id
    Given path '/data/suppliers/buyer/buyer_known_as'
    * path buyer_known_as_id
    And header Authorization = tealbookAdminToken
    * def payload = {"abc": "cbd"}
    When request payload
    When method PUT
    Then status 400
    And print 'Response Body -> ',response
    And assert response.description == 'Input failed validation.'


  @regression @smoke
  Scenario: put buyer known as details 400
    Given path '/data/suppliers/buyer/buyer_known_as'
    * path '123'
    And header Authorization = tealbookAdminToken
    When request postSupplierBuyerRequestBody
    When method PUT
    Then status 400
    And print 'Response Body -> ',response
    And assert response.description == 'Input failed validation.'

  @regression @smoke
  Scenario: put buyer known as detail 404
    Given path '/data/suppliers/buyer/buyer_known_as'
    * path randomUuid
    And header Authorization = tealbookAdminToken
    When method PUT
    Then status 404
    And print 'Response Body -> ',response
    And match response.description contains 'not found'


  @regression @smoke
  Scenario Outline: put buyer known as details 401
    * def createSupplierBuyerCall = call read('postBuyerKnownAs.feature@postBuyer')
    * def buyer_known_as_id = createSupplierBuyerCall.buyer_known_as_id
    Given path '/data/suppliers/buyer/buyer_known_as'
    * path buyer_known_as_id
    And header Authorization = '<key>'
    When request postSupplierBuyerRequestBody
    And print 'Request Body -> ',postSupplierBuyerRequestBody
    When method PUT
    Then status 401
    And print 'Response Body -> ',response
    And assert response.description=='<response>'
    Examples:
      | key  | response                   |
      | ksjd | no bearer token in request |




