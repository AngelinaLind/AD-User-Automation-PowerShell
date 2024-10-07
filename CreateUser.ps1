param (
    [Parameter(Mandatory = $true)]
    [string]$UserName,

    [Parameter(Mandatory = $true)]
    [string]$Email,

    [Parameter(Mandatory = $true)]
    [string]$Department,

    [Parameter(Mandatory = $true)]
    [string]$JobTitle,

    [string]$Password
)

# Check if all mandatory fields are provided
if (-not ($UserName -and $Email -and $Department -and $JobTitle)) {
    Write-Host "All fields are required." -ForegroundColor Red
    exit
}

# Check email format (regex validation allowing '.local' domains as my domain is "testdomain.local")
if ($Email -notmatch "^[\w\.\-]+@([\w\-]+\.)+[\w\-]{2,7}$") {
    Write-Host "Invalid email format." -ForegroundColor Red
    exit
}

# Check if the user already exists in Active Directory
if (Get-ADUser -Filter {SamAccountName -eq $UserName}) {
    Write-Host "User already exists." -ForegroundColor Yellow
    exit
}

# Generate a random secure password
$Password = -join ((33..126) | Get-Random -Count 12 | ForEach-Object {[char]$_})

# Create the new user in Active Directory
try {
    New-ADUser 
        -SamAccountName $UserName 
        -UserPrincipalName "$UserName@testdomain.local" 
        -Name $UserName 
        -GivenName $UserName 
        -Surname $UserName 
        -Department $Department 
        -Title $JobTitle 
        -EmailAddress $Email 
        -AccountPassword (ConvertTo-SecureString $Password -AsPlainText -Force) 
        -Enabled $true 
        -PasswordNeverExpires $true 
        -Path "CN=Users,DC=testdomain,DC=local" # In ADUC I had Users as CN, not OU

    Write-Host "User $UserName created successfully." -ForegroundColor Green

    # Add the user to the appropriate group based on department or job title
    if ($Department -eq "IT") {
        Add-ADGroupMember -Identity "IT Group" -Members $UserName
        Write-Host "$UserName added to IT Group." -ForegroundColor Green
    }

    if ($JobTitle -eq "Manager") {
        Add-ADGroupMember -Identity "Management Group" -Members $UserName
        Write-Host "$UserName added to Management Group." -ForegroundColor Green
    }
} catch {
    Write-Host "Error creating user: $_" -ForegroundColor Red
    exit
}

# Email the password to the user
try {
    $SmtpServer = "smtp.gmail.com" 
    $SmtpFrom = "your-gmail-address"
    $SmtpTo = $Email
    $MessageSubject = "Your new account password"
    $MessageBody = "Hello $UserName,nYour account has been created. Your password is: $Password"

    $SmtpClient = New-Object Net.Mail.SmtpClient($SmtpServer, 587)
    $SmtpClient.EnableSsl = $true
    $SmtpClient.Credentials = New-Object System.Net.NetworkCredential("your-gmail-address@gmail.com", "your-password")

    $SmtpClient.Send($SmtpFrom, $SmtpTo, $MessageSubject, $MessageBody)

    Write-Host "Password email sent to $Email." -ForegroundColor Green
} catch {
    Write-Host "Error sending email: $_" -ForegroundColor Red
}

$logFile = "C:\Users\Administrator\Documents\CreateUser\CreateUserLogFile.log" # Check your path
function Log-Message {
    param (
        [string]$Message
    )
    $timestamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    Add-Content -Path $logFile -Value "$timestamp - $Message"
}

# Log the successful creation
Log-Message "User $UserName created successfully."
