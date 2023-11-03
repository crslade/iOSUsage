# iOSUsage

`iOSUsage` is a MacOS app that reads the screentime usage stats from the MacOS database and exports it in CSV format or uploads the data in JSON format to a Web API. This is designed to support studies that analyze screen time data. The app reads the screen time of shared devices and not the Mac that reads the screen time.

<img width="901" alt="iOSUsage App" src="https://github.com/crslade/iOSUsage/assets/813401/489e1fbb-7941-48ec-9acd-3d32c8e9449b">

## Installation

Download the DMG from [GitHub](https://github.com/crslade/iOSUsage/releases), then drag `iOSUsage` to your application folder.

## Recommended Usage

Please remember the privacy of your participants and do all you can to ensure their privacy.

### 1. Login to the device with an Apple ID and Enable ScreenTime

If not already done, make sure the iPhone or iPad is logged in to an iCloud account with an Apple ID. Then go to Settings -> Screen Time and make sure it is enabled. Also, make sure "Share Across Devices" is enabled.

### 2. Setup Collection Mac.

On a Mac computer login to iCloud using the same Apple ID that the iPad or iPhone uses. If your participant doesn't have a Mac to sync the data to, you can create a new user account (see image below) on a research Mac.

#### To create an account on a research Mac:

1. Use an Admin account on the research Mac and go to Settings -> Users & Groups -> Add User. Make sure the new account is a "Standard" account.

<img width="715" alt="How to Create a User Account" src="https://github.com/crslade/iOSUsage/assets/813401/a5dc1560-0b17-4582-8e17-1d76ff1a0588">

After creating the user account (making sure the participant sets the password to ensure privacy), log into the new user account and then have the participant log in to their iCloud account. Make sure they use the same Apple ID as their device.

Then, to ensure privacy, shut off all iCloud services by going to Settings -> (Apple ID) -> iCloud (Click Show All). Turn off all services using iCloud.

<img width="722" alt="Turn off all iCloud services" src="https://github.com/crslade/iOSUsage/assets/813401/52c08af0-fd32-4e80-8b9d-bed52f565710">

Then, on the Mac, go to Settings -> Screen Time and enable screen time. Then make sure the "Share across devices" is turned on.

<img width="717" alt="Turn on Screen time and share across devices" src="https://github.com/crslade/iOSUsage/assets/813401/85515c84-04e0-4581-aca6-6e0429b61b4e">.

### 3. Sync Screen Time data to the Mac

On the Mac, go to Settings -> Screen Time -> App & Website Activity. Wait a little while (5-10 minutes) for data to sync between devices. You should see the iOS device in the list of devices. Also, make sure the screen time data from the iOS device is current.

<img width="803" alt="Let Screen Time data sync" src="https://github.com/crslade/iOSUsage/assets/813401/14f68a8d-a8a0-4fa9-a6f3-4a3199509762">

### 4. Copy the Screen Time database to a separate folder

After the Data has Synced, copy the Screen Time Database from `/Users/Account/Library/Application Support/Knowledge` to a folder on the Desktop or Documents. 

To find the folder, you must show hidden files: with the Finder as the active window, press `Shift-CMD-.` (period). From the user's home folder, you will see a Library folder. From that go to `Application Support` -> `Knowledge`. Right-click on Knowledge.db and select copy. Create a destination folder on the desktop/documents. Then inside this folder, right-click, and paste.

<img width="1304" alt="Find the Screen Time Data" src="https://github.com/crslade/iOSUsage/assets/813401/046f91ab-b00d-4ca5-95dc-ec429adc8d14">

### 4. Read Screen Time Data

If not already done, install the iOSUsage app on the Mac (see installation above). If you have a research Mac, you need to install it using the Admin account and it will be available to all users.

Open the iOSUsage app. Select the folder containing the copied knowledge.db file to read the data. 

### 5. Export Screen Time Data

Select among the different devices and make sure you have the right device selected by looking at the screen time data. Then you can export the file by entering the participant id.

## Uploading data to an API

If you would rather upload the data to an API, you can click upload. Enter the API Endpoint and the participant ID. You can also create a text file containing the API endpoint. 
