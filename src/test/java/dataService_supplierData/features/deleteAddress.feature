Feature: supplier data - DELETE address

  Background:
    * url baseURL
    * def randomUuid = Java.type('utils.GenerateRandomVariables').randomUuid()


  @regression @smoke
  Scenario: delete address
    * def createAddressesCall = call read('postAddress.feature@postAddress')
    * def address_id = createAddressesCall.address_id
    * def supplier_id = createAddressesCall.supplier_id
    Given path '/data/suppliers/buyer'
    * path supplier_id + '/addresses'
    * path address_id[0]
    And header Authorization = tealbookAdminToken
    When method DELETE
    Then status 200
    And print 'Response Body -> ',response
    * def responses = get response[*]
    * def address_ids = $responses[*].address.address_id
    And match address_ids !contains address_id


  @regression @smoke
  Scenario: delete address 400
    Given path '/data/suppliers/buyer'
    * path '123/addresses'
    * path '123'
    And header Authorization = tealbookAdminToken
    When method DELETE
    Then status 400
    And print 'Response Body -> ',response
    And assert response.description == 'Input failed validation.'

  @regression @smoke
  Scenario: delete Addresses detail 404
    Given path '/data/suppliers/buyer'
    * path randomUuid + '/addresses'
    * path randomUuid
    And header Authorization = tealbookAdminToken
    When method DELETE
    Then status 404
    And print 'Response Body -> ',response
    And match response.description contains 'not found'


  @regression @smoke
  Scenario Outline: delete Addresses details 401
    Given path '/data/suppliers/buyer'
    * path randomUuid + '/addresses'
    * path randomUuid
    And header Authorization = '<key>'
    When method DELETE
    Then status 401
    And print 'Response Body -> ',response
    And assert response.description=='<response>'
    Examples:
      | key          | response                   |
      | ksjd         | no bearer token in request |
