$dirs = @('D:\Curtin\DHS\Shared\ABST')
$depth = 2
for ($i = 0; $i -lt $depth; $i++) {
    $dirs = foreach ($dir in $dirs) {
        [System.IO.Directory]::EnumerateDirectories($dir)
    }
}

$dirs
