#!/bin/sh

echo "begin clean"
cd business
echo "cleaning business"
flutter clean
cd ../client
echo "cleaning client"
flutter clean
echo "clean finished"