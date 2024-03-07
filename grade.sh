# No set -e : we want to check for errors with this program
rm -rf student-submission
rm -rf grading-area

mkdir grading-area

# if something goes wrong with git clone, only the students need to see this
git clone $1 student-submission > ta-output.txt
echo 'Finished cloning'


# Draw a picture/take notes on the directory structure that's set up after
# getting to this point

# Then, add here code to compile and run, and do any post-processing of the
# tests

# check for missing file
if [[ -f student-submission/$2.java ]]
then
    cp student-submission/$2.java grading-area
    cp Test$2.java grading-area
else
    echo "Missing $2 file"
    exit 1
fi

# set up testing in grading area
cd grading-area

CPATH='.:../lib/hamcrest-core-1.3.jar:../lib/junit-4.13.2.jar'
javac -cp $CPATH *.java > compile-message.txt

if [[ $? -ne 0 ]]
then
    echo "Compile error"
    cat test-results.txt
    exit 1
fi

java -cp $CPATH org.junit.runner.JUnitCore Test$2 > test-results.txt

# calculate score based on failures

lastline = $(cat test-results.txt | tail -n 2 | head -n 1)
tests = $(echo $lastline | awk -F'[, ]' '{print $3}')
failures = $(echo $lastline | awk -F'[, ]' '{print $6}')
successes = $(tests-failures)

echo "Your score is $successes / $tests"

