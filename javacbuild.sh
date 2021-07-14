#! /bin/zsh

case "$(uname -s)" in
    *Linux*)
        THEOS=linux
        ;;
    *Darwin*)
        THEOS=macos
        ;;
    *MINGW* | MSYS*)
        echo "Windows currently not supported."
        exit 1
        ;;
    *)
        echo "Unknown operating system '$(uname -s)' (full uname: $(uname -a)."
        exit 2

esac

GIT_BRANCH="refs/heads/$(git branch --show-current)"
GIT_HASH=$(git rev-parse HEAD)

# helloworld.java
codeql-runner-$THEOS init \
    --github-url 'https://github.com' \
    --repository 'affrae/quickhelloworld' \
    --languages 'java' \
    --config-file '.github/codeql/codeql-config.yml'

. codeql-runner/codeql-env.sh

rm src/main/java/hello/HelloWorld.class

if [[ "$THEOS" == "macos" ]]
then
# Execution from macOS
    echo "\$CODEQL_RUNNER = $CODEQL_RUNNER" 
    $CODEQL_RUNNER javac src/main/java/hello/HelloWorld.java
else
    javac src/main/java/hello/HelloWorld.java
fi

codeql-runner-$THEOS analyze \
    --github-url 'https://github.com' \
    --repository 'affrae/quickhelloworld' \
    --commit $GIT_HASH \
    --no-upload \
    --ref $GIT_BRANCH