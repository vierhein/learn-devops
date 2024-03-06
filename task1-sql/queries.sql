-- Вывод полного имени сотрудников и названия их отдела
SELECT CONCAT(FirstName, ' ', LastName) AS FullName, DepartmentName
FROM Employees
LEFT JOIN Departments ON Employees.DepartmentID = Departments.DepartmentID;

-- Список отделов, в которых работают хотя бы два сотрудника
SELECT DepartmentName
FROM Employees
LEFT JOIN Departments ON Employees.DepartmentID = Departments.DepartmentID
GROUP BY DepartmentName
HAVING COUNT(*) >= 2;

-- Список всех отделов с именами сотрудников (если они есть) в этих отделах
SELECT DepartmentName, CONCAT(FirstName, ' ', LastName) AS FullName
FROM Departments
LEFT JOIN Employees ON Departments.DepartmentID = Employees.DepartmentID;

-- Список всех сотрудников вместе с именами и названиями отделов, даже если они не принадлежат ни к одному отделу
SELECT CONCAT(FirstName, ' ', LastName) AS FullName, DepartmentName
FROM Employees
LEFT JOIN Departments ON Employees.DepartmentID = Departments.DepartmentID
UNION
SELECT CONCAT(FirstName, ' ', LastName) AS FullName, NULL AS DepartmentName
FROM Employees
WHERE DepartmentID IS NULL;

-- Список всех сотрудников и их отделов, включая тех, кто не принадлежит ни к одному отделу, и отделы, в которых нет сотрудников
SELECT CONCAT(FirstName, ' ', LastName) AS FullName, DepartmentName
FROM Employees
RIGHT JOIN Departments ON Employees.DepartmentID = Departments.DepartmentID;

-- Список всех отделов с именами сотрудников (если они есть) в этих отделах, включая тех, кто не принадлежит ни к одному отделу
SELECT DepartmentName, CONCAT(FirstName, ' ', LastName) AS FullName
FROM Departments
LEFT JOIN Employees ON Departments.DepartmentID = Employees.DepartmentID
UNION
SELECT NULL AS DepartmentName, CONCAT(FirstName, ' ', LastName) AS FullName
FROM Employees
WHERE DepartmentID IS NULL;
