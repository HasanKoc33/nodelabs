#!/bin/bash

# Test coverage script for Nodelabs Movie Discovery App
echo "🧪 Running Flutter tests with coverage..."

# Clean previous coverage data
rm -rf coverage/

# Run unit and widget tests with coverage
echo "📱 Running unit and widget tests..."
flutter test --coverage

# Run integration tests (if available)
if [ -d "integration_test" ]; then
    echo "🔄 Running integration tests..."
    flutter test integration_test/
fi

# Generate coverage report
if [ -f "coverage/lcov.info" ]; then
    echo "📊 Processing coverage data..."
    
    # Remove generated files from coverage
    lcov --remove coverage/lcov.info \
        '*.g.dart' \
        '*.config.dart' \
        '*/firebase_options.dart' \
        '*/main.dart' \
        -o coverage/lcov.info
    
    # Check if lcov is installed (for generating HTML reports)
    if command -v genhtml &> /dev/null; then
        echo "📊 Generating HTML coverage report..."
        genhtml coverage/lcov.info -o coverage/html
        echo "✅ Coverage report generated at coverage/html/index.html"
        
        # Show coverage summary
        lcov --summary coverage/lcov.info
        
        # Open coverage report in browser (macOS)
        if [[ "$OSTYPE" == "darwin"* ]]; then
            open coverage/html/index.html
        fi
    else
        echo "⚠️  Install lcov to generate HTML coverage reports:"
        echo "   brew install lcov"
        echo "   On macOS: brew install lcov"
        echo "   On Ubuntu: sudo apt-get install lcov"
    fi
else
    echo "❌ No coverage data found. Make sure tests ran successfully."
fi

echo "✅ Test coverage complete!"
echo "📁 Coverage files location: coverage/"
echo "🌐 HTML report location: coverage/html/index.html"
