#!/bin/bash

# Script to analyze deployment costs from broadcast data

echo "💰 Analyzing deployment costs from broadcast data..."

BROADCAST_FILE="broadcast/Counter.s.sol/1/run-latest.json"

if [ ! -f "$BROADCAST_FILE" ]; then
    echo "❌ No broadcast file found at $BROADCAST_FILE"
    exit 1
fi

# Extract gas information using jq (if available) or grep/awk
if command -v jq &> /dev/null; then
    echo "📊 Using jq for JSON parsing..."
    
    GAS_USED_HEX=$(jq -r '.receipts[0].gasUsed' "$BROADCAST_FILE")
    EFFECTIVE_GAS_PRICE_HEX=$(jq -r '.receipts[0].effectiveGasPrice' "$BROADCAST_FILE")
    CONTRACT_ADDRESS=$(jq -r '.transactions[0].contractAddress' "$BROADCAST_FILE")
    TX_HASH=$(jq -r '.transactions[0].hash' "$BROADCAST_FILE")
    
else
    echo "📊 Using grep/awk for JSON parsing..."
    
    GAS_USED_HEX=$(grep '"gasUsed"' "$BROADCAST_FILE" | head -1 | awk -F'"' '{print $4}')
    EFFECTIVE_GAS_PRICE_HEX=$(grep '"effectiveGasPrice"' "$BROADCAST_FILE" | head -1 | awk -F'"' '{print $4}')
    CONTRACT_ADDRESS=$(grep '"contractAddress"' "$BROADCAST_FILE" | head -1 | awk -F'"' '{print $4}')
    TX_HASH=$(grep '"hash"' "$BROADCAST_FILE" | head -1 | awk -F'"' '{print $4}')
fi

# Convert hex to decimal
GAS_USED=$(printf "%d" "$GAS_USED_HEX")
EFFECTIVE_GAS_PRICE=$(printf "%d" "$EFFECTIVE_GAS_PRICE_HEX")

# Calculate total cost in wei
TOTAL_COST_WEI=$((GAS_USED * EFFECTIVE_GAS_PRICE))

# Convert to ETH (1 ETH = 10^18 wei)
TOTAL_COST_ETH=$(echo "scale=18; $TOTAL_COST_WEI / 1000000000000000000" | bc -l 2>/dev/null || python3 -c "print($TOTAL_COST_WEI / 1e18)")

echo ""
echo "📋 Deployment Cost Analysis:"
echo "   Contract Address: $CONTRACT_ADDRESS"
echo "   Transaction Hash: $TX_HASH"
echo "   Gas Used: $(printf "%'d" $GAS_USED) gas"
echo "   Gas Price: $(printf "%'d" $EFFECTIVE_GAS_PRICE) wei ($(echo "scale=2; $EFFECTIVE_GAS_PRICE / 1000000000" | bc -l 2>/dev/null || python3 -c "print(round($EFFECTIVE_GAS_PRICE / 1e9, 2))") gwei)"
echo "   Total Cost: $TOTAL_COST_WEI wei"
echo "   Total Cost: $TOTAL_COST_ETH ETH"
echo ""

# Convert gas price to gwei for better readability
GAS_PRICE_GWEI=$(echo "scale=2; $EFFECTIVE_GAS_PRICE / 1000000000" | bc -l 2>/dev/null || python3 -c "print(round($EFFECTIVE_GAS_PRICE / 1e9, 2))")

echo "💡 Summary:"
echo "   Your Counter contract deployment cost $TOTAL_COST_ETH ETH"
echo "   At a gas price of $GAS_PRICE_GWEI gwei"