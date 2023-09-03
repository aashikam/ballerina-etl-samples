import ballerina/io;

type Employee record {
    string name;
    string department;
    float salary;
};

type SalaryBracket record {
    string bracket;
    Employee[] employees;
};

public function main() {
    // Sample employee data
    Employee[] employees = [
        {name: "Alice", department: "HR", salary: 50000.0},
        {name: "Bob", department: "IT", salary: 60000.0},
        {name: "Charlie", department: "HR", salary: 55000.0},
        {name: "David", department: "IT", salary: 62000.0},
        {name: "Eve", department: "Finance", salary: 70000.0}
    ];

    // Define salary brackets
    SalaryBracket[] salaryBrackets = [
        {bracket: "Low", employees: []},
        {bracket: "Medium", employees: []},
        {bracket: "High", employees: []}
    ];

    // ETL Transformation using Ballerina query expressions
    foreach var bracket in salaryBrackets {
        bracket.employees = from var employee in employees
                            where (employee.salary >= 50000.0 && employee.salary < 55000.0 && bracket.bracket == "Low") ||
                                  (employee.salary >= 55000.0 && employee.salary < 62000.0 && bracket.bracket == "Medium") ||
                                  (employee.salary >= 62000.0 && bracket.bracket == "High")
                            select employee;
    }

    // Printing the result
    foreach var bracket in salaryBrackets {
        io:println("Bracket: " + bracket.bracket);
        io:println(bracket.employees);
    }
}
