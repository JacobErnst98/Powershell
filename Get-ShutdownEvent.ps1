<#
.Synopsis
   Lists Shutdown Information of (a) given Server(s)
.DESCRIPTION
   Provides Detaild Shutdown Information From Windows Event Logs
.EXAMPLE
   Get-ShutdownEvent -Servers $servers
.EXAMPLE
   Get-ShutdownEvent -Servers $(Get-AdServers) -Graphical
.EXAMPLE
   Get-ShutdownEvent -Servers $(Get-ADComputer -Filter { OperatingSystem -Like '*Windows Server*'} -SearchBase $((Get-ADDomain).DistinguishedName))
.ROLE
   JakesSysadminFunctions
.FUNCTIONALITY
   Get Shutdown Details
#>
Function Get-ShutdownEvent{
    [CmdletBinding()] #Enable all the default parameters, including -Verbose
    [Alias()]
    Param(
    [switch]$Graphical, #Displays results in Out-Gridview
    [String]$NumberOfShutdowns = 1,
    $Servers
    ) 

    $results = foreach($server in $Servers.DnsHostName) {
        if (Test-Connection -ComputerName $server -Count $NumberOfShutdowns -ErrorAction SilentlyContinue ) { 
            Write-verbose "Getting Eventlogs on $server" 
            try { Get-WinEvent -computername $server -FilterXml "<QueryList><Query Id=`"0`" Path=`"System`"><Select Path=`"System`">*[System[(EventID=1074)]]</Select></Query></QueryList>" -MaxEvents $NumberOfShutdowns  -ErrorAction Stop |select @{N='Server';E={"$server"}},TimeCreated,Message
            } 
            catch { 
                    if ($_.Exception -match "No events were found that match the specified selection criteria") { 
                        Write-Error "No events found of selected event Search criteria on Server $server" 
                    } 
            } 
        } 
        Else { 
            Write-Error "Is $server Offline?"
        } 
    }
    if($Graphical){
        $results | Out-GridView -Title "Shutdown Events"
    }else{
        return $results
    }
}
