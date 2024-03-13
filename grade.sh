# No set -e : we want to check for errors with this program
rm -rf student-submission
rm -rf grading-area

mkdir grading-area

# if something goes wrong with git clone, only the tas need to see this
# $1 = file the student submits
git clone $1 student-submission
echo 'Finished cloning'


# Draw a picture/take notes on the directory structure that's set up after
# getting to this point

# Then, add here code to compile and run, and do any post-processing of the
# tests

# check for missing file
# $2 = file to grade and check for
# if [[ -f student-submission/$2.java ]]
# then
#     cp student-submission/$2.java grading-area
#     cp Test$2.java grading-area
# else
#     echo "Missing ListExamples file"
#     exit 1
# fi
# cd student-submission/
if [[ $(find './student-submission/' -name 'ListExamples.java') ]]
then
   cp -r student-submission/ grading-area
   cp TestListExamples.java grading-area
else
   echo "Missing ListExamples file. Make sure you submit files with the matching name."
   exit 1
fi


# set up testing in grading area
cd grading-area

CPATH='.:../lib/hamcrest-core-1.3.jar:../lib/junit-4.13.2.jar'
javac -cp $CPATH *.java > compile-message.txt 2>&1

if [[ $? -ne 0 ]]
then
    echo "Compile error:"
    cat compile-message.txt
    echo "Your code failed to compile. This could be due to syntax errors, or when your implementation does not match the instructions."
    exit 1
fi

java -cp $CPATH org.junit.runner.JUnitCore TestListExamples > test-results.txt

# calculate score based on failures

lastline=$(cat test-results.txt | tail -n 2|head -n 1)
# cat test-results.txt | tail -n 2 | head -n 1 > tests-passed.txt
echo $lastline


allpassed=$(echo $lastline | grep 'OK')

# if there are no failues, the number of tests needs to be extracted another way
# if [[ ! $tests =~ '^-?[0-9]+$' ]] || [[ ! $failures =~ '^-?[0-9]+$' ]]
if [[ -n $allpassed ]]
then
   # tests=
   echo "Congratulations, you passed all $(echo $lastline | grep -Eo '[0-9]+') tests!"
   exit 0
fi

tests=$(echo $lastline | awk -F'[, ]' '{print $3}')
# echo $(cat tests-passed.txt | head -n 1 | awk -F'[, ]' '{print $3}')

failures=$(echo $lastline | awk -F'[, ]' '{print $6}')
# echo $(cat tests-passed.txt | head -n 1 | awk -F'[ ]' '{print $6}')

successes=$(($tests-$failures))

echo "Your score is $successes/$tests."




