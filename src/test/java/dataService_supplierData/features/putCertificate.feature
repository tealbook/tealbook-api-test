@data
Feature: supplier data - PUT certification

  Background:
    * url baseURL
    * def randomUuid = Java.type('utils.GenerateRandomVariables').randomUuid()


  @regression @smoke
  Scenario Outline: put certifications
    * def createCertificationsCall = call read('postCertificate.feature@postCertification')
    * def certification_id = createCertificationsCall.certification_id
    * def supplier_id = createCertificationsCall.supplier_id
    Given path '/data/suppliers/buyer'
    * path supplier_id + '/certifications'
    * path certification_id[0]
    And header Authorization = tealbookAdminToken
    And header Content-Type = 'application/json; charset=utf-8'
    * def payload = '<requestPayload>'
    When request payload
    * print payload
    When method PUT
    Then status 200
    And print 'Response Body -> ',response
    Examples:
      | requestPayload                                                                        |
      | {"org_id": "3d5e1780-8c91-4e3d-92d0-ad40bb490660","expires_at":"2024-06-28T08:51:29"} |
      | {"org_id": "3d5e1780-8c91-4e3d-92d0-ad40bb490660","sub_type":"qa test"}               |
      | {"org_id": "3d5e1780-8c91-4e3d-92d0-ad40bb490660","load_date":"2023-02-20"}           |
      | {"org_id": "3d5e1780-8c91-4e3d-92d0-ad40bb490660","attachment":{}}                    |
      | {"org_id": "3d5e1780-8c91-4e3d-92d0-ad40bb490660","certification_type":"qa test"}     |
      | {"org_id": "3d5e1780-8c91-4e3d-92d0-ad40bb490660","entity_source":"vendor"}           |
      | {"org_id": "3d5e1780-8c91-4e3d-92d0-ad40bb490660","category":"diversity"}             |
      | {"org_id": "3d5e1780-8c91-4e3d-92d0-ad40bb490660","agency_issued_date": "2020-02-20"} |
      | {"org_id": "3d5e1780-8c91-4e3d-92d0-ad40bb490660","certification_url": "string"}      |
      | {"org_id": "3d5e1780-8c91-4e3d-92d0-ad40bb490660","certifying_body": "sam.gov"}       |
      | {"org_id": "3d5e1780-8c91-4e3d-92d0-ad40bb490660", "sub_category": "SBE"}             |


  @regression @smoke
  Scenario: put certifications 400
    * def createCertificationsCall = call read('postCertificate.feature@postCertification')
    * def certification_id = createCertificationsCall.certification_id
    * def supplier_id = createCertificationsCall.supplier_id
    Given path '/data/suppliers/buyer'
    * path supplier_id + '/certifications'
    * path certification_id[0]
    And header Authorization = tealbookAdminToken
    And header Content-Type = 'application/json; charset=utf-8'
    * def payload = {"abc": "cbd"}
    When request payload
    When method PUT
    Then status 400
    And print 'Response Body -> ',response
    And assert response.description == 'Input failed validation.'


  @regression @smoke
  Scenario: put certifications 400
    Given path '/data/suppliers/buyer'
    * path '123/certifications'
    * path '123'
    And header Authorization = tealbookAdminToken
    And header Content-Type = 'application/json; charset=utf-8'
    When request {"org_id": "3d5e1780-8c91-4e3d-92d0-ad40bb490660", "sub_category": "SBE"}
    When method PUT
    Then status 400
    And print 'Response Body -> ',response
    And assert response.description == 'Input failed validation.'

  @regression @smoke
  Scenario: put certification detail 404
    Given path '/data/suppliers/buyer'
    * path randomUuid + '/certifications'
    * path randomUuid
    And header Authorization = tealbookAdminToken
    And header Content-Type = 'application/json; charset=utf-8'
    When request {"org_id": "3d5e1780-8c91-4e3d-92d0-ad40bb490660", "sub_category": "SBE"}
    When method PUT
    Then status 404
    And print 'Response Body -> ',response
    And match response.description contains 'not found'


  @regression @smoke
  Scenario Outline: put certification details 401
    Given path '/data/suppliers/buyer'
    * path randomUuid + '/certifications'
    * path randomUuid
    And header Authorization = '<key>'
    And header Content-Type = 'application/json; charset=utf-8'
    When request {"org_id": "3d5e1780-8c91-4e3d-92d0-ad40bb490660", "sub_category": "SBE"}
    When method PUT
    Then status 401
    And print 'Response Body -> ',response
    And assert response.description=='<response>'
    Examples:
      | key  | response                   |
      | ksjd | no bearer token in request |




