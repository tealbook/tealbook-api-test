@data
Feature: get buyer export using data service

  Background:
    * url baseURL

  @setup
  Scenario:
    * def adminToken = tealbookAdminToken
    * def supportToken = tealbookSupportToken
    * def csmToken = tealbookCsmToken
    * def dqToken = tealbookDqToken
    * def cdaToken = tealbookCdaToken

  @regression @smoke
  Scenario Outline: get buyer export 200 status code
    Given path '/data/suppliers/buyer/export'
    And header Authorization = <token>
    When method GET
    Then status 200
    And print 'Response Body -> ',response
    Examples:
      | token                       |
      | karate.setup().adminToken   |
      | karate.setup().supportToken |
      | karate.setup().csmToken     |
      | karate.setup().cdaToken     |
      | karate.setup().dqToken      |

  @regression @smoke
  Scenario Outline: GET vendor export 400
    Given path '/data/suppliers/buyer/export'
    And param <key>  = <value>
    And header Authorization = tealbookAdminToken
    When method GET
    Then status 400
    And print 'Response Body -> ',response
    And match response.description contains 'invalid input'
    Examples:
      | key                         | value  |
      | internal_supplier_id_source | '1234' |
      | internal_supplier_ids       | '$%^'    |

  @regression @smoke
  Scenario: get vendor export  404
    Given path '/data/suppliers/buyer/export'
    And param internal_supplier_id_source  = 'hello'
    And param internal_supplier_ids = 1
    And header Authorization = tealbookAdminToken
    When method GET
    Then status 404
    And print 'Response Body -> ',response
    And match response.description contains 'not found'

  @regression @smoke
  Scenario Outline: get vendor export  401
    Given path '/data/suppliers/buyer/export'
    And header Authorization = '<key>'
    When method GET
    Then status 401
    And print 'Response Body -> ',response
    And assert response.description == '<response>'
    Examples:
      | key  | response                   |
      | ksjd | no bearer token in request |

