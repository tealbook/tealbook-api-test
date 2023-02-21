Feature: supplier buy - DELETE supplier buyer known as

  Background:
    * url baseURL
    * def randomUuid = Java.type('utils.GenerateRandomVariables').randomUuid()


  @regression @smoke
  Scenario: delete supplier buyer known as
    * def createSupplierBuyerCall = call read('postBuyerKnownAs.feature@postBuyer')
    * def buyer_known_as_id = createSupplierBuyerCall.buyer_known_as_id
    Given path '/data/suppliers/buyer/buyer_known_as'
    * path buyer_known_as_id
    And header Authorization = tealbookAdminToken
    When method DELETE
    Then status 200
    And print 'Response Body -> ',response
    And match response contains 'deleted'


  @regression @smoke
  Scenario: delete supplier buyer known as detail 400
    Given path '/data/suppliers/buyer/buyer_known_as'
    * path '12345'
    And header Authorization = tealbookAdminToken
    When method DELETE
    Then status 400
    And print 'Response Body -> ',response
    And assert response.description == 'Input failed validation.'

  @regression @smoke
  Scenario: delete supplier buyer known as detail 404
    Given path '/data/suppliers/buyer/buyer_known_as'
    * path randomUuid
    And header Authorization = tealbookAdminToken
    When method DELETE
    Then status 404
    And print 'Response Body -> ',response
    And match response.description contains 'not found'


  @regression @smoke
  Scenario Outline: delete supplier buyer known as details 401
    * def createSupplierBuyerCall = call read('postBuyerKnownAs.feature@postBuyer')
    * def buyer_known_as_id = createSupplierBuyerCall.buyer_known_as_id
    Given path '/data/suppliers/buyer/buyer_known_as'
    * path buyer_known_as_id
    And header Authorization = '<key>'
    When method DELETE
    Then status 401
    And print 'Response Body -> ',response
    And assert response.description=='<response>'
    Examples:
      | key          | response                   |
      | ksjd         | no bearer token in request |
