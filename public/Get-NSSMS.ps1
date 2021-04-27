<#
.SYNOPSIS
    Get SMS/MMS routing for a DID
.DESCRIPTION
    Required permissions: User or above
.EXAMPLE
    Get-NSSMS -domain "domain"
    Get-NSSMS -number "3051112222"
    https://api.ucaasnetwork.com/ns-api/?object=smsnumber&action=read
#>
function Get-NSSMS {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $false)][string]$number,    
        [Parameter(Mandatory = $false)][string]$domain,
        [Parameter(Mandatory = $false)][string]$application,
        [Parameter(Mandatory = $false)][string]$destination
    )
    $payload = @{
        object = 'smsnumber'
        action = 'read'
    }
    if (-not ([string]::IsNullOrEmpty($domain))) {
        $payload.add("domain", $domain)
    }
    if (-not ([string]::IsNullOrEmpty($number))) {
        $number = Convert-NSDID $number -e164
        $payload.add("number", $number)
    }
    if (-not ([string]::IsNullOrEmpty($application))) {
        $payload.add("application", $application)
    }
    if (-not ([string]::IsNullOrEmpty($destination))) {
        $payload.add("destination", $destination)
    }
    try{
        $res = Invoke-NSRequest $payload
        return $res
    } catch {
        $res = "Error retrieving data or no data returned"
        return $res
    }
}