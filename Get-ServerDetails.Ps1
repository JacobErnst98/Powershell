
<#
.Synopsis
   Lists Os Information, IP's, and Roles of (a) given Server(s)
.DESCRIPTION
   Provides Os Version, Build Number, and OS Architecture; A & AAAA Records from DNS; All Roles
.EXAMPLE
   Get-ServerDetails -FilePath "C:\Output.txt" -Servers $servers
.EXAMPLE
   Get-ServerDetails -Servers $(Get-AdServers)
.EXAMPLE
   Get-ServerDetails -Servers $(Get-ADComputer -Filter { OperatingSystem -Like '*Windows Server*'} -SearchBase $((Get-ADDomain).DistinguishedName))
.ROLE
   JakesSysadminFunctions
.FUNCTIONALITY
   Get Server Details
#>
Function Get-AdServers{
    [CmdletBinding()] #Enable all the default paramters, including -Verbose
    [Alias()]
    Param(
    [string[]]$FilePath,
    $Servers
    )
    
    $results = foreach ($server in $servers) {
        $details = Get-WmiObject Win32_OperatingSystem -ComputerName $server.dnshostname | Select PSComputerName, Caption, OSArchitecture, Version, BuildNumber
        $ip = Resolve-DnsName $server.dnshostname -Server 10.100.0.222
        $roles =Get-WindowsFeature -ComputerName $server.dnshostname
        if ($?){
    
        }else {
           $roles = Invoke-Command -ComputerName $server.dnshostname -ScriptBlock {ServerManagerCmd.exe -query} 
           $roles = $roles[4..($roles.Length-1)]
        }
         [PSCustomObject]@{
            DnsName = $server.DNSHostName
            Details = $details
            IPs = $ip
            Roles = $roles
          }
    }

    $formated = $results | ForEach-Object {
        "----------------------------------------------------------------------------------------------------------------------------"
        $_.DnsName
        $_.details | ft
        $_.Ips | ft
        $_.Roles 
        "----------------------------------------------------------------------------------------------------------------------------"
    }
}
