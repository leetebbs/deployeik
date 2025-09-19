#!/bin/bash

# Load environment variables
source .env

# Check if TENDERLY_ACCESS_KEY is set
if [ -z "$TENDERLY_ACCESS_KEY" ] || [ "$TENDERLY_ACCESS_KEY" = "YOUR_TENDERLY_ACCESS_KEY_HERE" ]; then
    echo "❌ Please set your TENDERLY_ACCESS_KEY in the .env file"
    echo "You can get your access key from: https://dashboard.tenderly.co/account/authorization"
    exit 1
fi

echo "🚀 Deploying Counter contract to Tenderly Virtual TestNet..."
echo "📡 RPC URL: $RPC_URL"
echo "🔐 Using verifier: $TENDERLY_VERIFIER_URL"

# Deploy with verification using the recommended Tenderly flags
DEPLOY_OUTPUT=$(forge script script/Counter.s.sol:CounterScript \
    --slow \
    --verify \
    --verifier-url "$TENDERLY_VERIFIER_URL" \
    --rpc-url "$RPC_URL" \
    --private-key "$PRIVATE_KEY" \
    --etherscan-api-key "$TENDERLY_ACCESS_KEY" \
    --broadcast \
    -vvvv 2>&1)

DEPLOY_EXIT_CODE=$?

echo "$DEPLOY_OUTPUT"

if [ $DEPLOY_EXIT_CODE -eq 0 ]; then
    echo ""
    echo "✅ Deployment completed successfully!"
    
    # Extract cost information from the output
    echo "💰 Cost Summary:"
    echo "$DEPLOY_OUTPUT" | grep -E "(Deployment cost|Total Paid|Paid:)" | while read -r line; do
        echo "   $line"
    done
    
    # Extract contract address
    CONTRACT_ADDRESS=$(echo "$DEPLOY_OUTPUT" | grep "Counter deployed at:" | awk '{print $4}')
    if [ ! -z "$CONTRACT_ADDRESS" ]; then
        echo "📍 Contract Address: $CONTRACT_ADDRESS"
    fi
    
    echo "📄 Check your contract on Tenderly Dashboard"
else
    echo "❌ Deployment failed!"
    exit 1
fi