
# Wagon Challenges

This is the repository for my challenge submissions for Wagon
Analytics :D

Challenge 1 is contained in the packages in the Wagon folder.
Challenge 2 is contained in Server.hs in the main directory.
I haven't set aside the time to learn how to use Cabal or
Stack yet, so instead I decided to use Make. Running the
challenges is detailed in the following secions. I may add
cabal and stack files to this project in the future, but for
the time being make will suffice.


# Preliminaries

I assume you have Cabal installed and have at least GHC
7.10.3. It may work on previous versions of GHC, but I
have not tested it on any previous versions.

This project depends on Parsec, Yesod, and Yesod Static.
The included Makefile includes a rule for installing the
dependencies using cabal (I lied; I did partly use Cabal).
In order to install the dependencies through make, issue
the following command:

make deps

Cleaning the project after compilation can be done by
using the following command:

make clean

This will delete all files with the ending *.hi, *.o,
*.dyn_o, *.dyn_hi, and the produced executables.


# Challenge 1

My implementation of challenge 1 makes use of Parsec to
to parse any input csv data provided by the generator
executable in ./docs

Wagon.Data contains all of the data types used by this
part of the application. Contained in this package are
records for recording statistics to do with different
CSV fields, Data types for representing CSV fields, and
types for CSV Header fields.

Wagon.CSV contains the Parsec parser that interprets the
incoming data and returns WagonCSVVal types.

Wagon.Util contains some other depdency functions, some
of which may be provided by the Haskell standard that I
am not yet aware of.

Main.hs contains the main code for reading data from
stdin, converting it to CSV data, and then gathering
the statistics. My approach to this problem was to not
keep any persistent data beside the individual records
that record CSV Statistics. Rather, I loop over stdin
until an end-of-file is reached, and update all of the
fields of the CSVStats individually.

This way, the time complexity of this algorithm is
technically linear, and there shouldn't be any significant
data usage. Using top, I did notice that the CPU incurred
around 80% usage for my algorithm, with minimal memory
usage, however I am not sure how accurate top is for
real-time statistics such as this, so the accuracy of
those statements may vary.

Parsec may have been overkill, but I saw an opportunity
to try to learn more about Parsec and Parser Combinators
in general.

In order to build the challenge, use:

make build

In order to run, use

make run

or

./challenge

This executable will hang on stdin until and eof is reached.
You can pipe data from the generator executable into the
challenge file as follows:

docs/generator 1000 | ./challenge

The following make command can be used to run the challenge
with a default value of 1000:

make test.1 


# Challenge 2

For this challenge, I decided that the easiest way to
serve data was through a web server. At first, I tried
to use React to display the data, but importing all of
the CSV data en-masse caused my browser to crash, so I
jack-knifed off of that plan and decided to use Yesod!
An enormous jump, but templating it was easier than
using React. The react classes I created for that are
still located inside the public folder (along with
React and JQuery).

I used Whamlet to template the data, and also decided
to page the CSV data in order to avoid destroying
people's computers. My algorithm works by simply
scanning through the given CSV file and dropping all
of the previous data prior to the final 10 elements for
the current page. Theoretically, this wouldn't be very
feasible for large files, and I assume there must be
some superior way to do it, but the method I used
was intuitive and I believe readable, so it works.

You can run challenge 2 by using the command:

make serve

This will compile the server and run it on the default
port 3000. Navigate to it by simply going to
localhost:3000/ in your favorite web browser. 


# Final Notes

These couple challenges have been a huge learning
experience, and made me learn a lot of things. It's
been fun :D 


