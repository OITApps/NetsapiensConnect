<#
.SYNOPSIS
    Get User Info
.DESCRIPTION
    Required permissions: Reseller scope or above
.EXAMPLE
    Get-NSUserInfo -domain "domain"
.LINK
    https://api.ucaasnetwork.com/ns-api/?object=subscriber&action=read
#>
function Get-NSUser () {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)][string]$domain,
        [Parameter(Mandatory = $true)][string]$user,
        [Parameter(Mandatory = $false)][string]$uid,
        [Parameter(Mandatory = $false)][string]$login,
        [Parameter(Mandatory = $false)][string]$limit,
        [Parameter(Mandatory = $false)][string]$first_name,
        [Parameter(Mandatory = $false)][string]$last_name,
        [Parameter(Mandatory = $false)][string]$group,
        [Parameter(Mandatory = $false)][string]$fields,
        [Parameter(Mandatory = $false)][string]$srv_code,
        [Parameter(Mandatory = $false)][string]$email,
        [Parameter(Mandatory = $false)][string]$dir,
        [Parameter(Mandatory = $false)][string]$filter_users,
        [Parameter(Mandatory = $false)][string]$directory_match,
        [Parameter(Mandatory = $false)][string]$owner,
        [Parameter(Mandatory = $false)][string]$scope,
        [Parameter(Mandatory = $false)][string]$start,
        [Parameter(Mandatory = $false)][string]$sort       
    )
    $payload = @{
        object = 'subscriber'
        action = 'read'
        domain = $domain
        user = $user
    }
    
    try {
        $res = Invoke-NSRequest $payload
        return $res
    } catch {
        $res = "Error retrieving data or no data returned"
        return $res
    }
}