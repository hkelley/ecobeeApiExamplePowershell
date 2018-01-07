

param
(
	  [Parameter(Mandatory = $true)] [string] $ApiKey
    , [Parameter(Mandatory = $true)] [string] $TokenFile
	, [Parameter(Mandatory = $false)] [string] $BaseUri = "https://api.ecobee.com/"
)

$tokenData = Get-Content -Path $TokenFile | ConvertFrom-Json


# refresh the token
$uri = ("{0}token?grant_type=refresh_token&refresh_token={1}&client_id={2}" -f $BaseUri,$tokenData.refresh_token,$ApiKey) 
$uri
try{
    $response = Invoke-RestMethod -Uri $uri -Method Post
} catch {
    $Error[0]
    exit
}

$accessToken = $response.access_token 

# Save the tokens
$response | ConvertTo-Json | Out-File -FilePath ecobeeToken.json


# get the thermostat data
#`{'selection':`{'selectionType':'registered','selectionMatch':'','includeRuntime':true`}`}

$uri = "$baseuri/1/thermostat?format=json&body=`{'selection':`{'selectionType':'registered','selectionMatch':'','includeRuntime':true,'includeSettings':true,'includeExtendedRuntime':true,'includeEvents':true,'includeDevice':true`}`}" 
$uri
try{
    $response = Invoke-WebRequest -Uri $uri -Headers @{"Authorization"="Bearer $accessToken"}
} catch {
    $Error[0]
    exit
}

$response

$jsonResponse = $response.Content  | ConvertFrom-Json

foreach($t in $jsonResponse.thermostatList)
{
    $t | fl *

    "runtime"
    $t.runtime | fl *
     
    "events"
    $t.events.count
    $t.events

}
