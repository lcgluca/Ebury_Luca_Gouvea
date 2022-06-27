/*
* @author         Luca Gouvea
* @modifiedBy     Luca Gouvea 
* @maintainedBy   Luca Gouvea
* @version        1.0
* @created        2022-06-25
* @modified       2022-06-25
* Purpose:        Helper class for JsonCalloutTest
*/

public class JsonCalloutTestEndpoint extends JsonCallouts {
    private final static String CALLOUT_ENDPOINT = '/somepath/totest';
    private final static String CALLOUT_METHOD = 'POST';

    private final static String NAMED_CREDENTIAL = 'NAMED_CRED_TEST';

    public JsonCalloutTestEndpoint() {
        super();
    }

    public OutputStructure execute(InputStructure data) {
        return (OutputStructure)super.execute(data);
    }
    public override Map<String,String> endpointHeaders(){
        return new Map<String,String>();
    }
    public override String endpoint() {
        return CALLOUT_ENDPOINT;
    }
    protected override String httpMethod() {
        return CALLOUT_METHOD;
    }
    protected override Type outputType() {
        return OutputStructure.class;
    }


    /**
     * Structures
     */
    public class InputStructure {
        public String dataToCopyToOutput;
        public Integer statusCodeToReturn;

        public InputStructure(String iAttr, Integer sCode) {
            this.dataToCopyToOutput = iAttr;
            this.statusCodeToReturn = sCode;
        }

    }
    public class OutputStructure {
        public String outputAttribute;
    }
}