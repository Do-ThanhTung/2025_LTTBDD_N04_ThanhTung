# Reorganize Flutter Project Structure
$projectRoot = "D:\mobile\BaiTap\English_app_figma"
$libPath = "$projectRoot\lib"

Write-Host "Starting reorganization..." -ForegroundColor Cyan

# Copy files
Copy-Item "$libPath\screens\controller\panel\home_screen.dart" "$libPath\screens\home\home_dashboard_screen.dart" -Force -ErrorAction SilentlyContinue
Copy-Item "$libPath\screens\controller\panel\my_learning_screen.dart" "$libPath\screens\home\learning_progress_screen.dart" -Force -ErrorAction SilentlyContinue
Copy-Item "$libPath\screens\controller\panel\dictionary_screen.dart" "$libPath\screens\features\dictionary\dictionary_screen.dart" -Force -ErrorAction SilentlyContinue
Copy-Item "$libPath\screens\controller\panel\expand_screen.dart" "$libPath\screens\features\expand\expand_selector_screen.dart" -Force -ErrorAction SilentlyContinue
Copy-Item "$libPath\screens\controller\panel\settings_screen.dart" "$libPath\screens\features\settings\settings_screen.dart" -Force -ErrorAction SilentlyContinue

Write-Host "Files copied successfully!" -ForegroundColor Green
