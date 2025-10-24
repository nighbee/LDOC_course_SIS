#!/bin/bash
echo "App Smoke Test:"

curl -f http://localhost:3000 > /dev/null && echo "Frontend: PASS" || echo "Frontend: FAIL"

curl -f http://localhost:8080/health > /dev/null && echo "Backend: PASS" || echo "Backend: FAIL"

cd /home/almaz/ESG/frontend || { echo "Frontend directory not found"; exit 1; }
npm run build --silent && echo "Frontend Build: PASS" || echo "Frontend Build: FAIL"


cd /home/almaz/ESG/backend || { echo "Backend directory not found"; exit 1; }
go build ./... && echo "Backend Build: PASS" || echo "Backend Build: FAIL"

echo "App test complete"
