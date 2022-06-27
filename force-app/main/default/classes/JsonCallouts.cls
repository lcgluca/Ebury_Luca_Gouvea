/*
* @author         Luca Gouvea
* @modifiedBy     Luca Gouvea 
* @maintainedBy   Luca Gouvea
* @version        1.0
* @created        2022-06-25
* @modified       2022-06-25
* Purpose:        Provide a standard for all callouts 
*/

public abstract with sharing class JsonCallouts {
    private HttpRequest request;
    private HttpResponse response;

    public final static String HTTP_GET = 'GET';
    public final static String HTTP_POST = 'POST';
    public final static String HTTP_PUT = 'PUT';
    public final static String HTTP_DELETE = 'DELETE';

    protected Boolean isGETCallout{ get { return httpMethod() == HTTP_GET; }}
    protected Boolean isPOSTCallout{ get { return httpMethod() == HTTP_POST; }}
    protected Boolean isPUTCallout{ get { return httpMethod() == HTTP_PUT; }}
    protected Boolean isDELETECallout{ get { return httpMethod() == HTTP_DELETE; }}

    /**
     * Whether the callout should return the raw response, without serializing it. This returns the entire HTTPResponse object.
     */
    protected Boolean rawResponse = false;

    protected Map<String, String> baseHeaders = new Map<String, String> {
            'Accept' => 'application/json',
            'Content-Type' => 'application/json'
    };

    public JsonCallouts() {}

    private void setBaseHeaders(HttpRequest request) {
        for (String headerKey :baseHeaders.keySet()) {
            request.setHeader(headerKey, baseHeaders.get(headerKey));
        }
    }
    private void setEndpointHeaders(HttpRequest request) {
        for (String headerKey :endpointHeaders().keySet()) {
            request.setHeader(headerKey, endpointHeaders().get(headerKey));
        }
    }

    protected Object execute(Object dataToSend) {
        Object result = null;
            // Prepare the request part
            request = new HttpRequest();
            request.setEndpoint(endpoint());
            request.setMethod(httpMethod());
            // Prepare headers with authentication
            setBaseHeaders(request);
            setEndpointHeaders(request);

            // Set the body of the message to be sent (only when something must be sent)
            if ((isPOSTCallout || isDELETECallout || isPUTCallout) && dataToSend != null) {
                request.setBody(JSON.serialize(dataToSend,suppressPayloadNulls()));
                request.setBody(preProcessRequest(request.getBody()));
            }

            // Make the callout
            response = new Http().send(request);
            if (allowedStatusCodes().contains( response.getStatusCode() ) ) {
                String responseBody = postProcessResponse(response.getBody());
                if(rawResponse || responseBody == null || responseBody == '' || responseBody == '{}'){
                        return response;
                    }else{
                            Type outputType = outputType();
                            if(outputType == null){
                                result = JSON.deserializeUntyped(responseBody);
                            }
                            else {
                                result = JSON.deserialize(responseBody, outputType());
                            }
                    }
            }else {
                    throw new JsonCalloutsException('Error at callout with Status Code #' + response.getStatusCode(), request, response);
                }
        return result;
    }

    /**
    * A set of allowed status codes for this specific endpoint. Default is 200, change it to other numbers for other callout types. E.g. 201 when creating.
    * @return The set of allowed status codes.
    */
    protected virtual Set<Integer> allowedStatusCodes(){
        return new Set<Integer>{ 200 };
    }

    /**
    * A function that is called right before sending the callout so the body string can still be modified.
    * @return The processed request string.
    */
    protected virtual String preProcessRequest(String response){
        //Overwrite to replace some of the response string.
        return response;
    }

    /**
     * A function that is called with the response to modify the raw response.  E.g. if the response contains keys starting with _
     * @return The processed response string.
     */
    protected virtual String postProcessResponse(String response){
        //Overwrite to replace some of the response string.
        return response;
    }

    /**
     * A map of header that should be added to the request.
     * @return A map of string -> string with header key values.
     */
    protected abstract Map<String,String> endpointHeaders();

    /**
     * The HTTP Method / Verb for the callout. Use JsonCallouts.HTTP_ constants.
     * @return The endpoint string.
     */
    protected abstract String httpMethod();

    /**
     * The endpoint for the callout.
     * @return The endpoint string.
     */
    protected abstract String endpoint();

    /**
    * The endpoint for the callout.
    * @return The endpoint string.
    */
    protected virtual Boolean suppressPayloadNulls(){
        return false;
    }

    /**
     * The type of output the response should be serialized to. If null, the response will be serialized untyped.
     * @return The serialization type that should be used for the response.
     */
    protected abstract System.Type outputType();

    public virtual class JsonCalloutsException extends Exception {

        public HttpRequest request;
        public HttpResponse response;

        public JsonCalloutsException(String message, HttpRequest request, HttpResponse response){
            this.request = request;
            this.response = response;

            this.setMessage(message +' - ' + response.getBody());
        }

        public Map<String,Object> getJsonResponseUntyped{
            get {
                return (Map<String,Object>) JSON.deserializeUntyped(response.getBody());
            }
        }
    }
}