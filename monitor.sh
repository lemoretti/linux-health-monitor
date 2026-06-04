
#!/bin/bash
echo "--- Linux Health Report ---"
echo "CPU Usage: $(top -bn1 | grep 'Cpu(s)' | awk '{print $2}')%"
echo "Memory Usage: $(free -m | awk 'NR==2{printf "Memory Usage: %s/%sMB (%.2f%%)\n", $3,$2,$3*100/$2 }')"
echo "Disk Usage: $(df -h / | awk 'NR==2 {print $5}')"
