<#
.SYNOPSIS
    Returns a list or count of the active calls per your search criteria.
.DESCRIPTION
    Required permissions: User or above. You will only see calls visible to that scope's permissions. 
.EXAMPLE
    Get-NSCalls  
    Get-NSCalls -domain "domain"
    Get-NSCalls -domain "domain" -start "50"
    Get-NSCalls -domain "domain" -sort "time_start ASC"
    Get-NSCalls -domain "domain" -count
.LINK
    https://api.ucaasnetwork.com/ns-api/apidoc/#api-Call-Count
    https://api.ucaasnetwork.com/ns-api/apidoc/#api-Call-Read
#>
function Get-NSCalls{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $false, ValueFromPipeline, Position = 0)][string]$domain,
        [Parameter(Mandatory = $false)][string]$start="0",
        [Parameter(Mandatory = $false)][string]$limit,
        [Parameter(Mandatory = $false)][string]$sort,
        [Parameter(Mandatory = $false)][string]$groupby,
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName)][string]$territory,
        [Parameter(Mandatory = $false)][switch]$count
    )

    
    process {
        $payload = @{
            object = 'call'
        }
        if($domain){$payload.Add('domain',$domain)}
        if($territory){$payload.Add('territory',$territory)}
    
        # Determine if pulling count or all calls
        if($count){
            $payload.Add('action','count')
            if($groupby){$payload.Add('groupby',$groupby)}
        } else {
            $payload.Add('action','read')
            $payload.Add('start',$start)
            if($limit){$payload.Add('limit',$limit)}
            if($sort){$payload.Add('sort',$sort)}
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