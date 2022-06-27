/*
* @author         Luca Gouvea
* @modifiedBy     Luca Gouvea 
* @maintainedBy   Luca Gouvea
* @version        1.0
* @created        2022-06-25
* @modified       2022-06-25
* Purpose:        JsonCallout abstract class tests
*/

@IsTest
public with sharing class JsonCalloutsTest {

    @IsTest
    static void testSuccessCalloutJsonStructure() {
        JsonCalloutTestEndpoint.InputStructure dataToSend = new JsonCalloutTestEndpoint.InputStructure('INPUT d4t4', 200);
        JsonCalloutTestEndpoint calloutInstance = new JsonCalloutTestEndpoint();

        Test.setMock(HttpCalloutMock.class, new JsonCalloutTestMockResponse());

        Test.startTest();
        JsonCalloutTestEndpoint.OutputStructure returnData = calloutInstance.execute(dataToSend);
        Test.stopTest();

        System.assertEquals(dataToSend.dataToCopyToOutput, returnData.outputAttribute);
    }

    @IsTest
    static void execute_withFailMock_withoutLogging_shouldFail() {
        JsonCalloutTestEndpoint.InputStructure dataToSend = new JsonCalloutTestEndpoint.InputStructure('INPUT d4t4', 400);
        JsonCalloutTestEndpoint calloutInstance = new JsonCalloutTestEndpoint();

        Test.setMock(HttpCalloutMock.class, new JsonCalloutTestMockResponse());

        Test.startTest();
        try {
            JsonCalloutTestEndpoint.OutputStructure returnData = calloutInstance.execute(dataToSend);
            System.assert(false,'This callout should have failed as the mock response is 400, which is not allowed for this endpoint.');
        }
        catch(Exception e) {
            System.assert(true,'Test successful');
        }
        Test.stopTest();
    }
}