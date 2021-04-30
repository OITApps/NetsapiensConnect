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
function  Get-NSDomain {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true, ValueFromPipeline, Position = 0)][string]$domain,
        [Parameter(Mandatory = $false)][switch]$count
    )
    Process{
        if($count){
            $action = "count"
        } else {
            $action = "read"
        }
        $payload = @{
            object = 'domain'
            action = $action
            domain = $domain
        }
        try{
            $res = Invoke-NSRequest $payload
            return $res
        } catch {
            $res = "Error retrieving data or no data returned"
            return $res
        }
    }

}