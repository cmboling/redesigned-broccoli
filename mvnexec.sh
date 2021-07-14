#! /bin/zsh

echo "mvn clean"
mvn clean
echo "mvn package"
mvn package
echo "mvn exec:java -Dexec.mainClass=src.main.java.hello.HelloWorld"
mvn exec:java -Dexec.mainClass=src.main.java.hello.HelloWorld