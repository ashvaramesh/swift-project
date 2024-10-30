Changelog and Updates

**9/23/24 (Monday)**  
- **Data Models**:  
  - Expanded `Category` to include competition and research.  
  - Introduced `Badge` struct for gamification and achievement tracking.  
  - Added `StarredActivity` struct for improved management of starred activities.  
  - Created `Impact` struct to track metrics like volunteer hours, people helped, and carbon footprint reduction.

**9/24/24 (Tuesday)**  
- **VolunteerTrackerView**:  
  - Implemented a volunteer tracking view with a `CalendarView` to log hours and `ImpactGraphView` for a visual summary of impact.

**9/25/24 (Wednesday)**  
- **Badges and Leaderboards**:  
  - Developed `BadgesView` to showcase user achievements.  
  - Built `LeaderboardsView` to list top volunteers, starting with placeholder data.

**9/26/24 (Thursday)**  
- **Create Event**:  
  - Added `CreateEventView` allowing users to create new volunteering events and opportunities.

**9/27/24 (Friday)**  
- **Profile Customization**:  
  - Expanded `ProfileView` to let users add skills, set personal goals, and view their overall impact metrics.

**9/28/24 (Saturday)**  
- **Starred Activities**:  
  - Created `StarredActivitiesView` to display starred opportunities.

**9/30/24 (Monday)**  
- **Onboarding**:  
  - Added `OnboardingView` with a welcome message and app overview for new users.

**10/1/24 (Tuesday)**  
- **Improved Interactions**:  
  - Added star button animations and interactions for marking opportunities as completed or starred.

**10/2/24 (Wednesday)**  
- **Gamification Enhancements**:  
  - Implemented badge assignments based on actions, like tracking volunteer hours.

**10/3/24 (Thursday)**  
- **Dynamic Filtering**:  
  - Enhanced `HomeView` to filter opportunities by category (e.g., volunteer, government).

**10/4/24 (Friday)**  
- **Dark Mode Toggle**:  
  - Added a dark mode toggle in `MoreView` for user customization.

**10/5/24 (Saturday)**  
- **Impact Tracking Graph**:  
  - Built `ImpactGraphView` with bar charts to visualize weekly volunteer hours.

**10/6/24 (Sunday)**  
- **Accessibility Enhancements**:  
  - Added accessibility labels to buttons and key elements for better usability.

**10/7/24 (Monday)**  
- **Event Creation Logic**:  
  - Finalized create event functionality with title, category, description, and image name input fields.

**10/8/24 (Tuesday)**  
- **Sample Data Expansion**:  
  - Added additional sample opportunities for a variety of categories to improve the initial user experience.

**10/9/24 (Wednesday)**  
- **Onboarding Page 2**:  
  - Developed the second page of the onboarding flow, explaining the volunteer tracking feature to new users.  
  - **Bug Fix**: Resolved an issue with the back button not functioning correctly between the first and second onboarding screens.

**10/10/24 (Thursday)**  
- **Onboarding Page 3**:  
  - Completed the third onboarding page, focusing on badge tracking and gamification.  
  - **Bug Fix**: Fixed a bug where onboarding progress indicators were not updating properly after navigating between pages.

**10/11/24 (Friday)**  
- **Improved Event Creation UI**:  
  - Polished the UI for the `CreateEventView` by adding input validation and error handling (e.g., showing error messages when fields are left empty).  
  - **Bug Fix**: Resolved a bug where event images were not displaying correctly.

**10/12/24 (Saturday)**  
- **Leaderboards Dynamic Data**:  
  - Implemented dynamic leaderboard rankings that update in real-time based on the latest volunteer hours tracked by users.

**10/13/24 (Sunday)**  
- **ProfileView Customizations**:  
  - Improved profile customization features by allowing users to select from a predefined set of avatars.  
  - **Bug Fix**: Fixed an issue where custom user goals were not saving properly.

**10/14/24 (Monday)**  
- **ImpactGraph Enhancements**:  
  - Enhanced the impact tracking graph with additional filters, allowing users to view their impact over different time frames (e.g., daily, weekly, monthly).  
  - **Bug Fix**: Addressed a performance issue where the graph was slow to load with large datasets.

**10/15/24 (Tuesday)**  
- **Improved Accessibility**:  
  - Added more accessibility labels across all views for screen readers and improved button focus for better navigation.  
  - **Bug Fix**: Fixed an issue with dark mode toggle not applying consistently across all views.

**10/16/24 (Wednesday)**  
- **Onboarding Completion Screen**:  
  - Developed the final onboarding screen, congratulating users for completing onboarding and providing a link to start using the app.  
  - **Bug Fix**: Resolved a navigation loop error where users couldn’t exit the onboarding flow.

**10/17/24 (Thursday)**  
- **Enhanced Filter Options**:  
  - Added more filter categories (e.g., distance, duration) to the `HomeView` for browsing opportunities.  
  - **Bug Fix**: Fixed a layout issue where filter options would overflow on smaller screens.

**10/18/24 (Friday)**  
- **User Testing Feedback**:  
  - Incorporated feedback from initial user testing, improving button placement and event creation instructions for better usability.  
  - **Bug Fix**: Resolved an issue where the `ImpactGraphView` wasn’t displaying new data in real time.

- **UI Finalization**:  
  - All UI for the backend has been finalized. Need to integrate Firebase.

Here's the continuation of your changelog in the same format:

---

**10/19/24 (Saturday)**

- **Starred Activities Detail Enhancements:**
  - Added `StarredActivityDetailView` to showcase individual starred activities with options for adding journal entries and viewing detailed information.
  - Bug Fix: Fixed a bug where star status did not save consistently across app sessions.

**10/20/24 (Sunday)**

- **Add Journal Entry:**
  - Implemented `AddJournalEntryView` to allow users to record journal entries for each starred activity, tracking hours and reflections.
  - **Category-Based Tracking:** Enhanced journal entries to link with specific categories for easier analysis.
  - Bug Fix: Resolved an issue with entry date selection not saving correctly.

**10/21/24 (Monday)**

- **Weekly and Category Impact Charts:**
  - Developed `WeeklyHoursBarChart` and `CategoryHoursPieChart` views to visually track hours spent weekly and by category.
  - **Dynamic Data Update**: Charts automatically update when new hours are logged by users.
  - Bug Fix: Fixed an issue where chart data didn’t reflect recent entries in real-time.

**10/22/24 (Tuesday)**

- **User Interface Improvements:**
  - Polished UI elements, ensuring consistent padding and alignment for a smoother experience.
  - **Opportunity Tracking Enhancements**: Added a toggle to mark opportunities as completed directly in `OpportunityDetailView`.
  - Bug Fix: Corrected layout issues on smaller screens, ensuring UI compatibility across devices.

**10/23/24 (Wednesday)**

- **Starred Activity Context Menus:**
  - Created context menus within `StarredActivityCardView` to allow users to quickly delete or edit entries.
  - **Interaction Animations**: Improved animations for smoother transitions when toggling starred status on opportunities.
  - Bug Fix: Resolved accessibility issues, adding missing labels and improving button focus.

**10/24/24 (Thursday)**

- **Data Model Enhancements:**
  - Expanded the data model to accommodate `ActivityEntry` for logging hours and journal reflections, enhancing user interaction tracking.
  - **Integration with Firebase**: Began Firebase integration to allow storage and retrieval of user-specific data, such as starred activities and journal entries.
  - Bug Fix: Fixed a bug in the `ProfileView` where skill and goal selections were not saving correctly.

**10/25/24 (Friday)**

- **AddHoursView Enhancements:**
  - Implemented `AddHoursView` with a form for selecting activities, logging hours, and writing journal entries.
  - **Form Validation**: Added input validation to ensure required fields are completed before submission.
  - Bug Fix: Resolved an issue where hours were not correctly calculated in impact tracking graphs.

**10/26/24 (Saturday)**

- **OpportunityCardView Accessibility:**
  - Improved accessibility for `OpportunityCardView` by adding labels for categories and star toggle.
  - **Color Enhancements**: Refined tag colors to enhance readability across all themes.
  - Bug Fix: Corrected an animation delay that caused visual stuttering when loading cards.

**10/27/24 (Sunday)**

- **Profile Customization Completion:**
  - Finalized user profile customization options, enabling skills, goals, and avatar selections.
  - **UI Polishing**: Adjusted card corner radii and shadows for a more cohesive visual appearance.
  - Bug Fix: Fixed an issue with the `Save` button not appearing in some views.

