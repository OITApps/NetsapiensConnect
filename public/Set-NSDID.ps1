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
function  Set-NSDID {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true, ValueFromPipeline, Position = 0)][string]$number,
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName)][string]$domain,
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName)][switch]$activate
    )

    process {
        $numberData = Get-NSDID $number
        if ($numberData) {
            $payload = @{
                object      = 'phonenumber'
                action      = 'update'
                dest_domain = $numberData.domain
                matchrule   = $numberData.matchrule
                dialplan    = $numberData.dialplan
            }
            if($activate){$payload.Add('enable', 'yes')}

            try {
                $res = Invoke-NSRequest $payload
                Write-Output "$number has been updated"
                Get-NSDID $number
                return
            }
            catch {
                $res = "Error retrieving data or no data returned"
                return $res
            }
        }
        else {
            return "Error retrieving data or no data returned"
        }
    }
}