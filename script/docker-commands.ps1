function Show-Menu
{
     param (
           [string]$Title = 'Docker Commands'
     )
     cls
     Write-Host "=============== $Title ===============" -ForegroundColor Cyan -BackgroundColor Black
    
     Write-Host "1: List all containers (just runnning)"
     Write-Host "2: List all containers (including non-running)"
     Write-Host "3: List all images"
     Write-Host "4: Restart specific container"
     Write-Host "5: Restart all containers"
     Write-Host "6: Stop specific container"
     Write-Host "7: Stop all containers"
     Write-Host "8: Start specific container"
     Write-Host "9: Start all containers"
     Write-Host "10: Remove specific container"
     Write-Host "11: Remove specific image"
     Write-Host "12: Stop and Remove specific container"
     Write-Host "13: (WARNING!) Remove all containers"
     Write-Host "14: (WARNING!) Remove all images"
     Write-Host "15: (WARNING!) Remove all containers and images"
     Write-Host "16: Show the Docker version"
     Write-Host ""
     Write-Host "Q: Press 'Q' to quit."
     Write-Host ""
}

do
{
     Show-Menu
     $input = Read-Host "Please make a option for execute docker command(s)"
     $invalid_option = 0
     if((-Not ($input -match ".*\d+.*")) -And ($input -ne "Q")) {
        $invalid_option = 1
        Write-Host "Invalid option! Need to enter a number option" -ForegroundColor Yellow
     }
     switch ($input)
     {
           '1' {
                cls 
                (docker ps --format "table {{.ID}}\t{{.Image}}\t{{.RunningFor}}\t{{.Status}}\t{{.Ports}}")
                Write-Host ""
           } '2' {
                cls 
                (docker ps -a --format "table {{.ID}}\t{{.Image}}\t{{.RunningFor}}\t{{.Status}}\t{{.Ports}}")
                Write-Host ""
           } '3' {
                cls 
                (docker images)
           } '4' {
                Write-Host ""
                cls
                (docker ps --format ‘{{.ID}}: {{.Image}}’)
                Write-Host ""
                $container_id = Read-Host "Enter the CONTAINER ID to restart"
                if($container_id) {
                    $command = (docker restart $($container_id))
                    if ($command) {
                        Write-Host "Container restarted!" -ForegroundColor Green
                    }
                    Write-Host ""
                } else {
                    Write-Host ""
                    Write-Host "Need enter CONTAINER ID to restart!" -ForegroundColor Yellow
                    Write-Host ""
                }
           } '5' {
                Write-Host "Restarting all containers..." -ForegroundColor Yellow
                $command = (docker restart $(docker ps -a -q))
                if ($command) {
                    Write-Host "All containers restarted!" -ForegroundColor Green
                }
                Write-Host ""
           } '6' {
                Write-Host ""
                cls
                (docker ps --format ‘{{.ID}}: {{.Image}}’ --filter 'status=running')
                Write-Host ""
                $container_id = Read-Host "Enter the CONTAINER ID to stop"
                if($container_id) {
                    $command = (docker kill $container_id)
                    if ($command) {
                        Write-Host "Container stopped!" -ForegroundColor Green
                    }
                    Write-Host ""
                } else {
                    Write-Host ""
                    Write-Host "Need enter CONTAINER ID to stop!" -ForegroundColor Yellow
                    Write-Host ""
                }
           } '7' {
                Write-Host ""
                Write-Host "Stopping all containers..." -ForegroundColor Yellow
                $command = (docker kill $(docker ps -q))
                if ($command) {
                    Write-Host "Stopped all containers!" -ForegroundColor Green
                }
                Write-Host ""
           } '8' {
                Write-Host ""
                cls
                (docker ps --format ‘{{.ID}}: {{.Image}}’ --filter 'status=exited')
                Write-Host ""
                $container_id = Read-Host "Enter the CONTAINER ID to start container"
                if($container_id) {
                    $command = (docker start $container_id)
                    if ($command) {
                        Write-Host "Container started!" -ForegroundColor Green
                    }
                    Write-Host ""
                } else {
                    Write-Host ""
                    Write-Host "Need enter CONTAINER ID to start container!" -ForegroundColor Yellow
                    Write-Host ""
                }
           } '9' {
                Write-Host ""
                Write-Host "Starting all containers..." -ForegroundColor Yellow
                $command = (docker start $(docker ps -a -q -f status=exited))
                if ($command) {
                    Write-Host "All containers started!" -ForegroundColor Green
                }
                Write-Host ""
           } '10' {
                Write-Host ""
                cls
                (docker ps -a --format ‘{{.ID}}: {{.Image}}’)
                Write-Host ""
                $container_id = Read-Host "Enter the CONTAINER ID to remove container"
                if($container_id) {
                    $command = (docker rm --force $container_id)
                    if ($command) {
                        Write-Host "Container removed!" -ForegroundColor Green
                    }
                    Write-Host ""
                } else {
                    Write-Host ""
                    Write-Host "Need enter CONTAINER ID to remove container!" -ForegroundColor Yellow
                    Write-Host ""
                }
            } '11' {
                Write-Host ""
                cls
                (docker images --format "{{.Repository}}")
                Write-Host ""
                $container_id = Read-Host "Enter the REPOSITORY NAME to remove container image"
                if($container_id) {
                    $command = (docker rmi $container_id)
                    if ($command) {
                        Write-Host "Container image removed!" -ForegroundColor Green
                    }
                    Write-Host ""
                } else {
                    Write-Host ""
                    Write-Host "Need enter REPOSITORY NAME to remove container image!" -ForegroundColor Yellow
                    Write-Host ""
                }
             } '12' {
                Write-Host ""
                cls
                (docker ps --format ‘{{.ID}}: {{.Image}}’)
                Write-Host ""
                $container_id = Read-Host "Enter the CONTAINER ID to Stop and Remove container"
                if($container_id) {
                    (docker stop $container_id); 
                    Write-Host "Container stopped!" -ForegroundColor Green
                    (docker rm $container_id);
                    Write-Host "Container removed!" -ForegroundColor Green
                    Write-Host ""
                } else {
                    Write-Host ""
                    Write-Host "Need enter CONTAINER ID to Stop and Remove container!" -ForegroundColor Yellow
                    Write-Host ""
                }

              } '13' {
                Write-Host ""
                $confirm = Read-Host "Remove all containers? (Y/N)"
                if($confirm -eq 'Y') {
                    Write-Host "Removing all containers..." -ForegroundColor Yellow
                    $command = (docker rm $(docker ps -a -q) -f)
                    if ($command) {
                        Write-Host "All containers removed!" -ForegroundColor Green
                    }
                    Write-Host ""
                } else {
                    Write-Host ""
                    Write-Host "Command aborted!"
                }
              } '14' {
                Write-Host ""
                $confirm = Read-Host "Remove all images? (Y/N)"
                if($confirm -eq 'Y') {
                    Write-Host "Removing all images..." -ForegroundColor Yellow
                    $command = (docker rmi $(docker images -q))
                    if ($command) {
                        Write-Host "All images removed!" -ForegroundColor Green
                    }
                    Write-Host ""
                } else {
                    Write-Host ""
                    Write-Host "Command aborted!"
                }
              } '15' {
                Write-Host ""
                $confirm = Read-Host "Remove all containers and images? (Y/N)"
                if($confirm -eq 'Y') {
                    Write-Host "Removing all containers and images..." -ForegroundColor Yellow
                    $command = (docker rm $(docker ps -a -q) -f); docker rmi $(docker images -q)
                    if ($command) {
                        Write-Host "All containers and images removed!" -ForegroundColor Green
                    }
                    Write-Host ""
                } else {
                    Write-Host ""
                    Write-Host "Command aborted!"
                }
              } '16' {
                cls 
                (docker version)
                Write-Host ""
              } default {
                if(-Not $invalid_option) {
                    Write-Host ""
                    Write-Host "Invalid option! Need enter a valid option!" -ForegroundColor Yellow
                }
              } 'q' {
                Write-Host "Exiting... OK!" -ForegroundColor Yellow
                return
           }
     }
     pause
}
until ($input -eq 'q')