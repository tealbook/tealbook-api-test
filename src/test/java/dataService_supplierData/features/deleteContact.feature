Feature: supplier data - DELETE contact

  Background:
    * url baseURL
    * def randomUuid = Java.type('utils.GenerateRandomVariables').randomUuid()


  @regression @smoke
  Scenario: delete contact
    * def createContactsCall = call read('postContact.feature@postContact')
    * def contact_id = createContactsCall.contact_id
    * def supplier_id = createContactsCall.supplier_id
    Given path '/data/suppliers/buyer'
    * path supplier_id + '/contacts'
    * path contact_id[0]
    And header Authorization = tealbookAdminToken
    When method DELETE
    Then status 200
    And print 'Response Body -> ',response
    * def responses = get response[*]
    * def contact_ids = $responses[*].contact.contact_id
    And match contact_ids !contains contact_id


  @regression @smoke
  Scenario: delete contact 400
    Given path '/data/suppliers/buyer'
    * path '123/contacts'
    * path '123'
    And header Authorization = tealbookAdminToken
    When method DELETE
    Then status 400
    And print 'Response Body -> ',response
    And assert response.description == 'Input failed validation.'

  @regression @smoke
  Scenario: delete contacts detail 404
    Given path '/data/suppliers/buyer'
    * path randomUuid + '/contacts'
    * path randomUuid
    And header Authorization = tealbookAdminToken
    When method DELETE
    Then status 404
    And print 'Response Body -> ',response
    And match response.description contains 'not found'


  @regression @smoke
  Scenario Outline: delete scontacts details 401
    Given path '/data/suppliers/buyer'
    * path randomUuid + '/contacts'
    * path randomUuid
    And header Authorization = '<key>'
    When method DELETE
    Then status 401
    And print 'Response Body -> ',response
    And assert response.description=='<response>'
    Examples:
      | key          | response                   |
      | ksjd         | no bearer token in request |
