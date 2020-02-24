<#
.Synopsis
   Gets all windows servers from Active Directory
.DESCRIPTION
   Generates a List of AD computers whos operating system contains *Windows Server*
.EXAMPLE
   Get-AdServers
.EXAMPLE
   Get-AdServers -Properties *
.ROLE
   JakesSysadminFunctions
.FUNCTIONALITY
   Get all servers
#>
Function Get-AdServers{
    #Requires -Modules ActiveDirectory
    [CmdletBinding()] #Enable all the default paramters, including -Verbose
    [Alias()]
    Param(
    [string[]]$Properties,
    [string]$SearchBase = (Get-ADDomain).DistinguishedName
    )

    Begin{
        Write-Verbose -Message "Starting $($MyInvocation.InvocationName) with $($PsCmdlet.ParameterSetName) parameterset..."
        Write-Verbose -Message "Parameters are $($PSBoundParameters | Select-Object -Property *)"
    }
    Process{
            try{ 
                Write-Verbose -Message "Contacting AD"
                if($Properties){
                Get-ADComputer -Filter { OperatingSystem -Like '*Windows Server*'} -SearchBase $SearchBase -Properties $Properties -ErrorAction Stop
                }
                else{
                Get-ADComputer -Filter { OperatingSystem -Like '*Windows Server*'} -SearchBase $SearchBase -ErrorAction Stop
                }

               
            }
            catch{
                Write-Error -Message "$_ went wrong"
            }
        }
    
    End{
        Write-Verbose -Message "Ending $($MyInvocation.InvocationName)..."
    }
}
