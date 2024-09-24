# Ensure argument count
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <api-endpoint>"
    exit 1
fi

API_ENDPOINT=$1

touch .env && rm .env
echo "VITE_BASE_API_ENDPOINT=$API_ENDPOINT" > .env
npm install && npm run build