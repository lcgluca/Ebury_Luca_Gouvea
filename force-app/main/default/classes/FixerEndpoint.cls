public abstract class FixerEndpoint extends JsonCallouts{

    protected final String API_KEY = 'Fq5xaz7wkBSKJrfxpav1TgIkofZjkBVH';
    protected final String API_BASE_URL = [SELECT Endpoint FROM NamedCredential WHERE DeveloperName = 'Fixer'].Endpoint;

    public virtual override Map<String,String> endpointHeaders(){
        if(API_KEY == null){
            throw new OneflowAuthException('No key authentication found.');
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

    public class OneflowAuthException extends Exception{}
}