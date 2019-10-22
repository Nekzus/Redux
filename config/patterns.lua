config.patterns = {
	colorRGB = {
		base = "r%d+g%d+b%d+",
		capture = "r(%d+)g(%d+)b(%d+)",
	},
	mention = {
		base = "<@!?%d+>",
		capture = "<@!?(%d+)>",
	},
	role = {
		base = "<@&%d+>",
		capture = "<@&(%d+)>",
	},
	emoji = {
		base = "<a?:[%w_]+:%d+>",
		capture = "<a?:[%w_]+:(%d+)>",
	},
	channel = {
		base = "<#%d+>",
		capture = "<#(%d+)>",
	},
	time = {
		base = "%d+%a",
		capture = "(%d+)(%a)",
	},
	quotes = {
		base = "(%b\"\")",
	},
	numberType1 = {
		base = "[+-]?%d+%p?%d-",
		capture = "[+-]?(%d+%p?%d-)",
	},
	keyValue = {
		base = "%s*.-%s*=%s*.-%s*$",
		capture = "%s*(.-)%s*=%s*(.-)%s*$",
	},
}

--[[
str = " \t \r \n String with spaces  \t  \r  \n  "

print( string.format( "Leading whitespace removed: %s", str:match( "^%s*(.+)" ) ) )
print( string.format( "Trailing whitespace removed: %s", str:match( "(.-)%s*$" ) ) )
print( string.format( "Leading and trailing whitespace removed: %s", str:match( "^%s*(.-)%s*$" ) ) )

%a	letters (A-Z, a-z)
%c	control characters (\n, \t, \r, ...)
%d	digits (0-9)
%l	lower-case letter (a-z)
%p	punctuation characters (!, ?, &, ...)
%s	space characters
%u	upper-case letters
%w	alphanumeric characters (A-Z, a-z, 0-9)
%x	hexadecimal digits (\3, \4, ...)
%z	the character with representation 0
.	Matches any character

[]
()
%
.
+
-
*
?
^
$

+	One or more repetitions
*	Zero or more repetitions
-	Also zero or more repetitions
?	Optional (zero or one occurrence)

%n	for n between 1 and 9 matches a substring equal to the n-th captured string
%bxy	matches substring between two distinct characters (balanced pair of x and y)
%f[set]	frontier pattern: matches an empty string at any position such that the next character
belongs to set and the previous character does not belong to set
]]
