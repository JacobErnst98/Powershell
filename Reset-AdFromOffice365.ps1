Connect-MsolService
$people = "<SamaccountName>"
$domain = "<DomainName.com>"
foreach($person in $people){
$tmpPass = Set-MsolUserPassword -UserPrincipalName $($person + $domain)
Set-ADAccountPassword -Identity $person -Reset -NewPassword (ConvertTo-SecureString -AsPlainText $tmpPass -Force)
Add-ADGroupMember -Identity "E2" -Members $person
Write-Host $person "---Password---" $tmpPass
}
