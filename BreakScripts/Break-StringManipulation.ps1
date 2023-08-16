break;

$string1 = "This is a string"

$string1.Length
$string1.Split(" ")
$string1.Substring(0,6) # Gets the first 6 characters
$string1.Substring(6) #gets everything after the 6th character
$string1.Substring(5,2) # get two characters following 5th character.
$string1.IndexOf(" ") # gets the index of the first space or whatever is between the inverted columns
$space1 = $string1.IndexOf(" ") + 1
$string1.Substring($space1)  # Gets everything after the first space
$string1.GetEnumerator() #puts all of the characters on their own line it has more utility outside of strings.
$string1.IndexOfAny(" ")
$string1.LastIndexOf(" ") # gets the index of the last space
$string1.ToUpper() # displays the string in uppercase
$string1.ToLower() # Displays the string as lowercase
$string1.Normalize() # Displays the string with a first capital and then lower case.

$string2 = " this is the second string   "
$string2.Trim() # Takes out the spaces from the start and end of the string in output.
$string2.TrimEnd() # Removes the spaces from the end
$string2.TrimStart() # Removes the spaces from the start in output.
