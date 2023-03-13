@data
Feature: supplier data - GET certification

  Background:
    * url baseURL
    * def randomUuid = Java.type('utils.GenerateRandomVariables').randomUuid()


  @regression @smoke
  Scenario: get certification detail
    * def createCertificationsCall = call read('postCertificate.feature@postCertification')
    * def certification_id = createCertificationsCall.certification_id
    * def supplier_id = createCertificationsCall.supplier_id
    * print certification_id
    Given path '/data/suppliers/buyer'
    * path supplier_id + '/certifications'
    And header Authorization = tealbookAdminToken
    When method GET
    Then status 200
    And print 'Response Body -> ',response
    * def responses = get response[*]
    * def certification_ids = $responses[*].certification.certification_id
    And match certification_ids contains deep certification_id

  @regression @smoke
  Scenario: get certifications detail 400
    Given path '/data/suppliers/buyer'
    * path '12345/certifications'
    And header Authorization = tealbookAdminToken
    When method GET
    Then status 400
    And print 'Response Body -> ',response
    And assert response.description == 'Input failed validation.'

  @regression @smoke
  Scenario: get certification detail 404
    Given path '/data/suppliers/buyer'
    * path randomUuid + '/certifications'
    And header Authorization = tealbookAdminToken
    When method GET
    Then status 404
    And print 'Response Body -> ',response
    And match response.description contains 'not found'


  @regression @smoke
  Scenario Outline: get certification details 401
    Given path '/data/suppliers/buyer'
    * path randomUuid + '/certifications'
    And header Authorization = '<key>'
    When method GET
    Then status 401
    And print 'Response Body -> ',response
    And assert response.description=='<response>'
    Examples:
      | key          | response                   |
      | ksjd         | no bearer token in request |
