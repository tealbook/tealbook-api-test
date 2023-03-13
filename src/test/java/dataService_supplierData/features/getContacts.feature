@data
Feature: supplier data - GET contacts

  Background:
    * url baseURL
    * def randomUuid = Java.type('utils.GenerateRandomVariables').randomUuid()


  @regression @smoke
  Scenario: get contacts detail
    * def createContactsCall = call read('postContact.feature@postContact')
    * def contact_id = createContactsCall.contact_id
    * def supplier_id = createContactsCall.supplier_id
    * print contact_id
    Given path '/data/suppliers/buyer'
    * path supplier_id + '/contacts'
    And header Authorization = tealbookAdminToken
    When method GET
    Then status 200
    And print 'Response Body -> ',response
    * def responses = get response[*]
    * def contact_ids = $responses[*].contact.contact_id
    And match contact_ids contains deep contact_id

  @regression @smoke
  Scenario: get contacts detail 400
    Given path '/data/suppliers/buyer'
    * path '12345/contacts'
    And header Authorization = tealbookAdminToken
    When method GET
    Then status 400
    And print 'Response Body -> ',response
    And assert response.description == 'Input failed validation.'

  @regression @smoke
  Scenario: get contact detail 404
    Given path '/data/suppliers/buyer'
    * path randomUuid + '/contacts'
    And header Authorization = tealbookAdminToken
    When method GET
    Then status 404
    And print 'Response Body -> ',response
    And match response.description contains 'not found'


  @regression @smoke
  Scenario Outline: get contact details 401
    Given path '/data/suppliers/buyer'
    * path randomUuid + '/contacts'
    And header Authorization = '<key>'
    When method GET
    Then status 401
    And print 'Response Body -> ',response
    And assert response.description=='<response>'
    Examples:
      | key          | response                   |
      | ksjd         | no bearer token in request |
