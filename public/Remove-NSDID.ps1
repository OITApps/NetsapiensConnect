<#
.SYNOPSIS
    Remove phone number (DID) from Netsapiens platform.
.DESCRIPTION
    Required permissions: Reseller or above
.EXAMPLE
    Remove-NSDID -number "3051111234"
    Remove-NSDID -number "13051111234"
    Remove-NSDID -domain "demodomain.12345.service"
.LINK
    https://api.ucaasnetwork.com/ns-api/apidoc/#api-Phone_Number-Delete
#>
function  Remove-NSDID {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true, ValueFromPipeline, Position = 0)]
        [string]$number
    )
    Process {
        $num = Get-NSDID -number $number
        if($num.count -gt 0){
            $payload = @{
                object   = 'phonenumber'
                action   = 'delete'
                dialplan = 'DID Table'
                domain = $num.domain
                matchrule = $num.matchrule
            }
            try {
                Invoke-NSRequest $payload
                Write-Output  "$number has been deleted"
            }
            catch {
                $res = "Unable to delete $number. Error retrieving data or no data returned"
                return $res
            }
        } else {
            $res = "Error retrieving data or no data returned"
            return $res
        }
    }

}