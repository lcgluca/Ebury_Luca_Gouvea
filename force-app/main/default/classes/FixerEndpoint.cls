/*
* @author         Luca Gouvea
* @modifiedBy     Luca Gouvea 
* @maintainedBy   Luca Gouvea
* @version        1.0
* @created        2022-06-25
* @modified       2022-06-25
* Purpose:        Constructs the header and holds the authentications for Fixer callouts
*/

public abstract class FixerEndpoint extends JsonCallouts{

    protected final String API_KEY = 'Mj9iw5shwdaIjQP7szwAuWsGGqRYdguH';
    protected final String API_BASE_URL = [SELECT Endpoint FROM NamedCredential WHERE DeveloperName = 'Fixer'].Endpoint;

    public virtual override Map<String,String> endpointHeaders(){
        if(API_KEY == null){
            throw new FixerEndpointException('No key authentication found.');
        }
        if(API_BASE_URL == null){
            throw new FixerEndpointException('No address for endpoint found.');
        }
        return new Map<String,String>{
                'apikey' => API_KEY,
                'Content-Type' => 'application/json; charset=UTF-8'
        };
    }

    public abstract override String endpoint();

    public FixerEndpoint() {
        super();
    }

    public class FixerEndpointException extends Exception{}
}