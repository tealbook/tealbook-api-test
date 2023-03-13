@data
Feature: supplier data - DELETE certification

  Background:
    * url baseURL
    * def randomUuid = Java.type('utils.GenerateRandomVariables').randomUuid()


  @regression @smoke
  Scenario: delete certification
    * def createCertificationsCall = call read('postCertificate.feature@postCertification')
    * def certification_id = createCertificationsCall.certification_id
    * def supplier_id = createCertificationsCall.supplier_id
    Given path '/data/suppliers/buyer'
    * path supplier_id + '/certifications'
    * path certification_id[0]
    And header Authorization = tealbookAdminToken
    When method DELETE
    Then status 200
    And print 'Response Body -> ',response
    * def responses = get response[*]
    * def certification_ids = $responses[*].certification.certification_id
    And match certification_ids !contains certification_id


  @regression @smoke
  Scenario: delete certification 400
    Given path '/data/suppliers/buyer'
    * path '123/certifications'
    * path '123'
    And header Authorization = tealbookAdminToken
    When method DELETE
    Then status 400
    And print 'Response Body -> ',response
    And assert response.description == 'Input failed validation.'

  @regression @smoke
  Scenario: delete certifications detail 404
    Given path '/data/suppliers/buyer'
    * path randomUuid + '/certifications'
    * path randomUuid
    And header Authorization = tealbookAdminToken
    When method DELETE
    Then status 404
    And print 'Response Body -> ',response
    And match response.description contains 'not found'


  @regression @smoke
  Scenario Outline: delete certifications details 401
    Given path '/data/suppliers/buyer'
    * path randomUuid + '/certifications'
    * path randomUuid
    And header Authorization = '<key>'
    When method DELETE
    Then status 401
    And print 'Response Body -> ',response
    And assert response.description=='<response>'
    Examples:
      | key          | response                   |
      | ksjd         | no bearer token in request |
