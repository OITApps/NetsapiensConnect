<#
.SYNOPSIS
    Get information for a phone number (DID).
.DESCRIPTION
    Required permissions: Reseller or above
.EXAMPLE
    Get-NSDID -number "3051111234"
    Get-NSDID -number "13051111234"
    Get-NSDID -domain "demodomain.12345.service"
.LINK
    http://api.ucaasnetwork.com/ns-api/apidoc/#api-Domain-Read
#>
function  Get-NSDID {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $false, ValueFromPipeline, Position = 0)]
        [string]$number,

        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName, Position = 1)]
        [string]$domain,

        [Parameter(Mandatory = $false)]
        [switch]$count
    )

    Process {
        if ($count) {
            $action = "count"
        }
        else {
            $action = "read"
        }
        $payload = @{
            object   = 'phonenumber'
            action   = $action
            dialplan = 'DID Table'
        }
        if ($number) {
            $matchrule = Convert-NSDID $number -e164
            $matchrule = "sip:" + $matchrule + "@*"
            $payload.Add('matchrule', $matchrule)
        }    
        if ($domain) { $payload.Add('dest_domain', $domain) }
        try {
            $res = Invoke-NSRequest $payload
            if ($res.count -gt 0) {
                return $res.total
            }
            else {
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