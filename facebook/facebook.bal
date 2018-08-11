import ballerina/io;
import biruntha13/facebook;
import ballerina/config;

function main(string... args) {
    string userAccessToken = config:getAsString("ACCESS_TOKEN");
    string pageAccessToken = callMethodsWithUserToken(userAccessToken);
    callMethodsWithPageToken(pageAccessToken);
}

function callMethodsWithUserToken(string userAccessToken) returns string {
    endpoint facebook:Client client {
        clientConfig:{
            auth:{
                accessToken:userAccessToken
            }
        }
    };
    io:println("-----------------Calling to get page accessTokens details------------------");
    //Get page tokens
    var tokenResponse = client->getPageAccessTokens("me");
    //facebook:AccessTokens accessTokenList = {};
    string pageToken;

    match tokenResponse {
        facebook:AccessTokens list => {
            pageToken = list.data[0].pageAccessToken;
            io:println("Page token details: ");
            io:println(list.data);
            io:println("Page Name: ");
            io:println(list.data[0].pageName);
            io:println("Page token: ");
            io:println(pageToken);
        }
        facebook:FacebookError e => io:println(e.message);
    }

    io:println("-----------------Calling to get friends list details------------------");
    //Get Friends list details
    var friendsResponse = client->getFriendListDetails("me");
    match friendsResponse {
        facebook:FriendList list => {
            io:println("Friends list: ");
            io:println(list.data);
            io:println("Friends list count: ");
            io:println(list.summary.totalCount);
        }
        facebook:FacebookError e => io:println(e.message);
    }
    return pageToken;
}

function callMethodsWithPageToken(string pageAccessToken) {
    endpoint facebook:Client client {
        clientConfig:{
            auth:{
                accessToken:pageAccessToken
            }
        }
    };
    io:println("-----------------Calling to create fb post------------------");
    var createPostResponse = client->createPost("me","testBalMeassage","","");
    string postId;
    match createPostResponse {
        facebook:Post post => {
            postId = post.id;
            io:println("Post Id: ");
            io:println(postId);
        }
        facebook:FacebookError e => io:println(e.message);
    }

    io:println("-----------------Calling to retrieve fb post------------------");
    var retrievePostResponse = client->retrievePost(postId);
    match retrievePostResponse {
        facebook:Post post => {
            io:println("Post Details: ");
            io:println(post);
        }
        facebook:FacebookError e => io:println(e.message);
    }

    io:println("-----------------Calling to delete fb post------------------");
    var deleteResponse = client->deletePost(postId);
    match deleteResponse {
        boolean isDeleted => io:println(isDeleted);
        facebook:FacebookError e => io:println(e.message);
    }
}
