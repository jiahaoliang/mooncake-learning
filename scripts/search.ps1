param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$Pattern
)

rg $Pattern repos notes tasks
