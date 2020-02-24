<#
.Synopsis
   Get all logon scripts
.DESCRIPTION
   Long description
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
.INPUTS
   Inputs to this cmdlet (if any)
.OUTPUTS
   Output from this cmdlet (if any)
.NOTES
   General notes
.COMPONENT
   The component this cmdlet belongs to
.ROLE
   The role this cmdlet belongs to
.FUNCTIONALITY
   The functionality that best describes this cmdlet
#>
Function Get-AdLogonScripts{
    [CmdletBinding()] #Enable all the default paramters, including -Verbose
    [Alias()]
    Param(
    [string]$SearchBase = (Get-ADDomain).DistinguishedName
    )

    Begin{
        Write-Verbose -Message "Starting $($MyInvocation.InvocationName) with $($PsCmdlet.ParameterSetName) parameterset..."
        Write-Verbose -Message "Parameters are $($PSBoundParameters | Select-Object -Property *)"
    }
    Process{
            try{ 
                Write-Verbose -Message "Contacting AD"
                if($SearchBase){
                #(Get-ADUser -filter * -Properties scriptpath -SearchBase $SearchBase).scriptpath | Select-Object -Unique
                (Get-ADUser -filter * -Properties scriptpath -SearchBase $SearchBase) | sort -Unique -Property scriptpath | select -Property scriptpath,samaccountname

                }
                else{
                (Get-ADUser -filter * -Properties scriptpath) | sort -Unique -Property scriptpath | select -Property *
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
