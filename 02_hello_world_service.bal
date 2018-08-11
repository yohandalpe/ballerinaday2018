import ballerina/http;

service<http:Service> hello bind {port:9090} {
    say(endpoint caller, http:Request req) {
        http:Response res = new;
        res.setPayload("Hello World!\n");
        _ = caller->respond(res);
    }
}