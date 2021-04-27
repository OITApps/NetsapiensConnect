<#
.SYNOPSIS
    Returns a list or count of the active calls per your search criteria.
.DESCRIPTION
    Required permissions: Reseller or above.
.EXAMPLE
    Disconnect-NSCall -callID "callid"
    Disconnect-NSCall -callID
.LINK
    https://api.ucaasnetwork.com/ns-api/apidoc/#api-Call-Disconnect
#>
function Disconnect-NSCall {
    [CmdletBinding(DefaultParameterSetName = 'callID')]
    Param(
        [Parameter(Mandatory = $true, ValueFromPipeline, ParameterSetName = 'callID', Position=0)]
        [string]$callID,

        [Parameter(Mandatory = $true, ValueFromPipeline, ParameterSetName = 'Domain')]
        [string]$domain,

        [Parameter(Mandatory = $true, ValueFromPipeline, ParameterSetName = 'Territory')]
        [string]$territory,

        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName)][string]$uid
        
    )

    Process {
        if(!$uid){
            if($nsCreds){$uid = $nsCreds.UserName}else{
                $uid = Read-Host "Please enter your PBX user ID"
            }
        }
        switch ($PSCmdlet.ParameterSetName) {
            'callID' { 
                $payload = @{
                    object = 'call'
                    action = 'disconnect'
                    uid    = $uid
                    callid = $callID
                }
                Write-Output $payload
                Write-Output "Terminating call ID: $($callID)"
                try {
                    $res = Invoke-NSRequest $payload
                    Write-Output "Complete"
                    return
                }
                catch {
                    $res = "Error retrieving data or no data returned"
                    return $res
                }
            }
            'Domain' {
                $calls = Get-NSCalls -domain $domain
                foreach ($call in $calls) {
                    $payload = @{
                        object  = 'call'
                        action  = 'disconnect'
                        uid = $uid
                        callID = $call.orig_callid
                    }
                    Write-Output $payload
                    Write-Output "Terminating call ID: $($call.orig_callid)"
                    try {
                        $res = Invoke-NSRequest $payload
                        Write-Output "Complete"
                    }
                    catch {
                        $res = "Unable to terminate call ID $($call.orig_callid)"
                        $ErrorMessage = $_.Exception.Message
                        $FailedItem = $_.Exception.ItemName
                        Write-Output "Error: $($errormessage)"
                        Write-Output "Failed Item $faileditem"
                        return $res
                    }
                }
            }
            'Territory' {
                $calls = Get-NSCalls -territory $territory
                # Still figuring shit out
            }
        }
    }

}