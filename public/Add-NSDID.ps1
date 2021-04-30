<#
.SYNOPSIS
    Create a new phone number (DID) as an available number. Verifies that the intended domain or reseller ID exists before adding. Also verifies that the DID does not already exist.
.DESCRIPTION
    Required permissions: Reseller or above.
.EXAMPLE
    Add-NSDID -number "3051111234"
    Get-NSDID -number "13051111234"
    Get-NSDID -domain "demodomain.12345.service"
.LINK
    https://api.ucaasnetwork.com/ns-api/apidoc/#api-Phone_Number-Create
#>
function  Add-NSDID {
    [CmdletBinding(DefaultParameterSetName = 'domain')]
    Param(
        [Parameter(Mandatory = $true, ValueFromPipeline, Position = 0)]
        [string]$number,

        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName, Position = 1, ParameterSetName = 'domain')]
        [string]$domain,

        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName, Position = 1, ParameterSetName = 'resellerID')]
        [string]$resellerID,

        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName)]
        [switch]$disable
    )

    Process {
        # Check if number exists
        $num = Get-NSDID -number $number -count
        if($num.total -gt 0){
            $res = "$number already exists. No action taken"
            return $res
        }
        if(-not ([string]::IsNullOrEmpty($resellerID))) {
            $domain = "0000." + $resellerID + ".service"
        }
        $ckDomain = Get-NSDomain -domain $domain -count
        if($ckDomain.total -eq 0){
            $res = "$domain is not a value domain. No action taken"
            return $res
        }

        $matchrule = "sip:1" + $(Convert-NSDID($number)) + "@*"
        $payload = @{
            object   = 'phonenumber'
            action   = 'create'
            dialplan = 'DID Table'
            dest_domain = 'admin-only'
            matchrule = $matchrule
            responder = 'AvailableDID '
            to_user = '[*]'
            to_host = $domain
        }
        if($disable){
            $payload.Add('enable','no')
            } else {
                $payload.Add('enable','yes')
            }
    
        try {
            $res = Invoke-NSRequest $payload
            $cknum = Get-NSDID $number -count
            if($cknum.total -eq 1) {
                $res = "$number has been added"
                return $res
            }
            else {
                $res = "Unable to add $number"
                return $res
            }
        }
        catch {
            $res = "Unable to add $number"
            return $res
        }
    }

}