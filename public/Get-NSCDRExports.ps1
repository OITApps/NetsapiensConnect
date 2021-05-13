<#
.SYNOPSIS
    Returns a list of the available scheduled CDR Exports per your search criteria.
.DESCRIPTION
    Required permissions: Reseller or above. You will only see exports visible to that scope's permissions. 
.EXAMPLE
    Get-NSCDRExports
    Get-NSCDRExports "scheduleName"
    Get-NSCDRExports -scheduleName "scheduleName"
    Get-NSCDRExports -scheduleName "scheduleName" -domain "domain"
    Get-NSCDRExports -scheduleName "scheduleName" -territory "territory"
    Get-NSCDRExports -scheduleName "scheduleName" -domain "domain" -territory "territory"
.LINK
    https://manage.oitvoip.com/ns-api/webroot/apidoc/#api-CDR_Export-Read
#>
function Get-NSCDRExports{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true, ValueFromPipeline, Position = 0)][string]$scheduleName,
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName)][string]$domain,
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName)][string]$territory
    )

    
    process {
        $payload = @{
            object = 'cdrexport'
            action = 'read'
            schedule_name = $scheduleName
        }
        if($domain){$payload.Add('domain',$domain)}
        if($territory){$payload.Add('reseller',$territory)}
        Try{
            $res = Invoke-NSRequest $payload
            return $res
        } Catch {
            $res = "Error retrieving data or no data returned"
            return $res
        }
    }

}