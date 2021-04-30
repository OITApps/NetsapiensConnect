<#
.SYNOPSIS
    Get domain information.
.DESCRIPTION
    Required permissions: Office Manager or above
.EXAMPLE
    Get-NSDomain -domain "domain"
.LINK
    http://api.ucaasnetwork.com/ns-api/apidoc/#api-Domain-Read
#>
function  Get-NSReseller {
    [CmdletBinding(DefaultParameterSetName = 'reseller')]
    Param(
        [Parameter(Mandatory = $true, ValueFromPipeline, ParameterSetName = 'reseller', Position = 0)]
        [string]$reseller,

        [Parameter(Mandatory = $true, ValueFromPipeline, ParameterSetName = 'resellerID', Position = 0)]
        [string]$resellerID,

        [Parameter(Mandatory = $false)]
        [switch]$count,

        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName)]
        [string]$start,

        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName)]
        [string]$limit,

        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName)]
        [string]$sort
    )
    Process {
        if ($count) { $action = "count" } else { $action = "read" }
        if (-not ([string]::IsNullOrEmpty($resellerID))) {
            $reseller = $resellerID + ".service"
        }
        $payload = @{
            object    = 'reseller'
            action    = $action
            territory = $reseller
        }
        if (-not ([string]::IsNullOrEmpty($start))) {
            $payload.add("start", $start)
        }
        if (-not ([string]::IsNullOrEmpty($limit))) {
            $payload.add("limit", $limit)
        }
        if (-not ([string]::IsNullOrEmpty($sort))) {
            $payload.add("sort", $sort)
        }
        try {
            $res = Invoke-NSRequest $payload
            if (($action = 'read') -and ($res.count -ne 0)) {
                return $res
            } else {
                $res = "Error retrieving data or no data returned"
                return $res
            }
        }
        catch {
            $res = "Error retrieving data or no data returned"
            return $res
        }
    }

}