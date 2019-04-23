<#
Your challenge is to create a PowerShell function that takes the output from Get-Counter and transforms it into a more user friendly object. Each counter sample should be a separate object with these properties:
Timestamp
Computername
CounterSet
Counter
Value
#>

<#
.SYNOPSIS
    Formats output from Get-Counter
.DESCRIPTION
    Formats output from Get-Counter cmdlet to improve readability
.EXAMPLE
    Get-Counter | Format-SaSCounter
#>
function Format-SaSCounter {
    [CmdletBinding(PositionalBinding=$true)]
    Param (
        # Param1 help description
        [Parameter(Mandatory=$true,
                   Position=0,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        $CounterSet

    )
    process {
        $result = @()
        foreach ( $counter in $CounterSet) {
            foreach ( $c in $counter.countersamples ) {
                $cArray = @()
                $cArray = $c.path.split('\')
                $result += [PSCustomObject]@{
                    Timestamp = $c.Timestamp
                    Computername = $cArray[2]
                    CounterSet = $cArray[3]
                    Counter = $cArray[4]
                    Value = $c.CookedValue
                }
            }
        }
    }
    
    end {
        return $result
    }
}
