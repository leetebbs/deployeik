#!/bin/bash

# Load environment variables
source .env

# Contract address from your deployment
COUNTER_ADDRESS="0x7b9720bbf9dc220fdbd4ba633a7ae040304b59cb"

# Check if TENDERLY_ACCESS_KEY is set
if [ -z "$TENDERLY_ACCESS_KEY" ] || [ "$TENDERLY_ACCESS_KEY" = "YOUR_TENDERLY_ACCESS_KEY_HERE" ]; then
    echo "❌ Please set your TENDERLY_ACCESS_KEY in the .env file"
    echo "You can get your access key from: https://dashboard.tenderly.co/account/authorization"
    exit 1
fi

echo "🔍 Verifying existing Counter contract..."
echo "📍 Contract Address: $COUNTER_ADDRESS"
echo "🔐 Using verifier: $TENDERLY_VERIFIER_URL"

# Verify the existing contract
forge verify-contract $COUNTER_ADDRESS \
    Counter \
    --etherscan-api-key "$TENDERLY_ACCESS_KEY" \
    --verifier-url "$TENDERLY_VERIFIER_URL" \
    --watch

if [ $? -eq 0 ]; then
    echo "✅ Contract verification completed successfully!"
    echo "📄 Check your verified contract on Tenderly Dashboard"
else
    echo "❌ Contract verification failed!"
    exit 1
fi