Unicode was a brave effort to create a single character set that included every reasonable writing system on the planet and some make-believe ones like Klingon, too.

Some people are under the misconception that Unicode is simply a 16-bit code where each character takes 16 bits and therefore there are 65,536 possible characters. This is not, actually, correct. 

Every platonic letter in every alphabet is assigned a magic number by the Unicode consortium which is written like this: U+0639.  This magic number is called a code point. The U+ means “Unicode” and the numbers are hexadecimal. U+0639 is the Arabic letter Ain. The English letter A would be U+0041

There is no real limit on the number of letters that Unicode can define and in fact they have gone beyond 65,536 so not every unicode letter can really be squeezed into two bytes, but that was a myth anyway.


OK, so say we have a string:

``` Hello ```

which, in Unicode, corresponds to these five code points:

` U+0048 U+0065 U+006C U+006C U+006F.` 

==> Encoding