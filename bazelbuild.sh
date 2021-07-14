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

THEPATH=$PWD
BUNDLE=$THEPATH/codeqlbinaries/$THEOS
THECONFIGFILE=$THEPATH/.github/codeql/codeql-config.yml

if test -d "$BUNDLE"; then
  echo "Executing with:"
  echo "... the path to where we executed this from: $THEPATH"
  echo "... codeql cli binary: $BUNDLE/codeql"
  echo "... config file: $THECONFIGFILE"

  echo "Brute force removing prior bazel output..."
  rm -rf $THEPATH/bazel-*

  export SEMMLE_JAVA_INTERCEPT_VERBOSITY=6
  export SEMMLE_JAVA_INTERCEPT_LOG_FILE=true
  
  codeql-runner-$THEOS init \
    --github-url 'https://github.com' \
    --repository 'affrae/quickhelloworld' \
    --languages 'java' \
    --codeql-path $BUNDLE/codeql \
    --config-file $THECONFIGFILE \
    --debug
  
  . $THEPATH/codeql-runner/codeql-env.sh

  bazel shutdown 

  bazel clean --expunge

  if [[ "$THEOS" == "macos" ]]
  then
  # Execution from macOS
    echo "\$CODEQL_RUNNER = $CODEQL_RUNNER" 
    $CODEQL_RUNNER bazel build --spawn_strategy=local --nouse_action_cache //:app
  else
    bazel build --spawn_strategy=local --nouse_action_cache //:app
  fi

  codeql-runner-$THEOS analyze --github-url 'https://github.com' --repository 'affrae/quickhelloworld' --commit $GIT_HASH --no-upload --ref $GIT_BRANCH

  APP=$THEPATH/bazel-bin/app

  if test -f "$APP"; then
    echo "Executing $APP"
    $APP
  else 
    echo "$APP does not exist"
    exit 3
  fi
else 
  echo "$BUNDLE does not exist"
  exit 4
fi