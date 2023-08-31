import ballerina/io;
import ballerina/sql;
import ballerinax/mysql;
import ballerinax/mysql.driver as _;

// todo:test

// Defines the record to bind the data.
type Employee record {
    int id;
    string name;
    int salary;
};

// Load data from a CSV file
public function loadCSVFile() returns error? {
    string csvFilePath = "myfile.csv";

    // Loads the CSV file as a `Employee[]`.
    Employee[] readCsv = check io:fileReadCsv(csvFilePath);
    io:println(readCsv);

    // Reads the CSV file as a record stream.
    stream<Employee, io:Error?> csvStream = check
                                        io:fileReadCsvAsStream(csvFilePath);
    // Iterates through the stream and prints the records.
    check csvStream.forEach(function(Employee val) {
        io:println(val);
    });
}

public function loadDatabase() returns error? {
    mysql:Client db = check new ("localhost", "root", "Test@123", "OFFICE", 3306);
    // Execute simple query to retrieve all records from the `albums` table.
    stream<Employee, sql:Error?> employeeStream = db->query(`SELECT * FROM employees`);

    // Iterates through the stream and prints the records.
    check employeeStream.forEach(function(Employee val) {
        io:println(val);
    });
}

public function main() returns error? {
    check loadCSVFile();
    check loadDatabase();
}
