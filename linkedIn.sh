#!/bin/bash

# Path to the .pcapng file
PCAP_FILE="/home/kali/wireshark/linkedIn.pcapng"
REPORT_FILE="linkedIn_report.txt"

# Check if tshark is installed
if ! command -v tshark &> /dev/null; then
    echo "Error: tshark is not installed. Install it with 'sudo apt-get install tshark'"
    exit 1
fi

# Create the report file
echo "Report for $PCAP_FILE" > "$REPORT_FILE"
echo "Generated on $(date)" >> "$REPORT_FILE"
echo "---------------------------------------" >> "$REPORT_FILE"

# 1. Total number of packets
echo -e "\nTotal number of packets:" >> "$REPORT_FILE"
tshark -r "$PCAP_FILE" | wc -l >> "$REPORT_FILE"

# 2. Top 5 Protocols
echo -e "\nTop 5 Protocols:" >> "$REPORT_FILE"
tshark -r "$PCAP_FILE" -T fields -e _ws.col.Protocol | sort | uniq -c | sort -nr | head -5 >> "$REPORT_FILE"

# 3. Top 5 Source IP Addresses
echo -e "\nTop 5 Source IP Addresses:" >> "$REPORT_FILE"
tshark -r "$PCAP_FILE" -T fields -e ip.src | sort | uniq -c | sort -nr | head -5 >> "$REPORT_FILE"

# 4. Top 5 Destination IP Addresses
echo -e "\nTop 5 Destination IP Addresses:" >> "$REPORT_FILE"
tshark -r "$PCAP_FILE" -T fields -e ip.dst | sort | uniq -c | sort -nr | head -5 >> "$REPORT_FILE"

# 7. Average packet size
echo -e "\nAverage Packet Size:" >> "$REPORT_FILE"
tshark -r "$PCAP_FILE" -T fields -e frame.len | awk '{sum+=$1; count++} END {if (count > 0) print sum/count; else print 0}' >> "$REPORT_FILE"

# 8. Packets Containing TCP protocol (Fixed the command typo)
echo -e "\nTotal TCP Protocols:" >> "$REPORT_FILE"
tshark -r "$PCAP_FILE" -T fields -e _ws.col.Protocol | grep -c "TCP" >> "$REPORT_FILE"   # Fixed 'gerp' to 'grep'

# 9. HTTP Requests URLs (if any) (Fixed the command syntax)
echo -e "\nTotal number of bytes transferred:" >> "$REPORT_FILE"
tshark -r "$PCAP_FILE" -T fields -e frame.len | awk '{sum += $1} END {print sum}' >> "$REPORT_FILE"  # Fixed the 'tshark' syntax error

# Display the generated report
echo "Report generated: $REPORT_FILE"
cat "$REPORT_FILE"

