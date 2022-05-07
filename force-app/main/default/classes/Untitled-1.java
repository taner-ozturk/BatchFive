

public class RestRequest{

    public Map<String, String> params;
    public String path;
    public String domain;
}

public class RestContext {

    public RestRequest request;
    public RestResponse response;
}

RestRequest req = RestContext.request;


req-params;