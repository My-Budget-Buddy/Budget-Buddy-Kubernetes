TRIES_REMAINING=16

echo 'Waiting for frontend to be ready for testing'
while ! curl --output /dev/null --silent http://localhost:5173; do
    TRIES_REMAINING=$((TRIES_REMAINING - 1))
    if [ $TRIES_REMAINING -le 0 ]; then
        echo 'frontend did not start within expected time.'
        exit 1
    fi
    echo 'waiting for frontend...'
    sleep 5
done
echo '***frontend is ready***'