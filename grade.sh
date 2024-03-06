CPATH='.:../lib/hamcrest-core-1.3.jar:../lib/junit-4.13.2.jar'

rm -rf student-submission
rm -rf grading-area

mkdir grading-area

git clone $1 student-submission 2> git-output.txt
# echo 'Finished cloning'


# Draw a picture/take notes on the directory structure that's set up after
if [[ -f student-submission/ListExamples.java ]]
then 
    cp student-submission/ListExamples.java grading-area
    cp TestListExamples.java grading-area
else 
    echo "There should be one file titled ListExamples.java in your repository, nothing else."
    exit 1
fi
# getting to this point

# Then, add here code to compile and run, and do any post-processing of the
# tests
cd grading-area

javac -cp $CPATH *.java 
if [[ $? -ne 0 ]]
then    
    echo "Compilation error: see above."
    exit 1
fi

java -cp $CPATH org.junit.runner.JUnitCore TestListExamples > junit-output.txt 

if [[ $(head -n 2 junit-output.txt | tail -n 1 | grep "E") != "" ]]
then
    lastline=$(cat junit-output.txt | tail -n 2 | head -n 1)
    tests=$(echo $lastline | awk -F '[, ]' '{print $3}')
    failures=$(echo $lastline | awk -F '[, ]' '{print $6}')
    successes=$((tests-failures))
    echo "Failed tests: "
    grep ".) test" junit-output.txt
    echo "Number of tests passed: $successes / $tests"
else
    lastline=$(cat junit-output.txt | tail -n 2 | head -n 1)
    numtests=$(echo $lastline | grep -o '[0-9]*' | head -1)
    echo "All tests passed"
    echo "Number of tests passed: $numtests / $numtests"
fi
