-- How many albums does the artist Led Zeppelin
SELECT Count(al.AlbumId)
FROM albums al
JOIN artists ar ON al.ArtistId = ar.ArtistId 
WHERE ar.Name Like "Led Zeppelin";

-- Create a list of album titles and the unit prices for the artist "Audioslave".
SELECT ab.Title, ts.UnitPrice
FROM albums as ab
JOIN tracks as ts ON ab.AlbumId = ts.AlbumId
WHERE ab.ArtistId IN (
    SELECT ArtistId
    FROM artists
    WHERE Name = "Audioslave"
);

-- total price for the album “Big Ones”
SELECT COUNT(UnitPrice) * UnitPrice as total_price
FROM tracks
WHERE AlbumID IN (
SELECT AlbumId
FROM albums
WHERE Title = "Big Ones");

-- Retrieve the track name, album, artistID, and trackID for all the albums, What is the song title of trackID 12
SELECT tr.TrackId, ab.AlbumId, tr.name, ab.title
FROM Albums ab
JOIN Tracks tr ON ab.AlbumId = tr.AlbumId
WHERE tr.TrackId = 12;


-- Using a subquery, find the names of all the tracks for the album "Californication"
SELECT NAME
FROM Tracks
WHERE AlbumID IN (
    SELECT AlbumID
    FROM Albums
    WHERE Title = "Californication"
);

-- Retrieve a list with the managers last name, and the last name of the employees who report to him or her.who are the reports for the manager named Mitchell
SELECT e.LastName as Employee, m.LastName as Manager
FROM Employees e
JOIN Employees m ON e.ReportsTo = m.EmployeeId
WHERE m.LastName = "Mitchell";

-- Find the name and ID of the artists who do not have albums. 
SELECT ar.ArtistId, ar.Name
FROM Artists ar
LEFT JOIN Albums ab ON ar.ArtistId = ab.ArtistId
WHERE ab.ArtistId IS NULL;

-- See if there are any customers who have a different city listed in their billing city versus their customer city.
Select c.City AS CustomerCity, iv.BillingCity as BillingCity
FROM Customers c
JOIN Invoices iv ON c.CustomerId = iv.CustomerId
WHERE c.City != iv.BillingCity;


-- Create a new employee user id by combining the first 4 letters of the employee’s first name with the first 2 letters of the employee’s last name. Make the new field lower case and pull each individual step to show your work.
SELECT LOWER(SUBSTR(FirstName,1,4) || SUBSTR(LastName,1,2)) AS UserId
FROM Employees;

-- Show a list of employees who have worked for the company for 15 or more years using the current date function. Sort by lastname ascending.
SELECT LastName,
    HireDate,
    (STRFTIME('%Y', 'now') - STRFTIME('%Y', HireDate)) AS Duration
FROM Employees
WHERE Duration >= 15
Order by LastName Asc;