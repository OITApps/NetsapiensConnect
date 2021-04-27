<#
.SYNOPSIS
    Convert DID to 10 or 11 digit format  
.EXAMPLE
    Convert-NSDID -did "(305)111-1234"
    Convert-NSDID -did "305-111-1234" -e164
#>
function  Convert-NSDID {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true, ValueFromPipeline, Position = 0)][string]$did,
        [Parameter(Mandatory = $false)][switch]$e164
    )
    # Remove special characters from DID
    $did = ($did.Trim()) -replace '[\s()-]', ''

    if($e164){
        if($did.length -eq 10){
            $did = "1" + $did
            return $did
        } else {
            return $did
        }         
    }
    # Remove any preceeding 1 from DID
    if (($did.Length -eq 11) -and ($did[0] -eq "1")) { $did = $did.Substring(1) }

    # Check if DID is now 10 digits
    if ($did.Length -ne 10) {
        Write-Host "Your entered DID $did is not 10 characters. Please try again."
        return
    }
    return $did
}