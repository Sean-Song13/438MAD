1) Added a button to get the user's current location to autofill sales tax. First, I searched on Google "how to get location information in IOS development" and followed the instructions in "https://www.advancedswift.com/user-location-in-swift/" which helped me a lot. And then, I downloaded a table of sales tax in every state, converted it into a .json file. Finally, I wrote a DataManager Class to deal with the data.

2) Created an alert label for illegal input to indicate whether the input string is acceptable. 
When the text fields are empty, I consider their default value as 0. When they are zero or negative, I use the input directly. But if they are not numbers, I will throw out an alert "Input can only be numbers.". And I will clear the illegal input when the text field changed.
"
3) Localized the app for Chinese and Japanese.

4) Added a placeholder for each text field, which indicates the default value.



