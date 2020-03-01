# cypress-run.sh

# Just in case compiling takes a while on a fresh start
MIX_ENV=systemtest mix compile
echo "===STARTING PHX SERVER==="
echo "===IF STARTING CYPRESS FAILS==="
echo "===RUN npm install cypress --save-dev ==="
echo "===IN THE assets/ FOLDER==="
MIX_ENV=systemtest mix phx.server &
pid=$! # Store server pid
./assets/node_modules/.bin/cypress run
result=$?
kill -9 $pid # kill server
echo "===KILLING PHX SERVER==="
exit $result
