/*
* @author         Luca Gouvea
* @modifiedBy     Luca Gouvea 
* @maintainedBy   Luca Gouvea
* @version        1.0
* @created        2022-06-25
* @modified       2022-06-25
* Purpose:        HttpCalloutMock for JsonCallout abstract class
*/

public with sharing class JsonCalloutTestMockResponse implements HttpCalloutMock{
    public HttpResponse respond(HttpRequest req) {
        HttpResponse result = new HttpResponse();
        // Prepare returning data for the callout
        JsonCalloutTestEndpoint.InputStructure dataInCallout = (JsonCalloutTestEndpoint.InputStructure)JSON.deserialize(req.getBody(), JsonCalloutTestEndpoint.InputStructure.class);
        // Set status code for the callout
        result.setStatusCode(dataInCallout.statusCodeToReturn);
        // Set body of returning data
        JsonCalloutTestEndpoint.OutputStructure returningData = new JsonCalloutTestEndpoint.OutputStructure();
        returningData.outputAttribute = dataInCallout.dataToCopyToOutput;

        result.setBody(JSON.serialize(returningData));
        // Return response
        return result;
    }
}