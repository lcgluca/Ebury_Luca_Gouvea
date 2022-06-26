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