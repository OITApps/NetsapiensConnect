<#
.SYNOPSIS
    Get billable information for an NS domain.
.DESCRIPTION
    Required permissions: Office Manager or above
.EXAMPLE
    Get-NSDomainBilling -domain "domain"
.LINK
    http://api.ucaasnetwork.com/ns-api/apidoc/#api-Domain-ReadBilling
#>
function  Get-NSDomainBilling {
    [CmdletBinding()]

    Param(
        [Parameter(Mandatory = $true)][string]$domain
    )

    $payload = @{
        object  = 'domain'
        action  = 'read'
        billing = 'yes'
        domain  = $domain
    }

    try {
        $res = Invoke-NSRequest $payload
        return $res
    }
    catch {
        $res = "Error retrieving data or no data returned"
        return $res
    }
}