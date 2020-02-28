#!/bin/sh

echo "begin clean"
cd business
echo "cleaning business"
flutter clean
cd ../client
echo "cleaning business"
flutter clean
echo "clean finished"