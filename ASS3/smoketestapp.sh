#!/bin/bash
echo "App Smoke Test:"
curl -f http://localhost:3000 && echo "Frontend: PASS" || echo "Frontend: FAIL"
curl -f http://localhost:8080/health && echo "Backend: PASS" || echo "Backend: FAIL"  # Adjust endpoint

npm run build --silent && echo "Frontend Build: PASS" || echo "Frontend Build: FAIL"  # In /app/esgapp/frontend
go build ./... && echo "Backend Build: PASS" || echo "Backend Build: FAIL"  # In /app/esgapp/backend
echo "App test complete"
