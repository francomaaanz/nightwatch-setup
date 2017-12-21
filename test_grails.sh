#!/bin/bash
source /commands/node_env.sh
source /commands/load_grails.sh /app/application.properties

TEST_APP_HOST=127.0.0.1
#TEST_APP_HOST=192.168.99.100

function runGrailsTests() {
  cd /app
  grails compile
  grails test-app -coverage -xml

  if [[ "$CI_CONTEXT" == "push" ]]; then
    #Coveralls
    grails coveralls --token=FejVEP5I7v8HazJamxb4e5CvFaEB9Wh9w --report=target/test-reports/cobertura/coverage.xml --servicePullRequest=$GIT_PR_ID --gitSync --branch=$GIT_BRANCH --commitSha=$GIT_COMMIT

    #Sonar
    curl -v -X POST -F "app=fury_$APPLICATION" -F "branchname=$GIT_BRANCH" -F "buildnumber=$GIT_COMMIT" -F "pullrequestid=$GIT_PR_ID" http://scanner.sonar.ml.com/runner/start
  fi
}

function insertHosts() {
  echo "$TEST_APP_HOST desa.mercadolibre.com" >> /etc/hosts
  echo "$TEST_APP_HOST desa.mercadolibre.com" >> /etc/hosts
  echo "$TEST_APP_HOST desa.mercadolibre.com.ar" >> /etc/hosts
  echo "$TEST_APP_HOST desa.mercadolivre.com.br" >> /etc/hosts
  echo "$TEST_APP_HOST desa.mercadolibre.com.mx" >> /etc/hosts
  echo "$TEST_APP_HOST desa.mercadolibre.com.ve" >> /etc/hosts
  echo "$TEST_APP_HOST desa.mercadolibre.com.uy" >> /etc/hosts
  echo "$TEST_APP_HOST desa.mercadolibre.com.ec" >> /etc/hosts
  echo "$TEST_APP_HOST desa.mercadolibre.com.pe" >> /etc/hosts
  echo "$TEST_APP_HOST desa.mercadolivre.pt" >> /etc/hosts
  echo "$TEST_APP_HOST desa.mercadolibre.cl" >> /etc/hosts
  echo "$TEST_APP_HOST desa.mercadolibre.com.co" >> /etc/hosts
  echo "$TEST_APP_HOST desa.mercadolibre.com.pa" >> /etc/hosts
  echo "$TEST_APP_HOST desa.mercadolibre.com.do" >> /etc/hosts
  echo "$TEST_APP_HOST desa.mercadolibre.co.cr" >> /etc/hosts
}

function runUnitTest() {
    #run unit test with mocha and chai
    cd /app/ui-app
    npm run mocha
}

function installTestDependencies() {
    # We need to upgrade google-chrome due to chromedriver version
    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
    sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
    apt-get update
    apt-get --assume-yes upgrade google-chrome-stable
    echo "Starting Xvfb"
    Xvfb :0 -screen 0 1024x768x8 &> /dev/null &
}


function initAppAndWaitForPing() {
  cd /app
  grails compile
  grails run-app &
  COUNT=0
  echo "Waiting for app up"
  while [[ $COUNT -lt 1200 ]]; do
    OUT=$(curl -m 1 --write-out %{http_code} --silent --output /dev/null 127.0.0.1:8080/ping)
    if [[ "$OUT" == "200" ]]; then
      echo "App started"
      return
    fi
    sleep 1;
    COUNT=$(( $COUNT + 1 ))
  done
  echo "Wait for /ping timeout"
  exit 100
}

function executeTest() {
  echo "------- Test Execution -------"
  cd /app/ui-app
  sleep 5;
  echo "Display value is"
  echo $DISPLAY
  npm run nightwatch -- --env xvfb_desktop
}

runGrailsTests
insertHosts
runUnitTest
installTestDependencies
initAppAndWaitForPing
export DISPLAY=:0;
executeTest
