#!/bin/bash
#Get yesterday's date as $d
d=$(date -d "today 13:00" '+%Y-%m-%d')
t=$(date +"%T")
h=$(date +"%H")
echo "Today is $d $t"
echo "Passing todays raw URL feed through the first strainer to file "$d"cedka1.txt"
cat suspicious_domains_"$d".log | sort -u | grep -E i'wells|fargo|confirm|garena|duckdns|elon|failed|suspen|musk|crypto|facebook|instagram|basvuru|give|airdrop|bitcoin|edevlet|bofa|bank|bankasi|buzz|belifus|betaal|apple|pubg|ebay|authentication|auth|banka|hsbc|sbank|mobile|media|support|billing|payment|pay|signin|raboban|wellsfargo|uniswap|raiffeisen|pekao|fibank|claim|ether|google|vitalik|bnpparibas|aktifba|chaseban|icloud|docusign|santander|mabanque|barclays|halifax|cancel|mijn|particulare|govuk|taxrefund|request|reclaim|blockchaln|blockchain|suisse|nordea|sainsbury|polkadot|winklewoss|giveaway|decline|payee|sberbank|caixa|ersteban|union|credit|unicredit|bulban|amazon|account|verify|update|gouv|bankofameri|commerzbank|banca|banque|secure|rosbank|tsbnank|banco|virgin|lloyds|authoriz|authoris|paypal|paypay|experian|xyz|cloud|ziraat'>"$d"cedka1.txt
echo "sleeping for 1 seconds"
sleep 1
echo "Star remover "$d"cedka1.txt to file "$d"cedka2.txt"
sed -e '/*/d' $d"cedka1.txt">"$d"cedka2.txt
sleep 1
echo "Passing the now star free URLs "$d"cedka2.txt feed through the second FP strainer to file Useme_"$d$h"_final.txt"
cat "$d"cedka2.txt| grep -vwE '^.*\b(\*.|cpanel.|mail.|autodiscover.|cpcontacts.|whm.|ftp.|cpcalendars.|barclays.co.uk|paypalinc.com|webdisk.|webmail.|imap.|.amazon.com|.amazon.dev|.amazonaws.com|.amazonaws.com.cn|.appdirect.com|.appdomain.cloud|.apple.com|.aristos.pw|.avant.com|.aws-cbc.cloud|.axwaycloud.com|.azure.com|.bankofamerica.com|.barclays.com|.belfius.be|.blackbrick.com|.bmw-fleet.net|.bnpparibas-am.com|.bnpparibas.com|.bnpparibas.es|.cas.ms|.chinacloudapi.cn|.chinacloudsites.cn|.citibank.com|.cldr.work|.composedb.com|.conlance.info|.d-p.io|.dev-arquivei.com.br|.ebay.at|.ebay.be|.ebay.ca|.ebay.ch|.ebay.co.uk|.ebay.com|.ebay.de|.ebay.es|.ebay.fr.ebay.ie.ebay.in|.ebay.it.ebay.nl|.ebay.ph|.ebay.pl|.elcompanies.net|.esmartapi.com|.evergreen.space|.filemaker-cloud.com|.frgcloud.com|.hashicorp.cloud|.hcp.dev|.hcp.to|.hmgroup.tech|.hpicloud.net|.hsbc.co.uk|.hsbc.com.hk|.hybris.com|.ibm.com|.icloud.com|.intuit.com|.itclover.ru|.k8s.|.kn-e2e.dev|.lloydsbank.co.uk|.lloydsbank.com|.lloydsbanking.com|.logicworks.net|.magentosite.cloud|.microsoft.com|.nationbuilder.com|.nip.io|.nokia.net|.nordea.com|.oath.cloud|.ooklaserver.net|.opendns.com|.paypal.com|.paypalcorp.com|.platform.sh|.platformsh.site|.podchaser.com|.remotewd.com|.rabobank.nl|.rosatom-intranet.ru|.s5y.io|.scmp.tech|.securechkout.com|.secureserver.net|.shopsys.cloud|.sterbcroyalbank.com|.swiftserve.com|.teradata.com|.thermofisher.com|.umich.edu|.unicreditgroup.eu|.vanguard.com|.verizon.com|.vmware.com|.volvo.care|.vpn.chinacloudapi.cn|.wdr.io|.webex.com|.wellsfargo.com|.wikium.tech|.yrmon.com)\b.*$' >Useme_"$d$h"_final.txt
echo "Renaming suspicious_domains_"$d".log to timestamped suspicious_domains_"$d$t".log"
mv suspicious_domains_"$d".log suspicious_domains_"$d$t".log
sleep 1
echo "Splitting..."
split -l 999 Useme_"$d$h"_final.txt Useme_"$d$h"_final
find . -cmin -5