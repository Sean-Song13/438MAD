1) I add a placeholder for each text field, which provides explicit instruction for users to understand what information they need to fill in. To add the placeholder, I fill the placeholder property in the text field inspector.

2) I create an alert label for illegal input to indicate whether the input string is acceptable. 
When the text fields are empty, I consider their default value as 0. When they are zero or negative, I use the input directly. But if they are not numbers, I will throw out an alert "Input can only be numbers.". And I will clear the illegal input when the text field changed.

3) I localize my app for Chinese and Japanese.
