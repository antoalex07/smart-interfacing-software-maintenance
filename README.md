

### Step 1: Create the Script Files
1. Create a folder like `C:\Scripts\ServiceRestart\`
2. Save the PowerShell script as `RestartSmartMachineService.ps1`
3. Save the batch file as `RestartSmartMachineService.bat`
4. Make sure both files are in the same folder

### Step 2: Test the Script
1. Right-click on `RestartSmartMachineService.bat` and select "Run as administrator"
2. Check if the service restarts properly
3. Look for the log file at `%TEMP%\SmartMachineServiceRestart.log` to see what happened

### Step 3: Create the Scheduled Task
1. Press `Win + R`, type `taskschd.msc`, and press Enter
2. In Task Scheduler, click "Create Task..." (not "Create Basic Task")
3. **General Tab:**
   - Name: `Restart SmartMachine Service on Login`
   - Description: `Restarts SmartMachineInterfacingService after user login`
   - Select "Run with highest privileges"
   - Configure for: Windows 10/11

4. **Triggers Tab:**
   - Click "New..."
   - Begin the task: "At log on"
   - Settings: "Specific user" (select your username)
   - Click OK

5. **Actions Tab:**
   - Click "New..."
   - Action: "Start a program"
   - Program/script: Browse to your `RestartSmartMachineService.bat` file
   - Start in: Enter the folder path (e.g., `C:\Scripts\ServiceRestart\`)
   - Click OK

6. **Conditions Tab:**
   - Uncheck "Start the task only if the computer is on AC power"
   - Check "Wake the computer to run this task" if needed

7. **Settings Tab:**
   - Check "Allow task to be run on demand"
   - Check "Run task as soon as possible after a scheduled start is missed"
   - If task fails, restart every: 1 minute, attempt restart up to: 3 times

8. Click OK to save the task

### Step 4: Test the Setup
1. Restart your computer or log off and log back in
2. Check the log file to see if the service was restarted
3. Verify the service is working properly

## Customization Options:

**Change the delay:** Edit the `-DelaySeconds 30` parameter in the batch file to use a different delay (in seconds).

**Manual testing:** You can run the task manually by right-clicking it in Task Scheduler and selecting "Run".

**Troubleshooting:** The log file will show you exactly what happened during each restart attempt.

Would you like me to explain any part of this setup in more detail, or do you need help with any specific step?
