<#
.SYNOPSIS
    Update SMS/MMS routing for a DID
.DESCRIPTION
    Required permissions: User or above
.EXAMPLE
    Set-NSSMS -number "3051112222" 
    https://api.ucaasnetwork.com/ns-api/apidoc/#api-SMS_Number-Update
#>
function Set-NSSMS {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)][string]$number,    
        [Parameter(Mandatory = $false)][string]$domain,
        [Parameter(Mandatory = $false)][string]$application,
        [Parameter(Mandatory = $false)][string]$destination,
        [Parameter(Mandatory = $false)][string]$carrier
    )
    $number = Convert-NSDID $number -e164
    $existingsms = Get-NSSMS $number
    if (([string]::IsNullOrEmpty($existingsms))) {
        $res = "Error retrieving data or no data returned"
        return $res
    }
    if (([string]::IsNullOrEmpty($domain))) {
        $domain = $existingsms.domain
    }
    if (([string]::IsNullOrEmpty($application))) {
        $application = $existingsms.application
    }
    if (([string]::IsNullOrEmpty($destination))) {
        $destination = $existingsms.dest
    }
    if (([string]::IsNullOrEmpty($carrier))) {
        $carrier = $existingsms.carrier
    }
    $payload = @{
        object = 'smsnumber'
        action = 'update'
        domain = $domain
        number = $number
        application = $application
        dest = $destination
        carrier = $carrier
    }
    try{
        Invoke-NSRequest $payload
        $res = "$number has been updated"
        return $res
    } catch {
        $res = "Error retrieving data or no data returned"
        return $res
    }
}