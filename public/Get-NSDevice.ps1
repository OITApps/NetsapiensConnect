<#
.SYNOPSIS
    Get billable information for an NS domain.
.DESCRIPTION
    Required permissions: Reseller or above
.EXAMPLE
    Get-NSDevice -domain "domain.12345.service" 
    Get-NSDevice -domain "domain.12345.service" -user "1000@domain.12345.service"
.LINK
    http://api.ucaasnetwork.com/ns-api/apidoc/#api-Device-Read
#>
function Get-NSDevice {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)][string]$domain,
        [Parameter(Mandatory = $false)][string]$device,
        [Parameter(Mandatory = $false)][string]$user,
        [Parameter(Mandatory = $false)][string]$owner,
        [Parameter(Mandatory = $false)][string]$start,
        [Parameter(Mandatory = $false)][string]$mode,
        [Parameter(Mandatory = $false)][string]$limit,
        [Parameter(Mandatory = $false)][string]$sort,
        [Parameter(Mandatory = $false)][string]$list,
        [Parameter(Mandatory = $false)][string]$fields,
        [Parameter(Mandatory = $false)][string]$filters,
        [Parameter(Mandatory = $false)][string]$noNDP
    )
    $payload = @{
        object = 'device'
        action = 'read'
        domain = $domain
        format = 'json'
    }
    if (-not ([string]::IsNullOrEmpty($device))) {
        $payload.add("device", $device)
    }

    if (-not ([string]::IsNullOrEmpty($user))) {
        $payload.add("user", $user)
    }

    if (-not ([string]::IsNullOrEmpty($owner))) {
        $payload.add("owner", $owner)
    }

    if (-not ([string]::IsNullOrEmpty($mode))) {
        $payload.add("mode", $mode)
    }
    if (-not ([string]::IsNullOrEmpty($limit))) {
        $payload.add("limit", $limit)
    }

    if (-not ([string]::IsNullOrEmpty($short))) {
        $payload.add("short", $short)
    }
    if (-not ([string]::IsNullOrEmpty($fields))) {
        $payload.add("fields", $fields)
    }
    if (-not ([string]::IsNullOrEmpty($filters))) {
        $payload.add("filters", $filters)
    }
    if (-not ([string]::IsNullOrEmpty($noNDP))) {
        $payload.add("noNDP", $noNDP)
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