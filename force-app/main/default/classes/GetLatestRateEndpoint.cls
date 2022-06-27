/*
* @author         Luca Gouvea
* @modifiedBy     Luca Gouvea 
* @maintainedBy   Luca Gouvea
* @version        1.0
* @created        2022-06-25
* @modified       2022-06-25
* Purpose:        Constructs the endpoint and treats both request and response of Fixer callouts
*/

public inherited sharing class GetLatestRateEndpoint extends FixerEndpoint{
    private String base;
    private List<String> symbols;

    public GetLatestRateEndpoint(String base, List<String> symbols){
        this.base = base;
        this.symbols = symbols;
    }

    public GetLatestRateResponse execute() {
        Map<String, Object> response = (Map<String, Object>)super.execute(null);
        GetLatestRateResponse latestResponse = new GetLatestRateResponse(response);
        return latestResponse;
    }

    public override String endpoint() {
        String url = '/latest?symbols=';

        for(String symbol : symbols){
            url = url + symbol + ',';
        }
        
        url = url.removeEnd(',');
        url = url + '&base=' + base;

        return API_BASE_URL + url;
    }

    protected override String httpMethod() {
        return HTTP_GET;
    }

    protected override Type outputType() {
        return null;
    }

    public class GetLatestRateResponse{
        public Boolean success;
        public Integer timestamp;
        public String base;
        public Date responseDate;
        public List<Rate> rates;
        public Error error; 

        public GetLatestRateResponse(Map<String, Object> responseMap) {
            Map<String, Object> ratesMap = (Map<String, Object>)responseMap.get('rates');
            List<Rate> rateList = new List<Rate>();

            if((Boolean)responseMap.get('success')){
                this.success = (Boolean)responseMap.get('success');
                this.timestamp = (Integer)responseMap.get('timestamp');
                this.base = (String)responseMap.get('base');
                this.responseDate = Date.valueOf((String)responseMap.get('date'));
                this.error = null;

                for (String currencyCode : ratesMap.keySet()) { 
                    rateList.add(new Rate(currencyCode, (Double)ratesMap.get(currencyCode)));
                    this.rates = rateList;
                }
            }else{
                this.success = (Boolean)responseMap.get('success');
                this.error = new Error((Map<String, Object>)responseMap.get('error'));
            }        
        }
    }

    public class Rate { 
        public String currencyCode;
        public Double rate;

        public Rate(String currencyCode, Double rate) {
            this.currencyCode = currencyCode;
            this.rate = rate;
        }
    }

    public class Error {
        public Integer code;
        public String type;
        public String info;

        public Error(Map<String, Object> errorMap){
            this.code = (Integer)errorMap.get('code');
            this.type = (String)errorMap.get('type');
            this.info = (String)errorMap.get('info');
        }
    }
}