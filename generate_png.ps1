Add-Type -AssemblyName System.Drawing

function Create-AppIcon([int]$size, [string]$outPath) {
    $bmp = New-Object System.Drawing.Bitmap $size, $size
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit

    # Background
    $rect = New-Object System.Drawing.Rectangle 0, 0, $size, $size
    $bgBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(255, 15, 23, 42))
    $g.FillRectangle($bgBrush, $rect)

    # Accent rounded box
    $pad = [int]($size * 0.12)
    $innerSize = $size - (2 * $pad)
    $innerRect = New-Object System.Drawing.Rectangle $pad, $pad, $innerSize, $innerSize
    $innerBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(255, 30, 41, 59))
    $g.FillEllipse($innerBrush, $innerRect)

    # Accent circle ring
    $pen = New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(255, 99, 102, 241)), ([float]($size * 0.035))
    $g.DrawEllipse($pen, $innerRect)

    # Text "2/2"
    $fontFamily = [System.Drawing.FontFamily]::GenericSansSerif
    $fontSize = [float]($size * 0.24)
    $font = New-Object System.Drawing.Font $fontFamily, $fontSize, [System.Drawing.FontStyle]::Bold
    $textBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(255, 245, 158, 11))
    $sf = New-Object System.Drawing.StringFormat
    $sf.Alignment = [System.Drawing.StringAlignment]::Center
    $sf.LineAlignment = [System.Drawing.StringAlignment]::Center

    $textRect = New-Object System.Drawing.RectangleF ([float]0), ([float]($size * 0.28)), ([float]$size), ([float]($size * 0.44))
    $g.DrawString("2/2", $font, $textBrush, $textRect, $sf)

    # Subtext "SHIFT"
    $subSize = [float]($size * 0.08)
    $subFont = New-Object System.Drawing.Font $fontFamily, $subSize, [System.Drawing.FontStyle]::Bold
    $subBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(255, 226, 232, 240))
    $subRect = New-Object System.Drawing.RectangleF ([float]0), ([float]($size * 0.65)), ([float]$size), ([float]($size * 0.18))
    $g.DrawString("СМЕНЫ", $subFont, $subBrush, $subRect, $sf)

    $ms = New-Object System.IO.MemoryStream
    $bmp.Save($ms, [System.Drawing.Imaging.ImageFormat]::Png)
    [System.IO.File]::WriteAllBytes($outPath, $ms.ToArray())

    $ms.Dispose()
    $g.Dispose()
    $bmp.Dispose()
}

Create-AppIcon 192 "c:\ShiftCalendar\icon-192.png"
Create-AppIcon 512 "c:\ShiftCalendar\icon-512.png"
Write-Host "Icons generated successfully!"
