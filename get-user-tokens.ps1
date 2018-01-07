

param
(
	    [Parameter(Mandatory = $true)] [string] $ApiKey
	  , [Parameter(Mandatory = $false)] [string] $BaseUri = "https://api.ecobee.com/"
)


$uri = ("{0}authorize?response_type=ecobeePin&client_id={1}&scope=smartRead" -f $BaseUri,$ApiKey) 
$uri
try{
    $response = Invoke-RestMethod -Uri $uri -Method Get
} catch {
    $Error[0]
    exit
}

Read-Host ("Go to the ecobee portal and register for a new application with this PIN: {0}" -f $response.ecobeePin )

$uri = ("{0}token?grant_type=ecobeePin&code={1}&client_id={2}" -f $BaseUri,$response.code,$ApiKey) 
$uri
try{
    $response = Invoke-RestMethod -Uri $uri -Method Post
} catch {
    $Error[0]
    exit
}

# Save the tokens
$response | ConvertTo-Json | Out-File -FilePath ecobeeToken.json



