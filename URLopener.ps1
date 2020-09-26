$IE = new-object -ComObject "InternetExplorer.Application"
$urls= gc "urls.txt"
$count=1
foreach ($url in $urls){
    if ($count -eq 1){
        $IE.navigate($url,1)
    }
    else{
        $IE.navigate($url,2048)
    }
	Start-Sleep 4
    $count++
}