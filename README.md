# SmartWaste360
A Unified Waste Management App

## Overview
SmartWaste360 is an iOS app that brings citizens, municipal workers, and administrators together on one digital platform.  
It helps people report waste problems, schedule pickups, track e-waste, locate bins using Google Maps, and earn rewards for eco-friendly actions.  
The goal is to make waste management transparent, accountable, and motivating.

## Features
- Complaint reporting with photo and location  
- Pickup scheduling for dry, wet, and e-waste  
- Live bin locator using Google Maps SDK  
- Dedicated e-waste collection points  
- Reward system for responsible waste disposal  
- Auto-escalation after 72 hours if issues stay unresolved  
- Firebase backend for sync, login, and notifications  

## Tech Stack
- **Language:** Swift (SwiftUI + MVVM)  
- **Backend:** Firebase Authentication, Firestore, Cloud Storage, Cloud Messaging  
- **APIs:** Google Maps SDK for iOS, CoreLocation  
- **Platform:** iOS 17 and later  

## How It’s Different from Existing Solutions
Most existing apps, like the Swachhata App under Swachh Bharat Mission, only allow complaint reporting.  
SmartWaste360 goes further by offering:
- A unified platform for citizens, workers, and administrators  
- E-waste pickup tracking and mapped collection points  
- A reward system that motivates responsible behavior  
- Auto-escalation for unresolved complaints  
- Live bin locator powered by Google Maps  
- Real-time updates through Firebase  

This mix of engagement, automation, and accountability makes SmartWaste360 more complete than current municipal or private apps.

## Screenshots
| Citizen Dashboard | Complaint Module | Bin Locator | Admin Panel |
|:------------------:|:----------------:|:------------:|:-------------:|
| ![Citizen Dashboard](screenshots/citizen_dashboard.png) | ![Complaint Module](screenshots/complaint_module.png) | ![Bin Locator](screenshots/bin_locator.png) | ![Admin Panel](screenshots/admin_panel.png) |

*(Replace image paths with actual screenshot file names.)*

## Demo Video
🎬 [Watch Demo Video](demo/demo_video.mp4)  
*(Upload your `.mp4` file or YouTube demo link here.)*

## How to Run
1. Clone this repository.  
2. Open `SmartWaste360.xcodeproj` in Xcode 15 or later.  
3. Add your `GoogleService-Info.plist` Firebase config file.  
4. Build and run on an iOS 17+ simulator or device.

## Future Enhancements
- Support for multiple languages (English, Hindi, Kannada)  
- AI-based waste hotspot prediction using city data  
- Offline complaint submission with auto-sync when online  

## References
1. Government of India, *Solid Waste Management Rules, 2016*. [Online] http://moef.gov.in  
2. Swachh Bharat Mission (Urban), *Annual Report on Municipal Solid Waste Management*, 2023. [Online] https://sbmurban.org  
3. Ministry of Housing and Urban Affairs, *Swachhata-MoHUA Mobile Application*. [Online] https://swachhbharatmission.gov.in/swachhata-app  

## Repository Details
**Author:** Nikhil Kumar Khanna  
**Institute:** Indian Institute of Information Technology, Una (IIITU)  
**Supervisor:** Dr. Neha Sharma  
**License:** MIT License
