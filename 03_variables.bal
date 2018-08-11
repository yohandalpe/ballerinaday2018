import ballerina/io;

function main(string... args) {
    // set variables
    string name = "Ballerina";
    var age = 3;
    // print variables
    io:println("My name is " + name + " and I am " + age + " years old.");
}